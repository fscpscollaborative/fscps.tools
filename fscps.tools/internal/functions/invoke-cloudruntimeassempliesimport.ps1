
<#
    .SYNOPSIS
        This will import Cloud Runtime assemblies
        
    .DESCRIPTION
        This will import Cloud Runtime assemblies. Power Automate part
        
    .EXAMPLE
        PS C:\> Invoke-CloudRuntimeAssembliesImport
        
    .NOTES
        General notes
        Author: Oleksandr Nikolaiev (@onikolaiev)
#>
function Invoke-CloudRuntimeAssembliesImport()
{
    Write-PSFMessage -Level Verbose -Message "Importing cloud runtime assemblies"
    $miscPath = Join-Path -Path $($Script:ModuleRoot) -ChildPath "\internal\misc"
    
    # Need load metadata.dll and any referenced ones, not flexible to pick the new added references
    $textEncodings = Join-Path $miscPath "\CloudRuntimeDlls\System.Text.Encodings.Web.dll"         #"System.Text.Encodings.Web.6.0.0\lib\net461\System.Text.Encodings.Web.dll"
    $tasksExtensions = Join-Path $miscPath "\CloudRuntimeDlls\System.Threading.Tasks.Extensions.dll" #"System.Threading.Tasks.Extensions.4.5.4\lib\net461\System.Threading.Tasks.Extensions.dll"
    $memory = Join-Path $miscPath "\CloudRuntimeDlls\System.Memory.dll"                     #"System.Memory.4.5.4\lib\net461\System.Memory.dll"
    $asyncInterfaces = Join-Path $miscPath "\CloudRuntimeDlls\Microsoft.Bcl.AsyncInterfaces.dll"     #"Microsoft.Bcl.AsyncInterfaces.6.0.0\lib\net461\Microsoft.Bcl.AsyncInterfaces.dll"
    $json = Join-Path $miscPath "\CloudRuntimeDlls\System.Text.Json.dll"                  #"System.Text.Json.6.0.2\lib\net461\System.Text.Json.dll"
    $xrmSdk = Join-Path $miscPath "\CloudRuntimeDlls\Microsoft.Xrm.Sdk.dll"                 #"Microsoft.CrmSdk.CoreAssemblies.9.0.2.45\lib\net462\Microsoft.Xrm.Sdk.dll"


    $activeDirectory = Join-Path $miscPath "\CloudRuntimeDlls\Microsoft.IdentityModel.Clients.ActiveDirectory.dll"                          #"Microsoft.IdentityModel.Clients.ActiveDirectory.3.19.8\lib\net45\Microsoft.IdentityModel.Clients.ActiveDirectory.dll"
    $сrmPackageExtentionBase = Join-Path $miscPath "\CloudRuntimeDlls\Microsoft.Xrm.Tooling.PackageDeployment.CrmPackageExtentionBase.dll"          #"Microsoft.CrmSdk.XrmTooling.PackageDeployment.Core.9.1.0.116\lib\net462\Microsoft.Xrm.Tooling.PackageDeployment.CrmPackageExtentionBase.dll"
    $сrmPackageCoreFinanceOperations = Join-Path $miscPath "\CloudRuntimeDlls\Microsoft.Xrm.Tooling.PackageDeployment.CrmPackageCore.FinanceOperations.dll" #"Microsoft.CrmSdk.XrmTooling.PackageDeployment.Core.9.1.0.116\lib\net462\Microsoft.Xrm.Tooling.PackageDeployment.CrmPackageCore.FinanceOperations.dll"
    $сrmPackageCore = Join-Path $miscPath "\CloudRuntimeDlls\Microsoft.Xrm.Tooling.PackageDeployment.CrmPackageCore.dll"                   #"Microsoft.CrmSdk.XrmTooling.PackageDeployment.Core.9.1.0.116\lib\net462\Microsoft.Xrm.Tooling.PackageDeployment.CrmPackageCore.dll"
    $shared = Join-Path $miscPath "\CloudRuntimeDlls\Microsoft.Dynamics.VSExtension.Shared.dll"                                    #"Microsoft.Dynamics.VSExtension.Shared.7.0.30011\lib\net472\Microsoft.Dynamics.VSExtension.Shared.dll"
    $applicationInsights = Join-Path $miscPath "\CloudRuntimeDlls\Microsoft.ApplicationInsights.dll"                                            #"Microsoft.ApplicationInsights.2.21.0\lib\net46\Microsoft.ApplicationInsights.dll"
    $vSSharedUtil = Join-Path $miscPath "\CloudRuntimeDlls\Microsoft.PowerPlatform.VSShared.Util.dll"                                                   #"PowerPlatSharedLibrary.1.0.0\lib\net472\PowerPlatSharedLibrary.dll"
    $connector = Join-Path $miscPath "\CloudRuntimeDlls\Microsoft.Xrm.Tooling.Connector.dll"                                          #"Microsoft.CrmSdk.XrmTooling.CoreAssembly.9.1.1.27\lib\net462\Microsoft.Xrm.Tooling.Connector.dll"
    $newtonsoft = Join-Path $miscPath "\CloudRuntimeDlls\Newtonsoft.Json.dll"                                                          #"Newtonsoft.Json.13.0.1\lib\net45\Newtonsoft.Json.dll"
    $telemetry2 = Join-Path $miscPath "\CloudRuntimeDlls\Microsoft.Dynamics.AX.DesignTime.Telemetry2.dll"                              #"Microsoft.Dynamics.AX.DesignTime.Telemetry2.7.0.30004\lib\net462\Microsoft.Dynamics.AX.DesignTime.Telemetry2.dll"

    # Load required dlls, loading should fail the script run with exceptions thrown
    [Reflection.Assembly]::LoadFile($textEncodings) > $null
    [Reflection.Assembly]::LoadFile($tasksExtensions) > $null
    [Reflection.Assembly]::LoadFile($memory) > $null
    [Reflection.Assembly]::LoadFile($asyncInterfaces) > $null
    [Reflection.Assembly]::LoadFile($json) > $null
    [Reflection.Assembly]::LoadFile($xrmSdk) > $null
    [Reflection.Assembly]::LoadFile($activeDirectory) > $null
    [Reflection.Assembly]::LoadFile($сrmPackageExtentionBase) > $null
    [Reflection.Assembly]::LoadFile($сrmPackageCoreFinanceOperations) > $null
    [Reflection.Assembly]::LoadFile($сrmPackageCore) > $null
    [Reflection.Assembly]::LoadFile($shared) > $null
    [Reflection.Assembly]::LoadFile($applicationInsights) > $null
    [Reflection.Assembly]::LoadFile($vSSharedUtil) > $null
    [Reflection.Assembly]::LoadFile($connector) > $null
    [Reflection.Assembly]::LoadFile($newtonsoft) > $null
    [Reflection.Assembly]::LoadFile($telemetry2) > $null
}