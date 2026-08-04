# PortLink (リモートデータリンク)

## 概要

PortDIC は `portlink.dll` ベースの QUIC 産業用リモートデータリンク (`PortLink`) を提供します。遠隔地間（工場 ↔ 本社、装置 ↔ 装置）でテレメトリ、アラーム、コマンドを TLS 1.3 上で 3 段階の配信保証により交換します。

**主な特徴:**
- QUIC over UDP + TLS 1.3 — 常時暗号化、平文モードなし
- 証明書ピンニング + 事前共有キー (PSK) 認証 — CA なしで MITM を防御
- 3 段階 QoS:

| QoS | 保証 | トランスポート | 用途 |
|-----|-----|-----|-----|
| Q0 `BestEffort` | 損失許容 | QUIC datagram | 高頻度テレメトリ |
| Q1 `AtLeastOnce` | Ack まで再送 | ストリーム + バッチ ack | アラーム、重要テレメトリ |
| Q2 (コマンド) | Exactly-once effect | リクエスト毎ストリーム + idempotency key | 状態変更コマンド |

- クライアント自動再接続 + 未確認 Q1 メッセージの再送
- **Set ミラーリング** — ローカル `Port.Set` 値をリモートへ自動複製
- 1 プロセスで複数インスタンス運用可能（サーバー/クライアント役割の共存）

`portlink.dll` は他のネイティブプロトコルライブラリと同様に `C:\Program Files\Port\PortDIC\lib\` からロードされます。

---

## クイックスタート

### サーバー（工場側）

```csharp
using Portdic.Protocol.Link;

var server = new PortLink("factoryA");

server.OnConnection += (name, nodeId, connected) =>
    Console.WriteLine($"[{name}] {nodeId} {(connected ? "接続" : "切断")}");

server.OnMessage += (name, nodeId, topic, qos, payload) =>
    Console.WriteLine($"[{name}] {topic} = {Encoding.UTF8.GetString(payload)}");

server.OnCommand += (name, nodeId, topic, payload, corrId) =>
{
    // コマンドを実行して応答。ハンドラー内での同期応答は安全です。
    server.RespondCommand(corrId, 0, Encoding.UTF8.GetBytes("ok"));
};

server.StartServer(7443, "psk-secret");

// ピンニング用証明書をクライアントへ配布（ファイル、USB など）
byte[] certDer = server.GetServerCert();
```

### クライアント（遠隔地）

```csharp
using Portdic.Protocol.Link;

PortLink.SetPinnedCert(certDer);          // MITM 防御: サーバー証明書をピン留め

var client = new PortLink("line1");
client.Connect("203.0.113.10", 7443, "eq01", "psk-secret");

// テレメトリ（既定 Q1 at-least-once）
client.Publish("room1/Temp1", "41.5");

// 損失許容の高頻度値 (Q0)
client.Publish("room1/Vibration", vibBytes, LinkQos.BestEffort, ttlMs: 2000);

// アラーム
client.Publish("alarm/A100", "over-temp", LinkQos.AtLeastOnce, LinkMessageClass.Alarm);
```

`Connect` が一度成功すると、`Close()` を呼ぶまでエンジンが自動再接続（backoff 最大 10 秒）します。再接続時、未確認の Q1 メッセージは自動再送されます。

---

## コマンド (Q2 — Exactly-Once Effect)

状態変更コマンドは idempotency key を使い、再試行・再接続が重なっても効果は最大 1 回だけコミットされます。

```csharp
// 送信側 — 最終結果またはタイムアウトまでブロック（内部再試行を含む）
int code = client.SendCommand("robot/move",
    Encoding.UTF8.GetBytes("{\"target\":120.5}"),
    out byte[] result,
    idempotencyKey: "job42-move1",     // null = 自動生成
    timeoutMs: 30000);

// 呼び出しスレッドをブロックしない場合:
var (code2, result2) = await client.SendCommandAsync("robot/move", payload);
```

```csharp
// 受信側 — OnCommand 内で 30 秒以内に応答
server.OnCommand += (name, nodeId, topic, payload, corrId) =>
    server.RespondCommand(corrId, 0, resultBytes);
