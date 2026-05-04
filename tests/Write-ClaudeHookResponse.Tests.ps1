BeforeAll {
    Import-Module (Join-Path $PSScriptRoot '..\ClaudeHooks\ClaudeHooks.psd1') -Force
}

Describe 'Write-ClaudeHookResponse' {
    It 'emits valid JSON' {
        $out = Write-ClaudeHookResponse -SystemMessage 'hello'
        { $out | ConvertFrom-Json } | Should -Not -Throw
    }

    It 'includes systemMessage when specified' {
        $out = Write-ClaudeHookResponse -SystemMessage 'test message' | ConvertFrom-Json
        $out.systemMessage | Should -Be 'test message'
    }

    It 'sets continue:false when StopReason is provided' {
        $out = Write-ClaudeHookResponse -StopReason 'build failed' | ConvertFrom-Json
        $out.continue   | Should -Be $false
        $out.stopReason | Should -Be 'build failed'
    }

    It 'does not include continue when StopReason is omitted' {
        $out = Write-ClaudeHookResponse -SystemMessage 'ok' | ConvertFrom-Json
        $out.PSObject.Properties.Name | Should -Not -Contain 'continue'
    }

    It 'sets suppressOutput when switch is passed' {
        $out = Write-ClaudeHookResponse -SuppressOutput | ConvertFrom-Json
        $out.suppressOutput | Should -Be $true
    }

    It 'sets decision and reason fields' {
        $out = Write-ClaudeHookResponse -Decision 'block' -Reason 'not allowed' | ConvertFrom-Json
        $out.decision | Should -Be 'block'
        $out.reason   | Should -Be 'not allowed'
    }

    It 'merges HookSpecificOutput into the response' {
        $hso = @{ hookEventName = 'PreToolUse'; permissionDecision = 'deny' }
        $out = Write-ClaudeHookResponse -HookSpecificOutput $hso | ConvertFrom-Json
        $out.hookSpecificOutput.hookEventName     | Should -Be 'PreToolUse'
        $out.hookSpecificOutput.permissionDecision | Should -Be 'deny'
    }

    It 'returns a string (not exits) without -BlockingError' {
        { Write-ClaudeHookResponse -SystemMessage 'test' } | Should -Not -Throw
    }
}

Describe 'Write-ClaudeHookAllow' {
    It 'emits permissionDecision:allow in hookSpecificOutput' {
        $out = Write-ClaudeHookAllow | ConvertFrom-Json
        $out.hookSpecificOutput.permissionDecision | Should -Be 'allow'
        $out.hookSpecificOutput.hookEventName      | Should -Be 'PreToolUse'
    }

    It 'includes permissionDecisionReason when -Reason is provided' {
        $out = Write-ClaudeHookAllow -Reason 'approved' | ConvertFrom-Json
        $out.hookSpecificOutput.permissionDecisionReason | Should -Be 'approved'
    }

    It 'includes updatedInput when -UpdatedInput is provided' {
        $out = Write-ClaudeHookAllow -UpdatedInput @{ command = 'ls' } | ConvertFrom-Json
        $out.hookSpecificOutput.updatedInput.command | Should -Be 'ls'
    }
}

Describe 'Write-ClaudeHookDeny' {
    It 'emits permissionDecision:deny in hookSpecificOutput' {
        $out = Write-ClaudeHookDeny | ConvertFrom-Json
        $out.hookSpecificOutput.permissionDecision | Should -Be 'deny'
        $out.hookSpecificOutput.hookEventName      | Should -Be 'PreToolUse'
    }

    It 'includes permissionDecisionReason when -Reason is provided' {
        $out = Write-ClaudeHookDeny -Reason 'blocked' | ConvertFrom-Json
        $out.hookSpecificOutput.permissionDecisionReason | Should -Be 'blocked'
    }
}

Describe 'Write-ClaudeHookAsk' {
    It 'emits permissionDecision:ask in hookSpecificOutput' {
        $out = Write-ClaudeHookAsk | ConvertFrom-Json
        $out.hookSpecificOutput.permissionDecision | Should -Be 'ask'
    }
}

Describe 'Write-ClaudeHookBlock' {
    It 'emits decision:block with reason at top level' {
        $out = Write-ClaudeHookBlock -Reason 'not permitted' | ConvertFrom-Json
        $out.decision | Should -Be 'block'
        $out.reason   | Should -Be 'not permitted'
    }

    It 'does not include hookSpecificOutput' {
        $out = Write-ClaudeHookBlock -Reason 'x' | ConvertFrom-Json
        $out.PSObject.Properties.Name | Should -Not -Contain 'hookSpecificOutput'
    }
}

Describe 'Write-ClaudeHookContext' {
    It 'emits additionalContext in hookSpecificOutput with the correct event name' {
        $out = Write-ClaudeHookContext -Event SessionStart -Context 'project: MyApp' | ConvertFrom-Json
        $out.hookSpecificOutput.hookEventName    | Should -Be 'SessionStart'
        $out.hookSpecificOutput.additionalContext | Should -Be 'project: MyApp'
    }
}

Describe 'Write-ClaudeHookUpdatedInput' {
    It 'emits permissionDecision:allow with updatedInput' {
        $out = Write-ClaudeHookUpdatedInput -UpdatedInput @{ command = 'npm test' } | ConvertFrom-Json
        $out.hookSpecificOutput.permissionDecision     | Should -Be 'allow'
        $out.hookSpecificOutput.updatedInput.command   | Should -Be 'npm test'
    }
}
