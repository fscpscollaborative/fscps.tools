---
external help file: fscps.tools-help.xml
Module Name: fscps.tools
online version:
schema: 2.0.0
---

# Install-FSCPSSoftware

## SYNOPSIS
Install software from Choco

## SYNTAX

```
Install-FSCPSSoftware [-Name] <String[]> [-Force] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
Installs software from Chocolatey

Full list of software: https://community.chocolatey.org/packages

## EXAMPLES

### EXAMPLE 1
```
Install-FSCPSSoftware -Name vscode
```

This will install VSCode on the system.

### EXAMPLE 2
```
Install-FSCPSSoftware -Name vscode -Force
```

This will install VSCode on the system, forcing it to be (re)installed.

### EXAMPLE 3
```
Install-FSCPSSoftware -Name "vscode","fiddler"
```

This will install VSCode and fiddler on the system.

## PARAMETERS

### -Name
The name of the software to install

Support a list of softwares that you want to have installed on the system

```yaml
Type: String[]
Parameter Sets: (All)
Aliases: SoftwareName

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Force
Instruct the cmdlet to install the latest version of the software, regardless if it is already present on the system

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
Author: Oleksandr Nikolaiev (@onikolaiev)

## RELATED LINKS
