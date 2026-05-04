---
external help file: ClaudeHooks-help.xml
Module Name: ClaudeHooks
online version:
schema: 2.0.0
---

# Write-ClaudeHookDeny

## SYNOPSIS
Emits a PreToolUse deny decision.

## SYNTAX

```
Write-ClaudeHookDeny [[-Reason] <String>] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
Convenience wrapper for the PreToolUse permissionDecision:deny shape.
Use when your hook rejects a tool call.
The -Reason is shown to the user.

## EXAMPLES

### EXAMPLE 1
```
Write-ClaudeHookDeny -Reason 'rm -rf is not allowed in this project.'
```

Emits a deny decision for a PreToolUse hook with a message shown to the user.

### EXAMPLE 2
```
$base = Get-ClaudeBashBaseCommand $hook.tool_input.command
if ($base -eq 'rm') { Write-ClaudeHookDeny -Reason "Use Remove-Item instead." }
```

Denies the tool call when the base command is 'rm', suggesting a safer alternative.

## PARAMETERS

### -Reason
Required explanation shown to the user explaining why the tool was denied.

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

