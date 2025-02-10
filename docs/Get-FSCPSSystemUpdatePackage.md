---
external help file: fscps.tools-help.xml
Module Name: fscps.tools
online version:
schema: 2.0.0
---

# Get-FSCPSSystemUpdatePackage

## SYNOPSIS
Downloads a system update package for D365FSC.

## SYNTAX

```
Get-FSCPSSystemUpdatePackage [[-UpdateType] <UpdateType>] [[-D365FSCVersion] <String>] [[-OutputPath] <String>]
 [[-StorageAccountConfig] <String>] [-Force] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
The \`Get-FSCPSSystemUpdatePackage\` function downloads a system update package for Dynamics 365 Finance and Supply Chain (D365FSC) based on the specified update type and version.
The package is downloaded from Azure Storage using the specified storage account configuration and saved to the specified output path.

## EXAMPLES

### EXAMPLE 1
```
Get-FSCPSSystemUpdatePackage -UpdateType SystemUpdate -D365FSCVersion "10.0.40" -OutputPath "C:\Packages\"
```

Downloads the system update package for version 10.0.40 and saves it to "C:\Packages\".

## PARAMETERS

### -UpdateType
Specifies the type of update package to download.
Valid values are "SystemUpdate" and "Preview".

```yaml
Type: UpdateType
Parameter Sets: (All)
Aliases:
Accepted values: SystemUpdate, Preview, FinalQualityUpdate, ProactiveQualityUpdate

Required: False
Position: 1
Default value: SystemUpdate
Accept pipeline input: False
Accept wildcard characters: False
```

### -D365FSCVersion
Specifies the version of the D365FSC package to download.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -OutputPath
Specifies the path where the downloaded package will be saved.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -StorageAccountConfig
Specifies the storage account configuration to use.
Default is "PackageStorage".

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: PackageStorage
Accept pipeline input: False
Accept wildcard characters: False
```

### -Force
Forces the operation to proceed without prompting for confirmation.

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
Uses the \`Get-FSCPSAzureStorageFile\` function to download the package from Azure Storage.

## RELATED LINKS
