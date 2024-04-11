---
external help file: fscps.tools-help.xml
Module Name: fscps.tools
online version:
schema: 2.0.0
---

# Disable-FSCPSException

## SYNOPSIS
Disables throwing of exceptions

## SYNTAX

```
Disable-FSCPSException [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
Restore the default exception behavior of the module to not support throwing exceptions

Useful when the default behavior was changed with Enable-FSCPSException and the default behavior should be restored

## EXAMPLES

### EXAMPLE 1
```
Disable-FSCPSException
```

This will restore the default behavior of the module to not support throwing exceptions.

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

Original Author: Florian Hopfner (@FH-Inway)
Author: Oleksandr Nikolaiev (@onikolaiev)

## RELATED LINKS

[Enable-FSCPSException]()

