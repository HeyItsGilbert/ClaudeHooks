function Write-ClaudeHookAllow {
    <#
    .SYNOPSIS
        Emits a PreToolUse allow decision, optionally with a modified tool input.
    .DESCRIPTION
        Convenience wrapper around Write-ClaudeHookResponse for the PreToolUse
        permissionDecision:allow shape. Use when your hook approves the tool call.
        Pass -UpdatedInput to modify the tool's parameters before execution.
    .PARAMETER Reason
        Optional explanation for the allow decision.
    .PARAMETER UpdatedInput
        Hashtable of tool input fields to override before the tool runs.
    .EXAMPLE
        Write-ClaudeHookAllow

        Emits an unconditional allow for the current PreToolUse event.
    .EXAMPLE
        # Allow but sanitize the command
        Write-ClaudeHookAllow -UpdatedInput @{ command = 'npm run lint' }

        Allows the tool call but replaces the command with a safe alternative before execution.
    .OUTPUTS
        System.String
    .LINK
        about_ClaudeHooks
    #>
    [OutputType([string])]
    [CmdletBinding()]
    param(
        [string]$Reason,
        [hashtable]$UpdatedInput
    )

    $hso = [ordered]@{ hookEventName = 'PreToolUse'; permissionDecision = 'allow' }
    if ($PSBoundParameters.ContainsKey('Reason'))      { $hso['permissionDecisionReason'] = $Reason }
    if ($PSBoundParameters.ContainsKey('UpdatedInput')){ $hso['updatedInput'] = $UpdatedInput }

    Write-ClaudeHookResponse -HookSpecificOutput $hso
}
