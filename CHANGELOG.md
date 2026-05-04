# Change Log

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/)
and this project adheres to [Semantic Versioning](http://semver.org/).

## [0.1.0] - 2026-05-03

### Added

- `Read-ClaudeHookInput` — Read and parse JSON hook payload from stdin
- `Write-ClaudeHookAllow` — Emit allow decision for PreToolUse events
- `Write-ClaudeHookDeny` — Emit deny decision for PreToolUse events
- `Write-ClaudeHookAsk` — Emit ask-user decision for PreToolUse events
- `Write-ClaudeHookUpdatedInput` — Emit allow decision with modified input for PreToolUse events
- `Write-ClaudeHookBlock` — Emit block decision for Stop/UserPromptSubmit/PostToolUse events
- `Write-ClaudeHookContext` — Inject context message for Claude to read
- `Write-ClaudeHookResponse` — Low-level response builder with full control
- `Get-ClaudeBashBaseCommand` — Extract base command name from Bash command string
- `Add-ClaudeHookConfig` — Register a hook in Claude Code settings (User/Project/Local/Plugin scope)
- `Get-ClaudeHookConfig` — List registered hooks from settings files
- `Remove-ClaudeHookConfig` — Unregister a hook from settings
- `Test-ClaudeHookConfig` — Test a hook with sample JSON input
- `Get-ClaudeHookEventList` — List all valid hook event names

### Documentation

- README.md with quickstart, decision matrix, and function reference
- docs/en-US/about_ClaudeHooks.help.md comprehensive help topic
- Examples/ folder with 3 ready-to-use hook scripts
