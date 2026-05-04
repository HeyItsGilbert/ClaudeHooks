# ClaudeHooks

PowerShell helpers for writing and registering [Claude Code](https://code.claude.com) hook scripts.

## Installation

Clone this repository and import the module:

```powershell
Import-Module D:\PSClaudeHelpers\ClaudeHooks
```

Or add to your profile:

```powershell
Import-Module ~\path\to\PSClaudeHelpers\ClaudeHooks
```

Future versions will be published to PSGallery for `Install-Module ClaudeHooks`.

## Quickstart: Write a hook

Create a hook script that denies `rm -rf` commands in Bash:

```powershell
# ~/.claude/hooks/block-rm-rf.ps1
Import-Module ClaudeHooks

$hook = Read-ClaudeHookInput
$base = Get-ClaudeBashBaseCommand $hook.tool_input.command
if ($base -eq 'rm' -and $hook.tool_input.command -match '-rf?') {
    Write-ClaudeHookDeny -Reason 'rm -rf is not allowed. Use Remove-Item -Recurse instead.'
}
```

Then register it:

```powershell
Add-ClaudeHookConfig -Event PreToolUse -Matcher Bash `
    -ScriptPath '~/.claude/hooks/block-rm-rf.ps1' -Scope User
```

## Quickstart: Register a hook

List all registered hooks:

```powershell
Get-ClaudeHookConfig | Format-Table
```

Test a hook with sample input:

```powershell
Test-ClaudeHookConfig -Event PreToolUse -Matcher Bash
```

Remove a hook:

```powershell
Remove-ClaudeHookConfig -Event PreToolUse -Matcher Bash `
    -ScriptPath '~/.claude/hooks/block-rm-rf.ps1' -Scope User
```

## Decision matrix

Choose the right function based on your hook's situation:

| Situation | Use |
|-----------|-----|
| PreToolUse — allow | `Write-ClaudeHookAllow` |
| PreToolUse — deny | `Write-ClaudeHookDeny` |
| PreToolUse — ask user | `Write-ClaudeHookAsk` |
| PreToolUse — allow with modified input | `Write-ClaudeHookUpdatedInput` |
| Stop / UserPromptSubmit / PostToolUse — block | `Write-ClaudeHookBlock` |
| Any event — inject context for Claude | `Write-ClaudeHookContext` |
| Any event — show a message (non-blocking) | `Write-ClaudeHookResponse -SystemMessage` |
| Hard blocking exit-2 error | `Write-ClaudeHookResponse -BlockingError` |

## Concepts

Read the comprehensive [about_ClaudeHooks](docs/en-US/about_ClaudeHooks.help.md) help topic for details on:

- Hook lifecycle (JSON stdin → decision → JSON stdout → exit code)
- Exit code semantics
- Settings scope precedence
- Input/output JSON shapes

For the official hooks specification, see https://code.claude.com/docs/en/hooks.md

## Function reference

| Function | Purpose |
|----------|---------|
| `Read-ClaudeHookInput` | Read and parse JSON from stdin |
| `Write-ClaudeHookAllow` | Allow a PreToolUse action |
| `Write-ClaudeHookDeny` | Deny a PreToolUse action |
| `Write-ClaudeHookAsk` | Ask the user to confirm a PreToolUse action |
| `Write-ClaudeHookUpdatedInput` | Allow a PreToolUse action with modified input |
| `Write-ClaudeHookBlock` | Block Stop/UserPromptSubmit/PostToolUse events |
| `Write-ClaudeHookContext` | Inject context for Claude to read |
| `Write-ClaudeHookResponse` | Low-level response builder (all events) |
| `Get-ClaudeBashBaseCommand` | Extract the base command from a Bash string |
| `Add-ClaudeHookConfig` | Register a hook in settings |
| `Get-ClaudeHookConfig` | List registered hooks |
| `Remove-ClaudeHookConfig` | Unregister a hook |
| `Test-ClaudeHookConfig` | Test a hook with sample input |
| `Get-ClaudeHookEventList` | List all valid hook events |

## Examples

See the [Examples](Examples/) folder for ready-to-use hook scripts:

- `block-rm-rf.ps1` — Deny destructive `rm -rf` commands
- `inject-edit-context.ps1` — Add context when editing generated files
- `session-banner.ps1` — Inject project info at session start

Copy these to your hooks directory (e.g. `~/.claude/hooks/`) and register them with `Add-ClaudeHookConfig`.
