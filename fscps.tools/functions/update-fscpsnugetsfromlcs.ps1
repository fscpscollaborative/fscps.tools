
<#
    .SYNOPSIS
        This uploads the D365FSC nugets from the LCS to the active storage account
        
    .DESCRIPTION
        This uploads the D365FSC nugets from the LCS to the active NuGet storage account
        
    .PARAMETER LCSUserName
        The LCS username
        
    .PARAMETER LCSUserPassword
        The LCS password
        
    .PARAMETER LCSProjectId
        The LCS project ID
        
    .PARAMETER LCSClientId
        The ClientId what has access to the LCS
        
    .PARAMETER FSCMinimumVersion
        The minimum version of the FSC to update the NuGet`s
        
    .EXAMPLE
        PS C:\> Update-FSCPSNugetsFromLCS -LCSUserName "admin@contoso.com" -LCSUserPassword "superSecureString" -LCSProjectId "123456" -LCSClientId "123ebf68-a86d-4392-ae38-57b2172ee789" -FSCMinimumVersion "10.0.38"
        
        this will uploads the D365FSC nugets from the LCS to the active storage account
    .NOTES
        Author: Oleksandr Nikolaiev (@onikolaiev)
        
#>
function Update-FSCPSNugetsFromLCS {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseShouldProcessForStateChangingFunctions", "")]
    [CmdletBinding()]
    param(
        [Parameter()]
        [string]$LCSUserName,
        [Parameter()]
        [SecureString]$LCSUserPassword,
        [Parameter()]
        [string]$LCSProjectId,
        [Parameter()]
        [string]$LCSClientId,
        [Parameter()]
        [string]$FSCMinimumVersion
    )

    begin{
        Invoke-TimeSignal -Start
        $BSTR = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($LCSUserPassword)
        $UnsecureLCSUserPassword = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($BSTR)

        Get-D365LcsApiToken -ClientId $LCSClientId -Username $LCSUserName -Password $UnsecureLCSUserPassword -LcsApiUri "https://lcsapi.lcs.dynamics.com" | Set-D365LcsApiConfig -ProjectId $LCSProjectId -ClientId $LCSClientId

    }
    process{
    
        try
        {
            Get-D365LcsApiConfig
        }
        catch {
            Write-PSFMessage -Level Host -Message "Something went wrong while updating D365FSC package versiob" -Exception $PSItem.Exception
            Stop-PSFFunction -Message "Stopping because of errors" -EnableException $true
            return
        }
        finally{

        }

    }
    end{
        Invoke-TimeSignal -End
    }          
}