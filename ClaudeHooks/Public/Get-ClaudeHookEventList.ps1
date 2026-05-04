function Get-ClaudeHookEventList {
    <#
    .SYNOPSIS
        Returns the canonical list of Claude Code hook event names.
    .DESCRIPTION
        Provides the authoritative array of all supported hook event name strings.
        Use this to validate event names, populate ValidateSet arguments, or enumerate
        events in tooling and linters without hardcoding strings.
    .EXAMPLE
        Get-ClaudeHookEventList

        Returns all 30 event names as a string array.
    .EXAMPLE
        $events = Get-ClaudeHookEventList
        if ('PreToolUse' -in $events) { 'Valid event' }

        Validates that a given event name is in the canonical set.
    .OUTPUTS
        System.Array
    .LINK
        about_ClaudeHooks
    .LINK
        https://code.claude.com/docs/en/hooks.md
    #>
    [OutputType([Array])]
    [CmdletBinding()]
    param()

    @(
        'Setup'
        'SessionStart'
        'InstructionsLoaded'
        'UserPromptSubmit'
        'UserPromptExpansion'
        'PreToolUse'
        'PermissionRequest'
        'PermissionDenied'
        'PostToolUse'
        'PostToolUseFailure'
        'PostToolBatch'
        'Notification'
        'SubagentStart'
        'SubagentStop'
        'TaskCreated'
        'TaskCompleted'
        'Stop'
        'StopFailure'
        'TeammateIdle'
        'ConfigChange'
        'CwdChanged'
        'FileChanged'
        'WorktreeCreate'
        'WorktreeRemove'
        'PreCompact'
        'PostCompact'
        'Elicitation'
        'ElicitationResult'
        'SessionEnd'
    )
}
