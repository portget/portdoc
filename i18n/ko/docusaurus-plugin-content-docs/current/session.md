# Session

## Overview

PortDIC provides an operator session management handler (`ISessionHandler`) for SEMI E30 compliant systems. It handles user authentication (login/logout), role-based access control, and Control State transitions (Offline / Local / Remote). Passwords are hashed with bcrypt via the Rust FFI layer.

The Session handler is a **singleton** — one instance is shared across all `[Auth]`-decorated classes in the application.

---

## Quick Setup

### 1. Define an Auth class

```csharp
using Portdic;

[Auth]
[Package("security")]
public class SecurityPackage
{
    [SessionHandler]
    public ISessionHandler Session { get; set; }

    [Preset]
    void Init()
    {
        // Register users on startup
        Session.AddUser("admin",    "admin123",   "Administrator", roleLevel: 3);
        Session.AddUser("operator", "op_pass",    "Operator",      roleLevel: 1);
        Session.AddUser("viewer",   "view_pass",  "Viewer",        roleLevel: 0);

        Session.OnSessionChanged      += OnSessionChanged;
        Session.OnAuthenticationFailed += OnAuthFailed;
        Session.OnSessionTimeout      += OnTimeout;
    }

    private void OnSessionChanged(SessionEventArgs e)
    {
        Console.WriteLine($"[Auth] {e.ChangeType}: user={e.UserId}, role={e.RoleLevel}");
    }

    private void OnAuthFailed(AuthFailureEventArgs e)
    {
        Console.WriteLine($"[Auth] Failed: user={e.AttemptedUserId}, reason={e.FailureReason}, count={e.FailureCount}");
    }

    private void OnTimeout(TimeOutEventArgs e)
    {
        Console.WriteLine($"[Auth] Timeout: user={e.UserId}, idle={e.InactivityDuration}");
    }
}
```

### 2. Register and run

```csharp
Port.Add<SecurityPackage>("security");
Port.Run();
```

---

## Authentication

```csharp
// Login
bool ok = Session.Login("operator", "op_pass");
if (!ok)
    Console.WriteLine("Login failed");

// Check current session
Console.WriteLine(Session.IsAuthenticated);       // true
Console.WriteLine(Session.CurrentUserId);         // "operator"
Console.WriteLine(Session.CurrentRoleLevel);      // 1
Console.WriteLine(Session.LoginTime);             // DateTime

// Logout
Session.Logout();

// Change password (verifies current password first)
Session.SetPassword("operator", "op_pass", "new_secure_pass");

// List all registered users
List<string> users = Session.GetUsers();
```

---

## Role-Based Access Control

Role levels are plain integers — higher values grant more privileges.

| Role Level | Typical Role | Capabilities |
|------------|-------------|-------------|
| 0 | Viewer | Read-only access |
| 1 | Operator | Can switch to Local control |
| 2 | Engineer | Can switch to Remote control |
| 3 | Administrator | Full access |

```csharp
// Check role before allowing an action
if (Session.CurrentRoleLevel >= 2)
{
    // allowed for Engineer and above
}

// Get session info programmatically
int role   = Session.GetCurrentSessionRole();
string uid = Session.GetCurrentSessionUserID();
string name = Session.GetCurrentSessionUserName();
DateTime loginTime = Session.GetCurrentSessionLoginTime();
```

---

## Control State (SEMI E30)

Transitions between Offline / Local / Remote are authorized against the current user's role level. The minimum required role level per state is enforced by the Rust FFI layer.

```csharp
// Attempt to transition the equipment control state
bool granted = Session.ReassignControlState(ControlState.Remote);
if (!granted)
    Console.WriteLine("Insufficient role level for Remote control");
```

| `ControlState` | Description | Typical Minimum Role |
|---------------|-------------|---------------------|
| `Offline` | Equipment not accepting remote commands | — |
| `Local` | Local operator control | 1 |
| `Remote` | Host system control | 2 |

---

## API Reference

### Attributes

