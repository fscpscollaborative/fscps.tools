
<#
    .SYNOPSIS
        Enable exceptions to be thrown
        
    .DESCRIPTION
        Change the default exception behavior of the module to support throwing exceptions
        
        Useful when the module is used in an automated fashion, like inside Azure DevOps pipelines and large PowerShell scripts
        
    .EXAMPLE
        PS C:\>Enable-FSCPSException
        
        This will for the rest of the current PowerShell session make sure that exceptions will be thrown.
        
    .NOTES
        Tags: Exception, Exceptions, Warning, Warnings
        This is refactored function from d365fo.tools
        
        Original Author: Mötz Jensen (@Splaxi)
        Author: Oleksandr Nikolaiev (@onikolaiev)
        
    .LINK
        Disable-FSCPSException
#>

function Enable-FSCPSException {
    [CmdletBinding()]
    param ()

    Write-PSFMessage -Level Verbose -Message "Enabling exception across the entire module." -Target $configurationValue

    Set-PSFFeature -Name 'PSFramework.InheritEnableException' -Value $true -ModuleName "fscps.tools"
    Set-PSFFeature -Name 'PSFramework.InheritEnableException' -Value $true -ModuleName "PSOAuthHelper"
    $PSDefaultParameterValues['*:EnableException'] = $true
}