```

**結果コード:** アプリケーションコードは `>= 0`、負値はエンジンエラー (`LinkResult`) です。**同一 idempotency key** での再試行はコミット済みコマンドを再実行せず、保存済み結果を再応答します。同じキーで*異なる* payload は `IdempotencyConflict` (-6) で拒否されます。

| 状況 | 動作 |
|---|---|
| 重複キー、同一 payload、コミット済み | 保存結果を再応答; 受信ハンドラーは再呼び出しされない |
| 重複キー、同一 payload、実行中 | `InProgress` (-11); 送信側はタイムアウト内で再試行継続 |
| 重複キー、異なる payload | `IdempotencyConflict` (-6) |
| 受信アプリ無応答（30 秒） | `UnknownOutcome` (-13); 以後の再試行で再実行される可能性あり |

---

## Set ミラーリング

`EnableMirror` はこのプロセスの `Port.Set` 呼び出しをリモートピアへ自動複製します — 明示的な `Publish` は不要です。受信したミラー値はローカル entry に書き込まれ、構造的にエコーループは発生しません。

```csharp
// 送信サイト
var link = new PortLink("line1");
link.Connect("203.0.113.10", 7443, "eq01", "psk-secret");
link.EnableMirror("room1.*");            // room1 グループをミラーリング

Port.Set("room1.Temp1", 41.5);           // リモートへ自動到達
```

```csharp
// 受信サイト（サーバー）
var hub = new PortLink("hq");
hub.StartServer(7443, "psk-secret");
hub.EnableMirror("room1.*");             // 受信値をローカル entry に適用
```

| `EnableMirror` パラメータ | 既定値 | 説明 |
|---|---|---|
| `pattern` | `"*"` | カンマ区切りフィルタ: 完全一致 `"room1.Temp1"`、グループ `"room1.*"`、全体 `"*"` |
| `qos` | `AtLeastOnce` | ミラー値の配信保証 |
| `ttlMs` | `0` | ミラー値の有効期限 (0 = 無期限) |
| `applyIncoming` | `true` | 受信値をローカル entry に書き込み |
| `targetNode` | `null` | サーバーモード: 特定ノードのみへミラーリング |

**注意:**
- ワイヤの topic はドット表記キー (`room1.Temp1`)、payload は値文字列です。
- **このプロセスが実行した** Set のみキャプチャされます。Rust port サーバー内部（例: rule engine）で書かれた値はミラーリングされません。
- キャプチャはバックグラウンドポンプで発行されるため、アプリの `Set` パスがネットワーク I/O でブロックされることはありません。
- リンク切断中にキャプチャされた Set は破棄されます（切断ごとに最初の破棄 1 回だけ `OnError` が発生）。

---

## セキュリティ

1. **TLS 1.3** — 常時有効; サーバーは起動時に自己署名証明書を生成します。
2. **証明書ピンニング** — `Connect` の前に `PortLink.SetPinnedCert(certDer)` を呼び出してください。ピンなしでは暗号化はされますが MITM に脆弱です（イントラネット限定; 警告ログ出力）。
3. **PSK** — すべてのクライアントはセッション hello でサーバーの事前共有トークンを提示する必要があり、不一致はデータ交換前に `Unauthenticated` (-3) で拒否されます。

```csharp
// サーバー側: 一度エクスポートし、別経路で配布
File.WriteAllBytes("factoryA.der", server.GetServerCert());

