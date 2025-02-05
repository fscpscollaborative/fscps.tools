---
external help file: fscps.tools-help.xml
Module Name: fscps.tools
online version:
schema: 2.0.0
---

# Get-FSCPSADOTestCase

## SYNOPSIS
Retrieves information about a specific test case from Azure DevOps.

## SYNTAX

```
Get-FSCPSADOTestCase [[-TestCaseId] <Int32>] [[-Project] <String>] [[-Organization] <String>]
 [[-apiVersion] <String>] [[-Token] <String>] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
The \`Get-FSCPSADOTestCase\` function retrieves detailed information about a specified test case from Azure DevOps.
It requires the organization, project, test case ID, and a valid authentication token.
The function constructs
the appropriate URL, makes the REST API call, and returns the fields of the test case.
It also handles errors
and interruptions gracefully.

## EXAMPLES

### EXAMPLE 1
```
Get-FSCPSADOTestCase -TestCaseId 1234 -Project "my-project" -Organization "my-org" -Token "Bearer my-token"
```

This example retrieves detailed information about the test case with ID 1234 in the specified organization and project.

## PARAMETERS

### -TestCaseId
The ID of the test case to retrieve information for.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -Project
The name of the Azure DevOps project.

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

### -Organization
The name of the Azure DevOps organization.
If not in the form of a URL, it will be prefixed with "https://dev.azure.com/".

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

### -apiVersion
The version of the Azure DevOps REST API to use.
Default is "7.1".

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: 7.1
Accept pipeline input: False
Accept wildcard characters: False
```

### -Token
The authentication token for accessing Azure DevOps.

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

### System.Collections.Hashtable
## NOTES
- The function uses the Azure DevOps REST API to retrieve test case information.
- An authentication token is required.
- Handles errors and interruptions gracefully.

## RELATED LINKS
