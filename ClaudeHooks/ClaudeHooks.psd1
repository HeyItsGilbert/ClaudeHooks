@{
    RootModule = 'ClaudeHooks.psm1'
    ModuleVersion = '0.2.0'
    GUID = '345099e0-5c0c-4c0b-8117-1c070d3393ca'
    Author = 'Gilbert Sanchez'
    Copyright = '(c) Gilbert Sanchez. All rights reserved.'
    Description = 'PowerShell helpers for writing and registering Claude Code hook scripts.'
    PowerShellVersion = '7.0'

    FunctionsToExport = @(
        'Get-ClaudeHookEventList'
        'Read-ClaudeHookInput'
        'Get-ClaudeBashBaseCommand'
        'Write-ClaudeHookResponse'
        'Write-ClaudeHookAllow'
        'Write-ClaudeHookDeny'
        'Write-ClaudeHookAsk'
        'Write-ClaudeHookBlock'
        'Write-ClaudeHookContext'
        'Write-ClaudeHookUpdatedInput'
        'Add-ClaudeHookConfig'
        'Remove-ClaudeHookConfig'
        'Get-ClaudeHookConfig'
        'Test-ClaudeHookConfig'
    )
    CmdletsToExport = @()
    VariablesToExport = @()
    AliasesToExport = @()

    PrivateData = @{
        PSData = @{
            Tags = @('Claude', 'Hooks', 'ClaudeCode', 'AI')
            ProjectUri = 'https://github.com/heyitsgilbert/ClaudeHooks'
        }
    }
}
