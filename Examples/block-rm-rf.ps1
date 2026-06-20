# Block rm -rf commands in Bash
#
# Intended to be run as a hook entry point, not dot-sourced — it calls
# `exit 0`, which would terminate a session that dot-sources it.
#
# Copy this to your hooks directory (e.g. ~/.claude/hooks/) before registering.
#
# Register with:
#   Add-ClaudeHookConfig -Event PreToolUse -Matcher Bash `
#       -ScriptPath '~/.claude/hooks/block-rm-rf.ps1' -Scope User

Import-Module ClaudeHooks

$hook = Read-ClaudeHookInput -Quiet
if (-not $hook) { exit 0 }

$base = Get-ClaudeBashBaseCommand $hook.tool_input.command
if ($base -eq 'rm' -and $hook.tool_input.command -match '-rf?') {
    Write-ClaudeHookDeny -Reason 'rm -rf is not allowed. Use Remove-Item -Recurse instead.'
}
exit 0
