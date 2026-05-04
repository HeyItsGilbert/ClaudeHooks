function Read-ClaudeHookInput {
    <#
    .SYNOPSIS
        Reads and parses the JSON payload that Claude Code sends to a hook script on stdin.
    .DESCRIPTION
        In production (no -InputString), reads [Console]::In to end.
        In tests, pass -InputString to avoid reading actual stdin.
        Rejects payloads over 10MB. Throws on invalid JSON unless -Quiet is specified.
    .PARAMETER InputString
        JSON string to parse instead of reading stdin. Used for Pester testing.
    .PARAMETER Quiet
        Returns $null instead of throwing when JSON is invalid or input is empty.
    .EXAMPLE
        # In a hook script's main block:
        $hook = Read-ClaudeHookInput
        $hook.tool_name  # e.g. 'Bash'
        $hook.tool_input.command  # e.g. 'rm -rf /'

        Reads stdin from Claude and accesses the parsed event properties.
    .EXAMPLE
        # In a Pester test:
        $hook = Read-ClaudeHookInput -InputString '{"tool_name":"Bash","tool_input":{"command":"ls"}}'
        $hook.tool_name | Should -Be 'Bash'

        Uses -InputString to inject a test payload without touching real stdin.
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
        $raw = [Console]::In.ReadToEnd()
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
