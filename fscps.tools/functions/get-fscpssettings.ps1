
<#
    .SYNOPSIS
        Get the FSCPS configuration details
        
    .DESCRIPTION
        Get the FSCPS configuration details from the configuration store
        
        All settings retrieved from this cmdlets is to be considered the default parameter values across the different cmdlets
               
    .PARAMETER OutputAsHashtable
        Instruct the cmdlet to return a hashtable object

    .EXAMPLE
        PS C:\> Get-FSCPSSettings
        
        This will output the current FSCPS configuration.
        The object returned will be a PSCustomObject.
        
    .EXAMPLE
        PS C:\> Get-FSCPSSettings -OutputAsHashtable
        
        This will output the current FSCPS configuration.
        The object returned will be a Hashtable.
        
    .LINK
        Set-FSCPSSettings
        
    .NOTES
        Tags: Environment, Url, Config, Configuration, LCS, Upload, ClientId
        
        Author: Oleksandr Nikolaiev (@onikolaiev)
        
#>

function Get-FSCPSSettings {
    [CmdletBinding()]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseShouldProcessForStateChangingFunctions", "")]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseSingularNouns", "")]
    [OutputType([System.Collections.Specialized.OrderedDictionary])]
    param (
        [switch] $OutputAsHashtable
    )
    begin{
        Invoke-TimeSignal -Start   
    }
    process{         

        foreach ($config in Get-PSFConfig -FullName "fscps.tools.settings.*") {
            $propertyName = $config.FullName.ToString().Replace("fscps.tools.settings.", "")
            $res.$propertyName = $config.Value
        }

        if($OutputAsHashtable) {
            $res
        } else {
            [PSCustomObject]$res
        }   
       
    }
    end{
        Invoke-TimeSignal -End
    }

}