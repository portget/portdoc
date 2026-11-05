---
toc_min_heading_level: 2
toc_max_heading_level: 3
---

# MCP — SECS/GEM Testing with Claude

The port server exposes its SECS/GEM test surface as an **MCP (Model Context Protocol)** server.
Any MCP client — Claude Code, Claude Desktop, or your own agent — can connect over the network
and drive SECS/GEM communication against the equipment application attached to that server:
inject host messages, run scenarios, read the real wire traffic, and operate GEM
(events, alarms, variables, control state).

```
Claude (another PC)  ──MCP/HTTP──▶  port server :8000/mcp  ──gRPC──▶  porthsms.dll (equipment app)  ──HSMS──▶  host
```

The tools are the same operations the web **SECS Scenario Editor** and the
`/api/v1/secs/*` REST API use; nothing runs through MCP that you could not already do from the editor.

## Connect from another PC

1. On the equipment PC, run the project as usual (`port run <project>`, or the port service).
   The MCP endpoint is `http://<equipment-pc-ip>:8000/mcp` (the web UI port, `WEB_PORT` in `project.env`).
   `WEB_HOST` must be `0.0.0.0` (the default) for LAN access; `127.0.0.1` restricts it to the local machine.
2. Allow TCP 8000 through the Windows firewall on the equipment PC (the installer adds this rule).
3. On your PC, register the server in Claude Code:

```bash
claude mcp add --transport http port-secs http://192.168.0.44:8000/mcp
claude mcp list          # port-secs: ... - ✔ Connected
```

Then ask Claude in natural language, for example:

> "Check the SECS status, then run the comm-online scenario (S1F13 → S1F17 → S1F3) and show me the wire traffic."

Claude Desktop and other clients take the same URL as a *remote (HTTP) MCP server*.

### Authentication (optional)

Add a token to the project's `project.env` and restart the server:

```ini
# %LOCALAPPDATA%\port\env\<project>\project.env
MCP_TOKEN=change-me
```

Clients must then send `Authorization: Bearer change-me`:

```bash
claude mcp add --transport http port-secs http://192.168.0.44:8000/mcp \
  --header "Authorization: Bearer change-me"
```

Without `MCP_TOKEN` the endpoint is open, like the REST API it mirrors — use it only on a trusted LAN.

## Tools

| Tool | Kind | What it does |
|------|------|--------------|
| `secs_status` | read | HSMS/GEM connection snapshot (`connection_state`, `is_connected`, `is_online`, `device_id`) and recent HSMS events. **Call this first.** |
| `secs_monitor_messages` | read | The SECS traffic that actually flowed on the wire (ring buffer). `since_seq` / `last_seq` for incremental reads. This is the ground truth when a verdict looks wrong. |
| `secs_send_message` | write | One SECS message. `direction: "H2E"` injects a host message into the equipment and returns its reply (safe, virtual connection). `"E2H"` makes the equipment transmit to the connected host. |
| `secs_run_scenario` | write | Runs a scenario — saved (`name`) or inline (`steps`) — and returns one verdict per row: `sent` / `pass` / `fail` / `error`. |
| `secs_list_scenarios` / `secs_get_scenario` | read | Scenarios saved by the web editor or by `secs_save_scenario`. |
| `secs_save_scenario` | write | Saves (creates or replaces by name) a scenario; it appears in the web Scenario Editor too. |
| `gem_dictionary` | read | Registered SV / DV / ECV / CEID / alarm dictionary — look IDs up here instead of trusting a spec sheet. |
| `gem_get_variable` / `gem_set_variable` | read / write | Read or write a registered GEM variable by key. |
| `gem_send_event` | write | Equipment sends S6F11 for a CEID. The CEID must be enabled by the host (S2F37) first. |
| `gem_set_alarm` | write | Activates or clears an alarm (S5F1). The reply's `linked_ceid` is the event to send next. |
| `gem_get_control_state` / `gem_set_control_state` | read / write | GEM control state 0–5 (`EQ_OFFLINE` … `ONLINE_REMOTE`). |

Every tool carries MCP annotations (`readOnlyHint`, `destructiveHint`) so clients can ask for
confirmation before the write tools run.

### Scenario rows

```json
{ "stream": 1, "function": 13, "direction": "H2E", "wait_bit": true,  "body": "[]" },
{ "stream": 1, "function": 14, "direction": "E2H", "wait_bit": false, "body": "" }
```

- A `wait_bit: true` H2E row is checked against the **E2H row that follows it** (stream/function; the body too when `verify_body` is set).
- Other E2H rows are really sent to the connected host.
- `body` is PORT SML JSON: list `[...]`, string `"A"`, typed item `{"Type":"B","Value":128}`.
  Examples: S1F13 `[]` · S2F37 `[true, [150, 151]]` · S2F41 `["START", []]` · S5F1 `[{"Type":"B","Value":128}, 100, "text"]`

### Reading results

| Verdict | Meaning |
|---------|---------|
| `pass` | Reply matched the expected stream/function (and body when verified). |
| `sent` | Row sent; no reply expected (includes E2H broadcasts). |
| `fail` | A reply arrived but differed from the expectation → equipment behaviour to investigate. |
| `error` | HSMS could not process the row (no equipment, timeout, conversion error) → environment or input problem. |

GEM-level refusals (for example `CEID 150 is not enabled`) come back as a normal result with
`success: false`; only argument mistakes and an unreachable equipment are reported as tool errors.

## Typical session

```
secs_status                       → is_connected must be true for E2H / events
gem_dictionary {kind:"ceid"}      → which CEIDs exist
secs_run_scenario (S1F13, S1F17)  → communication + online
secs_send_message S2F33/S2F35/S2F37 (H2E) → host defines, links and enables the report
gem_send_event {ceid:150}         → equipment sends S6F11
secs_monitor_messages             → confirm S6F11 → S6F12 on the wire
```

## Safety

These tools act on real equipment: alarms are raised, control state changes, events reach the
host. H2E injection, dictionary/variable reads and the monitor are read-only or virtual and safe;
treat `gem_set_alarm`, `gem_set_control_state`, `gem_send_event` and E2H sends as production actions
when the equipment is connected to a live host.

## Protocol details

- Transport: MCP *Streamable HTTP* — JSON-RPC 2.0 over `POST /mcp`; replies are returned in the POST
  response (no server-initiated stream). `GET /mcp` answers 405, `DELETE /mcp` 204.
- Protocol versions: `2025-06-18`, `2025-03-26`, `2024-11-05`.
- Capabilities: `tools` only (no resources or prompts).
- Server name: `port-secs-gem`, version = port server version.

A dependency-free reference client is included in the repository:
`.claude/skills/secs-scenario/tools/mcp_client.py` (`list` / `call <tool> <json>`).
