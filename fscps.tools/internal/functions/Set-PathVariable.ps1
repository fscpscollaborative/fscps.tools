
<#
    .SYNOPSIS
        Modify the PATH environment variable.
    .DESCRIPTION
        Set-PathVariable allows you to add or remove paths to your PATH variable at the specified scope with logic that prevents duplicates.
    .PARAMETER AddPath
        A path that you wish to add. Can be specified with or without a trailing slash.
    .PARAMETER RemovePath
        A path that you wish to remove. Can be specified with or without a trailing slash.
    .PARAMETER Scope
        The scope of the variable to edit. Either Process, User, or Machine.
        
        If you specify Machine, you must be running as administrator.
    .EXAMPLE
        Set-PathVariable -AddPath C:\tmp\bin -RemovePath C:\path\java
        
        This will add the C:\tmp\bin path and remove the C:\path\java path. The Scope will be set to Process, which is the default.
    .INPUTS
        
    .OUTPUTS
        
    .NOTES
        Author: ThePoShWolf
    .LINK
        
        Author: Oleksandr Nikolaiev (@onikolaiev)
#>
Function Set-PathVariable {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseShouldProcessForStateChangingFunctions", "")]
    param (
        [string]$AddPath,
        [string]$RemovePath,
        [ValidateSet('Process', 'User', 'Machine')]
        [string]$Scope = 'Process'
    )
    $regexPaths = @()
    if ($PSBoundParameters.Keys -contains 'AddPath') {
        $regexPaths += [regex]::Escape($AddPath)
    }

    if ($PSBoundParameters.Keys -contains 'RemovePath') {
        $regexPaths += [regex]::Escape($RemovePath)
    }
    
    $arrPath = [System.Environment]::GetEnvironmentVariable('PATH', $Scope) -split ';'
    foreach ($path in $regexPaths) {
        $arrPath = $arrPath | Where-Object { $_ -notMatch "^$path\\?" }
    }
    $value = ($arrPath + $addPath) -join ';'
    [System.Environment]::SetEnvironmentVariable('PATH', $value, $Scope)
}