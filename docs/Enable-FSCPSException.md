---
external help file: fscps.tools-help.xml
Module Name: fscps.tools
online version:
schema: 2.0.0
---

# Enable-FSCPSException

## SYNOPSIS
Enable exceptions to be thrown

## SYNTAX

```
Enable-FSCPSException [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
Change the default exception behavior of the module to support throwing exceptions

Useful when the module is used in an automated fashion, like inside Azure DevOps pipelines and large PowerShell scripts

## EXAMPLES

### EXAMPLE 1
```
Enable-FSCPSException
```

This will for the rest of the current PowerShell session make sure that exceptions will be thrown.

## PARAMETERS

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
Tags: Exception, Exceptions, Warning, Warnings
This is refactored function from d365fo.tools

Original Author: Mötz Jensen (@Splaxi)
Author: Oleksandr Nikolaiev (@onikolaiev)

## RELATED LINKS

[Disable-D365Exception]()

