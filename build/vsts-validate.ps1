param (
    $TestGeneral = $true,
	
    $TestFunctions = $true,

	$Exclude = ""

)

# Guide for available variables and working with secrets:
# https://docs.microsoft.com/en-us/vsts/build-release/concepts/definitions/build/variables?tabs=powershell

# Needs to ensure things are Done Right and only legal commits to master get built

# Run internal pester tests

Write-Host "Working on the machine named: $($env:computername)"
Write-Host "The user running is: $($env:UserName)"

#region Installing d365fo.tools and dbatools <--
Write-Host "Installing required PowerShell modules" -ForegroundColor Yellow
[Net.ServicePointManager]::SecurityProtocol = [Net.ServicePointManager]::SecurityProtocol -bor [Net.SecurityProtocolType]::Tls12
#Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force -Scope AllUsers
$modules = @("PSFramework", "PSScriptAnalyzer", "Az.Storage", "PoshRSJob", "PSNotification", "d365fo.tools", "Invoke-MsBuild", "dbatools")
#Register-PSRepository -Default -Verbose
Set-PSRepository -Name PSGallery -InstallationPolicy Trusted
$modules | ForEach-Object {
    if ($_ -eq "Az") {
        Set-ExecutionPolicy RemoteSigned CurrentUser -Force
        try {
            Uninstall-AzureRm 
        } catch {
            Write-Host "AzureRm module is not installed or an error occurred during uninstallation."
        }
    }
    if (-not (Get-InstalledModule -Name $_ -ErrorAction SilentlyContinue)) {
        Write-Host "Installing module $_"
        Install-Module $_ -Force -AllowClobber | Out-Null
    }
}
$modules | ForEach-Object {
    Write-Host "Importing module $_"
    Import-Module $_ -DisableNameChecking -WarningAction SilentlyContinue | Out-Null
}
Set-DbatoolsConfig -Name Import.EncryptionMessageCheck -Value $false -PassThru | Register-DbatoolsConfig
Set-DbatoolsConfig -FullName 'sql.connection.trustcert' -Value $true -Register
#endregion Installing d365fo.tools and dbatools -->

Import-Module "Pester" -MaximumVersion 5.5.0 -Force

& "$PSScriptRoot\..\fscps.tools\tests\pester.ps1" -TestGeneral $TestGeneral -TestFunctions $TestFunctions -Exclude $Exclude