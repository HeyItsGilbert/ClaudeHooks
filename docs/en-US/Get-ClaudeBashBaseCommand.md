---
external help file: ClaudeHooks-help.xml
Module Name: ClaudeHooks
online version:
schema: 2.0.0
---

# Get-ClaudeBashBaseCommand

## SYNOPSIS
Extracts the base command name from a Bash tool_input.command string.

## SYNTAX

```
Get-ClaudeBashBaseCommand [-Command] <String> [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
Strips path prefixes and arguments from a shell command string, returning
only the executable name in lowercase.
Useful in PreToolUse hooks that
match on the Bash tool to identify which program is being invoked.

## EXAMPLES

### EXAMPLE 1
```
Get-ClaudeBashBaseCommand 'grep -r "foo" .'
```

Returns 'grep' - strips arguments and returns the base executable name.

### EXAMPLE 2
```
Get-ClaudeBashBaseCommand '/usr/bin/curl -s https://example.com'
```

Returns 'curl' - strips the full path prefix as well as arguments.

## PARAMETERS

### -Command
The full command string from tool_input.command.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByValue)
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

### System.String
## NOTES

## RELATED LINKS

[about_ClaudeHooks]()

