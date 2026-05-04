---
external help file: ClaudeHooks-help.xml
Module Name: ClaudeHooks
online version:
schema: 2.0.0
---

# Test-ClaudeHookConfig

## SYNOPSIS
Validates a Claude Code settings file's hook configuration.

## SYNTAX

### Path (Default)
```
Test-ClaudeHookConfig -Path <String> [-Strict] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### InputObject
```
Test-ClaudeHookConfig -InputObject <Hashtable> [-Strict] [-ProgressAction <ActionPreference>]
 [<CommonParameters>]
```

## DESCRIPTION
Checks that event names are in the canonical set, matcher entries are arrays,
each hook has required fields for its type, and warns when a command-type hook's
script path does not exist.
Returns result objects with Severity, Location, and Message.
Non-throwing by default; use -Strict to throw on the first error.

## EXAMPLES

### EXAMPLE 1
```
Test-ClaudeHookConfig -Path ~/.claude/settings.json
```

Validates all hooks in the user-level settings file and returns any warnings or errors.

### EXAMPLE 2
```
$results = Test-ClaudeHookConfig -Path .\.claude\settings.json
$results | Where-Object Severity -eq 'Error'
```

Validates the project settings file and filters the results to show only errors.

## PARAMETERS

### -Path
Path to the settings or plugin manifest file to validate.

```yaml
Type: String
Parameter Sets: Path
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -InputObject
Hashtable to validate directly (instead of reading a file).

```yaml
Type: Hashtable
Parameter Sets: InputObject
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Strict
Throws a terminating error on the first validation failure.

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

