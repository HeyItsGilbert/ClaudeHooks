function Lock-ClaudeSettingsFile {
    param([string]$Path)

    $lockPath = "$Path.lock"
    $acquired = $false
    for ($i = 0; $i -lt 10; $i++) {
        try {
            $null = New-Item -Path $lockPath -ItemType File -ErrorAction Stop
            $acquired = $true
            break
        } catch {
            Start-Sleep -Milliseconds 100
        }
    }
    if (-not $acquired) { throw "Could not acquire lock on '$Path' after 1 second." }

    [pscustomobject]@{ LockPath = $lockPath } |
        Add-Member -MemberType ScriptMethod -Name 'Dispose' -Value {
            if (Test-Path $this.LockPath) { Remove-Item $this.LockPath -Force -ErrorAction SilentlyContinue }
        } -PassThru
}
