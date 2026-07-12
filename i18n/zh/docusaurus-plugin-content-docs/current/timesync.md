---
id: timesync
---

# TimeSync

**PORT TimeSync Client** 是一款轻量级 Windows 托盘应用程序，用于让工厂网络中的
所有 PC 时钟保持一致。它可以监控相对于一个或多个 SNTP 时间主机的时钟偏移，
自身也可以作为时间主机运行，并通过 mDNS 自动发现局域网中的主机 —
无需配置文件，也没有运行时依赖。

## 下载

| 名称 | 版本 | 操作系统 | 要求 | 链接 |
|------|------|----------|------|------|
| TimeSync Client (便携版) | v1.0.0 | Windows x64 | 无 — 单个 exe | [TimeSyncClient.zip](pathname:///file/TimeSyncClient.zip) |

:::tip 便携单文件
下载内容是一个自包含的可执行文件。无需安装程序、.NET 运行时或额外 DLL —
解压后直接运行 `TimeSyncClient.exe` 即可。
:::

## 主要功能

- **时钟偏移监控** — 通过 SNTP (RFC 5905) 轮询每个已注册主机，实时显示各主机的
  *Offset (ms)*、*RTT (ms)* 和 *Stratum*。
- **系统托盘** — 托盘图标按最差主机状态着色（绿色 = 正常，琥珀色 = 超过阈值，
  红色 = 无响应），主机状态恶化时弹出气泡通知。关闭窗口时应用隐藏到托盘。
- **主机自动发现 (mDNS)** — 广播 `_porttime._udp.local` 的主机会自动出现在
  *Discovered hosts* 列表中，选中后点击 **Add** 即可开始监控。
- **内置时间主机** — 可将本机作为 SNTP 时间主机运行（默认绑定 `0.0.0.0:123`）。
  运行期间通过 mDNS 广播自身，供其他客户端自动发现。
- **随 Windows 启动** — 可选的按用户自动启动（以托盘最小化方式启动）。

## 快速开始

1. 下载并解压 [TimeSyncClient.zip](pathname:///file/TimeSyncClient.zip)。
2. 运行 `TimeSyncClient.exe`。主窗口打开，托盘中同时出现图标。
3. 稍等片刻，局域网中的时间主机会显示在 **Discovered hosts (mDNS)** 中。
   选中后点击 **Add selected**，或直接输入 `192.168.10.10:123` 形式的地址并点击 **Add**。
4. 在 **Hosts** 网格中查看每台主机的实时偏移、往返延迟、Stratum 和最后检查时间。
5. 若要将本机作为时间主机，在 *Settings* 中启用 **Run local SNTP host** 并点击 **Save**。

## 设置

| 设置 | 默认值 | 说明 |
|------|--------|------|
| Poll interval | 30 秒 | 所有主机的自动轮询间隔 |
| Timeout | 1000 ms | 每次 SNTP 查询的接收超时 |
| Warn offset | 100 ms | 使主机变为琥珀色并触发告警的绝对偏移 |
| Run local SNTP host | 关 | 在下方绑定地址上运行时间主机 |
| Host bind | `0.0.0.0:123` | 内置时间主机的绑定地址 |
| Start with Windows | 关 | 登录时按用户自动启动（以托盘方式启动） |
| Start minimized | 关 | 启动时隐藏到托盘而不显示窗口 |

设置保存在 `%AppData%\PortTimeSync\settings.json`。

## 托盘菜单

| 项目 | 操作 |
|------|------|
| **Open**（双击） | 恢复主窗口 |
| **Sync now** | 立即轮询所有主机 |
| **Run local host** | 切换内置 SNTP 主机 |
| **Exit** | 停止主机并退出 |

## 工作原理

- **SNTP** — 每次轮询是一次 48 字节的请求/响应交换。客户端根据 RFC 5905 的
  四个时间戳计算偏移和延迟，并拒绝 *Originate Timestamp* 与请求不匹配的响应
  （防止过期/伪造响应）。偏移为正表示本地时钟落后于主机。
- **mDNS 发现** — 主机广播服务类型 `_porttime._udp.local` (RFC 6762/6763)。
  支持多网卡环境：客户端在每个 IPv4 接口上加入组播组。
- **防火墙说明** — 内置主机监听 UDP 123，mDNS 使用 UDP 5353（组播
  `224.0.0.251`）。若无法发现主机，请在 *专用/域* 配置文件中放行这些端口的入站流量。

:::note 仅监控
TimeSync Client 只报告时钟偏移，不会修改 Windows 系统时钟。请根据测得的偏移，
使用操作系统时间服务（如 `w32tm`）或人工操作来校正时钟。
:::
