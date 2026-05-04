function Remove-ClaudeHookConfig {
    <#
    .SYNOPSIS
        Removes a hook entry from a Claude Code settings file.
    .DESCRIPTION
        Removes hooks matching the specified event, matcher, and optionally command
        from the target settings file. Collapses empty matcher entries and event
        arrays after removal.
    .PARAMETER Event
        The hook event name.
    .PARAMETER Matcher
        The matcher string to target.
    .PARAMETER Command
        If specified, only the hook with this exact command string is removed.
        If omitted, all hooks under the matcher are removed.
    .PARAMETER Scope
        Target settings scope: User, Project, Local, or Plugin. Default: User.
    .PARAMETER Path
        Override file path. Required when -Scope is Plugin.
    .EXAMPLE
        Remove-ClaudeHookConfig -Event PreToolUse -Matcher Bash -Scope User

        Removes all hooks registered under the Bash matcher for PreToolUse in the user settings.
    .EXAMPLE
        Remove-ClaudeHookConfig -Event Stop -Matcher '' `
            -Command 'pwsh -File "C:\hooks\on-stop.ps1"' -Scope Project

        Removes only the specific Stop hook with the given command from the project settings.
    .PARAMETER PassThru
        Returns the resulting hook entries for the target file after the removal.
    .OUTPUTS
        None
    .LINK
        about_ClaudeHooks
    #>
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute(
        'PSAvoidAssignmentToAutomaticVariable',
        'Event',
        Scope = 'Function',
        Justification = 'Parameter is immediately re-assigned.'
    )]
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [Parameter(Mandatory)]
        [ValidateScript({ $_ -in (Get-ClaudeHookEventList) })]
        [string]$Event,

        [string]$Matcher = '',

        [string]$Command,

        [ValidateSet('User', 'Project', 'Local', 'Plugin')]
        [string]$Scope = 'User',

        [string]$Path,

        [switch]$PassThru
    )
    # $eventName is an automatic variable in event handlers, so we use
    # $eventName for the parameter and $eventNameName for the internal variable
    # to avoid conflicts.
    $eventName = $PSBoundParameters['Event']

    $filePath = if (
        $PSBoundParameters.ContainsKey('Path') -and
        $Scope -ne 'Plugin'
    ) {
        $Path
    } else {
        Resolve-ClaudeSettingsPath -Scope $Scope -Path $Path
    }

    if (-not (Test-Path $filePath)) { return }

    $description = "Remove $eventName hook (matcher: '$Matcher')"
    if (-not $PSCmdlet.ShouldProcess($filePath, $description)) { return }

    $hasCommand = $PSBoundParameters.ContainsKey('Command')

    $editFn = if ($Scope -eq 'Plugin') {
        { param($p, $m) Edit-ClaudePluginManifest -Path $p -Modifier $m }
    } else {
        { param($p, $m) Edit-ClaudeSettingsFile   -Path $p -Modifier $m }
    }

    & $editFn $filePath {
        param($settings)

        if (
            -not $settings['hooks'] -or
            -not $settings['hooks'][$eventName]
        ) {
            return $settings
        }

        $matcherEntries = [System.Collections.Generic.List[object]]::new()
        $matcherEntries.AddRange([object[]]@($settings['hooks'][$eventName]))

        $toRemove = $matcherEntries | Where-Object {
            $_['matcher'] -eq $Matcher
        }

        foreach ($me in @($toRemove)) {
            if ($hasCommand) {
                $remaining = @($me['hooks']) | Where-Object {
                    $_['command'] -ne $Command
                }
                if ($remaining.Count -eq 0) {
                    $matcherEntries.Remove($me) | Out-Null
                } else {
                    $me['hooks'] = $remaining
                }
            } else {
                $matcherEntries.Remove($me) | Out-Null
            }
        }

        $settings['hooks'][$eventName] = $matcherEntries.ToArray()

        if (@($settings['hooks'][$eventName]).Count -eq 0) {
            $settings['hooks'].Remove($eventName)
        }

        $settings
    }

    if ($PassThru) { Get-ClaudeHookConfig -Path $filePath }
}
