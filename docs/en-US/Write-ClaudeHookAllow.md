---
external help file: ClaudeHooks-help.xml
Module Name: ClaudeHooks
online version:
schema: 2.0.0
---

# Write-ClaudeHookAllow

## SYNOPSIS
Emits a PreToolUse allow decision, optionally with a modified tool input.

## SYNTAX

```
Write-ClaudeHookAllow [[-Reason] <String>] [[-UpdatedInput] <Hashtable>] [-ProgressAction <ActionPreference>]
 [<CommonParameters>]
```

## DESCRIPTION
Convenience wrapper around Write-ClaudeHookResponse for the PreToolUse
permissionDecision:allow shape.
Use when your hook approves the tool call.
Pass -UpdatedInput to modify the tool's parameters before execution.

## EXAMPLES

### EXAMPLE 1
```
Write-ClaudeHookAllow
```

Emits an unconditional allow for the current PreToolUse event.

### EXAMPLE 2
```
# Allow but sanitize the command
Write-ClaudeHookAllow -UpdatedInput @{ command = 'npm run lint' }
```

Allows the tool call but replaces the command with a safe alternative before execution.

## PARAMETERS

### -Reason
Optional explanation for the allow decision.

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

### -UpdatedInput
Hashtable of tool input fields to override before the tool runs.

```yaml
Type: Hashtable
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
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

### System.String
## NOTES

## RELATED LINKS

[about_ClaudeHooks]()

