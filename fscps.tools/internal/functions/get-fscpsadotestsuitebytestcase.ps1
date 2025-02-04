
<#
    .SYNOPSIS
        Retrieves the test suite ID and name for a given test case from Azure DevOps.
        
    .DESCRIPTION
        This function constructs a URL to access the test suite details for a specific test case in Azure DevOps.
        It sends a GET request to the Azure DevOps API and retrieves the test suite ID and name for the specified test case.
        The function returns a hashtable with the test suite ID and name.
        
    .PARAMETER TestCaseId
        The ID of the test case.
        
    .PARAMETER Project
        The name of the Azure DevOps project.
        
    .PARAMETER Organization
        The name of the Azure DevOps organization.
        
    .PARAMETER BearerToken
        The authorization token for accessing the Azure DevOps API.
        
    .EXAMPLE
        $testCaseId = 4927
        $project = "MyProject"
        $organization = "https://dev.azure.com/dev-inc"
        $bearerToken = "your_access_token"
        
        $testSuiteInfo = Get-FSCPSADOTestSuiteByTestCase -TestCaseId $testCaseId -Project $project -Organization $organization -BearerToken $bearerToken
        Write-Output $testSuiteInfo
        
    .NOTES
        Ensure you have the correct permissions and a valid access token in the authorization header.
        The function assumes the Azure DevOps API is available and accessible from the environment where the script is executed.
#>

function Get-FSCPSADOTestSuiteByTestCase {
    [CmdletBinding()]
    param (
        [int]$TestCaseId,
        [string]$Project,
        [string]$Organization,
        [string]$BearerToken
    )
    begin {

        if ($BearerToken -eq $null) {
            Write-PSFMessage -Level Error -Message "BearerToken is required"
            return
        }
        if($TestCaseId -eq $null) {
            Write-PSFMessage -Level Error -Message "TestCaseId is required"
            return
        }
        if($Project -eq $null) {
            Write-PSFMessage -Level Error -Message "Project is required"
            return
        }
        if($Organization -eq $null) {
            Write-PSFMessage -Level Error -Message "Organization is required"
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
        $operationTestSuiteIdByTestCaseIdUrl = "$Organization/_apis/test/suites?testCaseId=$TestCaseId&api-version=7.1"
        $responsets = Invoke-RestMethod -Uri $operationTestSuiteIdByTestCaseIdUrl -Method Get -ContentType "application/json" -Headers $authHeader
        return @{"Id"=$responsets.value[0].id
                 "Name"=$responsets.value[0].name}
    }
    end{

    }
    
}