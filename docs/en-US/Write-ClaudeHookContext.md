---
external help file: ClaudeHooks-help.xml
Module Name: ClaudeHooks
online version:
schema: 2.0.0
---

# Write-ClaudeHookContext

## SYNOPSIS
Emits an additionalContext string for hook events that support it.

## SYNTAX

```
Write-ClaudeHookContext [-Event] <String> [-Context] <String> [-ProgressAction <ActionPreference>]
 [<CommonParameters>]
```

## DESCRIPTION
Convenience wrapper that wraps context text in the correct hookSpecificOutput
envelope.
Supported events: SessionStart, Setup, UserPromptSubmit,
UserPromptExpansion, PreToolUse, PostToolUse, PostToolUseFailure, PostToolBatch.

## EXAMPLES

### EXAMPLE 1
```
# Add context at session start
Write-ClaudeHookContext -Event SessionStart -Context 'Project: MyApp. Stack: PS + Azure.'
```

Injects project context into Claude's context window at the start of every session.

### EXAMPLE 2
```
# Add context after a file write
$hook = Read-ClaudeHookInput
if ($hook.tool_input.file_path -like '*.generated.ps1') {
    Write-ClaudeHookContext -Event PostToolUse -Context 'This file is auto-generated. Edit the template instead.'
}
```

Appends a caution note after Claude writes a generated file so it knows not to edit it directly.

## PARAMETERS

### -Event
The hook event name (e.g.
'SessionStart', 'PostToolUse').

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

### -Context
The context string to inject into Claude's context window.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
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

