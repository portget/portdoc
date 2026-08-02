# TDB — Time-Series Database

## Overview {#overview}

TDB is Port Server's built-in time-series database, designed for high-frequency industrial sensor data.
It automatically records **numeric Entry values** from the in-memory data store on every flush cycle,
using binary compression to achieve 90%+ space savings.

```
Memory Regions (MemoryManager)
        ↓  record_regions()
    MemTable  ←── lock-free concurrent writes
        ↓  flush (when full or on interval)
  StorageEngine  ─── binary compression → .tdb files
        ↓  metadata
  PortDatabase (redb)  ─── chunk index, min/max stats
        ↓  query
  QueryExecutor ←── SQL Planner
```

TDB is enabled by default. No code changes are required — every numeric Entry in your project
is recorded automatically once the Port Server starts.

---

## Which Entries Are Recorded {#which-entries}

TDB records any **numeric Entry** that is registered in a flow watcher. Non-numeric and uninitialized
values are excluded.

### Recorded types

| DataType | Rust type | Notes |
|----------|-----------|-------|
| `f4` | f32 | Converted to f64 for compression |
| `f8` | f64 | Native storage precision |
| `i1` – `i8` | i8 – i64 | Sign-extended to f64 |
| `u1` – `u8` | u8 – u64 | Zero-extended to f64 |

### Not recorded

| Type | Reason |
|------|--------|
| `A`, `A(n)`, `string` | Non-numeric — no meaningful XOR compression |
| `B` (binary blob) | Excluded |
| `bool` | Excluded |
| `L`, `DEF` | Metadata-only; no memory allocation |
| All-zero bytes | Stored as `0.0` (uninitialized region) |

:::info Enum Entries
`Enum.XXX` entries are stored as their underlying integer value (`u2`). They are recorded and
queryable as numeric data.
:::

---

## How Entry Values Flow Into TDB {#write-pipeline}

The data path from a live Entry update to a compressed `.tdb` file has three stages:

### Stage 1 — Watcher scan (every `TDB_FLUSH_INTERVAL_SEC`)

Port Server runs a background task that wakes on each flush interval. It reads the **WatcherConfig**
— the list of numeric Entry keys and their DataTypes collected from all registered flows — and calls
`TdbIntegration::record_regions()`.

```
tick (1 s default)
    ↓
scan all flow watchers → collect Entry keys + DataTypes
    ↓
read bytes from MemoryManager for each key
    ↓
convert_bytes_to_f64(bytes, datatype)
    ↓
TdbBridge::insert(timestamp_ms, Vec<f64>)
```

`WatcherConfig` keeps variable names and their DataType codes in lock-step (enforced by a length
assertion). This guarantees column alignment across restarts and project updates.

### Stage 2 — MemTable (in-memory buffer)

Each inserted row lands in a **lock-free MemTable** (crossbeam-skiplist `SkipMap`). The main
application thread is never blocked by disk I/O.

When the MemTable reaches `TDB_MAX_MEMTABLE_SIZE` (default 10 MB) **or** the flush interval
fires, a background thread atomically swaps the full table for an empty one and begins compression
on the old data.

### Stage 3 — Compression and persistence

The background flush thread:

1. Encodes timestamps with **delta-of-delta** (variable-length bits; 0 bits for unchanged delta)
2. Encodes each variable with XOR encoding (reuses leading/trailing zero patterns across consecutive values)
3. Appends the compressed chunk to the current `.tdb` file
4. Writes a `TdbChunkMetadata` entry to PortDatabase (redb) with file offset, time range, and per-column min/max stats
5. Appends a CSV row to the WAL (`{table}.wal`) for crash recovery

If compression fails, the raw rows are kept in `failed_data` and retried on the next cycle.

:::tip Zero-blocking writes
Writes always go to the MemTable. Disk I/O happens in a separate thread. Your application code
experiences constant-time write latency regardless of storage speed.
:::

---

## Configuration {#configuration}

TDB settings are read once at server startup from:

```
%LOCALAPPDATA%\port\env\{project_name}\tdb.env
```

The file is created with defaults on first run. Storage location is fixed to
`%LOCALAPPDATA%\port\tdb\{project_name}` and is not configurable.

```ini
TDB_ENABLED=true
TDB_MAX_MEMTABLE_SIZE=1073741824  # 1 GB — flush threshold
TDB_FLUSH_INTERVAL_SEC=1          # background flush + watcher recording interval
TDB_AUTO_FLUSH=true
TDB_RETENTION_DAYS=0              # 0 = keep forever
TDB_COMPACTION_ENABLED=false
TDB_COMPACTION_INTERVAL_SEC=300
TDB_RECORD_STORE_DAY=0            # 0 = keep files forever
TDB_ALARM_BACKUP_DURATION_SEC=300 # alarm backup window in seconds
EVENT_RETENTION_DAYS=7
TDB_TIMESTAMP_FORMAT=%Y-%m-%d %H:%M:%S%.3f
```

