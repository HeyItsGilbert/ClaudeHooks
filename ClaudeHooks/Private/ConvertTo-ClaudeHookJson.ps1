function ConvertTo-ClaudeHookJson {
    param([hashtable]$InputObject)
    $InputObject | ConvertTo-Json -Depth 20 -Compress
}
