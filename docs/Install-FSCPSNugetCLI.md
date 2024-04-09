---
external help file: fscps.tools-help.xml
Module Name: fscps.tools
online version:
schema: 2.0.0
---

# Install-FSCPSNugetCLI

## SYNOPSIS
Installation of Nuget CLI

## SYNTAX

```
Install-FSCPSNugetCLI [[-Path] <String>] [[-Url] <String>] [-ProgressAction <ActionPreference>]
 [<CommonParameters>]
```

## DESCRIPTION
Download latest Nuget CLI

## EXAMPLES

### EXAMPLE 1
```
Install-FSCPSNugetCLI -Path "C:\temp\fscps.tools\nuget" -Url "https://dist.nuget.org/win-x86-commandline/latest/nuget.exe"
```

This will download the latest version of nuget.

## PARAMETERS

### -Path
Download destination

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: C:\temp\fscps.tools\nuget
Accept pipeline input: False
Accept wildcard characters: False
```

### -Url
Url/Uri to where the latest nuget download is located

The default value is "https://dist.nuget.org/win-x86-commandline/latest/nuget.exe"

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: Https://dist.nuget.org/win-x86-commandline/latest/nuget.exe
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
Author: Oleksandr Nikolaiev (@onikolaiev)

## RELATED LINKS
