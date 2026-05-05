function Write-ClaudeHookContext {
    <#
    .SYNOPSIS
        Emits an additionalContext string for hook events that support it.
    .DESCRIPTION
        Convenience wrapper that wraps context text in the correct hookSpecificOutput
        envelope. Supported events: SessionStart, Setup, UserPromptSubmit,
        UserPromptExpansion, PreToolUse, PostToolUse, PostToolUseFailure, PostToolBatch.
    .PARAMETER Event
        The hook event name (e.g. 'SessionStart', 'PostToolUse').
    .PARAMETER Context
        The context string to inject into Claude's context window.
    .EXAMPLE
        # Add context at session start
        Write-ClaudeHookContext -Event SessionStart -Context 'Project: MyApp. Stack: PS + Azure.'

        Injects project context into Claude's context window at the start of every session.
    .EXAMPLE
        # Add context after a file write
        $hook = Read-ClaudeHookInput
        if ($hook.tool_input.file_path -like '*.generated.ps1') {
            Write-ClaudeHookContext -Event PostToolUse -Context 'This file is auto-generated. Edit the template instead.'
        }

        Appends a caution note after Claude writes a generated file so it knows not to edit it directly.
    .OUTPUTS
        System.String
    .LINK
        about_ClaudeHooks
    #>
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute(
        'PSAvoidAssignmentToAutomaticVariable',
        'Event',
        Scope = 'Function',
        Justification = 'Parameter is immediately re-assigned.'
    )]
    [OutputType([string])]
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [ValidateSet('SessionStart', 'Setup', 'UserPromptSubmit', 'UserPromptExpansion', 'PreToolUse', 'PostToolUse', 'PostToolUseFailure', 'PostToolBatch')]
        [ArgumentCompleter({
            'SessionStart', 'Setup', 'UserPromptSubmit', 'UserPromptExpansion', 'PreToolUse', 'PostToolUse', 'PostToolUseFailure', 'PostToolBatch'
        })]
        [string]$Event,

        [Parameter(Mandatory)]
        [string]$Context
    )
    # Event is an automatic variable. This protects us just in case.
    $eventName = $PSBoundParameters['Event']

    $hso = [ordered]@{ hookEventName = $eventName; additionalContext = $Context }
    Write-ClaudeHookResponse -HookSpecificOutput $hso
}
