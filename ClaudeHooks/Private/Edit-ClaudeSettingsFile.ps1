function Edit-ClaudeSettingsFile {
    <#
    .SYNOPSIS
    Modify the Claude settings file using a provided script block.

    .DESCRIPTION
    Modify the Claude settings file at the specified path using a script block
    that takes the current settings as input and returns the modified settings.

    .PARAMETER Path
    The path to the Claude settings file.

    .PARAMETER Modifier
    The script block that modifies the settings. It takes the current settings
    as a parameter and should return the modified settings. If it returns $null,
    the original settings will be saved without modification.

    .EXAMPLE
    Edit-ClaudeSettingsFile -Path "C:\Claude\settings.json" -Modifier {
        param($settings)
        $settings['newSetting'] = 'newValue'
        return $settings
    }

    Edit C:\Claude\settings.json to add a new setting "newSetting" with the
    value "newValue".
    #>
    [CmdletBinding()]
    param(
        [string]$Path,
        [scriptblock]$Modifier
    )

    $dir = Split-Path $Path -Parent
    if (-not (Test-Path $dir)) {
        New-Item -ItemType Directory -Path $dir -Force | Out-Null
    }

    $settings = if (Test-Path $Path) {
        $raw = Get-Content $Path -Raw -Encoding UTF8
        if ([string]::IsNullOrWhiteSpace($raw)) {
            [ordered]@{}
        } else {
            $raw | ConvertFrom-Json -Depth 64 -AsHashtable
        }
    } else {
        [ordered]@{}
    }

    if ($settings -isnot [System.Collections.Specialized.OrderedDictionary]) {
        $ordered = [ordered]@{}
        foreach ($key in $settings.Keys) { $ordered[$key] = $settings[$key] }
        $settings = $ordered
    }

    $modified = & $Modifier $settings
    if ($null -eq $modified) { $modified = $settings }

    $tmpPath = "$Path.tmp"
    $json = $modified | ConvertTo-Json -Depth 20
    [System.IO.File]::WriteAllText($tmpPath, $json, [System.Text.Encoding]::UTF8)

    Move-Item $tmpPath $Path -Force
}

