BeforeAll {
    Import-Module (Join-Path $PSScriptRoot '..\ClaudeHooks\ClaudeHooks.psd1') -Force
}

Describe 'Get-ClaudeHookConfig' {
    BeforeEach {
        $settingsPath = Join-Path $TestDrive "settings-$(New-Guid).json"
        Add-ClaudeHookConfig -Event PreToolUse -Matcher Bash `
            -Command 'pwsh -File hook1.ps1' -Shell powershell -Scope User -Path $settingsPath
        Add-ClaudeHookConfig -Event Stop -Matcher '' `
            -Command 'pwsh -File hook2.ps1' -Scope User -Path $settingsPath
    }

    It 'returns rows for all hooks in the file' {
        $rows = Get-ClaudeHookConfig -Path $settingsPath -Scope User
        $rows.Count | Should -Be 2
    }

    It 'each row has expected properties' {
        $row = Get-ClaudeHookConfig -Path $settingsPath -Scope User |
            Where-Object Event -eq PreToolUse
        $row.Scope   | Should -Be 'User'
        $row.Event   | Should -Be 'PreToolUse'
        $row.Matcher | Should -Be 'Bash'
        $row.Command | Should -Be 'pwsh -File hook1.ps1'
        $row.Shell   | Should -Be 'powershell'
    }

    It 'filters by -Event' {
        $rows = Get-ClaudeHookConfig -Path $settingsPath -Scope User -Event PreToolUse
        $rows.Count         | Should -Be 1
        $rows[0].Event      | Should -Be 'PreToolUse'
    }

    It 'filters by -Matcher' {
        $rows = Get-ClaudeHookConfig -Path $settingsPath -Scope User -Matcher 'Bash'
        $rows.Count | Should -Be 1
    }

    It 'returns nothing for a non-existent file without error' {
        $rows = Get-ClaudeHookConfig -Path (Join-Path $TestDrive 'missing.json') -Scope User
        $rows | Should -BeNullOrEmpty
    }
}
