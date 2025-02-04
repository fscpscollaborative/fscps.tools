
<#
    .SYNOPSIS
        Installs and imports specified PowerShell modules, with special handling for the "Az" module.
        
    .DESCRIPTION
        The `Invoke-FSCPSInstallModule` function takes an array of module names, installs them if they are not already installed, and then imports them. It also handles the uninstallation of the "AzureRm" module if "Az" is specified. Real-time monitoring is temporarily disabled during the installation process to speed it up.
        
    .PARAMETER Modules
        An array of module names to be installed and imported.
        
    .PARAMETER Scope
        Specifies the scope in which to install the modules. Valid values are "AllUsers" or "CurrentUser".
        
    .EXAMPLE
        Invoke-FSCPSInstallModule Modules @("Az", "Pester") -scope CurrentUser
        
        This example installs and imports the "Az" and "Pester" modules in the current user scope.
        
    .NOTES
        - Real-time monitoring is disabled during the installation process to improve performance.
        - The "AzureRm" module is uninstalled if "Az" is specified.
#>

enum ModuleScope {
    AllUsers
    CurrentUser
}

function Invoke-FSCPSInstallModule {
    Param(
        [String[]] $Modules,
        [ModuleScope] $Scope = [ModuleScope]::CurrentUser
    )
    begin {
        # Disable real-time monitoring to speed up installation
        Set-MpPreference -DisableRealtimeMonitoring $true
        [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
        Install-Module PowershellGet -Force -AllowClobber -SkipPublisherCheck -Scope $Scope.ToString() -ErrorAction SilentlyContinue
    }
    process {
        $modules | ForEach-Object {
            if ($_ -eq "Az") {
                Set-ExecutionPolicy RemoteSigned -Scope $Scope.ToString() -Force
                try {
                    Uninstall-AzureRm 
                } catch {
                    Write-PSFMessage -Level Host -Message "AzureRm module is not installed or an error occurred during uninstallation."
                }
            }
            if (-not (Get-InstalledModule -Name $_ -Scope $Scope.ToString() -ErrorAction SilentlyContinue)) {
                Write-PSFMessage -Level Host -Message "Installing module $_"
                Install-Module $_ -Scope $scope.ToString() -Force -AllowClobber | Out-Null
            }
        }
        $modules | ForEach-Object {
            Write-PSFMessage -Level Host -Message "Importing module $_"
            Import-Module $_ -Scope $Scope.ToString() -DisableNameChecking -WarningAction SilentlyContinue | Out-Null
        }
    }
    end {
        # Re-enable real-time monitoring
        Set-MpPreference -DisableRealtimeMonitoring $false
    }
}