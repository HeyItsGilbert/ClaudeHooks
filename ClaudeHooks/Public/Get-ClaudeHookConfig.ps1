function Get-ClaudeHookConfig {
    <#
    .SYNOPSIS
        Lists hook entries from Claude Code settings files.
    .DESCRIPTION
        Returns a flat list of hook entries from the specified settings files.
        Each row includes Scope, Path, Event, Matcher, Type, Command, Shell, and Timeout.
        Use -Scope All (default) to read User, Project, and Local files in priority order.
        Rows are tagged with their source scope - this function lists, it does not resolve
        effective hooks (precedence merging is not applied).
    .PARAMETER Event
        Filter results to a specific event name.
    .PARAMETER Matcher
        Filter results to a specific matcher string.
    .PARAMETER Scope
        Which settings file(s) to read. All (default), User, Project, Local, or Plugin.
        Plugin requires -Path.
    .PARAMETER Path
        Override file path. Required when -Scope is Plugin.
    .EXAMPLE
        Get-ClaudeHookConfig | Format-Table

        Lists all hook entries from User, Project, and Local settings files in a table.
    .EXAMPLE
        Get-ClaudeHookConfig -Event PreToolUse -Matcher Bash

        Returns only the hooks registered for the PreToolUse event with the Bash matcher.
    .OUTPUTS
        System.Management.Automation.PSCustomObject
    .LINK
        about_ClaudeHooks
    #>
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute(
        'PSAvoidAssignmentToAutomaticVariable',
        'Event',
        Scope = 'Function',
        Justification = 'Parameter is immediately re-assigned.'
    )]
    [OutputType([PSCustomObject])]
    [CmdletBinding()]
    param(
        [ArgumentCompleter({ Get-ClaudeHookEventList })]
        [string]$Event,
        [string]$Matcher,

        [ValidateSet('All', 'User', 'Project', 'Local', 'Plugin')]
        [string]$Scope = 'All',

        [string]$Path
    )
    # $eventName is an automatic variable in event handlers, so we use
    # $eventName for the parameter and $eventNameName for the internal variable
    # to avoid conflicts.
    $eventName = $PSBoundParameters['Event']

    $targets = if ($Scope -eq 'All') {
        @(
            @{ Scope = 'User'; Path = Resolve-ClaudeSettingsPath -Scope User }
            @{ Scope = 'Project'; Path = Resolve-ClaudeSettingsPath -Scope Project }
            @{ Scope = 'Local'; Path = Resolve-ClaudeSettingsPath -Scope Local }
        )
    } elseif ($Scope -eq 'Plugin') {
        @(@{ Scope = 'Plugin'; Path = $Path })
    } else {
        @(@{ Scope = $Scope; Path = $(if ($Path) { $Path } else { Resolve-ClaudeSettingsPath -Scope $Scope }) })
    }

    foreach ($target in $targets) {
        $filePath = $target.Path
        if (-not (Test-Path $filePath)) { continue }

        $raw = Get-Content $filePath -Raw -Encoding UTF8 -ErrorAction SilentlyContinue
        if ([string]::IsNullOrWhiteSpace($raw)) { continue }

        try { $settings = $raw | ConvertFrom-Json -Depth 64 -AsHashtable }
        catch { continue }

        if (-not $settings['hooks']) { continue }

        foreach ($evtName in $settings['hooks'].Keys) {
            if ($eventName -and $evtName -ne $eventName) { continue }

            foreach ($matcherEntry in @($settings['hooks'][$evtName])) {
                $mStr = $matcherEntry['matcher']
                if ($PSBoundParameters.ContainsKey('Matcher') -and $mStr -ne $Matcher) { continue }

                foreach ($h in @($matcherEntry['hooks'])) {
                    [pscustomobject]@{
                        Scope = $target.Scope
                        Path = $filePath
                        Event = $evtName
                        Matcher = $mStr
                        Type = $h['type']
                        Command = $h['command']
                        Shell = $h['shell']
                        Timeout = $h['timeout']
                    }
                }
            }
        }
    }
}
