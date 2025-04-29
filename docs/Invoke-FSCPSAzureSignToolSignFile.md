---
external help file: fscps.tools-help.xml
Module Name: fscps.tools
online version:
schema: 2.0.0
---

# Invoke-FSCPSAzureSignToolSignFile

## SYNOPSIS
Function to sign the files with KeyVault

## SYNTAX

```
Invoke-FSCPSAzureSignToolSignFile [[-Uri] <String>] [-TenantId] <String> [[-CertificateName] <String>]
 [[-ClientId] <String>] [-ClientSecret] <SecureString> [-TimestampServer] <String> [-FILE] <String>
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
Function to sign the files with KeyVault

## EXAMPLES

### EXAMPLE 1
```
Invoke-FSCPSAzureSignToolSignFile -Uri "https://my-vault.vault.azure.net" `
    -TenantId "01234567-abcd-ef012-0000-0123456789ab" `
    -CertificateName "my-key-name" `
    -ClientId "01234567-abcd-ef012-0000-0123456789ab" `
    -ClientSecret "secret" `
    -FILE "$filePath"
```

This will sign the target file with the KeyVault certificate

## PARAMETERS

### -Uri
A fully qualified URL of the key vault with the certificate that will be used for signing.
An example value might be https://my-vault.vault.azure.net.

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

### -TenantId
This is the tenant id used to authenticate to Azure, which will be used to generate an access token.

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

### -CertificateName
The name of the certificate used to perform the signing operation.

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

### -ClientId
This is the client ID used to authenticate to Azure, which will be used to generate an access token.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ClientSecret
This is the client secret used to authenticate to Azure, which will be used to generate an access token.

```yaml
Type: SecureString
Parameter Sets: (All)
Aliases:

Required: True
Position: 5
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -TimestampServer
A URL to an RFC3161 compliant timestamping service.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 6
Default value: Http://timestamp.digicert.com
Accept pipeline input: False
Accept wildcard characters: False
```

### -FILE
A file to sign

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 7
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
