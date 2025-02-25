---
external help file: fscps.tools-help.xml
Module Name: fscps.tools
online version:
schema: 2.0.0
---

# Get-FSCPSADOTestSuitesByTestPlan

## SYNOPSIS
Retrieves test suites from an Azure DevOps test plan.

## SYNTAX

```
Get-FSCPSADOTestSuitesByTestPlan [[-Organization] <String>] [[-Project] <String>] [[-TestPlanId] <Int32>]
 [[-Token] <String>] [[-apiVersion] <String>] [[-continuationToken] <String>]
```

## DESCRIPTION
The \`Get-FSCPSADOTestSuitesByTestPlan\` function retrieves test suites from a specified Azure DevOps test plan.
It requires the organization, project, test plan ID, and a valid authentication token.
The function handles
pagination through the use of a continuation token and returns the test suites along with the new continuation token.

## EXAMPLES

### EXAMPLE 1
```
Get-FSCPSADOTestSuitesByTestPlan -Organization "my-org" -Project "my-project" -TestPlanId 123 -Token "Bearer my-token"
```

This example retrieves test suites from the test plan with ID 123 in the specified organization and project.

## PARAMETERS

### -Organization
The name of the Azure DevOps organization.

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

### -TestPlanId
The ID of the test plan from which to retrieve test suites.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: 0
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
Position: 4
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
Position: 5
Default value: 7.1
Accept pipeline input: False
Accept wildcard characters: False
```

### -continuationToken
The continuation token for pagination.
Default is $null.

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

## INPUTS

## OUTPUTS

## NOTES
- The function uses the Azure DevOps REST API to retrieve test suites.
- An authentication token is required.
- Handles pagination through continuation tokens.

Author: Oleksandr Nikolaiev (@onikolaiev)

## RELATED LINKS
