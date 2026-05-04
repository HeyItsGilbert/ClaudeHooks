function Write-ClaudeHookUpdatedInput {
    <#
    .SYNOPSIS
        Emits a PreToolUse allow decision with a modified tool input.
    .DESCRIPTION
        Convenience wrapper that combines Write-ClaudeHookAllow with an updatedInput
        payload. Use when your hook wants to allow the tool but change its parameters
        (e.g., normalize a path, inject flags, redirect output).
    .PARAMETER UpdatedInput
        Hashtable of tool input fields to override. Only specified fields are overridden;
        unspecified fields retain their original values per the hooks spec.
    .EXAMPLE
        # Redirect a file write to a safe temp location
        $hook = Read-ClaudeHookInput
        Write-ClaudeHookUpdatedInput -UpdatedInput @{ file_path = $hook.tool_input.file_path -replace 'prod', 'staging' }

        Allows the Write tool but redirects the target path from production to staging.
    .EXAMPLE
        # Enforce a timeout on every Bash call
        Write-ClaudeHookUpdatedInput -UpdatedInput @{ timeout = 30000 }

        Allows the Bash call but enforces a 30-second timeout on every invocation.
    .OUTPUTS
        System.String
    .LINK
        about_ClaudeHooks
    #>
    [OutputType([string])]
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [hashtable]$UpdatedInput
    )

    Write-ClaudeHookAllow -UpdatedInput $UpdatedInput
}
