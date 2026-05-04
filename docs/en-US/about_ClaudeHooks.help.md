# about_ClaudeHooks

## TOPIC

about_ClaudeHooks

## SHORT DESCRIPTION

Hook development model and response API for Claude Code hook scripts.

## LONG DESCRIPTION

### Hook Lifecycle

Claude Code hook scripts operate in a simple, event-driven model:

1. Claude Code fires an event (PreToolUse, Stop, etc.) and serializes the event context to JSON
2. It pipes the JSON to your hook script's stdin
3. Your script reads stdin, makes a decision, and emits a response JSON to stdout
4. Claude Code parses the response and acts accordingly based on the exit code

The entire transaction is synchronous and must complete within the configured timeout (default 5s).

### Event Names and Hook Types

Hooks are registered for specific events and optional tool matchers:

| Event | Matcher | Purpose |
|-------|---------|---------|
| `PreToolUse` | Tool name (Bash, Edit, etc.) | Approve/deny/modify a tool call before execution |
| `Stop` | Empty | Block a stop request |
| `UserPromptSubmit` | Empty | Block a user input before sending |
| `PostToolUse` | Tool name | React after tool execution |
| `SessionStart` | Empty | Inject context at session start |

### Decision Model

Your hook must emit one of these decisions in the JSON response:

| Situation | Response Field | Function | Notes |
|-----------|----------------|----------|-------|
| PreToolUse - allow | `hookSpecificOutput.permissionDecision: allow` | `Write-ClaudeHookAllow` | Tool executes unchanged |
| PreToolUse - deny | `hookSpecificOutput.permissionDecision: deny` | `Write-ClaudeHookDeny` | Tool blocked; message shown |
| PreToolUse - ask user | `hookSpecificOutput.permissionDecision: ask` | `Write-ClaudeHookAsk` | User prompted to approve/deny |
| PreToolUse - allow modified | `hookSpecificOutput` with tool input updates | `Write-ClaudeHookUpdatedInput` | Tool executes with new input |
| Stop/UserPromptSubmit/PostToolUse - block | `decision: block` | `Write-ClaudeHookBlock` | Action blocked; message shown |
| Any event - inject context | `systemMessage` | `Write-ClaudeHookContext` | Non-blocking; Claude reads message |
| Any event - show message | `systemMessage` | `Write-ClaudeHookResponse -SystemMessage` | Non-blocking; user sees message |
| Any event - hard error | exit code 2 | `Write-ClaudeHookResponse -BlockingError` | Hook error; stderr shown |

### Exit Code Semantics

- **0 (success)** - Hook executed normally. Claude Code parses the JSON response from stdout.
- **2 (blocking error)** - Hook encountered a fatal error. The response is sent to stderr (not parsed). Claude Code stops and shows the error to the user. Use `Write-ClaudeHookResponse -BlockingError` to trigger this.
- **Any other code (non-blocking error)** - Hook failed but non-fatally. Claude Code logs the error but continues. No stdout is parsed.

### Settings Scope Precedence

Hooks are registered to settings files in order of precedence (User < Project < Local < Plugin):

- **User** (`~/.claude/settings.json`) - Global hooks, always loaded
- **Project** (`.claude/settings.json` in project root) - Project-specific hooks
- **Local** (`.claude/settings.local.json`) - Machine-specific overrides (not committed)
- **Plugin** (`plugin.json` in plugin directory) - Plugin-provided hooks

When multiple hooks match the same event/matcher, all are executed in order of precedence. The first to emit `continue: false` or `decision: block` wins.

### Input JSON Shape

Claude Code sends this JSON structure to your hook on stdin (keys vary by event):

```json
{
  "session_id": "uuid",
  "cwd": "/path/to/project",
  "hook_event_name": "PreToolUse",
  "tool_name": "Bash",
  "tool_input": {
    "command": "rm -rf /"
  },
  "timestamp": "2026-05-03T12:34:56Z"
}
```

Not all fields are present for all events. PreToolUse includes `tool_name` and `tool_input`. SessionStart has minimal fields.

Use `Read-ClaudeHookInput` to parse this safely:

```powershell
$hook = Read-ClaudeHookInput
$command = $hook.tool_input.command
```

### Output JSON Shape

Your hook script should emit JSON with this structure (all fields optional):

```json
{
  "continue": true,
  "stopReason": "Optional: stops Claude if present",
  "systemMessage": "Optional: message for Claude or user",
  "suppressOutput": false,
  "decision": "Optional: block",
  "reason": "Optional: reason for decision",
  "hookSpecificOutput": {
    "permissionDecision": "allow|deny|ask"
  }
}
```

The helper functions construct this for you. For PreToolUse with permission, set `hookSpecificOutput.permissionDecision` to `allow`, `deny`, or `ask`. For blocking other events, set `decision: block`.

### Common Patterns

**Deny a Bash command:**

```powershell
$hook = Read-ClaudeHookInput
if ($hook.tool_name -eq 'Bash' -and $hook.tool_input.command -match 'rm -rf') {
    Write-ClaudeHookDeny -Reason 'rm -rf is dangerous'
}
```

**Inject context:**

```powershell
$hook = Read-ClaudeHookInput
Write-ClaudeHookContext -Event SessionStart `
    -Context "Project uses PowerShell 7. Prefer pwsh cmdlets over bash equivalents."
```

**Block editing generated files:**

```powershell
$hook = Read-ClaudeHookInput
if ($hook.hook_event_name -eq 'PostToolUse' -and $hook.tool_input.file_path -like '*.generated.*') {
    Write-ClaudeHookBlock -Reason 'Generated files should not be edited directly'
}
```

### Testing Hooks

Use the helper functions to test hooks with sample JSON:

```powershell
$testInput = @{
    session_id = 'test-session'
    hook_event_name = 'PreToolUse'
    tool_name = 'Bash'
    tool_input = @{ command = 'rm -rf /' }
} | ConvertTo-Json

$hook = Read-ClaudeHookInput -InputString $testInput
```

Or use `Test-ClaudeHookConfig` to invoke a registered hook directly:

```powershell
Test-ClaudeHookConfig -Event PreToolUse -Matcher Bash
```

### Best Practices

1. **Guard against empty/null input** - Use `if (-not $hook)` or `Read-ClaudeHookInput -Quiet`
2. **Exit with 0** - Always exit 0 on success, even if you didn't emit a response
3. **Keep hooks fast** - Target <100ms. Timeout defaults to 5 seconds.
4. **Be idempotent** - Hooks may be called multiple times per event. Avoid side effects.
5. **Prefer helpers over raw JSON** - Use `Write-ClaudeHookDeny`, etc., not manual `ConvertTo-Json`
6. **Test before registering** - Use Pester or `Test-ClaudeHookConfig` to verify behavior

## NOTES

Claude Code hooks are a powerful way to extend and customize Claude's behavior. They operate at the boundary between Claude's decision-making and tool execution, giving you fine-grained control over what actions Claude can take.

For the official hooks specification and examples, see:
<https://code.claude.com/docs/en/hooks.md>

## SEE ALSO

- `Get-ClaudeHookEventList` - List all valid hook events
- `Read-ClaudeHookInput` - Read hook payload from stdin
- `Write-ClaudeHookResponse` - Low-level response builder
- `Write-ClaudeHookAllow`, `Write-ClaudeHookDeny`, `Write-ClaudeHookAsk`
- `Add-ClaudeHookConfig`, `Get-ClaudeHookConfig`, `Remove-ClaudeHookConfig`
- `Test-ClaudeHookConfig` - Test a hook with sample input
