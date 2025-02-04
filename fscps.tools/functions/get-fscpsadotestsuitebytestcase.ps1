
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
        
    .PARAMETER Token
        The authorization token for accessing the Azure DevOps API.
        
    .EXAMPLE
        $testCaseId = 4927
        $project = "MyProject"
        $organization = "https://dev.azure.com/dev-inc"
        $token = "Bearer your_access_token"
        
        $testSuiteInfo = Get-FSCPSADOTestSuiteByTestCase -TestCaseId $testCaseId -Project $project -Organization $organization -Token $token
        Write-Output $testSuiteInfo
        
    .NOTES
        Ensure you have the correct permissions and a valid access token in the authorization header.
        The function assumes the Azure DevOps API is available and accessible from the environment where the script is executed.
#>

function Get-FSCPSADOTestSuiteByTestCase {
    [CmdletBinding()]
    [OutputType([hashtable])]    
    param (
        [int]$TestCaseId,
        [string]$Project,
        [string]$Organization,
        [string]$Token
    )
    begin {

        if ($Token -eq $null) {
            Write-PSFMessage -Level Error -Message "Token is required"
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
        $operationTestSuiteIdByTestCaseIdUrl = "$Organization/_apis/test/suites?testCaseId=$TestCaseId"
        $response = Invoke-RestMethod -Uri $operationTestSuiteIdByTestCaseIdUrl -Method Get -ContentType "application/json" -Headers $authHeader
        if ($response.StatusCode -eq 200) {
            return @{"Id"=$response.value[0].id
            "Name"=$response.value[0].name}
        } else {
            Write-PSFMessage -Level Error -Message  "The request failed with status code: $($response.StatusCode)"
        }

    }
    end{

    }
    
}