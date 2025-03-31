$Script:TimeSignals = @{ }

Write-PSFMessage -Level Verbose -Message "Gathering all variables to assist the different cmdlets to function"

$serviceDrive = ($env:ServiceDrive) -replace " ", ""

# When a local Tier1 machine is domain joined, the domain users will not have the %ServiceDrive% environment variable
if ([system.string]::IsNullOrEmpty($serviceDrive)) {
    $serviceDrive = "c:"

   # Write-PSFMessage -Level Host -Message "Unable to locate the %ServiceDrive% environment variable. It could indicate that the machine is either not configured with D365FO or that you have domain joined a local Tier1. We have defaulted to <c='em'>c:\</c>"
   # Write-PSFMessage -Level Host -Message "This message will show every time you load the module. If you want to silence this message, please add the ServiceDrive environment variable by executing this command (remember to restart the console afterwards):"
   # Write-PSFHostColor -String '<c="em">[Environment]::SetEnvironmentVariable("ServiceDrive", "C:", "Machine")</c>'
}

$script:ServiceDrive = $serviceDrive

$Script:IsAdminRuntime = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

$Script:WebConfig = "web.config"

$Script:DevConfig = "DynamicsDevConfig.xml"

$Script:WifConfig = "wif.config"

$Script:WifServicesConfig = "wif.services.config"

$Script:Hosts = 'C:\Windows\System32\drivers\etc\hosts'

$Script:DefaultAOSName = 'usnconeboxax1aos'

$Script:IISHostFile = 'C:\Windows\System32\inetsrv\Config\applicationHost.config'

$Script:MRConfigFile = 'C:\FinancialReporting\Server\ApplicationService\bin\MRServiceHost.settings.config'

$Script:IsOnGitHub = $null -ne $env:GITHUB_REPOSITORY

$Script:IsOnAzureDevOps = $null -ne $env:AGENT_ID

$Script:IsOnLocalhost = -not $Script:IsOnGitHub -and -not $Script:IsOnAzureDevOps

#Update all module variables
Update-ModuleVariables

$environment = Get-ApplicationEnvironment

$Script:AOSPath = $environment.Aos.AppRoot

$dataAccess = $environment.DataAccess

$Script:DatabaseServer = $dataAccess.DbServer

$Script:DatabaseName = $dataAccess.Database

$Script:BinDir = $environment.Common.BinDir

$Script:PackageDirectory = $environment.Aos.PackageDirectory

$Script:MetaDataDir = $environment.Aos.MetadataDirectory

$Script:BinDirTools = $environment.Common.DevToolsBinDir

$Script:ServerRole = [ServerRole]::Unknown
$RoleVaule = $(If ($environment.Monitoring.MARole -eq "" -or $environment.Monitoring.MARole -eq "dev") { "Development" } Else { $environment.Monitoring.MARole })

if ($null -ne $RoleVaule) {
    $Script:ServerRole = [ServerRole][Enum]::Parse([type]"ServerRole", $RoleVaule, $true);
}

$Script:EnvironmentType = [EnvironmentType]::Unknown
$Script:CanUseTrustedConnection = $false
if ($environment.Infrastructure.HostName -like "*cloud.onebox.dynamics.com*") {
    $Script:EnvironmentType = [EnvironmentType]::LocalHostedTier1
    $Script:CanUseTrustedConnection = $true
}
elseif ($environment.Infrastructure.HostName -match "(cloudax|axcloud).*dynamics.com") {
    $Script:EnvironmentType = [EnvironmentType]::AzureHostedTier1
    $Script:CanUseTrustedConnection = $true
}
elseif ($environment.Infrastructure.HostName -like "*sandbox.ax.dynamics.com*") {
    $Script:EnvironmentType = [EnvironmentType]::MSHostedTier1
    $Script:CanUseTrustedConnection = $true
}
elseif ($environment.Infrastructure.HostName -like "*sandbox.operations.*dynamics.com*") {
    $Script:EnvironmentType = [EnvironmentType]::MSHostedTier2
}