| Key | Default | Description |
|-----|---------|-------------|
| `TDB_ENABLED` | `true` | Enable/disable the entire TDB subsystem |
| `TDB_MAX_MEMTABLE_SIZE` | `1073741824` (1 GB) | Flush when in-memory buffer exceeds this size |
| `TDB_FLUSH_INTERVAL_SEC` | `1` | Periodic flush + watcher recording interval in seconds |
| `TDB_AUTO_FLUSH` | `true` | Flush on interval in addition to size threshold |
| `TDB_RETENTION_DAYS` | `0` | Delete chunks older than N days (`0` = keep forever) |
| `TDB_COMPACTION_ENABLED` | `false` | Merge multiple L0 files into fewer, larger files |
| `TDB_COMPACTION_INTERVAL_SEC` | `300` | Compaction run interval |
| `TDB_RECORD_STORE_DAY` | `0` | Delete `.tdb` files older than N days by creation time |
| `TDB_ALARM_BACKUP_DURATION_SEC` | `300` | History window (seconds) preserved on alarm fire |
| `EVENT_RETENTION_DAYS` | `7` | Days to keep event data partitions |
| `TDB_TIMESTAMP_FORMAT` | `%Y-%m-%d %H:%M:%S%.3f` | Timestamp display format for `temp.csv` (chrono strftime) |

### Timestamp format {#timestamp-format}

