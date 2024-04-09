<#
    .SYNOPSIS
        Installation of Nuget CLI

    .DESCRIPTION
        Download latest Nuget CLI

    .PARAMETER Path
        Download destination

    .PARAMETER Url
        Url/Uri to where the latest nuget download is located
            
        The default value is "https://dist.nuget.org/win-x86-commandline/latest/nuget.exe"

    .EXAMPLE
        PS C:\> Install-FSCPSNugetCLI -Path "C:\temp\fscps.tools\nuget" -Url "https://dist.nuget.org/win-x86-commandline/latest/nuget.exe"

        This will download the latest version of nuget.

    .NOTES
        Author: Oleksandr Nikolaiev (@onikolaiev)
#>
function Install-FSCPSNugetCLI {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseShouldProcessForStateChangingFunctions", "")]
    [CmdletBinding()]
    param (
        [string] $Path = "C:\temp\fscps.tools\nuget",
        [string] $Url = "https://dist.nuget.org/win-x86-commandline/latest/nuget.exe"
    )
    begin{
        $downloadPath = Join-Path -Path $Path -ChildPath "nuget.exe"

    if (-not (Test-PathExists -Path $Path -Type Container -Create)) { return }
    }
    process{
        if (Test-PSFFunctionInterrupt) { return }

        Write-PSFMessage -Level Verbose -Message "Downloading nuget.exe. $($Url)" -Target $Url
        (New-Object System.Net.WebClient).DownloadFile($Url, $downloadPath)
    
        if (-not (Test-PathExists -Path $downloadPath -Type Leaf)) { return }
    }
    end{
        Unblock-File -Path $downloadPath
        Set-PSFConfig -FullName "fscps.tools.path.nuget" -Value $downloadPath
        Register-PSFConfig -FullName "fscps.tools.path.nuget"

        Update-ModuleVariables
    } 
}