function Get-ClaudeBashBaseCommand {
    <#
    .SYNOPSIS
        Extracts the base command name from a Bash tool_input.command string.
    .DESCRIPTION
        Strips path prefixes and arguments from a shell command string, returning
        only the executable name in lowercase. Useful in PreToolUse hooks that
        match on the Bash tool to identify which program is being invoked.
    .PARAMETER Command
        The full command string from tool_input.command.
    .EXAMPLE
        Get-ClaudeBashBaseCommand 'grep -r "foo" .'

        Returns 'grep' - strips arguments and returns the base executable name.
    .EXAMPLE
        Get-ClaudeBashBaseCommand '/usr/bin/curl -s https://example.com'

        Returns 'curl' - strips the full path prefix as well as arguments.
    .OUTPUTS
        System.String
    .LINK
        about_ClaudeHooks
    #>
    [OutputType([string])]
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, ValueFromPipeline)]
        [string]$Command
    )
    process {
        $token = ($Command.Trim() -split '\s+')[0]
        ($token -replace '^.*[/\\]', '').ToLower()
    }
}
