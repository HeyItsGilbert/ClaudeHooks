---
external help file: ClaudeHooks-help.xml
Module Name: ClaudeHooks
online version:
schema: 2.0.0
---

# Add-ClaudeHookConfig

## SYNOPSIS

Adds a hook entry to a Claude Code settings file.

## SYNTAX

### ScriptPath
```
Add-ClaudeHookConfig -Event <String> [-Matcher <String>] [-ScriptPath <String>] [-ArgumentList <String[]>]
 [-Shell <String>] [-Type <String>] [-Timeout <Int32>] [-Scope <String>] [-Path <String>] [-Force] [-PassThru]
 [-ProgressAction <ActionPreference>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

### Command
```
Add-ClaudeHookConfig -Event <String> [-Matcher <String>] [-Command <String>] [-Shell <String>] [-Type <String>]
 [-Timeout <Int32>] [-Scope <String>] [-Path <String>] [-Force] [-PassThru]
 [-ProgressAction <ActionPreference>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION

Inserts a hook definition under the specified event and matcher in the target
settings file.
Supports user, project, local, and plugin scopes.
Idempotent: if the same (Event, Matcher, Type, Command/ScriptPath, Shell) tuple
already exists, does nothing unless -Force is specified.
Uses -ScriptPath for safely-quoted invocations; -Command for raw shell strings
(caller is responsible for correct quoting).

## EXAMPLES

### EXAMPLE 1

```
Add-ClaudeHookConfig -Event PreToolUse -Matcher Bash `
    -ScriptPath '~/.claude/hooks/track-bash.ps1' -Scope User
```

Registers a PreToolUse hook for Bash commands in the user settings using a safe quoted path.

### EXAMPLE 2

```
# Raw command (escape hatch - caller handles quoting)
Add-ClaudeHookConfig -Event Stop -Matcher '' `
    -Command 'pwsh -File "C:\hooks\on-stop.ps1"' -Scope Project
```

Registers a Stop hook using a raw command string in the project settings file.

## PARAMETERS

### -Event

The Claude Code hook event name (e.g. 'PreToolUse', 'Stop').

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Matcher

The matcher string for the event (e.g.
'Bash', 'Edit|Write').

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ScriptPath

Path to a PowerShell script.
Generates a safely-quoted pwsh invocation.
Use this instead of -Command for script paths.

```yaml
Type: String
Parameter Sets: ScriptPath
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ArgumentList

Arguments to pass to the script specified in -ScriptPath.

```yaml
Type: String[]
Parameter Sets: ScriptPath
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Command

Raw shell command string written verbatim to the settings file.
Caller is responsible for correct quoting.
Trust boundary: do not build
this from untrusted input.

```yaml
Type: String
Parameter Sets: Command
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Shell

Shell to use for command hooks: 'powershell' or 'bash'.
Default: 'powershell'.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: Powershell
Accept pipeline input: False
Accept wildcard characters: False
```

### -Type

Hook type.
One of: command, http, McpTool (-> mcp_tool), prompt, agent.
Default: 'command'.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: Command
Accept pipeline input: False
Accept wildcard characters: False
```

### -Timeout

Hook timeout in seconds.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -Scope

Target settings file: User, Project, Local, or Plugin.
Default: User.
Plugin requires -Path.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: User
Accept pipeline input: False
Accept wildcard characters: False
```

### -Path

Full path to the settings file.
Required when -Scope is Plugin.
Optional override for other scopes.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Force

Overwrites an existing entry with the same (Event, Matcher, Command/ScriptPath) tuple.

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

### -PassThru

Returns the resulting hook entries for the target file after the write.

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

### None. Use -PassThru to return the resulting hooks block

## NOTES

## RELATED LINKS

[about_ClaudeHooks]()

[https://code.claude.com/docs/en/hooks.md](https://code.claude.com/docs/en/hooks.md)
