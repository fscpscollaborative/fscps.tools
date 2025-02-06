
<#
    .SYNOPSIS
        Retrieves test cases from a specified test suite in Azure DevOps.
        
    .DESCRIPTION
        The `Get-FSCPSADOTestCasesBySuite` function retrieves test cases from a specified test suite within a specified test plan
        in an Azure DevOps project. The function requires the organization, project, test suite ID, test plan ID, and a valid
        authentication token. It uses the Azure DevOps REST API to perform the operation and handles errors gracefully.
        
    .PARAMETER TestSuiteId
        The ID of the test suite from which to retrieve test cases.
        
    .PARAMETER TestPlanId
        The ID of the test plan containing the test suite.
        
    .PARAMETER Organization
        The name of the Azure DevOps organization.
        
    .PARAMETER Project
        The name of the Azure DevOps project.
        
    .PARAMETER apiVersion
        The version of the Azure DevOps REST API to use. Default is "6.0".
        
    .PARAMETER Token
        The authentication token for accessing Azure DevOps.
        
    .EXAMPLE
        Get-FSCPSADOTestCasesBySuite -TestSuiteId 1001 -TestPlanId 2001 -Organization "my-org" -Project "my-project" -Token "Bearer my-token"
        
        This example retrieves the test cases from the test suite with ID 1001 within the test plan with ID 2001 in the specified organization and project.
        
    .NOTES
        - The function uses the Azure DevOps REST API to retrieve test cases.
        - An authentication token is required.
        - Handles errors and interruptions gracefully.
#>

function Get-FSCPSADOTestCasesBySuite {
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param (
        [int]$TestSuiteId,
        [int]$TestPlanId,
        [string]$Organization,
        [string]$Project,
        [string]$apiVersion = "6.0",
        [string]$Token
    )
    begin {
        Invoke-TimeSignal -Start
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
            $operationTestSuiteIdByTestCaseIdUrl = "$Organization/$Project/_apis/test/Plans/$TestPlanId/suites/$TestSuiteId/testcases?api-version=$apiVersion"

            # Make the REST API call
            if ($PSVersionTable.PSVersion.Major -ge 7) {
                $response = Invoke-RestMethod -Uri $operationTestSuiteIdByTestCaseIdUrl -Method Get -Headers $authHeader -ContentType "application/json" -StatusCodeVariable statusCode
            } else {
                $response = Invoke-WebRequest -Uri $operationTestSuiteIdByTestCaseIdUrl -Method Get -Headers $authHeader -UseBasicParsing
                $statusCode = $response.StatusCode
                $response = $response.Content | ConvertFrom-Json 
            }
            
            
            if ($statusCode -eq 200) {
                return  $response.value                
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