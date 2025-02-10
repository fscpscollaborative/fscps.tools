
<#
    .SYNOPSIS
        Retrieves test suites from an Azure DevOps test plan.
        
    .DESCRIPTION
        The `Get-FSCPSADOTestSuitesByTestPlan` function retrieves test suites from a specified Azure DevOps test plan.
        It requires the organization, project, test plan ID, and a valid authentication token. The function handles
        pagination through the use of a continuation token and returns the test suites along with the new continuation token.
        
    .PARAMETER Organization
        The name of the Azure DevOps organization.
        
    .PARAMETER Project
        The name of the Azure DevOps project.
        
    .PARAMETER TestPlanId
        The ID of the test plan from which to retrieve test suites.
        
    .PARAMETER Token
        The authentication token for accessing Azure DevOps.
        
    .PARAMETER apiVersion
        The version of the Azure DevOps REST API to use. Default is "7.1".
        
    .PARAMETER continuationToken
        The continuation token for pagination. Default is $null.
        
    .EXAMPLE
        Get-FSCPSADOTestSuitesByTestPlan -Organization "my-org" -Project "my-project" -TestPlanId 123 -Token "Bearer my-token"
        
        This example retrieves test suites from the test plan with ID 123 in the specified organization and project.
        
    .NOTES
        - The function uses the Azure DevOps REST API to retrieve test suites.
        - An authentication token is required.
        - Handles pagination through continuation tokens.

        Author: Oleksandr Nikolaiev (@onikolaiev)
#>

function Get-FSCPSADOTestSuitesByTestPlan {
    param (
        [string]$Organization,
        [string]$Project,
        [int]$TestPlanId,
        [string]$Token,
        [string]$apiVersion = "7.1",
        [string]$continuationToken = $null
    )
    begin{
        Invoke-TimeSignal -Start
        if ($Token -eq $null) {
            Write-PSFMessage -Level Error -Message "Token is required"
            return
        }
        if($TestPlanId -eq $null) {
            Write-PSFMessage -Level Error -Message "TestPlanId is required"
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
    process{
        if (Test-PSFFunctionInterrupt) { return }

        try {
            $statusCode = $null
            # Construct the URL with continuation token if available
            $operationStatusUrl = "$Organization/$Project/_apis/testplan/Plans/$TestPlanId/suites?api-version=$apiVersion"
            if ($continuationToken) {
                $operationStatusUrl += "&continuationToken=$continuationToken"
            }

            # Make the REST API call
            if ($PSVersionTable.PSVersion.Major -ge 7) {
                $response = Invoke-RestMethod -Uri $operationStatusUrl -Method Get -Headers $authHeader -ResponseHeadersVariable responseHeaders -StatusCodeVariable statusCode
                $newContinuationToken = $responseHeaders['X-MS-ContinuationToken']
            } else {
                $response = Invoke-WebRequest -Uri $operationStatusUrl -Method Get -Headers $authHeader -UseBasicParsing
                $newContinuationToken = $response.Headers['X-MS-ContinuationToken']
                $statusCode = $response.StatusCode
                $response = $response.Content | ConvertFrom-Json 
            }

            if ($statusCode -eq 200) {
                return @{
                    Response = $response.value
                    ContinuationToken = $newContinuationToken
                }
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