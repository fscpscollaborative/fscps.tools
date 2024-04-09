---
external help file: fscps.tools-help.xml
Module Name: fscps.tools
online version:
schema: 2.0.0
---

# Get-FSCPSSettings

## SYNOPSIS
Get the FSCPS configuration details

## SYNTAX

```
Get-FSCPSSettings [[-RepositoryRootPath] <String>] [-OutputAsHashtable] [-ProgressAction <ActionPreference>]
 [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Get the FSCPS configuration details from the configuration store

All settings retrieved from this cmdlets is to be considered the default parameter values across the different cmdlets

## EXAMPLES

### EXAMPLE 1
```
Get-FSCPSSettings
```

This will output the current FSCPS configuration.
The object returned will be a PSCustomObject.

### EXAMPLE 2
```
Get-FSCPSSettings -OutputAsHashtable
```

This will output the current FSCPS configuration.
The object returned will be a Hashtable.

## PARAMETERS

### -RepositoryRootPath
Set root path of the project folder

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

### -OutputAsHashtable
Instruct the cmdlet to return a hashtable object

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

### System.Collections.Specialized.OrderedDictionary
## NOTES
Tags: Environment, Url, Config, Configuration, LCS, Upload, ClientId

Author: Oleksandr Nikolaiev (@onikolaiev)

## RELATED LINKS

[Set-FSCPSSettings]()

