
<#
    .SYNOPSIS
        Install software from Choco
        
    .DESCRIPTION
        Installs software from Chocolatey
        
        Full list of software: https://community.chocolatey.org/packages
        
    .PARAMETER Name
        The name of the software to install
        
        Support a list of softwares that you want to have installed on the system
        
    .PARAMETER Force
        Instruct the cmdlet to install the latest version of the software, regardless if it is already present on the system
        
    .EXAMPLE
        PS C:\> Install-FSCPSSoftware -Name vscode
        
        This will install VSCode on the system.
        
    .EXAMPLE
        PS C:\> Install-FSCPSSoftware -Name vscode -Force
        
        This will install VSCode on the system, forcing it to be (re)installed.
        
    .EXAMPLE
        PS C:\> Install-FSCPSSoftware -Name "vscode","fiddler"
        
        This will install VSCode and fiddler on the system.
        
    .NOTES
        This is refactored function from d365fo.tools
        
        Original Author: Mötz Jensen (@Splaxi)
        Author: Oleksandr Nikolaiev (@onikolaiev)
        
#>

Function Install-FSCPSSoftware {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseShouldProcessForStateChangingFunctions", "")]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSAvoidUsingInvokeExpression", "")]
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [Alias('SoftwareName')]
        [string[]] $Name,
        [switch] $Force
    )

    BEGIN {
        Invoke-TimeSignal -Start
        try {
            if (Test-Path -Path "$env:ProgramData\Chocolatey") {
                choco upgrade chocolatey -y -r
                choco upgrade all --ignore-checksums -y -r
            }
            else {
                Write-PSFMessage -Level InternalComment -Message "Installing Chocolatey"
            
                # Download and execute installation script
                [System.Net.WebRequest]::DefaultWebProxy.Credentials = [System.Net.CredentialCache]::DefaultCredentials
                Invoke-Expression ((New-Object System.Net.WebClient).DownloadString("https://chocolatey.org/install.ps1"))
            }
        }
        catch {
            Write-PSFMessage -Level Host -Message "Something went wrong while installing or updating Chocolatey" -Exception $PSItem.Exception
            Stop-PSFFunction -Message "Stopping because of errors"
            return
        }

        #Determine choco executable location
        #   This is needed because the path variable is not updated in this session yet
        #   This part is copied from https://chocolatey.org/install.ps1
        $chocoPath = [Environment]::GetEnvironmentVariable("ChocolateyInstall")
        if ($chocoPath -eq $null -or $chocoPath -eq '') {
            $chocoPath = "$env:ALLUSERSPROFILE\Chocolatey"
        }
        if (!(Test-Path ($chocoPath))) {
            $chocoPath = "$env:SYSTEMDRIVE\ProgramData\Chocolatey"
        }
        $chocoExePath = Join-Path $chocoPath 'bin\choco.exe'

        if (-not (Test-PathExists -Path $chocoExePath -Type Leaf)) { return }
    }
    
    PROCESS {
        if (Test-PSFFunctionInterrupt) { return }
        
        try {
            foreach ($item in $Name) {
                Write-PSFMessage -Level InternalComment -Message "Installing $item"

                $params = New-Object System.Collections.Generic.List[System.Object]

                $params.AddRange(@(
                        "install"
                        "$item",
                        "-y",
                        "-r"
                    ))

                if ($Force) {
                    $params.Add("-f")
                }

                Invoke-Process -Executable $chocoExePath -Params $($params.ToArray()) -ShowOriginalProgress:$true
            }
        }
        catch {
            Write-PSFMessage -Level Host -Message "Something went wrong while installing software" -Exception $PSItem.Exception
            Stop-PSFFunction -Message "Stopping because of errors"
            return
        }
        finally{
            
        }
    }
    END {
        Invoke-TimeSignal -End
    }
}