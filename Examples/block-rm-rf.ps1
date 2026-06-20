# Block rm -rf commands in Bash
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
