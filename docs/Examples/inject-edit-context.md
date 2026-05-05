# Inject Context for Generated Files

Warns Claude when it edits an auto-generated file by injecting a context note
after the `Edit` tool runs, nudging it to modify the source template instead.

## Overview

Generated files (e.g. `*.generated.cs`, `*.generated.ts`) are typically
produced by a code generator and will be overwritten on the next build. Directly
editing them wastes effort and is often reverted. This hook detects when Claude
edits a file whose name contains `.generated.` and appends a context note
reminding it to prefer the upstream template.

## How It Works

1. Fires on the `PostToolUse` event, scoped to the `Edit` tool matcher.
2. Reads the incoming hook payload with `Read-ClaudeHookInput`.
3. Checks whether `tool_input.file_path` matches the `*.generated.*` pattern.
4. If it matches, calls `Write-ClaudeHookContext` to inject an advisory message
   into the running session without blocking the edit.

## Registration

Copy the script to your hooks directory and register it:

```powershell
Add-ClaudeHookConfig -Event PostToolUse -Matcher Edit `
    -ScriptPath '~/.claude/hooks/inject-edit-context.ps1' -Scope User
```

## Script

```powershell
Import-Module ClaudeHooks

if ($MyInvocation.InvocationName -ne '.') {
    $hook = Read-ClaudeHookInput -Quiet
    if (-not $hook) { exit 0 }

    $path = $hook.tool_input.file_path
    if ($path -and $path -like '*.generated.*') {
        Write-ClaudeHookContext -Event PostToolUse `
            -Context "Note: '$path' is auto-generated. Prefer editing the source template instead."
    }
    exit 0
}
```

## Related Commands

- [`Read-ClaudeHookInput`](../en-US/Read-ClaudeHookInput.md)
- [`Write-ClaudeHookContext`](../en-US/Write-ClaudeHookContext.md)
- [`Add-ClaudeHookConfig`](../en-US/Add-ClaudeHookConfig.md)
