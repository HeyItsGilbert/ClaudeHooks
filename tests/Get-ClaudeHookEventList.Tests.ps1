BeforeAll {
    Import-Module (Join-Path $PSScriptRoot '..\ClaudeHooks\ClaudeHooks.psd1') -Force
}

Describe 'Get-ClaudeHookEventList' {
    It 'returns a non-empty string array' {
        $events = Get-ClaudeHookEventList
        $events | Should -Not -BeNullOrEmpty
        $events | ForEach-Object { $_ | Should -BeOfType [string] }
    }

    It 'includes PreToolUse' {
        Get-ClaudeHookEventList | Should -Contain 'PreToolUse'
    }

    It 'includes PostToolUse' {
        Get-ClaudeHookEventList | Should -Contain 'PostToolUse'
    }

    It 'includes Stop' {
        Get-ClaudeHookEventList | Should -Contain 'Stop'
    }

    It 'includes SessionStart and SessionEnd' {
        $events = Get-ClaudeHookEventList
        $events | Should -Contain 'SessionStart'
        $events | Should -Contain 'SessionEnd'
    }

    It 'returns at least 20 events' {
        (Get-ClaudeHookEventList).Count | Should -BeGreaterOrEqual 20
    }

    It 'contains no duplicates' {
        $events = Get-ClaudeHookEventList
        ($events | Select-Object -Unique).Count | Should -Be $events.Count
    }
}
