---
external help file: ClaudeHooks-help.xml
Module Name: ClaudeHooks
online version:
schema: 2.0.0
---

# Get-ClaudeHookConfig

## SYNOPSIS
Lists hook entries from Claude Code settings files.

## SYNTAX

```
Get-ClaudeHookConfig [[-Event] <String>] [[-Matcher] <String>] [[-Scope] <String>] [[-Path] <String>]
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
Returns a flat list of hook entries from the specified settings files.
Each row includes Scope, Path, Event, Matcher, Type, Command, Shell, and Timeout.
Use -Scope All (default) to read User, Project, and Local files in priority order.
Rows are tagged with their source scope - this function lists, it does not resolve
effective hooks (precedence merging is not applied).

## EXAMPLES

### EXAMPLE 1
```
Get-ClaudeHookConfig | Format-Table
```

Lists all hook entries from User, Project, and Local settings files in a table.

### EXAMPLE 2
```
Get-ClaudeHookConfig -Event PreToolUse -Matcher Bash
```

Returns only the hooks registered for the PreToolUse event with the Bash matcher.

## PARAMETERS

### -Event
Filter results to a specific event name.

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

### -Matcher
Filter results to a specific matcher string.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Scope
Which settings file(s) to read.
All (default), User, Project, Local, or Plugin.
Plugin requires -Path.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: All
Accept pipeline input: False
Accept wildcard characters: False
```

### -Path
Override file path.
Required when -Scope is Plugin.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: None
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

