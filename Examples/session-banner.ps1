# Inject project context at session start
#
# Intended to be run as a hook entry point, not dot-sourced — it calls
# `exit 0`, which would terminate a session that dot-sources it.
#
# Copy this to your hooks directory (e.g. ~/.claude/hooks/) before registering.
#
# Register with:
#   Add-ClaudeHookConfig -Event SessionStart `
#       -ScriptPath '~/.claude/hooks/session-banner.ps1' -Scope User

Import-Module ClaudeHooks

$hook = Read-ClaudeHookInput -Quiet
if (-not $hook) { exit 0 }

$projectName = Split-Path (Get-Location) -Leaf
Write-ClaudeHookContext -Event SessionStart `
    -Context "Project: $projectName | Shell: PowerShell 7 | Prefer pwsh cmdlets over bash equivalents."
exit 0
