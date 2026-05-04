---
external help file: ClaudeHooks-help.xml
Module Name: ClaudeHooks
online version:
schema: 2.0.0
---

# Read-ClaudeHookInput

## SYNOPSIS
Reads and parses the JSON payload that Claude Code sends to a hook script on stdin.

## SYNTAX

```
Read-ClaudeHookInput [[-InputString] <String>] [-Quiet] [-ProgressAction <ActionPreference>]
 [<CommonParameters>]
```

## DESCRIPTION
In production (no -InputString), reads \[Console\]::In to end.
In tests, pass -InputString to avoid reading actual stdin.
Rejects payloads over 10MB.
Throws on invalid JSON unless -Quiet is specified.

## EXAMPLES

### EXAMPLE 1
```
# In a hook script's main block:
$hook = Read-ClaudeHookInput
$hook.tool_name  # e.g. 'Bash'
$hook.tool_input.command  # e.g. 'rm -rf /'
```

Reads stdin from Claude and accesses the parsed event properties.

### EXAMPLE 2
```
# In a Pester test:
$hook = Read-ClaudeHookInput -InputString '{"tool_name":"Bash","tool_input":{"command":"ls"}}'
$hook.tool_name | Should -Be 'Bash'
```

Uses -InputString to inject a test payload without touching real stdin.

## PARAMETERS

### -InputString
JSON string to parse instead of reading stdin.
Used for Pester testing.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Quiet
Returns $null instead of throwing when JSON is invalid or input is empty.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -ProgressAction
{{ Fill ProgressAction Description }}

```yaml
Type: ActionPreference
Parameter Sets: (All)
Aliases: proga

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### System.Management.Automation.PSCustomObject
## NOTES

## RELATED LINKS

[about_ClaudeHooks]()

[https://code.claude.com/docs/en/hooks.md](https://code.claude.com/docs/en/hooks.md)

