function Write-ClaudeHookBlock {
    <#
    .SYNOPSIS
        Emits a top-level block decision for Stop, UserPromptSubmit, or PostToolUse hooks.
    .DESCRIPTION
        Convenience wrapper around Write-ClaudeHookResponse for the top-level
        decision:block shape. Use this (not Write-ClaudeHookDeny) for Stop,
        UserPromptSubmit, and PostToolUse events. For PreToolUse permission denial
        use Write-ClaudeHookDeny instead.
    .PARAMETER Reason
        Required explanation for the block shown to the user.
    .EXAMPLE
        # Block a Stop event to keep Claude running
        Write-ClaudeHookBlock -Reason 'Tests are still failing. Fix them before stopping.'

        Emits a top-level block decision for a Stop event, preventing Claude from stopping.
    .EXAMPLE
        # Block a prompt submission
        $hook = Read-ClaudeHookInput
        if ($hook.prompt -match 'delete production') {
            Write-ClaudeHookBlock -Reason 'Destructive production operations require manual review.'
        }

        Blocks a UserPromptSubmit event when the prompt contains a sensitive keyword.
    .OUTPUTS
        System.String
    .LINK
        about_ClaudeHooks
    #>
    [OutputType([string])]
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]$Reason
    )

    Write-ClaudeHookResponse -Decision 'block' -Reason $Reason
}
