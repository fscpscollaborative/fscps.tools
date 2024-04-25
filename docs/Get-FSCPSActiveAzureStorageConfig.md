---
external help file: fscps.tools-help.xml
Module Name: fscps.tools
online version:
schema: 2.0.0
---

# Get-FSCPSActiveAzureStorageConfig

## SYNOPSIS
Get active Azure Storage Account configuration

## SYNTAX

```
Get-FSCPSActiveAzureStorageConfig [-OutputAsPsCustomObject] [-ProgressAction <ActionPreference>]
 [<CommonParameters>]
```

## DESCRIPTION
Get active Azure Storage Account configuration object from the configuration store

## EXAMPLES

### EXAMPLE 1
```
Get-FSCPSActiveAzureStorageConfig
```

This will get the active Azure Storage configuration.

### EXAMPLE 2
```
Get-FSCPSActiveAzureStorageConfig -OutputAsPsCustomObject:$true
```

This will get the active Azure Storage configuration.
The object will be output as a PsCustomObject, for you to utilize across your scripts.

## PARAMETERS

### -OutputAsPsCustomObject
Instruct the cmdlet to return a PsCustomObject object

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

## NOTES
Tags: Azure, Azure Storage, Config, Configuration, Token, Blob, Container

This is refactored function from d365fo.tools

Original Author: Mötz Jensen (@Splaxi)
Author: Oleksandr Nikolaiev (@onikolaiev)

## RELATED LINKS
