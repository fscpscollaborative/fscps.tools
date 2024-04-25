
<#
    .SYNOPSIS
        Get active Azure Storage Account configuration
        
    .DESCRIPTION
        Get active Azure Storage Account configuration object from the configuration store
        
    .PARAMETER OutputAsPsCustomObject
        Instruct the cmdlet to return a PsCustomObject object
        
    .EXAMPLE
        PS C:\> Get-FSCPSActiveAzureStorageConfig
        
        This will get the active Azure Storage configuration.
        
    .EXAMPLE
        PS C:\> Get-FSCPSActiveAzureStorageConfig -OutputAsPsCustomObject:$true
        
        This will get the active Azure Storage configuration.
        The object will be output as a PsCustomObject, for you to utilize across your scripts.
        
    .NOTES
        Tags: Azure, Azure Storage, Config, Configuration, Token, Blob, Container
        
        This is refactored function from d365fo.tools
        
        Original Author: Mötz Jensen (@Splaxi)
        Author: Oleksandr Nikolaiev (@onikolaiev)
        
#>
function Get-FSCPSActiveAzureStorageConfig {
    [CmdletBinding()]
    param (
        [switch] $OutputAsPsCustomObject
    )

    $res = Get-PSFConfigValue -FullName "fscps.tools.active.azure.storage.account"

    if ($OutputAsPsCustomObject) {
        [PSCustomObject]$res
    }
    else {
        $res
    }
}