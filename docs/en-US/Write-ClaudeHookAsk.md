---
external help file: ClaudeHooks-help.xml
Module Name: ClaudeHooks
online version:
schema: 2.0.0
---

# Write-ClaudeHookAsk

## SYNOPSIS
Emits a PreToolUse ask decision, prompting the user to confirm.

## SYNTAX

```
Write-ClaudeHookAsk [[-Reason] <String>] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
Convenience wrapper for the PreToolUse permissionDecision:ask shape.
Use when the tool call needs human confirmation before proceeding.

## EXAMPLES

### EXAMPLE 1
```
Write-ClaudeHookAsk -Reason 'About to write to production config. Confirm?'
```

Prompts the user to confirm before Claude proceeds with the tool call.

### EXAMPLE 2
```
if ($hook.tool_input.file_path -like '*prod*') {
    Write-ClaudeHookAsk -Reason "Writing to a production path: $($hook.tool_input.file_path)"
}
```

Asks for confirmation only when the target file path matches a production pattern.

## PARAMETERS

### -Reason
Message shown to the user explaining what they are being asked to confirm.

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