// クライアント側: 接続前にピン留め
PortLink.SetPinnedCert(File.ReadAllBytes("factoryA.der"));
```

---

## API リファレンス

### コンストラクタ / ライフサイクル

| メンバー | 説明 |
|---|---|
| `new PortLink(string name)` | インスタンス生成; `name` はコールバックルーティングキー。 |
| `StartServer(int port, string psk)` | `0.0.0.0:port` (UDP) で待ち受け。 |
| `Connect(string host, int port, string nodeId, string psk)` | 接続 + 認証; 最初のセッションまでブロック、以後自動再接続。 |
| `Close()` / `Dispose()` | インスタンス終了（クライアントは再接続を停止）。 |
| `IsDllLoaded` (static) | `portlink.dll` エクスポートのロード状態。 |

### データ

| メンバー | 説明 |
|---|---|
| `Publish(topic, byte[]/string, qos, messageClass, ttlMs, targetNode)` | テレメトリ (class 1) / アラーム (class 2) を Q0/Q1 で送信。 |
| `SendCommand(topic, payload, out result, idemKey, timeoutMs, targetNode)` | ブロッキング Q2 コマンド; アプリコード (≥0) または `LinkResult` (<0) を返す。 |
| `SendCommandAsync(...)` | スレッドプールラッパー、`(code, result)` を返す。 |
| `RespondCommand(corrId, resultCode, payload)` | `OnCommand` で受けたコマンドへ応答。 |
| `EnableMirror(pattern, qos, ttlMs, applyIncoming, targetNode)` | このインスタンスの Set ミラーリングを開始。 |
| `DisableMirror()` | ミラーリングを停止。 |

### セキュリティ / 診断

| メンバー | 説明 |
|---|---|
| `GetServerCert()` | クライアントピンニング用サーバー証明書 (DER)。 |
| `SetPinnedCert(byte[])` (static) | 以後の `Connect` に使うサーバー証明書ピン。 |
| `SetLogger(rootPath[, PortLogConfiguration])` | ローテーションファイルログ (TCP/Serial/FileSender と同一設定オブジェクト)。 |
| `GetLastError()` (static) | 呼び出しスレッドの直近失敗の詳細メッセージ。 |

### イベント (named delegate)

| イベント | デリゲート | 発生タイミング |
|---|---|---|
| `OnMessage` | `LinkMessageHandler(name, nodeId, topic, qos, payload)` | テレメトリ/アラーム受信。 |
| `OnCommand` | `LinkCommandHandler(name, nodeId, topic, payload, corrId)` | Q2 コマンド受信 — `RespondCommand` で応答。 |
| `OnConnection` | `LinkConnectionHandler(name, nodeId, connected)` | ピアセッション接続/切断（クライアントではサーバーピアは `"@server"`）。 |
| `OnError` | `LinkErrorHandler(name, code, message)` | 非同期エンジンエラー（例: キュー超過 drop）。 |

コールバックは portlink ランタイムスレッドで到着します — UI スレッドへのマーシャリングは自身で行い、ハンドラーは短く保ってください。

### LinkResult コード

| コード | 値 | 意味 |
|---|---|---|
| `Ok` | 0 | 成功。 |
| `InvalidArgument` | -1 | 不正な引数。 |
| `Unauthenticated` | -3 | PSK 不一致。 |
| `Expired` | -4 | TTL 超過。 |
| `IdempotencyConflict` | -6 | 同一キー、異なる payload。 |
| `RateLimited` | -7 | 待機キュー満杯。 |
| `Unavailable` | -8 | 接続ピアなし / 一時障害。 |
| `DeadlineExceeded` | -9 | コマンドタイムアウト。 |
| `PayloadTooLarge` | -10 | 1 MiB フレーム上限/結果バッファ超過。 |
| `InProgress` | -11 | コマンド実行中。 |
| `UnknownOutcome` | -13 | 結果未確認 — 装置状態を照会してください。 |
| `NotFound` | -14 | インスタンスまたは待機コマンドなし。 |
| `DllNotLoaded` | -98 | `portlink.dll` 未ロード。 |

---

## 運用既定値

| 項目 | 既定値 |
|---|---|
| フレーム上限 | 1 MiB |
| keep-alive / idle timeout | 10 秒 / 30 秒 (QUIC レベル) |
| Q1 再試行 backoff | 200ms ×2 上限 5 秒、±20% jitter |
| Q1 未確認キュー上限 | 10,000 件 (oldest drop) |
| Q2 dedup 保持 | 24 時間 (インメモリ) |
| コマンド応答ウィンドウ (受信アプリ) | 30 秒 |
| 再接続 backoff | 500ms ×2 上限 10 秒 |
