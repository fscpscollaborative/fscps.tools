
<#
    .SYNOPSIS
        Installs and imports specified PowerShell modules, with special handling for the "Az" module.
        
    .DESCRIPTION
        The `Invoke-FSCPSInstallModule` function takes an array of module names, installs them if they are not already installed, and then imports them. It also handles the uninstallation of the "AzureRm" module if "Az" is specified. Real-time monitoring is temporarily disabled during the installation process to speed it up.
        
    .PARAMETER Modules
        An array of module names to be installed and imported.
        
    .EXAMPLE
        Invoke-FSCPSInstallModule -Modules @("Az", "Pester")
        
        This example installs and imports the "Az" and "Pester" modules in the current user scope.
        
    .NOTES
        - Real-time monitoring is disabled during the installation process to improve performance.
        - The "AzureRm" module is uninstalled if "Az" is specified.
#>

function Invoke-FSCPSInstallModule {
    Param(
        [String[]] $Modules
    )
    begin {
        # Disable real-time monitoring to speed up installation
        Set-MpPreference -DisableRealtimeMonitoring $true
        [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
        Install-Module PowershellGet -Force -AllowClobber -Scope CurrentUser -SkipPublisherCheck  -ErrorAction SilentlyContinue
    }
    process {
        $modules | ForEach-Object {
            if ($_ -eq "Az") {
                Set-ExecutionPolicy RemoteSigned  -Force
                try {
                    Uninstall-AzureRm 
                } catch {
                    Write-PSFMessage -Level Host -Message "AzureRm module is not installed or an error occurred during uninstallation."
                }
            }
            if (-not (Get-InstalledModule -Name $_ -Scope CurrentUser -ErrorAction SilentlyContinue)) {
                Write-PSFMessage -Level Host -Message "Installing module $_"
                Install-Module $_ -Scope CurrentUser -Force -AllowClobber | Out-Null
            }
        }
        $modules | ForEach-Object {
            Write-PSFMessage -Level Host -Message "Importing module $_"
            Import-Module $_ -Scope CurrentUser -DisableNameChecking -WarningAction SilentlyContinue | Out-Null
        }
    }
    end {
        # Re-enable real-time monitoring
        Set-MpPreference -DisableRealtimeMonitoring $false
    }
}