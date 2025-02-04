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
 [-Latest] [-ProgressAction <ActionPreference>] [<CommonParameters>]
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
Parameter Sets: Default
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

This is refactored function from d365fo.tools (https://github.com/d365collaborative/d365fo.tools) under the
MIT License

Copyright (c) 2018 Mötz Jensen & Rasmus Andersen

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.

Original Author: Mötz Jensen (@Splaxi)
Author: Oleksandr Nikolaiev (@onikolaiev)

## RELATED LINKS
