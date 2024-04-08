<#
    .SYNOPSIS
        Copy files with filter parameters
        
    .DESCRIPTION
        Copy files with filter parameters
        
    .PARAMETER Source
        The source path of copying files

    .PARAMETER Target
        The destination path of copying files

    .PARAMETER Filter
        The filter parameter

    .EXAMPLE
        PS C:\> Copy-Filtered -Source "c:\temp\source" -Target "c:\temp\target" -Filter *.*       

        This will build copy all the files to the destination folder

    .NOTES
        Author: Oleksandr Nikolaiev (@onikolaiev)
        
#>
function Copy-Filtered {
    param (
        [Parameter(Mandatory = $true)]
        [string] $Source,
        [Parameter(Mandatory = $true)]
        [string] $Target,
        [Parameter(Mandatory = $true)]
        [string[]] $Filter
    )
    $ResolvedSource = Resolve-Path $Source
    $NormalizedSource = $ResolvedSource.Path.TrimEnd([IO.Path]::DirectorySeparatorChar) + [IO.Path]::DirectorySeparatorChar
    Get-ChildItem $Source -Include $Filter -Recurse | ForEach-Object {
        $RelativeItemSource = $_.FullName.Replace($NormalizedSource, '')
        $ItemTarget = Join-Path $Target $RelativeItemSource
        $ItemTargetDir = Split-Path $ItemTarget
        if (!(Test-Path $ItemTargetDir)) {
            [void](New-Item $ItemTargetDir -Type Directory)
        }
        Copy-Item $_.FullName $ItemTarget
    }
}