function Edit-ClaudeSettingsFile {
    param(
        [string]$Path,
        [scriptblock]$Modifier
    )

    $dir = Split-Path $Path -Parent
    if (-not (Test-Path $dir)) { New-Item -ItemType Directory -Path $dir -Force | Out-Null }

    $lock = Lock-ClaudeSettingsFile -Path $Path
    try {
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
        $json    = $modified | ConvertTo-Json -Depth 20
        [System.IO.File]::WriteAllText($tmpPath, $json, [System.Text.Encoding]::UTF8)

        Move-Item $tmpPath $Path -Force
    } finally {
        $lock.Dispose()
    }
}
