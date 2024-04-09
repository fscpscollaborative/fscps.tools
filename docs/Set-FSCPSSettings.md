---
external help file: fscps.tools-help.xml
Module Name: fscps.tools
online version:
schema: 2.0.0
---

# Set-FSCPSSettings

## SYNOPSIS
Get the FSCPS configuration details

## SYNTAX

```
Set-FSCPSSettings [[-SettingsFilePath] <String>] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
Get the FSCPS configuration details from the configuration store

All settings retrieved from this cmdlets is to be considered the default parameter values across the different cmdlets

## EXAMPLES

### EXAMPLE 1
```
Set-FSCPSSettings -SettingsFilePath "c:\temp\settings.json"
```

This will output the current FSCPS configuration.
The object returned will be a Hashtable.

## PARAMETERS

### -SettingsFilePath
Set path to the settings.json file

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

### System.Collections.Specialized.OrderedDictionary
## NOTES
Tags: Environment, Url, Config, Configuration, Upload, ClientId, Settings

Author: Oleksandr Nikolaiev (@onikolaiev)

## RELATED LINKS

[Get-FSCPSSettings]()

