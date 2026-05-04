---
external help file: ClaudeHooks-help.xml
Module Name: ClaudeHooks
online version:
schema: 2.0.0
---

# Remove-ClaudeHookConfig

## SYNOPSIS
Removes a hook entry from a Claude Code settings file.

## SYNTAX

```
Remove-ClaudeHookConfig [-Event] <String> [[-Matcher] <String>] [[-Command] <String>] [[-Scope] <String>]
 [[-Path] <String>] [-PassThru] [-ProgressAction <ActionPreference>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Removes hooks matching the specified event, matcher, and optionally command
from the target settings file.
Collapses empty matcher entries and event
arrays after removal.

## EXAMPLES

### EXAMPLE 1
```
Remove-ClaudeHookConfig -Event PreToolUse -Matcher Bash -Scope User
```

Removes all hooks registered under the Bash matcher for PreToolUse in the user settings.

### EXAMPLE 2
```
Remove-ClaudeHookConfig -Event Stop -Matcher '' `
    -Command 'pwsh -File "C:\hooks\on-stop.ps1"' -Scope Project
```

Removes only the specific Stop hook with the given command from the project settings.

## PARAMETERS

### -Event
The hook event name.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Matcher
The matcher string to target.

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

### -Command
If specified, only the hook with this exact command string is removed.
If omitted, all hooks under the matcher are removed.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Scope
Target settings scope: User, Project, Local, or Plugin.
Default: User.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: User
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
Position: 5
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -PassThru
Returns the resulting hook entries for the target file after the removal.

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

### -WhatIf
Shows what would happen if the cmdlet runs.
The cmdlet is not run.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: wi

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Confirm
Prompts you for confirmation before running the cmdlet.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: cf

Required: False
Position: Named
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

### None
## NOTES

## RELATED LINKS

[about_ClaudeHooks]()

