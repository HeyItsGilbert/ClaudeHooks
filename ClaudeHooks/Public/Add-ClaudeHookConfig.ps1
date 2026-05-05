function Add-ClaudeHookConfig {
    <#
    .SYNOPSIS
        Adds a hook entry to a Claude Code settings file.
    .DESCRIPTION
        Inserts a hook definition under the specified event and matcher in the target
        settings file. Supports user, project, local, and plugin scopes.
        Idempotent: if the same (Event, Matcher, Type, Command/ScriptPath, Shell) tuple
        already exists, does nothing unless -Force is specified.
        Uses -ScriptPath for safely-quoted invocations; -Command for raw shell strings
        (caller is responsible for correct quoting).
    .PARAMETER Event
        The Claude Code hook event name (e.g. 'PreToolUse', 'Stop').
    .PARAMETER Matcher
        The matcher string for the event (e.g. 'Bash', 'Edit|Write').
    .PARAMETER ScriptPath
        Path to a PowerShell script. Generates a safely-quoted pwsh invocation.
        Use this instead of -Command for script paths.
    .PARAMETER ArgumentList
        Arguments to pass to the script specified in -ScriptPath.
    .PARAMETER Command
        Raw shell command string written verbatim to the settings file.
        Caller is responsible for correct quoting. Trust boundary: do not build
        this from untrusted input.
    .PARAMETER Shell
        Shell to use for command hooks: 'powershell' or 'bash'. Default: 'powershell'.
    .PARAMETER Type
        Hook type. One of: command, http, McpTool (-> mcp_tool), prompt, agent.
        Default: 'command'.
    .PARAMETER Timeout
        Hook timeout in seconds.
    .PARAMETER Scope
        Target settings file: User, Project, Local, or Plugin.
        Default: User. Plugin requires -Path.
    .PARAMETER Path
        Full path to the settings file. Required when -Scope is Plugin.
        Optional override for other scopes.
    .PARAMETER Force
        Overwrites an existing entry with the same (Event, Matcher, Command/ScriptPath) tuple.
    .PARAMETER PassThru
        Returns the resulting hook entries for the target file after the write.
    .EXAMPLE
        Add-ClaudeHookConfig -Event PreToolUse -Matcher Bash `
            -ScriptPath '~/.claude/hooks/track-bash.ps1' -Scope User

        Registers a PreToolUse hook for Bash commands in the user settings using a safe quoted path.
    .EXAMPLE
        # Raw command (escape hatch - caller handles quoting)
        Add-ClaudeHookConfig -Event Stop -Matcher '' `
            -Command 'pwsh -File "C:\hooks\on-stop.ps1"' -Scope Project

        Registers a Stop hook using a raw command string in the project settings file.
    .OUTPUTS
        None. Use -PassThru to return the resulting hooks block.
    .LINK
        about_ClaudeHooks
    .LINK
        https://code.claude.com/docs/en/hooks.md
    #>
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute(
        'PSAvoidAssignmentToAutomaticVariable',
        'Event',
        Justification = 'Parameter is immediately re-assigned.'
    )]
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [Parameter(Mandatory)]
        [ValidateScript({ $_ -in (Get-ClaudeHookEventList) })]
        [ArgumentCompleter({ Get-ClaudeHookEventList })]
        [string]$Event,

        [string]$Matcher = '',

        [Parameter(ParameterSetName = 'ScriptPath')]
        [string]$ScriptPath,

        [Parameter(ParameterSetName = 'ScriptPath')]
        [string[]]$ArgumentList,

        [Parameter(ParameterSetName = 'Command')]
        [string]$Command,

        [ValidateSet('powershell', 'bash')]
        [string]$Shell = 'powershell',

        [ValidateSet('command', 'http', 'McpTool', 'prompt', 'agent')]
        [string]$Type = 'command',

        [int]$Timeout,

        [ValidateSet('User', 'Project', 'Local', 'Plugin')]
        [string]$Scope = 'User',

        [string]$Path,

        [switch]$Force,
        [switch]$PassThru
    )
    # $eventName is an automatic variable in event handlers, so we use
    # $eventName for the parameter and $eventNameName for the internal variable
    # to avoid conflicts.
    $eventName = $PSBoundParameters['Event']

    if ($PSCmdlet.ParameterSetName -eq 'ScriptPath') {
        $resolved = $ScriptPath
        $argStr = if ($ArgumentList) {
            ' ' + ($ArgumentList -join ' ')
        } else {
            ''
        }

        $command = "pwsh -NoProfile -File `"$resolved`"$argStr"
    }

    $jsonType = if ($Type -eq 'McpTool') { 'mcp_tool' } else { $Type }

    $hookEntry = [ordered]@{ type = $jsonType; command = $command; shell = $Shell }
    if ($PSBoundParameters.ContainsKey('Timeout')) {
        $hookEntry['timeout'] = $Timeout
    }

    $filePath = if (
        $PSBoundParameters.ContainsKey('Path') -and
        $Scope -ne 'Plugin'
    ) {
        $Path
    } else {
        Resolve-ClaudeSettingsPath -Scope $Scope -Path $Path
    }

    # ShouldProcess support for WhatIf and Confirm prompts
    $processDescription = "Add hook for event '$eventName' with matcher '$Matcher' to $filePath"
    if (-not $PSCmdlet.ShouldProcess($filePath, $processDescription)) { return }

    $editFn = if ($Scope -eq 'Plugin') {
        { param($p, $m) Edit-ClaudePluginManifest -Path $p -Modifier $m }
    } else {
        { param($p, $m) Edit-ClaudeSettingsFile -Path $p -Modifier $m }
    }

    # The modifier script block for both settings and plugin manifest has the
    # same structure:
    & $editFn $filePath {
        param($settings)

        if (-not $settings['hooks']) {
            $settings['hooks'] = [ordered]@{}
        }
        if (-not $settings['hooks'][$eventName]) {
            $settings['hooks'][$eventName] = @()
        }

        $matcherEntries = @($settings['hooks'][$eventName])
        $matcherEntry = $matcherEntries | Where-Object {
            $_['matcher'] -eq $Matcher
        } | Select-Object -First 1

        if (-not $matcherEntry) {
            $matcherEntry = [ordered]@{ matcher = $Matcher; hooks = @() }
            $settings['hooks'][$eventName] = @($matcherEntries) + @($matcherEntry)
        }

        $existing = @($matcherEntry['hooks']) | Where-Object {
            $_['type'] -eq $jsonType -and $_['command'] -eq $command
        } | Select-Object -First 1

        if ($existing -and -not $Force) {
            Write-Verbose "Hook already exists. Use -Force to overwrite."
            return $settings
        }

        if ($existing -and $Force) {
            $idx = [array]::IndexOf(@($matcherEntry['hooks']), $existing)
            $arr = [System.Collections.Generic.List[object]]::new()
            $arr.AddRange([object[]]@($matcherEntry['hooks']))
            $arr[$idx] = $hookEntry
            $matcherEntry['hooks'] = $arr.ToArray()
        } else {
            $matcherEntry['hooks'] = @($matcherEntry['hooks']) + @($hookEntry)
        }

        $settings
    }

    if ($PassThru) { Get-ClaudeHookConfig -Path $filePath }
}
