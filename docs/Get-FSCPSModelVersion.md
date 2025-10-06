---
external help file: fscps.tools-help.xml
Module Name: fscps.tools
online version:
schema: 2.0.0
---

# Get-FSCPSModelVersion

## SYNOPSIS
This gets the D365FSC model version

## SYNTAX

```
Get-FSCPSModelVersion [-ModelPath] <String> [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
This gets the D365FSC model version from the descriptor file by automatically finding the descriptor in the model path

## EXAMPLES

### EXAMPLE 1
```
Get-FSCPSModelVersion -ModelPath "c:\temp\metadata\TestModel"
```

This will get the version information of the TestModel by automatically finding the descriptor file

### EXAMPLE 2
```
Get-FSCPSModelVersion -ModelPath "c:\temp\PackagesLocalDirectory\MyCustomModel"
```

This will get the version information of MyCustomModel including layer name

## PARAMETERS

### -ModelPath
Path to the model folder (automatically searches for Descriptor\*.xml inside)

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

## NOTES
Tags: D365, FO, Finance, Operations, Model, Version, Descriptor, Metadata

Author: Oleksandr Nikolaiev (@onikolaiev)

## RELATED LINKS
