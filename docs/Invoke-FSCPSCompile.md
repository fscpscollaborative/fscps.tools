---
external help file: fscps.tools-help.xml
Module Name: fscps.tools
online version:
schema: 2.0.0
---

# Invoke-FSCPSCompile

## SYNOPSIS
Invoke the D365FSC models compilation

## SYNTAX

```
Invoke-FSCPSCompile [[-Version] <String>] [-SourcesPath] <String> [[-Type] <FSCPSType>]
 [[-BuildFolderPath] <String>] [-OutputAsHashtable] [-Force] [-ProgressAction <ActionPreference>]
 [<CommonParameters>]
```

## DESCRIPTION
Invoke the D365FSC models compilation

## EXAMPLES

### EXAMPLE 1
```
Invoke-FSCPSCompile -Version "10.0.39" -Type FSCM
```

Example output:

METADATA_DIRECTORY  : D:\a\8\s\Metadata
FRAMEWORK_DIRECTORY : C:\temp\buildbuild\packages\Microsoft.Dynamics.AX.Platform.CompilerPackage.7.0.7120.99
BUILD_OUTPUT_DIRECTORY    : C:\temp\buildbuild\bin
SOLUTION_FOLDER   : C:\temp\buildbuild\10.0.39_build
NUGETS_FOLDER    : C:\temp\buildbuild\packages
BUILD_LOG_FILE_PATH     : C:\Users\VssAdministrator\AppData\Local\Temp\Build.sln.msbuild.log
PACKAGE_NAME         : MAIN TEST-DeployablePackage-10.0.39-78
PACKAGE_PATH         : C:\temp\buildbuild\artifacts\MAIN TEST-DeployablePackage-10.0.39-78.zip
ARTIFACTS_PATH       : C:\temp\buildbuild\artifacts
ARTIFACTS_LIST       : \["C:\temp\buildbuild\artifacts\MAIN TEST-DeployablePackage-10.0.39-78.zip"\]

This will build D365FSC package with version "10.0.39" to the Temp folder

### EXAMPLE 2
```
Invoke-FSCPSCompile -Version "10.0.39" -Path "c:\Temp"
```

Example output:

METADATA_DIRECTORY  : D:\a\8\s\Metadata
FRAMEWORK_DIRECTORY : C:\temp\buildbuild\packages\Microsoft.Dynamics.AX.Platform.CompilerPackage.7.0.7120.99
BUILD_OUTPUT_DIRECTORY    : C:\temp\buildbuild\bin
SOLUTION_FOLDER   : C:\temp\buildbuild\10.0.39_build
NUGETS_FOLDER    : C:\temp\buildbuild\packages
BUILD_LOG_FILE_PATH     : C:\Users\VssAdministrator\AppData\Local\Temp\Build.sln.msbuild.log
PACKAGE_NAME         : MAIN TEST-DeployablePackage-10.0.39-78
PACKAGE_PATH         : C:\temp\buildbuild\artifacts\MAIN TEST-DeployablePackage-10.0.39-78.zip
ARTIFACTS_PATH       : C:\temp\buildbuild\artifacts
ARTIFACTS_LIST       : \["C:\temp\buildbuild\artifacts\MAIN TEST-DeployablePackage-10.0.39-78.zip"\]

This will build D365FSC package with version "10.0.39" to the Temp folder

## PARAMETERS

### -Version
The version of the D365FSC used to build

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

### -SourcesPath
The folder contains a metadata files with binaries

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Type
The type of the FSCPS project to build

```yaml
Type: FSCPSType
Parameter Sets: (All)
Aliases:
Accepted values: FSCM, Commerce, ECommerce

Required: False
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -BuildFolderPath
The destination build folder

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: (Join-Path $script:DefaultTempPath _bld)
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

### -Force
Cleanup destination build folder befor build

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

### System.Collections.Specialized.OrderedDictionary
## NOTES
Author: Oleksandr Nikolaiev (@onikolaiev)

## RELATED LINKS
