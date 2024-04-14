---
external help file: fscps.tools-help.xml
Module Name: fscps.tools
online version:
schema: 2.0.0
---

# Update-FSCPSModelVersion

## SYNOPSIS
This updates the D365FSC model version

## SYNTAX

```
Update-FSCPSModelVersion [[-xppSourcePath] <String>] [[-xppDescriptorSearch] <String>] [[-xppLayer] <Object>]
 [[-versionNumber] <Object>] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
This updates the D365FSC model version

## EXAMPLES

### EXAMPLE 1
```
Update-FSCPSModelVersion -xppSourcePath "c:\temp\metadata" -xppLayer "ISV" -versionNumber "5.4.8.4" -xppDescriptorSearch $("TestModel"+"\Descriptor\*.xml")
```

this will change the version of the TestModel to 5.4.8.4

## PARAMETERS

### -xppSourcePath
Path to the xpp metadata folder

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

### -xppDescriptorSearch
Descriptor search pattern

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

### -xppLayer
Layer of the code

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -versionNumber
Target model version change to

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
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
