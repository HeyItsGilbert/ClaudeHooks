---
external help file: ClaudeHooks-help.xml
Module Name: ClaudeHooks
online version:
schema: 2.0.0
---

# Get-ClaudeHookEventList

## SYNOPSIS
Returns the canonical list of Claude Code hook event names.

## SYNTAX

```
Get-ClaudeHookEventList [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
Provides the authoritative array of all supported hook event name strings.
Use this to validate event names, populate ValidateSet arguments, or enumerate
events in tooling and linters without hardcoding strings.

## EXAMPLES

### EXAMPLE 1
```
Get-ClaudeHookEventList
```

Returns all 30 event names as a string array.

### EXAMPLE 2
```
$events = Get-ClaudeHookEventList
if ('PreToolUse' -in $events) { 'Valid event' }
```

Validates that a given event name is in the canonical set.

## PARAMETERS

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

### System.String[]
## NOTES

## RELATED LINKS

[about_ClaudeHooks]()

[https://code.claude.com/docs/en/hooks.md](https://code.claude.com/docs/en/hooks.md)

