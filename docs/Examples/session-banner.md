# Session Banner

Injects project context into every new Claude session so the model immediately
knows which project it is in and which shell conventions to follow.

## Overview

Without session context, Claude has to infer your environment from scratch at
the start of each conversation. This hook fires on `SessionStart` and pushes a
one-line context string containing the current project name and shell
preference, reducing the chance of Claude defaulting to bash idioms in a
PowerShell-first repo.

## How It Works

1. Fires on the `SessionStart` event (no tool matcher needed).
2. Reads the incoming hook payload with `Read-ClaudeHookInput`.
3. Derives the project name from the current working directory leaf.
4. Calls `Write-ClaudeHookContext` to inject a summary string into the session.

## Registration

Copy the script to your hooks directory and register it:

```powershell
Add-ClaudeHookConfig -Event SessionStart `
    -ScriptPath '~/.claude/hooks/session-banner.ps1' -Scope User
```

## Script

```powershell
Import-Module ClaudeHooks

if ($MyInvocation.InvocationName -ne '.') {
    $hook = Read-ClaudeHookInput -Quiet
    if (-not $hook) { exit 0 }

    $projectName = Split-Path (Get-Location) -Leaf
    Write-ClaudeHookContext -Event SessionStart `
        -Context "Project: $projectName | Shell: PowerShell 7 | Prefer pwsh cmdlets over bash equivalents."
    exit 0
}
```

## Customization

The context string is plain text — extend it with anything Claude should know
upfront, such as:

- Preferred language or framework version
- Repository conventions (e.g. "Always run tests before committing")
- Links or references Claude should keep in mind

## Related Commands

- [`Read-ClaudeHookInput`](../en-US/Read-ClaudeHookInput.md)
- [`Write-ClaudeHookContext`](../en-US/Write-ClaudeHookContext.md)
- [`Add-ClaudeHookConfig`](../en-US/Add-ClaudeHookConfig.md)
