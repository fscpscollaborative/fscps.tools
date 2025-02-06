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
        # Disable real-time monitoring to improve performance
        Write-Host "Disabling real-time monitoring..."
        Set-MpPreference -DisableRealtimeMonitoring $true
        [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
        Install-Module PowershellGet -Force -AllowClobber -SkipPublisherCheck -ErrorAction SilentlyContinue
    }
    process {
        foreach ($module in $Modules) {
            if ($module -eq "Az") {
                # Uninstall AzureRm module if Az is specified
                if (Get-Module -ListAvailable -Name "AzureRm") {
                    Write-Host "Uninstalling AzureRm module..."
                    Uninstall-Module -Name "AzureRm" -AllVersions -Force
                }
            }

            # Check if the module is already installed
            if (-not (Get-Module -ListAvailable -Name $module)) {
                Write-Host "Installing module $module..."
                try {
                    if ($PSVersionTable.PSVersion.Major -ge 5) {
                        Install-Module -Name $module -Scope CurrentUser -Force
                    } else {
                        Install-Module -Name $module -Force
                    }
                } catch {
                    Write-Error "Failed to install module $module : $_"
                }
            }

            # Import the module
            Write-Host "Importing module $module..."
            Import-Module -Name $module -Force
        }
    }
    end {
        # Re-enable real-time monitoring
        Write-Host "Re-enabling real-time monitoring..."
        # Add your code to re-enable real-time monitoring here
        Set-MpPreference -DisableRealtimeMonitoring $false
    }
}