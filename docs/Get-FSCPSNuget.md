---
external help file: fscps.tools-help.xml
Module Name: fscps.tools
online version:
schema: 2.0.0
---

# Get-FSCPSNuget

## SYNOPSIS
Get the D365FSC NuGet package

## SYNTAX

### Version (Default)
```
Get-FSCPSNuget -Version <String> -Type <NuGetType> [-Path <String>] [-Force]
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### KnownVersion
```
Get-FSCPSNuget -KnownVersion <String> -KnownType <VersionStrategy> -Type <NuGetType> [-Path <String>] [-Force]
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
Get the D365FSC NuGet package from storage account

Full list of NuGet: https://lcs.dynamics.com/V2/SharedAssetLibrary and select NuGet packages

## EXAMPLES

### EXAMPLE 1
```
Get-FSCPSNuget -Version "10.0.1777.99" -Type PlatformCompilerPackage
```

This will download the NuGet package with version "10.0.1777.99" and type "PlatformCompilerPackage" to the current folder

### EXAMPLE 2
```
Get-FSCPSNuget -Version "10.0.1777.99" -Type PlatformCompilerPackage -Path "c:\temp"
```

This will download the NuGet package with version "10.0.1777.99" and type "PlatformCompilerPackage" to the c:\temp folder

### EXAMPLE 3
```
Get-FSCPSNuget -Version "10.0.1777.99" -Type PlatformCompilerPackage -Path "c:\temp" -Force
```

This will download the NuGet package with version "10.0.1777.99" and type "PlatformCompilerPackage" to the c:\temp folder and override if the package with the same name exists.

### EXAMPLE 4
```
Get-FSCPSNuget -KnownVersion "10.0.45" -KnownType GA -Type PlatformCompilerPackage -Path "c:\temp"
```

This will resolve the GA platform version for FNO 10.0.45 and download the PlatformCompilerPackage NuGet to c:\temp

### EXAMPLE 5
```
Get-FSCPSNuget -KnownVersion "10.0.45" -KnownType Latest -Type ApplicationDevALM -Path "c:\temp"
```

This will resolve the Latest application version for FNO 10.0.45 and download the ApplicationDevALM NuGet to c:\temp

## PARAMETERS

### -Version
The version of the NuGet package to download

```yaml
Type: String
Parameter Sets: Version
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -KnownVersion
The short FNO version (e.g.
"10.0.45").
The actual NuGet version will be resolved using the version info data and the KnownType parameter

```yaml
Type: String
Parameter Sets: KnownVersion
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -KnownType
The version strategy to use when resolving KnownVersion.
Valid values are GA and Latest

```yaml
Type: VersionStrategy
Parameter Sets: KnownVersion
Aliases:
Accepted values: GA, Latest

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Type
The type of the NuGet package to download

```yaml
Type: NuGetType
Parameter Sets: (All)
Aliases:
Accepted values: ApplicationSuiteDevALM, ApplicationDevALM, PlatformDevALM, PlatformCompilerPackage

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Path
The destination folder of the NuGet package to download

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
Instruct the cmdlet to override the package if exists

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

### System.Collections.Hashtable
## NOTES
Author: Oleksandr Nikolaiev (@onikolaiev)

## RELATED LINKS
