BeforeAll {
    Import-Module (Join-Path $PSScriptRoot '..\ClaudeHooks\ClaudeHooks.psd1') -Force
}

Describe 'Add-ClaudeHookConfig' {
    BeforeEach {
        $settingsPath = Join-Path $TestDrive "settings-$(New-Guid).json"
    }

    It 'creates the settings file if it does not exist' {
        Add-ClaudeHookConfig -Event PreToolUse -Matcher Bash `
            -Command 'pwsh -File myhook.ps1' -Scope User -Path $settingsPath
        $settingsPath | Should -Exist
    }

    It 'writes a valid JSON file' {
        Add-ClaudeHookConfig -Event PreToolUse -Matcher Bash `
            -Command 'pwsh -File myhook.ps1' -Scope User -Path $settingsPath
        { Get-Content $settingsPath -Raw | ConvertFrom-Json } | Should -Not -Throw
    }

    It 'creates the correct hooks structure' {
        Add-ClaudeHookConfig -Event PreToolUse -Matcher Bash `
            -Command 'pwsh -File myhook.ps1' -Shell powershell -Scope User -Path $settingsPath
        $s = Get-Content $settingsPath -Raw | ConvertFrom-Json
        $s.hooks.PreToolUse              | Should -Not -BeNullOrEmpty
        $s.hooks.PreToolUse[0].matcher   | Should -Be 'Bash'
        $s.hooks.PreToolUse[0].hooks[0].command | Should -Be 'pwsh -File myhook.ps1'
        $s.hooks.PreToolUse[0].hooks[0].shell   | Should -Be 'powershell'
    }

    It 'is idempotent: calling twice does not duplicate the entry' {
        Add-ClaudeHookConfig -Event PreToolUse -Matcher Bash `
            -Command 'pwsh -File myhook.ps1' -Scope User -Path $settingsPath
        Add-ClaudeHookConfig -Event PreToolUse -Matcher Bash `
            -Command 'pwsh -File myhook.ps1' -Scope User -Path $settingsPath
        $s = Get-Content $settingsPath -Raw | ConvertFrom-Json
        $s.hooks.PreToolUse[0].hooks.Count | Should -Be 1
    }

    It 'appends a second hook under the same matcher' {
        Add-ClaudeHookConfig -Event PreToolUse -Matcher Bash `
            -Command 'pwsh -File hook1.ps1' -Scope User -Path $settingsPath
        Add-ClaudeHookConfig -Event PreToolUse -Matcher Bash `
            -Command 'pwsh -File hook2.ps1' -Scope User -Path $settingsPath
        $s = Get-Content $settingsPath -Raw | ConvertFrom-Json
        $s.hooks.PreToolUse[0].hooks.Count | Should -Be 2
    }

    It 'adds multiple events to the same file' {
        Add-ClaudeHookConfig -Event PreToolUse -Matcher Bash `
            -Command 'pwsh -File hook1.ps1' -Scope User -Path $settingsPath
        Add-ClaudeHookConfig -Event Stop -Matcher '' `
            -Command 'pwsh -File hook2.ps1' -Scope User -Path $settingsPath
        $s = Get-Content $settingsPath -Raw | ConvertFrom-Json
        $s.hooks.PSObject.Properties.Name | Should -Contain 'PreToolUse'
        $s.hooks.PSObject.Properties.Name | Should -Contain 'Stop'
    }

    It 'overwrites an existing entry with -Force' {
        Add-ClaudeHookConfig -Event PreToolUse -Matcher Bash `
            -Command 'pwsh -File old.ps1' -Scope User -Path $settingsPath
        Add-ClaudeHookConfig -Event PreToolUse -Matcher Bash `
            -Command 'pwsh -File old.ps1' -Shell bash -Scope User -Path $settingsPath -Force
        $s = Get-Content $settingsPath -Raw | ConvertFrom-Json
        $s.hooks.PreToolUse[0].hooks.Count | Should -Be 1
        $s.hooks.PreToolUse[0].hooks[0].shell | Should -Be 'bash'
    }
}
