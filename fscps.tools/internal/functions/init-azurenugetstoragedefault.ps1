
<#
    .SYNOPSIS
        Init the Azure Storage config variables
        
    .DESCRIPTION
        Update the active Azure Storage config variables that the module will use as default values
        
    .EXAMPLE
        PS C:\> Init-AzureNugetStorageDefault
        
        This will update the Azure Storage variables.
        
    .NOTES
        This initializes the default NugetStorage settings
        
        Author: Oleksandr Nikolaiev (@onikolaiev)
#>

function Init-AzureNugetStorageDefault {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseShouldProcessForStateChangingFunctions", "")]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseSingularNouns", "")]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseApprovedVerbs", "")]
    [CmdletBinding()]
    [OutputType()]
    param ( )

    Register-FSCPSAzureStorageConfig -ConfigStorageLocation "System"
    Add-FSCPSAzureStorageConfig -Name NuGetStorage -SAS $Script:NuGetStorageSASToken -AccountId $Script:NuGetStorageAccountName -Container $Script:NuGetStorageContainer -Force    
}