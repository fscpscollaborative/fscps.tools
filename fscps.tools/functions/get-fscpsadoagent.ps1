
<#
    .SYNOPSIS
        Retrieves agents from a specified agent pool in Azure DevOps.
        
    .DESCRIPTION
        The `Get-FSCPSADOAgent` function retrieves agents from a specified agent pool in Azure DevOps.
        It requires the organization, agent pool ID, and a valid authentication token. The function constructs
        the appropriate URL, makes the REST API call, and returns detailed information about the agents,
        including their capabilities and statuses. It also handles errors and interruptions gracefully.
        
    .PARAMETER AgentPoolId
        The ID of the agent pool from which to retrieve agents.
        
    .PARAMETER Organization
        The name of the Azure DevOps organization. If not in the form of a URL, it will be prefixed with "https://dev.azure.com/".
        
    .PARAMETER apiVersion
        The version of the Azure DevOps REST API to use. Default is "7.0".
        
    .PARAMETER Token
        The authentication token for accessing Azure DevOps.
        
    .EXAMPLE
        Get-FSCPSADOAgent -AgentPoolId 1 -Organization "my-org" -Token "Bearer my-token"
        
        This example retrieves agents from the agent pool with ID 1 in the specified organization.
        
    .NOTES
            - The function uses the Azure DevOps REST API to retrieve agent information.
            - An authentication token is required.
            - Handles errors and interruptions gracefully.
        Author: Oleksandr Nikolaiev (@onikolaiev)
#>

function Get-FSCPSADOAgent {
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param (
        [int]$AgentPoolId,
        [string]$Organization,
        [string]$apiVersion = "7.0",
        [string]$Token
    )
    begin {
        Invoke-TimeSignal -Start
        if ($Token -eq $null) {
            Write-PSFMessage -Level Error -Message "Token is required"
            return
        }
        if ($AgentPoolId -eq $null) {
            Write-PSFMessage -Level Error -Message "AgentPoolId is required"
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
            $statusCode = $null
            $agents = @{}
            $poolsUrl = "$Organization/_apis/distributedtask/pools/"+$($AgentPoolId)+"/agents?includeCapabilities=true&api-version=$apiVersion"
            $response = Invoke-RestMethod -Uri $poolsUrl -Method Get -ContentType "application/json" -Headers $authHeader -StatusCodeVariable statusCode      
            if ($statusCode -eq 200) {
                ($response.value | ForEach-Object {
                    $agents += @{
                        Id = $_.id
                        Name = $_.name
                        UserCapabilities = $_.userCapabilities
                        Enabled = $_.enabled
                        Parameters = $_
                    } 
                })
                return @{
                    Response = @{
                        Agents = $agents
                        AgentsCount = $agents.count
                    }
                }
            } 
            else {
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