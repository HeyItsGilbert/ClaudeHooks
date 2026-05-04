# Change Log

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/)
and this project adheres to [Semantic Versioning](http://semver.org/).

## [Unreleased]

## [0.1.1] - 2026-05-04

### Added

- GitHub Pages workflow for publishing MkDocs documentation site
- GitHub Publish workflow for releasing to the PowerShell Gallery
- Comprehensive cmdlet help files for all public functions under
  `docs/en-US/`

### Fixed

- `$Event` automatic variable conflict in `Add-ClaudeHookConfig`,
  `Get-ClaudeHookConfig`, and `Remove-ClaudeHookConfig` — PowerShell
  reserves `$Event` in event-handler scope; the internal binding now
  uses `$eventName` to avoid shadowing
- `ProjectUri` in `ClaudeHooks.psd1` corrected from `PSClaudeHelpers`
  to `ClaudeHooks`

### Changed

- `Resolve-ClaudeSettingsPath` refactored to use named `-Path` /
  `-ChildPath` parameters on `Join-Path` for cross-platform path
  handling

## [0.1.0] - 2026-05-03

### Added

- `Read-ClaudeHookInput` - Read and parse JSON hook payload from stdin
- `Write-ClaudeHookAllow` - Emit allow decision for PreToolUse events
- `Write-ClaudeHookDeny` - Emit deny decision for PreToolUse events
- `Write-ClaudeHookAsk` - Emit ask-user decision for PreToolUse events
- `Write-ClaudeHookUpdatedInput` - Emit allow decision with modified input for PreToolUse events
- `Write-ClaudeHookBlock` - Emit block decision for Stop/UserPromptSubmit/PostToolUse events
- `Write-ClaudeHookContext` - Inject context message for Claude to read
- `Write-ClaudeHookResponse` - Low-level response builder with full control
- `Get-ClaudeBashBaseCommand` - Extract base command name from Bash command string
- `Add-ClaudeHookConfig` - Register a hook in Claude Code settings (User/Project/Local/Plugin scope)
- `Get-ClaudeHookConfig` - List registered hooks from settings files
- `Remove-ClaudeHookConfig` - Unregister a hook from settings
- `Test-ClaudeHookConfig` - Test a hook with sample JSON input
- `Get-ClaudeHookEventList` - List all valid hook event names

### Documentation

- README.md with quickstart, decision matrix, and function reference
- docs/en-US/about_ClaudeHooks.help.md comprehensive help topic
- Examples/ folder with 3 ready-to-use hook scripts
