
<#
    .SYNOPSIS
        Update the module variables based on the PSF Configuration store
        
    .DESCRIPTION
        Will read the current PSF Configuration store and create local module variables
        
    .EXAMPLE
        PS C:\> Update-PsfConfigVariables
        
        This will read all relevant PSF Configuration values and create matching module variables.
        
    .NOTES
        This is refactored function from d365fo.tools
        
        Original Author: Mötz Jensen (@Splaxi)
        Author: Oleksandr Nikolaiev (@onikolaiev)
#>

function Update-PsfConfigVariables {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseSingularNouns", "")]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseShouldProcessForStateChangingFunctions", "")]

    [CmdletBinding()]
    [OutputType()]
    param ()

    foreach ($config in Get-PSFConfig -FullName "fscps.tools.path.*") {
        $item = $config.FullName.Replace("fscps.tools.path.", "")
        $name = (Get-Culture).TextInfo.ToTitleCase($item) + "Path"
        
        Set-Variable -Name $name -Value $config.Value -Scope Script
    }
}