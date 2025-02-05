
<#
    .SYNOPSIS
        Retrieves information about a specific test case from Azure DevOps.
        
    .DESCRIPTION
        The `Get-FSCPSADOTestCase` function retrieves detailed information about a specified test case from Azure DevOps.
        It requires the organization, project, test case ID, and a valid authentication token. The function constructs
        the appropriate URL, makes the REST API call, and returns the fields of the test case. It also handles errors
        and interruptions gracefully.
        
    .PARAMETER TestCaseId
        The ID of the test case to retrieve information for.
        
    .PARAMETER Project
        The name of the Azure DevOps project.
        
    .PARAMETER Organization
        The name of the Azure DevOps organization. If not in the form of a URL, it will be prefixed with "https://dev.azure.com/".
        
    .PARAMETER apiVersion
        The version of the Azure DevOps REST API to use. Default is "7.1".
        
    .PARAMETER Token
        The authentication token for accessing Azure DevOps.
        
    .EXAMPLE
        Get-FSCPSADOTestCase -TestCaseId 1234 -Project "my-project" -Organization "my-org" -Token "Bearer my-token"
        
        This example retrieves detailed information about the test case with ID 1234 in the specified organization and project.
        
    .NOTES
        - The function uses the Azure DevOps REST API to retrieve test case information.
        - An authentication token is required.
        - Handles errors and interruptions gracefully.
#>

function Get-FSCPSADOTestCase {
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param (
        [int]$TestCaseId,
        [string]$Project,
        [string]$Organization,
        [string]$apiVersion = "7.1",
        [string]$Token
    )
    begin {
        Invoke-TimeSignal -Start
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
            # Construct the URL for the operation
            $operationTestCaseNameUrl = "$($Organization)/$($Project)/_apis/wit/workItems/$($TestCaseId)?api-version=$apiVersion"        
            # Invoke the REST method to get the test case name
            $response = Invoke-RestMethod -Uri $operationTestCaseNameUrl -Method Get -ContentType "application/json" -Headers $authHeader        
            if ($response.StatusCode -eq 200) {
                return @{
                    Response = $response.fields
                }
                #return $response.fields."System.Title" #Name of the test case
            } 
            else {
                Write-PSFMessage -Level Error -Message  "The request failed with status code: $($response.StatusCode)"
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