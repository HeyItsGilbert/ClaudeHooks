function Resolve-ClaudeSettingsPath {
    param(
        [ValidateSet('User', 'Project', 'Local', 'Plugin')]
        [string]$Scope = 'User',
        [string]$HomeOverride,
        [string]$Path
    )

    switch ($Scope) {
        'User' {
            $home = if ($HomeOverride) { $HomeOverride } else { [Environment]::GetFolderPath('UserProfile') }
            if ([string]::IsNullOrWhiteSpace($home)) { throw 'Could not determine user home directory.' }
            Join-Path $home '.claude' 'settings.json'
        }
        'Project' {
            Join-Path (Get-Location) '.claude' 'settings.json'
        }
        'Local' {
            Join-Path (Get-Location) '.claude' 'settings.local.json'
        }
        'Plugin' {
            if ([string]::IsNullOrWhiteSpace($Path)) { throw '-Path is required when -Scope is Plugin.' }
            $Path
        }
    }
}
