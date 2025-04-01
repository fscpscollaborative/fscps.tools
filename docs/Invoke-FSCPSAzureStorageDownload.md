﻿---
external help file: fscps.tools-help.xml
Module Name: fscps.tools
online version:
schema: 2.0.0
---

# Invoke-FSCPSAzureStorageDownload

## SYNOPSIS
Download a file to Azure

## SYNTAX

### Default (Default)
```
Invoke-FSCPSAzureStorageDownload [-AccountId <String>] [-AccessToken <String>] [-SAS <String>]
 [-Container <String>] -FileName <String> [-Path <String>] [-Force] [-EnableException]
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### Latest
```
Invoke-FSCPSAzureStorageDownload [-AccountId <String>] [-AccessToken <String>] [-SAS <String>]
 [-Container <String>] [-Path <String>] [-Latest] [-Force] [-EnableException]
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
Download any file to an Azure Storage Account

## EXAMPLES

### EXAMPLE 1
```
Invoke-FSCPSAzureStorageDownload -AccountId "miscfiles" -AccessToken "xx508xx63817x752xx74004x30705xx92x58349x5x78f5xx34xxxxx51" -Container "backupfiles" -FileName "OriginalUAT.bacpac" -Path "c:\temp"
```

Will download the "OriginalUAT.bacpac" file from the storage account and save it to "c:\temp\OriginalUAT.bacpac"

### EXAMPLE 2
```
Invoke-FSCPSAzureStorageDownload -AccountId "miscfiles" -AccessToken "xx508xx63817x752xx74004x30705xx92x58349x5x78f5xx34xxxxx51" -Container "backupfiles" -Path "c:\temp" -Latest
```

Will download the file with the latest modified datetime from the storage account and save it to "c:\temp\".
The complete path to the file will returned as output from the cmdlet.

### EXAMPLE 3
```
$AzureParams = Get-FSCPSActiveAzureStorageConfig
PS C:\> Invoke-FSCPSAzureStorageDownload @AzureParams -Path "c:\temp" -Latest
```

This will get the current Azure Storage Account configuration details
and use them as parameters to download the latest file from an Azure Storage Account

Will download the file with the latest modified datetime from the storage account and save it to "c:\temp\".
The complete path to the file will returned as output from the cmdlet.

### EXAMPLE 4
```
Invoke-FSCPSAzureStorageDownload -Latest
```

This will use the default parameter values that are based on the configuration stored inside "Get-FSCPSActiveAzureStorageConfig".
Will download the file with the latest modified datetime from the storage account and save it to "c:\temp\fscps.tools".

### EXAMPLE 5
```
Invoke-FSCPSAzureStorageDownload -AccountId "miscfiles" -SAS "sv2018-03-28&siunlisted&src&sigAUOpdsfpoWE976ASDhfjkasdf(5678sdfhk" -Container "backupfiles" -Path "c:\temp" -Latest
```

Will download the file with the latest modified datetime from the storage account and save it to "c:\temp\".
A SAS key is used to gain access to the container and downloading the file from it.
The complete path to the file will returned as output from the cmdlet.

## PARAMETERS

### -AccountId
Storage Account Name / Storage Account Id where you want to fetch the file from

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: $Script:AzureStorageAccountId
Accept pipeline input: False
Accept wildcard characters: False
```

### -AccessToken
The token that has the needed permissions for the download action

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: $Script:AzureStorageAccessToken
Accept pipeline input: False
Accept wildcard characters: False
```

### -SAS
The SAS key that you have created for the storage account or blob container

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: $Script:AzureStorageSAS
Accept pipeline input: False
Accept wildcard characters: False
```

### -Container
Name of the blob container inside the storage account you where the file is

```yaml
Type: String
Parameter Sets: (All)
Aliases: Blobname, Blob

Required: False
Position: Named
Default value: $Script:AzureStorageContainer
Accept pipeline input: False
Accept wildcard characters: False
```

### -FileName
Name of the file that you want to download

```yaml
Type: String
Parameter Sets: Default
Aliases: Name

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Path
Path to the folder / location you want to save the file

The default path is "c:\temp\fscps.tools"

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: $Script:DefaultTempPath
Accept pipeline input: False
Accept wildcard characters: False
```

### -Latest
Instruct the cmdlet to download the latest file from Azure regardless of name

```yaml
Type: SwitchParameter
Parameter Sets: Latest
Aliases: GetLatest

Required: True
Position: 5
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -Force
Instruct the cmdlet to overwrite the local file if it already exists

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

### -EnableException
This parameters disables user-friendly warnings and enables the throwing of exceptions
This is less user friendly, but allows catching exceptions in calling scripts

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
Tags: Azure, Azure Storage, Config, Configuration, Token, Blob, File, Files, Latest, Bacpac, Container

This is a wrapper for the d365fo.tools function Invoke-D365AzureStorageDownload.

Author: Oleksandr Nikolaiev (@onikolaiev)
Author: Florian Hopfner (@FH-Inway)

The cmdlet supports piping and can be used in advanced scenarios.
See more on github and the wiki pages.

## RELATED LINKS
