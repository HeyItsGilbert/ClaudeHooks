BeforeAll {
    Import-Module (Join-Path $PSScriptRoot '..\ClaudeHooks\ClaudeHooks.psd1') -Force
}

Describe 'Read-ClaudeHookInput' {
    It 'parses valid hook JSON from -InputString' {
        $json = '{"tool_name":"Bash","tool_input":{"command":"ls"},"hook_event_name":"PreToolUse"}'
        $result = Read-ClaudeHookInput -InputString $json
        $result.tool_name            | Should -Be 'Bash'
        $result.tool_input.command   | Should -Be 'ls'
        $result.hook_event_name      | Should -Be 'PreToolUse'
    }

    It 'throws on invalid JSON without -Quiet' {
        { Read-ClaudeHookInput -InputString 'not json' } | Should -Throw
    }

    It 'returns $null on invalid JSON with -Quiet' {
        Read-ClaudeHookInput -InputString 'not json' -Quiet | Should -BeNullOrEmpty
    }

    It 'throws on empty input without -Quiet' {
        { Read-ClaudeHookInput -InputString '' } | Should -Throw
    }

    It 'returns $null on empty input with -Quiet' {
        Read-ClaudeHookInput -InputString '' -Quiet | Should -BeNullOrEmpty
    }

    It 'throws when input exceeds 10MB' {
        $big = 'x' * (11 * 1024 * 1024)
        { Read-ClaudeHookInput -InputString $big } | Should -Throw
    }

    It 'parses nested tool_input fields' {
        $json = '{"tool_name":"Write","tool_input":{"file_path":"/tmp/foo.txt","content":"hello"}}'
        $result = Read-ClaudeHookInput -InputString $json
        $result.tool_input.file_path | Should -Be '/tmp/foo.txt'
    }
}
