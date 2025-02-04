
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
        
    .PARAMETER Token
        The authorization token for accessing the Azure DevOps API.
        
    .EXAMPLE
        $testSuiteId = 5261
        $testPlanId = 6
        $project = "MyProject"
        $organization = "https://dev.azure.com/dev-inc"
        $token = "Bearer your_access_token"
        
        $testCases = Get-FSCPSADOTestCasesBySuite -TestSuiteId $testSuiteId -TestPlanId $testPlanId -Project $project -Organization $organization -Token $token
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
        [string]$Token
    )
    begin {
        if ($Token -eq $null) {
            Write-PSFMessage -Level Error -Message "Token is required"
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
        if ($Token.StartsWith("Bearer") -eq $false) {
            $authHeader = @{
                Authorization = "$Token"
            }
        }
        else {
            $authHeader = @{
                Authorization = "Bearer $Token"
            }
        }
    }
    process {
        $operationTestSuiteIdByTestCaseIdUrl = "$Organization/$Project/_apis/test/Plans/$TestPlanId/suites/$TestSuiteId/testcases"
        $response = Invoke-RestMethod -Uri $operationTestSuiteIdByTestCaseIdUrl -Method Get -ContentType "application/json" -Headers $authHeader
        if ($response.StatusCode -eq 200) {
            return $response.value
        } else {
            Write-PSFMessage -Level Error -Message  "The request failed with status code: $($response.StatusCode)"
        }
        
    }
    end {
        Write-PSFMessage -Level Host -Message "Test cases count in the test suite: $($response.value.count)"
    }
}