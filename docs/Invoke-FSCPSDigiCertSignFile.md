---
external help file: fscps.tools-help.xml
Module Name: fscps.tools
online version:
schema: 2.0.0
---

# Invoke-FSCPSDigiCertSignFile

## SYNOPSIS
Function to sign the files with digicert

## SYNTAX

```
Invoke-FSCPSDigiCertSignFile [[-SM_HOST] <String>] [-SM_API_KEY] <String> [[-SM_CLIENT_CERT_FILE] <String>]
 [[-SM_CLIENT_CERT_FILE_URL] <String>] [-SM_CLIENT_CERT_PASSWORD] <SecureString>
 [-SM_CODE_SIGNING_CERT_SHA1_HASH] <String> [-FILE] <String> [-ProgressAction <ActionPreference>]
 [<CommonParameters>]
```

## DESCRIPTION
Function to sign the files with digicert

## EXAMPLES

### EXAMPLE 1
```
Invoke-FSCPSDigiCertSignFile -SM_API_KEY "$codeSignDigiCertAPISecretName" `
    -SM_CLIENT_CERT_FILE_URL "$codeSignDigiCertUrlSecretName" `
    -SM_CLIENT_CERT_PASSWORD $(ConvertTo-SecureString $codeSignDigiCertPasswordSecretName -AsPlainText -Force) `
    -SM_CODE_SIGNING_CERT_SHA1_HASH "$codeSignDigiCertHashSecretName" `
    -FILE "$filePath"
```

This will sign the target file with the DigiCert certificate

## PARAMETERS

### -SM_HOST
Digicert host URL.
Default value "https://clientauth.one.digicert.com"

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: Https://clientauth.one.digicert.com
Accept pipeline input: False
Accept wildcard characters: False
```

### -SM_API_KEY
The DigiCert API Key

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

### -SM_CLIENT_CERT_FILE
The DigiCert certificate local path (p12)

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: C:\temp\digicert.p12
Accept pipeline input: False
Accept wildcard characters: False
```

### -SM_CLIENT_CERT_FILE_URL
The DigiCert certificate URL (p12)

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

### -SM_CLIENT_CERT_PASSWORD
The DigiCert certificate password

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

### -SM_CODE_SIGNING_CERT_SHA1_HASH
The DigiCert certificate thumbprint(fingerprint)

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 6
Default value: None
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
