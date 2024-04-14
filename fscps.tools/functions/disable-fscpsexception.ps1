
<#
    .SYNOPSIS
        Disables throwing of exceptions
        
    .DESCRIPTION
        Restore the default exception behavior of the module to not support throwing exceptions
        
        Useful when the default behavior was changed with Enable-FSCPSException and the default behavior should be restored
        
    .EXAMPLE
        PS C:\>Disable-FSCPSException
        
        This will restore the default behavior of the module to not support throwing exceptions.
        
    .NOTES
        Tags: Exception, Exceptions, Warning, Warnings
        This is refactored function from d365fo.tools
        
        Original Author: Florian Hopfner (@FH-Inway)
        Author: Oleksandr Nikolaiev (@onikolaiev)
        
    .LINK
        Enable-FSCPSException
#>

function Disable-FSCPSException {
    [CmdletBinding()]
    param ()

    Write-PSFMessage -Level Verbose -Message "Disabling exception across the entire module." -Target $configurationValue

    Set-PSFFeature -Name 'PSFramework.InheritEnableException' -Value $false -ModuleName "fscps.tools"
    Set-PSFFeature -Name 'PSFramework.InheritEnableException' -Value $false -ModuleName "PSOAuthHelper"
    $PSDefaultParameterValues['*:EnableException'] = $false
}