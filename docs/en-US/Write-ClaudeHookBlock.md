---
external help file: ClaudeHooks-help.xml
Module Name: ClaudeHooks
online version:
schema: 2.0.0
---

# Write-ClaudeHookBlock

## SYNOPSIS
Emits a top-level block decision for Stop, UserPromptSubmit, or PostToolUse hooks.

## SYNTAX

```
Write-ClaudeHookBlock [-Reason] <String> [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
Convenience wrapper around Write-ClaudeHookResponse for the top-level
decision:block shape.
Use this (not Write-ClaudeHookDeny) for Stop,
UserPromptSubmit, and PostToolUse events.
For PreToolUse permission denial
use Write-ClaudeHookDeny instead.

## EXAMPLES

### EXAMPLE 1
```
# Block a Stop event to keep Claude running
Write-ClaudeHookBlock -Reason 'Tests are still failing. Fix them before stopping.'
```

Emits a top-level block decision for a Stop event, preventing Claude from stopping.

### EXAMPLE 2
```
# Block a prompt submission
$hook = Read-ClaudeHookInput
if ($hook.prompt -match 'delete production') {
    Write-ClaudeHookBlock -Reason 'Destructive production operations require manual review.'
}
```

Blocks a UserPromptSubmit event when the prompt contains a sensitive keyword.

## PARAMETERS

### -Reason
Required explanation for the block shown to the user.

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

