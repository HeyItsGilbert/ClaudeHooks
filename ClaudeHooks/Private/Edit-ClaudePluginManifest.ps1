function Edit-ClaudePluginManifest {
    param(
        [string]$Path,
        [scriptblock]$Modifier
    )

    Edit-ClaudeSettingsFile -Path $Path -Modifier {
        param($manifest)
        if (-not $manifest['hooks']) { $manifest['hooks'] = [ordered]@{} }
        $hooksResult = & $Modifier $manifest['hooks']
        if ($null -ne $hooksResult) { $manifest['hooks'] = $hooksResult }
        $manifest
    }
}
