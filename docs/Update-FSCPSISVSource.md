---
external help file: fscps.tools-help.xml
Module Name: fscps.tools
online version:
schema: 2.0.0
---

# Update-FSCPSISVSource

## SYNOPSIS
Installation of Nuget CLI

## SYNTAX

```
Update-FSCPSISVSource [-MetadataPath] <String> [-Url] <String> [[-FileName] <String>]
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
Download latest Nuget CLI

## EXAMPLES

### EXAMPLE 1
```
Update-FSCPSISVSource MetadataPath "C:\temp\PackagesLocalDirectory" -Url "https://ciellosarchive.blob.core.windows.net/test/Main-Extension-10.0.39_20240516.263.zip?sv=2023-01-03&st=2024-05-21T14%3A26%3A41Z&se=2034-05-22T14%3A26%3A00Z&sr=b&sp=r&sig=W%2FbS1bQrr59i%2FBSHWsftkfNsE1HvFXTrICwZSFiUItg%3D""
```

This will update the local metadata with the source from the downloaded zip archive.

## PARAMETERS

### -MetadataPath
Path to the local Metadata folder

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Url
Url/Uri to zip file contains code/package/axmodel

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

### -FileName
The name of the file should be downloaded by the url.
Use if the url doesnt contain the filename.

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
