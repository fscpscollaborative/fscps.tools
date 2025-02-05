
<#
    .SYNOPSIS
        Retrieves the test suite associated with a specific test case from Azure DevOps.
        
    .DESCRIPTION
        The `Get-FSCPSADOTestSuiteByTestCase` function retrieves the test suite associated with a specified test case ID from Azure DevOps.
        It requires the organization, project, test case ID, and a valid authentication token. The function returns the test suite information
        and handles any errors that may occur during the request.
        
    .PARAMETER TestCaseId
        The ID of the test case for which to retrieve the associated test suite.
        
    .PARAMETER Project
        The name of the Azure DevOps project.
        
    .PARAMETER Organization
        The name of the Azure DevOps organization.
        
    .PARAMETER apiVersion
        The version of the Azure DevOps REST API to use. Default is "5.0".
        
    .PARAMETER Token
        The authentication token for accessing Azure DevOps.
        
    .EXAMPLE
        Get-FSCPSADOTestSuiteByTestCase -TestCaseId 1460 -Project "my-project" -Organization "my-org" -Token "Bearer my-token"
        
        This example retrieves the test suite associated with the test case ID 1460 in the specified organization and project.
        
    .NOTES
        - The function uses the Azure DevOps REST API to retrieve the test suite.
        - An authentication token is required.
        - Handles errors and interruptions gracefully.
#>

function Get-FSCPSADOTestSuiteByTestCase {
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param (
        [int]$TestCaseId,
        [string]$Project,
        [string]$Organization,
        [string]$apiVersion = "5.0",
        [string]$Token
    )
    begin {
        Invoke-TimeSignal -Start
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
        if($Organization.StartsWith("https://dev.azure.com") -eq $false) {
            $Organization = "https://dev.azure.com/$Organization"

        }
        if ($Token.StartsWith("Bearer") -eq $true) {
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
        if (Test-PSFFunctionInterrupt) { return }

        try {
            $statusCode = $null
            $operationTestSuiteIdByTestCaseIdUrl = "$Organization/_apis/test/suites?testCaseId=$TestCaseId&api-version=$apiVersion"
            $response = Invoke-RestMethod -Uri $operationTestSuiteIdByTestCaseIdUrl -Method Get -ContentType "application/json" -Headers $authHeader -StatusCodeVariable statusCode
            if ($statusCode -eq 200) {
                return $response.value
            } else {
                Write-PSFMessage -Level Error -Message  "The request failed with status code: $($statusCode)"
            }
        }
        catch {
            Write-PSFMessage -Level Host -Message "Something went wrong during request to ADO" -Exception $PSItem.Exception
            Stop-PSFFunction -Message "Stopping because of errors"
            return
        }        
    }
    end {
        Invoke-TimeSignal -End
    }
}