---
external help file: fscps.tools-help.xml
Module Name: fscps.tools
online version:
schema: 2.0.0
---

# Get-FSCPSADOTestSuiteByTestCase

## SYNOPSIS
Retrieves the test suite associated with a specific test case from Azure DevOps.

## SYNTAX

```
Get-FSCPSADOTestSuiteByTestCase [[-TestCaseId] <Int32>] [[-Project] <String>] [[-Organization] <String>]
 [[-apiVersion] <String>] [[-Token] <String>] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
The \`Get-FSCPSADOTestSuiteByTestCase\` function retrieves the test suite associated with a specified test case ID from Azure DevOps.
It requires the organization, project, test case ID, and a valid authentication token.
The function returns the test suite information
and handles any errors that may occur during the request.

## EXAMPLES

### EXAMPLE 1
```
Get-FSCPSADOTestSuiteByTestCase -TestCaseId 1460 -Project "my-project" -Organization "my-org" -Token "Bearer my-token"
```

This example retrieves the test suite associated with the test case ID 1460 in the specified organization and project.

## PARAMETERS

### -TestCaseId
The ID of the test case for which to retrieve the associated test suite.

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
Default is "5.0".

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: 5.0
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
- The function uses the Azure DevOps REST API to retrieve the test suite.
- An authentication token is required.
- Handles errors and interruptions gracefully.

## RELATED LINKS
