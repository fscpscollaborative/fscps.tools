---
external help file: fscps.tools-help.xml
Module Name: fscps.tools
online version:
schema: 2.0.0
---

# Get-FSCPSAzureStorageFile

## SYNOPSIS
Get a file from Azure

## SYNTAX

### Default (Default)
```
Get-FSCPSAzureStorageFile [-AccountId <String>] [-AccessToken <String>] [-SAS <String>] [-Container <String>]
 [-Name <String>] [-DestinationPath <String>] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### Latest
```
Get-FSCPSAzureStorageFile [-AccountId <String>] [-AccessToken <String>] [-SAS <String>] [-Container <String>]
 [-DestinationPath <String>] [-Latest] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
Get all files from an Azure Storage Account

## EXAMPLES

### EXAMPLE 1
```
Get-FSCPSAzureStorageFile -AccountId "miscfiles" -AccessToken "xx508xx63817x752xx74004x30705xx92x58349x5x78f5xx34xxxxx51" -Container "backupfiles"
```

This will get the information of all files in the blob container "backupfiles".
It will use the AccessToken "xx508xx63817x752xx74004x30705xx92x58349x5x78f5xx34xxxxx51" to gain access.

### EXAMPLE 2
```
Get-FSCPSAzureStorageFile -AccountId "miscfiles" -AccessToken "xx508xx63817x752xx74004x30705xx92x58349x5x78f5xx34xxxxx51" -Container "backupfiles" -Latest
```

This will get the information of the latest (newest) file from the blob container "backupfiles".
It will use the AccessToken "xx508xx63817x752xx74004x30705xx92x58349x5x78f5xx34xxxxx51" to gain access to the container.

### EXAMPLE 3
```
Get-FSCPSAzureStorageFile -AccountId "miscfiles" -AccessToken "xx508xx63817x752xx74004x30705xx92x58349x5x78f5xx34xxxxx51" -Container "backupfiles" -Name "*UAT*"
```

This will get the information of all files in the blob container "backupfiles" that fits the "*UAT*" search value.
It will use the AccessToken "xx508xx63817x752xx74004x30705xx92x58349x5x78f5xx34xxxxx51" to gain access to the container.

### EXAMPLE 4
```
Get-FSCPSAzureStorageFile -AccountId "miscfiles" -SAS "sv2018-03-28&siunlisted&src&sigAUOpdsfpoWE976ASDhfjkasdf(5678sdfhk" -Container "backupfiles" -Latest
```

This will get the information of the latest (newest) file from the blob container "backupfiles".
It will use the SAS key "sv2018-03-28&siunlisted&src&sigAUOpdsfpoWE976ASDhfjkasdf(5678sdfhk" to gain access to the container.

### EXAMPLE 5
```
Get-FSCPSAzureStorageFile -AccountId "miscfiles" -SAS "sv2018-03-28&siunlisted&src&sigAUOpdsfpoWE976ASDhfjkasdf(5678sdfhk" -Container "backupfiles" -Name "*UAT*" -DestinationPath "C:\Temp"
```

This will get the information of all files in the blob container "backupfiles" that fits the "*UAT*" search value.
It will also download all the files to the "C:\Temp" folder.
It will use the SAS key "sv2018-03-28&siunlisted&src&sigAUOpdsfpoWE976ASDhfjkasdf(5678sdfhk" to gain access to the container.

## PARAMETERS

### -AccountId
Storage Account Name / Storage Account Id where you want to look for files

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
The token that has the needed permissions for the search action

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
Name of the blob container inside the storage account where you want to look for files

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

### -Name
Name of the file you are looking for

Accepts wildcards for searching.
E.g.
-Name "Application*Adaptor"

Default value is "*" which will search for all files

```yaml
Type: String
Parameter Sets: Default
Aliases: FileName

Required: False
Position: Named
Default value: *
Accept pipeline input: False
Accept wildcard characters: False
```

### -DestinationPath
The destination folder of the Azure file to download.
If empty just show the file information

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

### -Latest
Instruct the cmdlet to only fetch the latest file from the Azure Storage Account

```yaml
Type: SwitchParameter
Parameter Sets: Latest
Aliases: GetLatest

Required: True
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
Tags: Azure, Azure Storage, Token, Blob, File, Container

This is a wrapper for the d365fo.tools functions Get-D365AzureStorageFile and Invoke-D365AzureStorageDownload to enable both retrieving file information from an Azure Storage Account and donwloading the files.

Author: Oleksandr Nikolaiev (@onikolaiev)
Author: Florian Hopfner (@FH-Inway)

## RELATED LINKS