| Attribute | Target | Description |
|-----------|--------|-------------|
| `[Auth]` | Class | Marks the class as authentication-aware |
| `[SessionHandler]` | Property | Injects the shared `ISessionHandler` singleton |
| `[Preset]` | Method | Called after injection to configure the handler |

### Properties

| Property | Type | Description |
|----------|------|-------------|
| `CurrentUserId` | `string` | Logged-in user ID, or `""` if not authenticated |
| `CurrentRoleLevel` | `int` | Role level of the logged-in user, or `-1` if not authenticated |
| `LoginTime` | `DateTime` | Timestamp when the current user logged in |
| `IsAuthenticated` | `bool` | `true` if a user is currently logged in |

### User management methods

| Method | Returns | Description |
|--------|---------|-------------|
| `AddUser(userId, password, name, roleLevel)` | `bool` | Register a new user. Password is bcrypt-hashed |
| `Login(userId, password)` | `bool` | Authenticate a user |
| `Logout()` | — | Log out the current user |
| `SetPassword(userId, currentPassword, newPassword)` | `bool` | Change a user's password (verifies current password) |
| `GetUsers()` | `List<string>` | Return all registered user IDs |

### Session query methods

| Method | Returns | Description |
|--------|---------|-------------|
| `GetCurrentSessionRole()` | `int` | Role level of the current session, or `-1` |
| `GetCurrentSessionUserID()` | `string` | User ID of the current session, or `""` |
| `GetCurrentSessionUserName()` | `string` | Display name of the current user, or `""` |
| `GetCurrentSessionLoginTime()` | `DateTime` | Login timestamp, or `DateTime.MinValue` |

### Control state

| Method | Returns | Description |
|--------|---------|-------------|
| `ReassignControlState(ControlState)` | `bool` | Attempt a control state transition (role-checked) |

| `ControlState` | Value | Description |
|---------------|-------|-------------|
| `Offline` | — | Equipment offline |
| `Local` | — | Local control mode |
| `Remote` | — | Remote host control |

### Logging

| Method | Description |
|--------|-------------|
| `SetLogger(string rootPath)` | Enable hourly-rotated session log files. Format: `session_{date}_{hour}.log` |
| `WriteLog(string message)` | Write a custom entry prefixed with `[Session][{userId}]` |

---

## Events

### `OnSessionChanged`

Fired when a user logs in, logs out, or is forcefully logged out.

```csharp
Session.OnSessionChanged += (SessionEventArgs e) =>
{
    // e.UserId, e.RoleLevel, e.ChangeType, e.Timestamp, e.ClientIp
    Console.WriteLine($"{e.ChangeType}: {e.UserId} (role={e.RoleLevel})");
};
```

| `SessionChangeType` | Description |
|--------------------|-------------|
| `Login` | User logged in |
| `Logout` | User logged out normally |
| `ForcedLogout` | User was forcefully logged out (e.g., by admin or timeout) |

### `OnAuthenticationFailed`

Fired when a login attempt fails.

```csharp
Session.OnAuthenticationFailed += (AuthFailureEventArgs e) =>
{
    // e.AttemptedUserId, e.FailureReason, e.FailureCount, e.ClientIp, e.Timestamp
    Console.WriteLine($"Failed login: {e.AttemptedUserId} — {e.FailureReason} (attempt {e.FailureCount})");
};
```

### `OnSessionTimeout`

Fired when the current session times out due to inactivity.

```csharp
Session.OnSessionTimeout += (TimeOutEventArgs e) =>
{
    // e.UserId, e.LastActivityTime, e.InactivityDuration, e.Timestamp
    Console.WriteLine($"Session expired: {e.UserId} after {e.InactivityDuration}");
};
```

---

## Security Notes

- Passwords are **never stored in plaintext** — bcrypt hashing is applied by the Rust FFI layer.
- The singleton pattern ensures all `[Auth]` classes share one session state — a login from one component is visible to all.
- Role-level enforcement for Control State transitions is performed on the Rust side, not in C#.

---

## Related

- [attribute](attribute) — Port attribute reference (`[Package]`, `[Controller]`, etc.)
- [SECS/GEM](secs) — GEM Control State management (S1F17 Online/Offline)