$Script:Url = $environment.Infrastructure.HostUrl
$Script:DatabaseUserName = $dataAccess.SqlUser
$Script:DatabaseUserPassword = $dataAccess.SqlPwd
$Script:Company = "DAT"

$Script:IsOnebox = $environment.Common.IsOneboxEnvironment

$RegSplat = @{
    Path = "HKLM:\SOFTWARE\Microsoft\Dynamics\Deployment\"
    Name = "InstallationInfoDirectory"
}

$RegValue = $( if (Test-RegistryValue @RegSplat) { Join-Path (Get-ItemPropertyValue @RegSplat) "InstallationRecords" } else { "" } )
$Script:InstallationRecordsDir = $RegValue

$Script:UserIsAdmin = $env:UserName -like "*admin*"

$Script:TfDir = "C:\Program Files (x86)\Microsoft Visual Studio 14.0\Common7\IDE\"

$Script:SQLTools = "C:\Program Files (x86)\Microsoft SQL Server\130\Tools\Binn"

$Script:SSRSTools = "C:\Program Files\Microsoft SQL Server Reporting Services\Shared Tools"

$Script:DefaultTempPath = "c:\temp\fscps.tools"

$Script:MediaTypesPath = "C:\temp\fscps.tools\mediatypes\mediatypes.json"

#default nuget storage account settings
$Script:NuGetStorageAccountName = "ciellosarchive"
$Script:NuGetStorageContainer = "nuget"
$Script:NuGetStorageSASToken = "sp=rl&st=2024-04-26T01:44:36Z&se=2034-04-26T09:44:36Z&spr=https&sv=2022-11-02&sr=c&sig=svD1T8qTAFTb8MmquBQ3ljWP83FNJ5ev5gPuQUpNmEE%3D"
$Script:ModelsCacheStorageAccountName = "ciellosarchive"
$Script:ModelsCacheStorageContainer = "models-hash"
$Script:ModelsCacheStorageSASToken = "sp=racwdl&st=2024-04-26T21:17:33Z&se=2034-04-27T05:17:33Z&spr=https&sv=2022-11-02&sr=c&sig=YQj8BKjGyZoqheoe9MqCcUEnqPy7Twtfd0ZTq1e9%2BfQ%3D"
$Script:PackageStorageAccountName = "ciellosarchive"
$Script:PackageStorageContainer = "deployablepackages"
$Script:PackageStorageSASToken = "sp=rl&st=2025-02-10T11:04:46Z&se=2035-02-10T19:04:46Z&spr=https&sv=2022-11-02&sr=c&sig=IjAL%2Fp2RVaKJHsOV%2FJ5wmIQTTY7hDRyDDaqhHBh3KSc%3D"

foreach ($item in (Get-PSFConfig -FullName fscps.tools.active*)) {
    $nameTemp = $item.FullName -replace "^fscps.tools.", ""
    $name = ($nameTemp -Split "\." | ForEach-Object { (Get-Culture).TextInfo.ToTitleCase($_) } ) -Join ""
    
    New-Variable -Name $name -Value $item.Value -Scope Script -Force
}

#Active LCS Upload config extraction
Update-LcsApiVariables

$maskOutput = @(
    "AccessToken",
    "AzureStorageAccessToken",
    "Token",
    "BearerToken",
    "Password",
    "RefreshToken",
    "SAS"
    "AzureStorageSAS"
)

#init
Init-AzureStorageDefault

#Active broadcast message config extraction
#Update-BroadcastVariables

#Update different PSF Configuration variables values
Update-PsfConfigVariables

#Active Azure Storage Configuration variables values
Update-AzureStorageVariables



(Get-Variable -Scope Script) | ForEach-Object {
    $val = $null

    if ($maskOutput -contains $($_.Name)) {
        $val = "The variable was found - [...REDACTED...]"
    }
    else {
        $val = $($_.Value)
    }
   
    Write-PSFMessage -Level Verbose -Message "$($_.Name) - $val" -Target $val -FunctionName "Variables.ps1"
}

Write-PSFMessage -Level Verbose -Message "Finished outputting all the variable content."