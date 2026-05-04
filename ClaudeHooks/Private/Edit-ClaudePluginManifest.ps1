function Edit-ClaudePluginManifest {
    <#
    .SYNOPSIS
    Similar to Edit-ClaudeSettingsFile but matches the Plugin schema.

    .DESCRIPTION
    Modify the Claude plugin manifest file at the specified path using a script
    block that takes the current manifest as input and returns the modified
    manifest.

    .PARAMETER Path
    The path to the Claude plugin manifest file.

    .PARAMETER Modifier
    The script block that modifies the manifest. It takes the current manifest
    as a parameter and should return the modified manifest. If it returns $null,
    the original manifest will be saved without modification.

    .EXAMPLE
    Edit-ClaudePluginManifest -Path "C:\Claude\MyPlugin\manifest.json" -Modifier {
        param($manifest)
        $manifest['newField'] = 'newValue'
        return $manifest
    }

    Edit C:\Claude\MyPlugin\manifest.json to add a new field "newField" with the
    value "newValue".
    #>
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute(
        'PSReviewUnusedParameter',
        'Modifier',
        Scope = 'Function',
        Justification = 'Parameter is used inside a scriptblock.'
    )]
    [CmdletBinding()]
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
