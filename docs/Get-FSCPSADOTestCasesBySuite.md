---
external help file: fscps.tools-help.xml
Module Name: fscps.tools
online version:
schema: 2.0.0
---

# Get-FSCPSADOTestCasesBySuite

## SYNOPSIS
Retrieves test cases from a specified test suite in Azure DevOps.

## SYNTAX

```
Get-FSCPSADOTestCasesBySuite [[-TestSuiteId] <Int32>] [[-TestPlanId] <Int32>] [[-Organization] <String>]
 [[-Project] <String>] [[-apiVersion] <String>] [[-Token] <String>] [-ProgressAction <ActionPreference>]
 [<CommonParameters>]
```

## DESCRIPTION
The \`Get-FSCPSADOTestCasesBySuite\` function retrieves test cases from a specified test suite within a specified test plan
in an Azure DevOps project.
The function requires the organization, project, test suite ID, test plan ID, and a valid
authentication token.
It uses the Azure DevOps REST API to perform the operation and handles errors gracefully.

## EXAMPLES

### EXAMPLE 1
```
Get-FSCPSADOTestCasesBySuite -TestSuiteId 1001 -TestPlanId 2001 -Organization "my-org" -Project "my-project" -Token "Bearer my-token"
```

This example retrieves the test cases from the test suite with ID 1001 within the test plan with ID 2001 in the specified organization and project.

## PARAMETERS

### -TestSuiteId
The ID of the test suite from which to retrieve test cases.

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

### -TestPlanId
The ID of the test plan containing the test suite.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: 0
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

### -Project
The name of the Azure DevOps project.

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

### -apiVersion
The version of the Azure DevOps REST API to use.
Default is "6.0".

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 5
Default value: 6.0
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
Position: 6
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
- The function uses the Azure DevOps REST API to retrieve test cases.
- An authentication token is required.
- Handles errors and interruptions gracefully.
Author: Oleksandr Nikolaiev (@onikolaiev)

## RELATED LINKS
