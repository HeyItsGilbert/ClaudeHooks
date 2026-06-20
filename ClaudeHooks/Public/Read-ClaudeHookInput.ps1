function Read-ClaudeHookInput {
    <#
    .SYNOPSIS
        Reads and parses the JSON payload that Claude Code sends to a hook script.
    .DESCRIPTION
        In production, reads from $global:ClaudeHookInput, which PowerServe injects before
        executing the hook script. Pass -InputString to supply a payload directly, e.g. in
        Pester tests. Rejects payloads over 10MB. Throws on invalid JSON unless -Quiet is
        specified.
    .PARAMETER InputString
        JSON string to parse directly. Used for Pester testing.
    .PARAMETER Quiet
        Returns $null instead of throwing when JSON is invalid or input is empty.
    .EXAMPLE
        $hook = Read-ClaudeHookInput
        $hook.tool_name          # e.g. 'Bash'
        $hook.tool_input.command # e.g. 'rm -rf /'

        Reads the injected payload from Claude and accesses the parsed event properties.
    .EXAMPLE
        # In a Pester test:
        $hook = Read-ClaudeHookInput -InputString '{"tool_name":"Bash","tool_input":{"command":"ls"}}'
        $hook.tool_name | Should -Be 'Bash'

        Uses -InputString to inject a test payload without relying on the global variable.
    .OUTPUTS
        System.Management.Automation.PSCustomObject
    .LINK
        about_ClaudeHooks
    .LINK
        https://code.claude.com/docs/en/hooks.md
    #>
    [OutputType([pscustomobject])]
    [CmdletBinding()]
    param(
        [string]$InputString,
        [switch]$Quiet
    )

    $maxBytes = 10MB

    if ($PSBoundParameters.ContainsKey('InputString')) {
        $raw = $InputString
    } else {
        $raw = $global:ClaudeHookInput
    }

    if ([string]::IsNullOrWhiteSpace($raw)) {
        if ($Quiet) { return $null }
        throw 'Hook input was empty.'
    }

    if ([System.Text.Encoding]::UTF8.GetByteCount($raw) -gt $maxBytes) {
        if ($Quiet) { return $null }
        throw 'Hook input exceeds maximum allowed size of 10MB.'
    }

    try {
        $raw | ConvertFrom-Json -Depth 64
    } catch {
        if ($Quiet) { return $null }
        throw "Hook input is not valid JSON: $_"
    }
}
