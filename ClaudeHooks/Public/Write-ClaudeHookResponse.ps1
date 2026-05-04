function Write-ClaudeHookResponse {
    <#
    .SYNOPSIS
        Emits a JSON response from a hook script to Claude Code.
    .DESCRIPTION
        Constructs and outputs the hook response JSON. All parameters are optional.
        Providing -StopReason sets continue:false. -BlockingError emits JSON then exits
        with code 2 (the hard-blocking error signal per the hooks spec).
        All other calls return normally so the hook can continue additional logic.
    .PARAMETER StopReason
        Message shown when Claude is stopped. Presence implies continue:false.
    .PARAMETER SystemMessage
        Non-blocking informational message shown to the user.
    .PARAMETER SuppressOutput
        Omits the response from the debug log when $true.
    .PARAMETER Decision
        Top-level decision field (e.g. 'block') for events like Stop, UserPromptSubmit.
    .PARAMETER Reason
        Explanation shown with -Decision.
    .PARAMETER HookSpecificOutput
        Hashtable of event-specific output fields merged under hookSpecificOutput.
    .PARAMETER BlockingError
        Emits the JSON response then immediately calls exit 2 (blocking error).
        Use only at the top level of a hook script, not inside testable functions.
    .EXAMPLE
        # Inject a system message (non-blocking)
        Write-ClaudeHookResponse -SystemMessage 'Lint passed.'

        Emits a non-blocking system message that is shown to the user without stopping Claude.
    .EXAMPLE
        # Stop Claude with a reason
        Write-ClaudeHookResponse -StopReason 'Build failed: 3 errors in src/'

        Emits a stop response that sets continue:false and shows the reason to the user.
    .OUTPUTS
        System.String
    .LINK
        about_ClaudeHooks
    .LINK
        https://code.claude.com/docs/en/hooks.md
    #>
    [OutputType([string])]
    [CmdletBinding()]
    param(
        [string]$StopReason,
        [string]$SystemMessage,
        [switch]$SuppressOutput,
        [string]$Decision,
        [string]$Reason,
        [hashtable]$HookSpecificOutput,
        [switch]$BlockingError
    )

    $response = [ordered]@{}

    if ($PSBoundParameters.ContainsKey('StopReason')) {
        $response['continue']    = $false
        $response['stopReason']  = $StopReason
    }
    if ($PSBoundParameters.ContainsKey('SystemMessage'))  { $response['systemMessage']  = $SystemMessage }
    if ($SuppressOutput)                                   { $response['suppressOutput'] = $true }
    if ($PSBoundParameters.ContainsKey('Decision'))        { $response['decision']       = $Decision }
    if ($PSBoundParameters.ContainsKey('Reason'))          { $response['reason']         = $Reason }
    if ($HookSpecificOutput)                               { $response['hookSpecificOutput'] = $HookSpecificOutput }

    $json = ConvertTo-ClaudeHookJson -InputObject $response
    Write-Output $json

    if ($BlockingError) { exit 2 }
}
