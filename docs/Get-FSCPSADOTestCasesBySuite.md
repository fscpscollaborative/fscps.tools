---
external help file: fscps.tools-help.xml
Module Name: fscps.tools
online version:
schema: 2.0.0
---

# Get-FSCPSADOTestCasesBySuite

## SYNOPSIS
Retrieves the test cases in a specified test suite from Azure DevOps.

## SYNTAX

```
Get-FSCPSADOTestCasesBySuite [[-TestSuiteId] <Int32>] [[-TestPlanId] <Int32>] [[-Organization] <String>]
 [[-Project] <String>] [[-Token] <String>] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
This function constructs a URL to access the test cases within a specific test suite in Azure DevOps.
It sends a GET request to the Azure DevOps API and retrieves the test cases in the specified test suite.
The function returns the test cases.

## EXAMPLES

### EXAMPLE 1
```
$testSuiteId = 5261
$testPlanId = 6
$project = "MyProject"
$organization = "https://dev.azure.com/dev-inc"
$token = "Bearer your_access_token"
```

$testCases = Get-FSCPSADOTestCasesBySuite -TestSuiteId $testSuiteId -TestPlanId $testPlanId -Project $project -Organization $organization -Token $token
Write-Output $testCases

## PARAMETERS

### -TestSuiteId
The ID of the test suite.

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
The ID of the test plan.

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

### -Token
The authorization token for accessing the Azure DevOps API.

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
Ensure you have the correct permissions and valid access token in the authorization header.
The function assumes the Azure DevOps API is available and accessible from the environment where the script is executed.

## RELATED LINKS
