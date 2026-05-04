function Test-ClaudeHookConfig {
    <#
    .SYNOPSIS
        Validates a Claude Code settings file's hook configuration.
    .DESCRIPTION
        Checks that event names are in the canonical set, matcher entries are arrays,
        each hook has required fields for its type, and warns when a command-type hook's
        script path does not exist. Returns result objects with Severity, Location, and Message.
        Non-throwing by default; use -Strict to throw on the first error.
    .PARAMETER Path
        Path to the settings or plugin manifest file to validate.
    .PARAMETER InputObject
        Hashtable to validate directly (instead of reading a file).
    .PARAMETER Strict
        Throws a terminating error on the first validation failure.
    .EXAMPLE
        Test-ClaudeHookConfig -Path ~/.claude/settings.json

        Validates all hooks in the user-level settings file and returns any warnings or errors.
    .EXAMPLE
        $results = Test-ClaudeHookConfig -Path .\.claude\settings.json
        $results | Where-Object Severity -eq 'Error'

        Validates the project settings file and filters the results to show only errors.
    .OUTPUTS
        System.Management.Automation.PSCustomObject
    .LINK
        about_ClaudeHooks
    #>
    [OutputType([pscustomobject])]
    [CmdletBinding(DefaultParameterSetName = 'Path')]
    param(
        [Parameter(ParameterSetName = 'Path', Mandatory)]
        [string]$Path,

        [Parameter(ParameterSetName = 'InputObject', Mandatory)]
        [hashtable]$InputObject,

        [switch]$Strict
    )

    $results = [System.Collections.Generic.List[pscustomobject]]::new()

    function Add-Result {
        param([string]$Severity, [string]$Location, [string]$Message)
        $r = [pscustomobject]@{ Severity = $Severity; Location = $Location; Message = $Message }
        $results.Add($r)
        if ($Strict -and $Severity -eq 'Error') { throw "$Location`: $Message" }
    }

    $settings = if ($PSCmdlet.ParameterSetName -eq 'Path') {
        if (-not (Test-Path $Path)) {
            Add-Result -Severity Error -Location $Path -Message 'File not found.'
            return $results
        }
        try { Get-Content $Path -Raw -Encoding UTF8 | ConvertFrom-Json -Depth 64 -AsHashtable }
        catch {
            Add-Result -Severity Error -Location $Path -Message "Invalid JSON: $_"
            return $results
        }
    } else {
        $InputObject
    }

    $loc = if ($PSCmdlet.ParameterSetName -eq 'Path') { $Path } else { '<InputObject>' }

    if (-not $settings['hooks']) {
        Add-Result -Severity Warning -Location $loc -Message 'No hooks block found.'
        return $results
    }

    $validEvents = Get-ClaudeHookEventList

    foreach ($evtName in $settings['hooks'].Keys) {
        $evtLoc = "$loc/hooks/$evtName"

        if ($evtName -notin $validEvents) {
            Add-Result -Severity Error -Location $evtLoc -Message "Unknown hook event '$evtName'."
        }

        $matcherEntries = $settings['hooks'][$evtName]
        if ($matcherEntries -isnot [array] -and $matcherEntries -isnot [System.Collections.IList]) {
            Add-Result -Severity Error -Location $evtLoc -Message 'Event value must be an array of matcher entries.'
            continue
        }

        $i = 0
        foreach ($me in @($matcherEntries)) {
            $meLoc = "$evtLoc[$i]"
            $i++

            if (-not $me['matcher'] -and $me['matcher'] -ne '') {
                Add-Result -Severity Warning -Location $meLoc -Message 'Missing matcher field.'
            }

            $hookArr = $me['hooks']
            if (-not $hookArr) {
                Add-Result -Severity Error -Location $meLoc -Message 'Missing hooks array.'
                continue
            }

            $j = 0
            foreach ($h in @($hookArr)) {
                $hLoc = "$meLoc/hooks[$j]"
                $j++

                if (-not $h['type']) {
                    Add-Result -Severity Error -Location $hLoc -Message 'Missing required field: type.'
                }

                switch ($h['type']) {
                    { $_ -in 'command','mcp_tool' } {
                        if (-not $h['command']) {
                            Add-Result -Severity Error -Location $hLoc -Message 'command type requires a command field.'
                        } elseif ($h['type'] -eq 'command') {
                            $cmdBase = ($h['command'] -split '\s+' | Where-Object { $_ -match '\.ps1$|\.sh$' } | Select-Object -First 1)
                            if ($cmdBase) {
                                $expanded = [Environment]::ExpandEnvironmentVariables($cmdBase)
                                if (-not (Test-Path $expanded)) {
                                    Add-Result -Severity Warning -Location $hLoc -Message "Script path '$expanded' was not found."
                                }
                            }
                        }
                    }
                    'http' {
                        if (-not $h['url']) {
                            Add-Result -Severity Error -Location $hLoc -Message 'http type requires a url field.'
                        }
                    }
                    { $_ -in 'prompt','agent' } {
                        if (-not $h['prompt']) {
                            Add-Result -Severity Error -Location $hLoc -Message "$($h['type']) type requires a prompt field."
                        }
                    }
                }
            }
        }
    }

    $results
}
