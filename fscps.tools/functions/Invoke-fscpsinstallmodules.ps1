
<#
    .SYNOPSIS
        Installs and imports specified PowerShell modules, with special handling for the "Az" module.
        
    .DESCRIPTION
        The `Invoke-FSCPSInstallModules` function takes an array of module names, installs them if they are not already installed, and then imports them. It also handles the uninstallation of the "AzureRm" module if "Az" is specified. Real-time monitoring is temporarily disabled during the installation process to speed it up.
        
    .PARAMETER modules
        An array of module names to be installed and imported.
        
    .EXAMPLE
        Invoke-FSCPSInstallModules -modules @("Az", "Pester")
        
        This example installs and imports the "Az" and "Pester" modules.
        
    .NOTES
        - Real-time monitoring is disabled during the installation process to improve performance.
        - The "AzureRm" module is uninstalled if "Az" is specified.
#>
function Invoke-FSCPSInstallModules {
    Param(
        [String[]] $modules
    )
    begin {
        # Disable real-time monitoring to speed up installation
        Set-MpPreference -DisableRealtimeMonitoring $true
        [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
        Install-Module PowershellGet -Force -AllowClobber -SkipPublisherCheck -Scope CurrentUser -ErrorAction SilentlyContinue
    }
    process {
        try {
            Install-PackageProvider -Name NuGet 
            Set-PSRepository -Name PSGallery -InstallationPolicy Trusted -ErrorAction SilentlyContinue
        }
        catch {
            Write-PSFMessage -Level Host -Message "Failed to install NuGet provider or set PSGallery as a trusted repository."
        }

        $modules | ForEach-Object {
            if ($_ -eq "Az") {
                Set-ExecutionPolicy RemoteSigned CurrentUser -Force
                try {
                    Uninstall-AzureRm 
                } catch {
                    Write-PSFMessage -Level Host -Message  "AzureRm module is not installed or an error occurred during uninstallation."
                }
            }
            if (-not (Get-InstalledModule -Name $_ -ErrorAction SilentlyContinue)) {
                Write-PSFMessage -Level Host -Message  "Installing module $_"
                Install-Module $_ -Force -AllowClobber | Out-Null
            }
        }
        $modules | ForEach-Object {
            Write-PSFMessage -Level Host -Message  "Importing module $_"
            Import-Module $_ -DisableNameChecking -WarningAction SilentlyContinue | Out-Null
        }
    }
    end {
        # Re-enable real-time monitoring
        Set-MpPreference -DisableRealtimeMonitoring $false
    }
}