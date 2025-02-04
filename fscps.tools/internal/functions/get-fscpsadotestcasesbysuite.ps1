<#
.SYNOPSIS
Retrieves the test cases in a specified test suite from Azure DevOps.

.DESCRIPTION
This function constructs a URL to access the test cases within a specific test suite in Azure DevOps.
It sends a GET request to the Azure DevOps API and retrieves the test cases in the specified test suite.
The function returns the test cases.

.PARAMETER TestSuiteId
The ID of the test suite.

.PARAMETER TestPlanId
The ID of the test plan.

.PARAMETER Organization
The name of the Azure DevOps organization.

.PARAMETER Project
The name of the Azure DevOps project.

.PARAMETER BearerToken
The authorization token for accessing the Azure DevOps API.

.EXAMPLE
$testSuiteId = 5261
$testPlanId = 6
$project = "MyProject"
$organization = "https://dev.azure.com/dev-inc"
$token = "Bearer your_access_token"

$testCases = Get-FSCPSADOTestCasesBySuite -TestSuiteId $testSuiteId -TestPlanId $testPlanId -Project $project -Organization $organization -BearerToken $token
Write-Output $testCases

.NOTES
Ensure you have the correct permissions and valid access token in the authorization header.
The function assumes the Azure DevOps API is available and accessible from the environment where the script is executed.
#>

function Get-FSCPSADOTestCasesBySuite {
    [CmdletBinding()]
    param (
        [int]$TestSuiteId,
        [int]$TestPlanId,
        [string]$Organization,
        [string]$Project,
        [string]$BearerToken
    )
    begin {
        if ($BearerToken -eq $null) {
            Write-PSFMessage -Level Error -Message "BearerToken is required"
            return
        }
        if ($TestSuiteId -eq $null) {
            Write-PSFMessage -Level Error -Message "TestSuiteId is required"
            return
        }
        if ($Project -eq $null) {
            Write-PSFMessage -Level Error -Message "Project is required"
            return
        }
        if ($Organization -eq $null) {
            Write-PSFMessage -Level Error -Message "Organization is required"
            return
        }
        if($TestPlanId -eq $null) {
            Write-PSFMessage -Level Error -Message "TestPlanId is required"
            return
        }
        if ($BearerToken.StartsWith("Bearer") -eq $false) {
            $authHeader = @{
                Authorization = "$BearerToken"
            }
        }
        else {
            $authHeader = @{
                Authorization = "Bearer $BearerToken"
            }
        }
    }
    process {
        $operationTestSuiteIdByTestCaseIdUrl = "$Organization/$Project/_apis/test/Plans/$TestPlanId/suites/$TestSuiteId/testcases?api-version=7.1"
        $responsets = Invoke-RestMethod -Uri $operationTestSuiteIdByTestCaseIdUrl -Method Get -ContentType "application/json" -Headers $authHeader
        return $responsets.value
    }
    end {
        Write-PSFMessage -Level Host -Message "Test cases count in the test suite: $($responsets.value.count)"
    }
}
