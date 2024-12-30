---
external help file: fscps.tools-help.xml
Module Name: fscps.tools
online version:
schema: 2.0.0
---

# Update-FSCPSNugetsFromLCS

## SYNOPSIS
This uploads the D365FSC nugets from the LCS to the active storage account

## SYNTAX

```
Update-FSCPSNugetsFromLCS [[-LCSUserName] <String>] [[-LCSUserPassword] <SecureString>]
 [[-LCSProjectId] <String>] [[-LCSClientId] <String>] [[-FSCMinimumVersion] <String>]
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
This uploads the D365FSC nugets from the LCS to the active NuGet storage account

## EXAMPLES

### EXAMPLE 1
```
Update-FSCPSNugetsFromLCS -LCSUserName "admin@contoso.com" -LCSUserPassword "superSecureString" -LCSProjectId "123456" -LCSClientId "123ebf68-a86d-4392-ae38-57b2172ee789" -FSCMinimumVersion "10.0.38"
```

this will uploads the D365FSC nugets from the LCS to the active storage account

## PARAMETERS

### -LCSUserName
The LCS username

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

### -LCSUserPassword
The LCS password

```yaml
Type: SecureString
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -LCSProjectId
The LCS project ID

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

### -LCSClientId
The ClientId what has access to the LCS

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

### -FSCMinimumVersion
The minimum version of the FSC to update the NuGet\`s

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 5
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
