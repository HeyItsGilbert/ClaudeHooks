function Write-ClaudeHookDeny {
    <#
    .SYNOPSIS
        Emits a PreToolUse deny decision.
    .DESCRIPTION
        Convenience wrapper for the PreToolUse permissionDecision:deny shape.
        Use when your hook rejects a tool call. The -Reason is shown to the user.
    .PARAMETER Reason
        Required explanation shown to the user explaining why the tool was denied.
    .EXAMPLE
        Write-ClaudeHookDeny -Reason 'rm -rf is not allowed in this project.'

        Emits a deny decision for a PreToolUse hook with a message shown to the user.
    .EXAMPLE
        $base = Get-ClaudeBashBaseCommand $hook.tool_input.command
        if ($base -eq 'rm') { Write-ClaudeHookDeny -Reason "Use Remove-Item instead." }

        Denies the tool call when the base command is 'rm', suggesting a safer alternative.
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

    $hso = [ordered]@{ hookEventName = 'PreToolUse'; permissionDecision = 'deny' }
    if ($PSBoundParameters.ContainsKey('Reason')) { $hso['permissionDecisionReason'] = $Reason }

    Write-ClaudeHookResponse -HookSpecificOutput $hso
}
