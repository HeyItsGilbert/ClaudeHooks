BeforeAll {
    Import-Module (Join-Path $PSScriptRoot '..\ClaudeHooks\ClaudeHooks.psd1') -Force
}

Describe 'Remove-ClaudeHookConfig' {
    BeforeEach {
        $settingsPath = Join-Path $TestDrive "settings-$(New-Guid).json"
        Add-ClaudeHookConfig -Event PreToolUse -Matcher Bash `
            -Command 'pwsh -File hook.ps1' -Scope User -Path $settingsPath
    }

    It 'removes a hook entry by event and matcher' {
        Remove-ClaudeHookConfig -Event PreToolUse -Matcher Bash -Scope User -Path $settingsPath
        $s = Get-Content $settingsPath -Raw | ConvertFrom-Json
        $s.hooks.PSObject.Properties.Name | Should -Not -Contain 'PreToolUse'
    }

    It 'removes only the matching command when -Command is specified' {
        Add-ClaudeHookConfig -Event PreToolUse -Matcher Bash `
            -Command 'pwsh -File second.ps1' -Scope User -Path $settingsPath
        Remove-ClaudeHookConfig -Event PreToolUse -Matcher Bash `
            -Command 'pwsh -File hook.ps1' -Scope User -Path $settingsPath
        $s = Get-Content $settingsPath -Raw | ConvertFrom-Json
        $s.hooks.PreToolUse[0].hooks.Count | Should -Be 1
        $s.hooks.PreToolUse[0].hooks[0].command | Should -Be 'pwsh -File second.ps1'
    }

    It 'is a no-op when the file does not exist' {
        $missing = Join-Path $TestDrive 'nonexistent.json'
        { Remove-ClaudeHookConfig -Event PreToolUse -Matcher Bash -Scope User -Path $missing } | Should -Not -Throw
    }

    It 'round-trips: Add then Remove returns to baseline' {
        $baseline = Join-Path $TestDrive "baseline-$(New-Guid).json"
        # Start with an existing hook
        Add-ClaudeHookConfig -Event Stop -Matcher '' `
            -Command 'pwsh -File base.ps1' -Scope User -Path $baseline
        $before = Get-Content $baseline -Raw

        # Add then remove a different hook
        Add-ClaudeHookConfig -Event PreToolUse -Matcher Bash `
            -Command 'pwsh -File temp.ps1' -Scope User -Path $baseline
        Remove-ClaudeHookConfig -Event PreToolUse -Matcher Bash -Scope User -Path $baseline

        $after = Get-Content $baseline -Raw
        ($after | ConvertFrom-Json).hooks.PSObject.Properties.Name |
            Should -Not -Contain 'PreToolUse'
        ($after | ConvertFrom-Json).hooks.Stop | Should -Not -BeNullOrEmpty
    }
}
