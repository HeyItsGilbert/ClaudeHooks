@{
    PSDepend = @{
        Version = '0.3.8'
    }
    PSDependOptions = @{
        Target = 'CurrentUser'
    }
    'Pester' = @{
        Version = '5.7.1'
        Parameters = @{
            SkipPublisherCheck = $true
        }
    }
    'psake' = @{
        Version = '5.0.3'
        Parameters = @{
            AllowPrerelease = $true
        }
    }
    'BuildHelpers' = @{
        Version = '2.0.16'
    }
    'PowerShellBuild' = @{
        Version = '0.7.2'
    }
    'PSScriptAnalyzer' = @{
        Version = '1.25.0'
    }
    'GoodEnoughRules' = @{
        Version = 'latest'
    }
}
