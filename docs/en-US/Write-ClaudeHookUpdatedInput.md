---
external help file: ClaudeHooks-help.xml
Module Name: ClaudeHooks
online version:
schema: 2.0.0
---

# Write-ClaudeHookUpdatedInput

## SYNOPSIS
Emits a PreToolUse allow decision with a modified tool input.

## SYNTAX

```
Write-ClaudeHookUpdatedInput [-UpdatedInput] <Hashtable> [-ProgressAction <ActionPreference>]
 [<CommonParameters>]
```

## DESCRIPTION
Convenience wrapper that combines Write-ClaudeHookAllow with an updatedInput
payload.
Use when your hook wants to allow the tool but change its parameters
(e.g., normalize a path, inject flags, redirect output).

## EXAMPLES

### EXAMPLE 1
```
# Redirect a file write to a safe temp location
$hook = Read-ClaudeHookInput
Write-ClaudeHookUpdatedInput -UpdatedInput @{ file_path = $hook.tool_input.file_path -replace 'prod', 'staging' }
```

Allows the Write tool but redirects the target path from production to staging.

### EXAMPLE 2
```
# Enforce a timeout on every Bash call
Write-ClaudeHookUpdatedInput -UpdatedInput @{ timeout = 30000 }
```

Allows the Bash call but enforces a 30-second timeout on every invocation.

## PARAMETERS

### -UpdatedInput
Hashtable of tool input fields to override.
Only specified fields are overridden;
unspecified fields retain their original values per the hooks spec.

```yaml
Type: Hashtable
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

