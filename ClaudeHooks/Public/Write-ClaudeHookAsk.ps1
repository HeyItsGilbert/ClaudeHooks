function Write-ClaudeHookAsk {
    <#
    .SYNOPSIS
        Emits a PreToolUse ask decision, prompting the user to confirm.
    .DESCRIPTION
        Convenience wrapper for the PreToolUse permissionDecision:ask shape.
        Use when the tool call needs human confirmation before proceeding.
    .PARAMETER Reason
        Message shown to the user explaining what they are being asked to confirm.
    .EXAMPLE
        Write-ClaudeHookAsk -Reason 'About to write to production config. Confirm?'

        Prompts the user to confirm before Claude proceeds with the tool call.
    .EXAMPLE
        if ($hook.tool_input.file_path -like '*prod*') {
            Write-ClaudeHookAsk -Reason "Writing to a production path: $($hook.tool_input.file_path)"
        }

        Asks for confirmation only when the target file path matches a production pattern.
    .OUTPUTS
        System.String
    .LINK
        about_ClaudeHooks
    #>
    [OutputType([string])]
    [CmdletBinding()]
    param(
        [string]$Reason
    )

    $hso = [ordered]@{ hookEventName = 'PreToolUse'; permissionDecision = 'ask' }
    if ($PSBoundParameters.ContainsKey('Reason')) { $hso['permissionDecisionReason'] = $Reason }

    Write-ClaudeHookResponse -HookSpecificOutput $hso
}
