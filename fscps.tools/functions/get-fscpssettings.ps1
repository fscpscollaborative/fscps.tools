
<#
    .SYNOPSIS
        Get the LCS configuration details
        
    .DESCRIPTION
        Get the LCS configuration details from the configuration store
        
        All settings retrieved from this cmdlets is to be considered the default parameter values across the different cmdlets
        
    .PARAMETER OutputAsHashtable
        Instruct the cmdlet to return a hashtable object
        
    .EXAMPLE
        PS C:\> Get-FSCPSSettings
        
        This will output the current LCS API configuration.
        The object returned will be a PSCustomObject.
        
    .EXAMPLE
        PS C:\> Get-FSCPSSettings -OutputAsHashtable
        
        This will output the current LCS API configuration.
        The object returned will be a Hashtable.
        
    .LINK
        Set-D365LcsApiConfig
        
    .NOTES
        Tags: Environment, Url, Config, Configuration, LCS, Upload, ClientId
        
        Author: Mötz Jensen (@Splaxi)
        
#>

function Get-FSCPSSettings {
    [CmdletBinding()]
    [OutputType()]
    param (
        [Alias('RepositoryRootPath')]
        [string[]] $RepositoryRootPath,
        [switch] $OutputAsHashtable
    )

    Invoke-TimeSignal -Start

    $res = [Ordered]@{}

    Write-PSFMessage -Level Verbose -Message "Extracting all the LCS configuration and building the result object."

    foreach ($config in Get-PSFConfig -FullName "fscps.tools.settings.*") {
        $propertyName = $config.FullName.ToString().Replace("fscps.tools.settings.", "")
        $res.$propertyName = $config.Value
    }



    
    if($OutputAsHashtable) {
        $res
    } else {
        [PSCustomObject]$res
    }

    Invoke-TimeSignal -End
}