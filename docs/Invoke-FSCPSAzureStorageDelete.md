---
external help file: fscps.tools-help.xml
Module Name: fscps.tools
online version:
schema: 2.0.0
---

# Invoke-FSCPSAzureStorageDelete

## SYNOPSIS
Delete a file to Azure

## SYNTAX

### Default (Default)
```
Invoke-FSCPSAzureStorageDelete [-AccountId <String>] [-AccessToken <String>] [-SAS <String>]
 [-Container <String>] -FileName <String> [-Force] [-EnableException] [-ProgressAction <ActionPreference>]
 [<CommonParameters>]
```

### Pipeline
```
Invoke-FSCPSAzureStorageDelete [-AccountId <String>] [-AccessToken <String>] [-SAS <String>]
 [-Container <String>] -FileName <String> [-Force] [-EnableException] [-ProgressAction <ActionPreference>]
 [<CommonParameters>]
```

## DESCRIPTION
Delete any file to an Azure Storage Account

## EXAMPLES

### EXAMPLE 1
```
$AzureParams = Get-FSCActiveAzureStorageConfig
PS C:\> New-D365Bacpac | Invoke-FSCPSAzureStorageDelete @AzureParams
```

This will get the current Azure Storage Account configuration details and use them as parameters to delete the file from Azure Storage Account.

### EXAMPLE 2
```
Invoke-FSCPSAzureStorageDelete -AccountId "miscfiles" -SAS "sv2018-03-28&siunlisted&src&sigAUOpdsfpoWE976ASDhfjkasdf(5678sdfhk" -Container "backupfiles" -FileName "UAT_20180701.bacpac"
```

This will delete the "UAT_20180701.bacpac" from the "backupfiles" container, inside the "miscfiles" Azure Storage Account.
A SAS key is used to gain access to the container and deleteng the file.

## PARAMETERS

### -AccountId
Storage Account Name / Storage Account Id where you want to store the file

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
The token that has the needed permissions for the delete action

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
Name of the blob container inside the storage account you want to store the file

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
Path to the file you want to delete

```yaml
Type: String
Parameter Sets: Default
Aliases: File

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

```yaml
Type: String
Parameter Sets: Pipeline
Aliases: File

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -Force
Instruct the cmdlet to overwrite the file in the container if it already exists

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
Tags: Azure, Azure Storage, Config, Configuration, Token, Blob, File, Files, Bacpac, Container
Author: Oleksandr Nikolaiev (@onikolaiev)

The cmdlet supports piping and can be used in advanced scenarios.
See more on github and the wiki pages.

## RELATED LINKS
