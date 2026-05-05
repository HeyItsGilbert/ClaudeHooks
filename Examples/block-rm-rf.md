# Block `rm -rf` Commands

Prevents Claude from running destructive `rm -rf` commands via the Bash tool by
intercepting the `PreToolUse` event and emitting a deny decision.

## Overview

Claude sometimes reaches for `rm -rf` when cleaning up files. On a shared or
production system this can cause irreversible data loss. This hook blocks any
Bash command whose base is `rm` **and** whose arguments include the `-rf` (or
`-r -f`) flags, and suggests the PowerShell-idiomatic `Remove-Item -Recurse`
alternative instead.

## How It Works

1. Fires on the `PreToolUse` event, scoped to the `Bash` tool matcher.
2. Reads the incoming hook payload with `Read-ClaudeHookInput`.
3. Extracts the base command using `Get-ClaudeBashBaseCommand`.
4. If the base is `rm` and the full command contains `-rf?`, emits a deny via
   `Write-ClaudeHookDeny` with a human-readable reason.
5. Otherwise exits cleanly (`exit 0`), allowing the command to proceed.

## Registration

Copy the script to your hooks directory and register it:

```powershell
Add-ClaudeHookConfig -Event PreToolUse -Matcher Bash `
    -ScriptPath '~/.claude/hooks/block-rm-rf.ps1' -Scope User
```

## Script

```powershell
Import-Module ClaudeHooks

if ($MyInvocation.InvocationName -ne '.') {
    $hook = Read-ClaudeHookInput -Quiet
    if (-not $hook) { exit 0 }

    $base = Get-ClaudeBashBaseCommand $hook.tool_input.command
    if ($base -eq 'rm' -and $hook.tool_input.command -match '-rf?') {
        Write-ClaudeHookDeny -Reason 'rm -rf is not allowed. Use Remove-Item -Recurse instead.'
    }
    exit 0
}
```

## Related Commands

- [`Read-ClaudeHookInput`](../en-US/Read-ClaudeHookInput.md)
- [`Get-ClaudeBashBaseCommand`](../en-US/Get-ClaudeBashBaseCommand.md)
- [`Write-ClaudeHookDeny`](../en-US/Write-ClaudeHookDeny.md)
- [`Add-ClaudeHookConfig`](../en-US/Add-ClaudeHookConfig.md)
