function Resolve-ClaudeSettingsPath {
    <#
    .SYNOPSIS
    Resolve the settings Path based on Scope.

    .DESCRIPTION
    Resolve the settings Path based on Scope. For 'User', it defaults to
    the user's home directory. For 'Project' and 'Local', it uses the current
    directory. For 'Plugin', it uses the provided Path.

    .PARAMETER Scope
    The scope of the settings file. Valid values are 'User', 'Project', 'Local', and 'Plugin'.

    .PARAMETER HomeOverride
    Optional override for the user's home directory when Scope is 'User'.

    .PARAMETER Path
    The path to the settings file when Scope is 'Plugin'. This parameter is
    required when Scope is 'Plugin'.

    .EXAMPLE
    Resolve-ClaudeSettingsPath -Scope User

    Resolves to the user-level settings path, typically
    C:\Users\Username\.claude\settings.json

    .EXAMPLE
    Resolve-ClaudeSettingsPath -Scope Project

    Resolves to the project-level settings path, typically
    C:\CurrentDirectory\.claude\settings.json
    #>
    param(
        [ValidateSet('User', 'Project', 'Local', 'Plugin')]
        [string]$Scope = 'User',
        [string]$HomeOverride,
        [string]$Path
    )
    $settingsFileName = 'settings.json'
    if ($Scope -eq 'Local') {
        $settingsFileName = 'settings.local.json'
    }
    # Always prefer Join-Path for cross-platform compatibility, even on Windows.
    # It handles path separators correctly.
    $childPath = Join-Path -Path '.claude' -ChildPath $settingsFileName

    switch ($Scope) {
        'User' {
            $homeDir = if ($HomeOverride) {
                $HomeOverride
            } else {
                [Environment]::GetFolderPath('UserProfile')
            }
            if ([string]::IsNullOrWhiteSpace($homeDir)) {
                throw 'Could not determine user home directory.'
            }
            Join-Path -Path $homeDir -ChildPath $childPath
        }
        'Project' {
            Join-Path -Path (Get-Location) -ChildPath $childPath
        }
        'Local' {
            Join-Path -Path (Get-Location) -ChildPath $childPath
        }
        'Plugin' {
            if ([string]::IsNullOrWhiteSpace($Path)) {
                throw '-Path is required when -Scope is Plugin.'
            }
            $Path
        }
    }
}
