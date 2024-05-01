
<#
    .SYNOPSIS
        Install software from Choco
        
    .DESCRIPTION
        Installs software from Chocolatey
        
        Full list of software: https://community.chocolatey.org/packages
        
    .PARAMETER Command
        The command of the choco to execute
        
        Support a list of softwares that you want to have installed on the system

    .PARAMETER Silent
        Disable output

    .PARAMETER Command
        The command of the choco to execute

    .PARAMETER RemainingArguments
        List of arguments

    .PARAMETER Force
        Force command. Reinstall latest version if command is install or upgrade to latest version

    .EXAMPLE
        PS C:\> Invoke-FSCPSChoco install gh -y --allow-unofficial -Silent
        
        This will install GH tools on the system without console output
        
    .NOTES
        Author: Oleksandr Nikolaiev (@onikolaiev)
        
#>

Function Invoke-FSCPSChoco {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseShouldProcessForStateChangingFunctions", "")]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSAvoidUsingInvokeExpression", "")]
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, Position = 0)]
        [string] $Command,
        [Parameter(Mandatory = $false, Position = 1, ValueFromRemainingArguments = $true)] $RemainingArguments,
        [switch] $Silent,
        [switch] $Force
    )

    BEGIN {
        Invoke-TimeSignal -Start
        try {
            if (Test-Path -Path "$env:ProgramData\Chocolatey") {
                if (!$Silent) {
                    choco upgrade chocolatey -y -r 
                    choco upgrade all --ignore-checksums -y -r
                }
                else{
                    $null = choco upgrade chocolatey -y -r -silent
                    $null = choco upgrade all --ignore-checksums -y -r
                }
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

                $arguments = New-Object System.Collections.Generic.List[System.Object]


                $arguments.Add("$Command ")
                $RemainingArguments | ForEach-Object {
                    if ("$_".IndexOf(" ") -ge 0 -or "$_".IndexOf('"') -ge 0) {
                        $arguments.Add("""$($_.Replace('"','\"'))"" ")
                    }
                    else {
                        $arguments.Add("$_ ")
                    }
                }
                if ($Force) {
                    $arguments.Add("-f")
                }
                if (!$Silent) {
                    Invoke-Process -Executable $chocoExePath -Params $($arguments.ToArray()) -ShowOriginalProgress:$true
                }
                else {
                    $null = Invoke-Process -Executable $chocoExePath -Params $($arguments.ToArray()) -ShowOriginalProgress:$false
                }
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