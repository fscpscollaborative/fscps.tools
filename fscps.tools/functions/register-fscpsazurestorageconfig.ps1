
<#
    .SYNOPSIS
        Register Azure Storage Configurations
        
    .DESCRIPTION
        Register all Azure Storage Configurations
        
    .PARAMETER ConfigStorageLocation
        Parameter used to instruct where to store the configuration objects
        
        The default value is "User" and this will store all configuration for the active user
        
        Valid options are:
        "User"
        "System"
        
        "System" will store the configuration as default for all users, so they can access the configuration objects
        
    .EXAMPLE
        PS C:\> Register-FSCPSAzureStorageConfig -ConfigStorageLocation "System"
        
        This will store all Azure Storage Configurations as defaults for all users on the machine.
        
    .NOTES
        Tags: Configuration, Azure, Storage
        This is refactored function from d365fo.tools
        
        Original Author: Mötz Jensen (@Splaxi)
        Author: Oleksandr Nikolaiev (@onikolaiev)
        
#>

function Register-FSCPSAzureStorageConfig {
    [CmdletBinding()]
    [OutputType()]
    param (
        [ValidateSet('User', 'System')]
        [string] $ConfigStorageLocation = "User"
    )

    $configScope = Test-ConfigStorageLocation -ConfigStorageLocation $ConfigStorageLocation
    
    Register-PSFConfig -FullName "fscps.tools.azure.storage.accounts" -Scope $configScope
}