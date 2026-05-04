---
external help file: ClaudeHooks-help.xml
Module Name: ClaudeHooks
online version:
schema: 2.0.0
---

# Write-ClaudeHookResponse

## SYNOPSIS
Emits a JSON response from a hook script to Claude Code.

## SYNTAX

```
Write-ClaudeHookResponse [[-StopReason] <String>] [[-SystemMessage] <String>] [-SuppressOutput]
 [[-Decision] <String>] [[-Reason] <String>] [[-HookSpecificOutput] <Hashtable>] [-BlockingError]
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
Constructs and outputs the hook response JSON.
All parameters are optional.
Providing -StopReason sets continue:false.
-BlockingError emits JSON then exits
with code 2 (the hard-blocking error signal per the hooks spec).
All other calls return normally so the hook can continue additional logic.

## EXAMPLES

### EXAMPLE 1
```
# Inject a system message (non-blocking)
Write-ClaudeHookResponse -SystemMessage 'Lint passed.'
```

Emits a non-blocking system message that is shown to the user without stopping Claude.

### EXAMPLE 2
```
# Stop Claude with a reason
Write-ClaudeHookResponse -StopReason 'Build failed: 3 errors in src/'
```

Emits a stop response that sets continue:false and shows the reason to the user.

## PARAMETERS

### -StopReason
Message shown when Claude is stopped.
Presence implies continue:false.

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

### -SystemMessage
Non-blocking informational message shown to the user.

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

### -SuppressOutput
Omits the response from the debug log when $true.

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

### -Decision
Top-level decision field (e.g.
'block') for events like Stop, UserPromptSubmit.

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

### -Reason
Explanation shown with -Decision.

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

### -HookSpecificOutput
Hashtable of event-specific output fields merged under hookSpecificOutput.

```yaml
Type: Hashtable
Parameter Sets: (All)
Aliases:

Required: False
Position: 5
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -BlockingError
Emits the JSON response then immediately calls exit 2 (blocking error).
Use only at the top level of a hook script, not inside testable functions.

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

### System.String
## NOTES

## RELATED LINKS

[about_ClaudeHooks]()

[https://code.claude.com/docs/en/hooks.md](https://code.claude.com/docs/en/hooks.md)

