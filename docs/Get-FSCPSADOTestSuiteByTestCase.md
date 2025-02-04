---
external help file: fscps.tools-help.xml
Module Name: fscps.tools
online version:
schema: 2.0.0
---

# Get-FSCPSADOTestSuiteByTestCase

## SYNOPSIS
Retrieves the test suite ID and name for a given test case from Azure DevOps.

## SYNTAX

```
Get-FSCPSADOTestSuiteByTestCase [[-TestCaseId] <Int32>] [[-Project] <String>] [[-Organization] <String>]
 [[-BearerToken] <String>] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
This function constructs a URL to access the test suite details for a specific test case in Azure DevOps.
It sends a GET request to the Azure DevOps API and retrieves the test suite ID and name for the specified test case.
The function returns a hashtable with the test suite ID and name.

## EXAMPLES

### EXAMPLE 1
```
$testCaseId = 4927
$project = "MyProject"
$organization = "https://dev.azure.com/dev-inc"
$bearerToken = "your_access_token"
```

$testSuiteInfo = Get-FSCPSADOTestSuiteByTestCase -TestCaseId $testCaseId -Project $project -Organization $organization -BearerToken $bearerToken
Write-Output $testSuiteInfo

## PARAMETERS

### -TestCaseId
The ID of the test case.

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

### -BearerToken
The authorization token for accessing the Azure DevOps API.

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
Ensure you have the correct permissions and a valid access token in the authorization header.
The function assumes the Azure DevOps API is available and accessible from the environment where the script is executed.

## RELATED LINKS
