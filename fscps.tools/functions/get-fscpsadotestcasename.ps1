
<#
    .SYNOPSIS
        Retrieves the title of a test case from Azure DevOps.
        
    .DESCRIPTION
        This function constructs a URL to access the work item details of a test case in Azure DevOps.
        It sends a GET request to the Azure DevOps API and retrieves the title of the specified test case.
        The function returns the title of the test case.
        
    .PARAMETER TestCaseId
        The ID of the test case.
        
    .PARAMETER Project
        The name of the Azure DevOps project.
        
    .PARAMETER Organization
        The name of the Azure DevOps organization.
        
    .PARAMETER Token
        The token for accessing the Azure DevOps API.
        
    .EXAMPLE
        $testCaseId = 4927
        $project = "MyProject"
        $organization = "https://dev.azure.com/dev-inc"
        $token = "Bearer your_access_token"
        
        $testCaseName = Get-FSCPSADOTestCaseName -TestCaseId $testCaseId -Project $project -Organization $organization -Token $token
        Write-Output $testCaseName
        
    .NOTES
        Ensure you have the correct permissions and valid access token in the authorization header.
        The function assumes the Azure DevOps API is available and accessible from the environment where the script is executed.
#>

function Get-FSCPSADOTestCaseName {
    [CmdletBinding()]
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
        if ($TestCaseId -eq $null) {
            Write-PSFMessage -Level Error -Message "TestCaseId is required"
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
        # Construct the URL for the operation
        $operationTestCaseNameUrl = "$($Organization)/$($Project)/_apis/wit/workItems/$($TestCaseId)?api-version=7.1"        
        # Invoke the REST method to get the test case name
        $response = Invoke-RestMethod -Uri $operationTestCaseNameUrl -Method Get -ContentType "application/json" -Headers $authHeader        
        if ($response.StatusCode -eq 200) {
                    return $response.fields."System.Title"
        } else {
            Write-PSFMessage -Level Error -Message  "The request failed with status code: $($response.StatusCode)"
        }
    }
    end {

    }
}