`TDB_TIMESTAMP_FORMAT` controls how the human-readable timestamp column in `temp.csv`
is rendered. It uses [chrono strftime](https://docs.rs/chrono/latest/chrono/format/strftime/)
syntax on the server side:

| chrono token | Meaning | Example |
|--------------|---------|---------|
| `%Y` | 4-digit year | `2026` |
| `%m` | Month (01–12) | `07` |
| `%d` | Day (01–31) | `07` |
| `%H` | Hour, 24h (00–23) | `14` |
| `%M` | Minute (00–59) | `30` |
| `%S` | Second (00–59) | `15` |
| `%3f` | Milliseconds, no dot | `123` |
| `%.3f` | Milliseconds with dot | `.123` |

```ini
# 2026_07_07 14:30:15:123
TDB_TIMESTAMP_FORMAT=%Y_%m_%d %H:%M:%S:%3f
```

Query results from SQL and the REST/Trend APIs always use raw Unix-millisecond
timestamps regardless of this setting — the format applies to the CSV mirror only.

### Configuring from C# (`Port.Set(TDBConfigure)`) {#tdb-configure-csharp}

Applications using the Portdic .NET library can write the whole `tdb.env` file
programmatically instead of editing it by hand. Call it **before** `Port.Run()` —
the server reads the file once at startup:

```csharp
Port.Create("MyRepo");

Port.Set(new TDBConfigure
{
    Enabled = true,
    FlushIntervalSec = 5,
    RecordStoreDay = 30,
    AlarmBackupDurationSec = 600,
    TimestampFormat = "yyyy_MM_dd HH:mm:ss:zzz",   // .NET-style tokens
});

Port.Run();
```

`TDBConfigure.TimestampFormat` accepts **.NET-style tokens** and converts them to
chrono syntax automatically (`yyyy_MM_dd HH:mm:ss:zzz` → `%Y_%m_%d %H:%M:%S:%3f`):

| .NET token | chrono | Notes |
|------------|--------|-------|
| `yyyy` | `%Y` | 4-digit year |
| `MM` / leading `mm` | `%m` | Month — lowercase `mm` before the day token is treated as month |
| `dd` | `%d` | Day |
| `HH` / `hh` | `%H` | Hour (always 24-hour) |
| `mm` (after hour) | `%M` | Minute |
| `ss` | `%S` | Second |
| `fff` / `zzz` | `%3f` | Milliseconds (`zzz` is treated as milliseconds, not a timezone offset) |
| `ffffff` | `%6f` | Microseconds |

A value that already contains `%` is passed through to `tdb.env` unchanged, so you
can also supply raw chrono syntax directly.

---

## Querying TDB Data {#query}

TDB supports SQL queries over its compressed chunks. The `SqlPlanner` translates a SQL string
into a `LogicalPlan`; the `QueryExecutor` scans only the chunks whose time range and min/max
statistics satisfy the predicates.

### Basic time-range query

```sql
SELECT temperature, pressure
FROM   metrics
WHERE  timestamp >= 1_700_000_000_000
  AND  timestamp <= 1_700_003_600_000;
```

`timestamp` values are Unix milliseconds (ms since epoch).

### Relative time expressions (`Now()`) {#relative-time}

Instead of raw millisecond literals, `Now()` and `Now() - <n><unit>` can be used
anywhere a timestamp is expected. They are rewritten to millisecond literals before
parsing, so they work in every query interface (Web, REST, CLI, gRPC):

```sql
-- Explicit bounds with Now()
SELECT * FROM metrics
WHERE  timestamp >= Now() - 1hour
  AND  timestamp <= Now();

-- Chained offsets
SELECT * FROM metrics
WHERE  timestamp >= Now() - 1day - 30min;
```

**Shorthand**: a `WHERE` clause consisting of just a `Now()` offset expands to a
`timestamp >=` lower bound — "everything in the last N":

```sql
SELECT * FROM metrics WHERE Now() - 1hour;          -- last 1 hour
SELECT * FROM metrics WHERE Now() - 1day LIMIT 500; -- last 1 day, capped at 500 rows
SELECT * FROM metrics WHERE Now() - 30sec;          -- last 30 seconds
```

Supported units (case-insensitive, singular or plural):

| Unit | Aliases |
|------|---------|
| seconds | `sec`, `second`, `s` |
| minutes | `min`, `minute`, `m` |
| hours | `hour`, `hr`, `h` |
| days | `day`, `d` |
| weeks | `week`, `w` |

An unrecognized unit (e.g. `- 5fortnights`) is left untouched and surfaces as a
normal SQL parsing error.

### Value filter

```sql
SELECT motor_rpm
FROM   equipment
WHERE  timestamp >= 1_700_000_000_000
  AND  motor_rpm > 3000.0;
```

### Aggregation with time bucketing (resampling)

`time_bucket('<interval>', timestamp)` groups rows into fixed-width windows — the
time-series *resample* operation. Combine it with `GROUP BY 1` (group by the first
select item) and one or more aggregate functions:

```sql
-- Resample to 5-minute buckets: min / avg / max per window
SELECT time_bucket('5m', timestamp),
       min(temperature),
       avg(temperature),
       max(pressure)
FROM   sensors
WHERE  timestamp >= Now() - 1day
GROUP  BY 1
ORDER  BY 1;
```

Descriptive statistics per bucket (spread and central tendency):

```sql
SELECT time_bucket('1h', timestamp),
       avg(temperature),
       stddev(temperature),
       median(temperature)
FROM   sensors
WHERE  Now() - 1day
GROUP  BY 1;
```

Row throughput per minute, and a single-row summary over the whole range:

```sql
SELECT time_bucket('1m', timestamp), count(*)
FROM   metrics WHERE Now() - 1hour GROUP BY 1;

SELECT avg(motor_rpm), min(motor_rpm), max(motor_rpm)
FROM   equipment WHERE Now() - 1hour;   -- no GROUP BY -> one summary row
```

Each aggregated row is timestamped at the **bucket start**; on the Web Query page the
result is charted and shown in the grid exactly like a raw-row query.

### Supported statements

| Statement | Description |
|-----------|-------------|
| `SELECT … FROM … WHERE …` | Time-range scan with optional column projection and value filter |
| `SELECT … GROUP BY time_bucket(…)` | Aggregation with time bucketing |
| `SHOW TABLES` | List all tables with recorded data |
| `DELETE FROM … WHERE timestamp < …` | Remove data older than a threshold |
| `DROP TABLE …` | Delete all data for a table |

### Supported aggregation functions

Aggregates are executed **server-side** across every query interface. `time_bucket(...)`
resamples the series into fixed windows; without a `time_bucket`/`GROUP BY` the whole
matched range collapses to a single summary row.

| Function | Aliases | Description |
|----------|---------|-------------|
| `avg(col)` | `mean` | Arithmetic mean |
| `sum(col)` | | Sum of values |
| `count(col)` | | Number of non-missing values in the bucket |
| `count(*)` | | Number of rows in the bucket |
| `min(col)` | | Minimum value |
| `max(col)` | | Maximum value |
| `stddev(col)` | `std`, `stddev_samp` | Sample standard deviation (ddof = 1) |
| `variance(col)` | `var`, `var_samp` | Sample variance (ddof = 1) |
| `median(col)` | | Median (mean of the two middle values for even counts) |
| `first(col)` | | Earliest value in the bucket (by timestamp) |
| `last(col)` | | Latest value in the bucket (by timestamp) |

Output columns are named `{func}_{col}` (e.g. `avg_temperature`, `stddev_pressure`);
`count(*)` is named `count`. `stddev`/`variance` return an empty value for buckets with
fewer than two samples.

### `time_bucket` intervals

`s` (seconds), `m` (minutes), `h` (hours), `d` (days)

```sql
time_bucket('15m', timestamp)   -- 15-minute buckets
time_bucket('1h',  timestamp)   -- 1-hour buckets
time_bucket('1d',  timestamp)   -- 1-day buckets
```

---

## Query Interfaces {#query-interfaces}

TDB data can be queried through four interfaces. All of them go through the same
`SqlPlanner` → `QueryExecutor` pipeline, so the SQL syntax above applies everywhere.

| Interface | Access | Statements |
|-----------|--------|------------|
| **Web Query page** | Port web UI (`http://localhost:8000`) → **TDB Query** menu | `SELECT`, `SHOW TABLES` (read-only) |
| **REST API** | `POST /api/v1/tdb/sql` | `SELECT`, `SHOW TABLES` (read-only) |
| **CLI** | `port query "<SQL>"` | All statements including `DELETE` / `DROP` |
| **gRPC** | `ExecuteSqlQuery` (localhost:50051) | All statements including `DELETE` / `DROP` |

### Web Query page

The **TDB Query** menu in the Port web UI (left icon bar, database icon) provides an
interactive SQL console:

1. Type a query in the SQL editor — or pick one from **Examples** (list tables, latest rows,
   `Now() - 1hour` relative-range templates, and `time_bucket` resample / descriptive-stats
   templates) or **History** (your last 10 successful queries).
2. Press **Run** or `Ctrl+Enter`.
3. A **time-series chart** of the result is drawn above the grid (up to 8 series, one line
   per column, hover for per-point values). Toggle it with the **Chart** button in the
   result bar.
4. Results appear in a data grid: a `Time` column (formatted from the Unix-ms timestamp)
   plus one column per selected key. `SHOW TABLES` renders as a table list.

The result bar shows the row count, elapsed time, and whether the result was truncated
by the row cap (default 10,000 rows).

:::warning Web Query page is read-only
`DELETE` and `DROP` are rejected on the Web Query page and REST API. Run destructive
statements from the CLI (`port query`) instead.

`SELECT` (raw rows) and aggregate/resample queries (`time_bucket` + `avg`/`sum`/`count`/
`min`/`max`/`stddev`/`variance`/`median`/`first`/`last`) both run server-side here.
:::

:::info Aggregation input cap
Aggregate queries scan up to **200,000** raw rows to build their buckets. If the matched
range exceeds that, the result is aggregated over the first 200,000 rows and the response
is flagged as truncated — narrow the time range (e.g. `Now() - 1hour`) for exact results.
:::

### REST API

```bash
curl -X POST http://localhost:8000/api/v1/tdb/sql \
  -H "Content-Type: application/json" \
  -d '{"sql": "SELECT * FROM metrics LIMIT 100;", "max_rows": 1000}'
```

Response (column order in `columns`, one entry per row in `rows`):

```json
{
  "success": true,
  "message": "Returned 100 row(s) in 12 ms",
  "kind": "rows",
  "columns": ["room1/custom.Done_i"],
  "rows": [ { "ts": 1767600000000, "values": { "room1/custom.Done_i": 1.0 } } ],
  "count": 100,
  "truncated": false,
  "elapsed_ms": 12
}
```

Related endpoints used by the **TDB Trend** menu (chart + data grid):

| Endpoint | Purpose |
|----------|---------|
| `GET /api/v1/tdb/variables` | List every recorded variable with its time coverage |
| `GET /api/v1/tdb/data?start_ts=&end_ts=&keys=` | Column-oriented decoded values for charting |

### CLI

```bash
port query "SHOW TABLES;"
port query "SELECT * FROM metrics WHERE timestamp >= 1767600000000 LIMIT 100;"
port query "DELETE FROM metrics WHERE timestamp < 1767000000000;"   # destructive — CLI only
```

### TDB Trend page (no SQL required)

For visual exploration without writing SQL, use the **TDB Trend** menu instead:
select up to 8 variables, watch them stream in **Live** mode (1-second moving window),
or switch to **History** mode for a fixed date/time range with drag-to-zoom.
The grid below the chart shows the same rows as a Time × key table.

---

## Alarm Backup {#alarm-backup}

`TdbBackupManager` automatically saves a snapshot of sensor history whenever an alarm fires.
The snapshot covers the window defined by `TDB_ALARM_BACKUP_DURATION_SECONDS` (default 600 s = 10 minutes)
before the alarm timestamp. This allows post-incident analysis without requiring full-history retention.

---

## File Layout {#file-layout}

```
{TDB_STORAGE_PATH}/
├── {table}.tdb          # primary data file (append-only)
├── {table}_2.tdb        # rotation file (after 1 GB)
├── {table}_3.tdb
└── {table}.wal          # write-ahead log (CSV, for crash recovery)
```

Files auto-rotate at 1 GB. Rotation appends a numeric suffix; the base name corresponds to the
table name used in SQL queries.

---

## Related

- [Flow](flow) — `[FlowWatcherCompare]` entries are the source of watcher keys fed into TDB
- [Commands](commands) — `port run` starts the Port Server that drives TDB recording
- [Quick Start](quick) — Entry definition syntax and data types
