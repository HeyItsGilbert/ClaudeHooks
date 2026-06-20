# Inject context when editing generated files
#
# Intended to be run as a hook entry point, not dot-sourced — it calls
# `exit 0`, which would terminate a session that dot-sources it.
#
# Copy this to your hooks directory (e.g. ~/.claude/hooks/) before registering.
#
# Register with:
#   Add-ClaudeHookConfig -Event PostToolUse -Matcher Edit `
#       -ScriptPath '~/.claude/hooks/inject-edit-context.ps1' -Scope User

Import-Module ClaudeHooks

$hook = Read-ClaudeHookInput -Quiet
if (-not $hook) { exit 0 }

$path = $hook.tool_input.file_path
if ($path -and $path -like '*.generated.*') {
    Write-ClaudeHookContext -Event PostToolUse `
        -Context "Note: '$path' is auto-generated. Prefer editing the source template instead."
}
exit 0
