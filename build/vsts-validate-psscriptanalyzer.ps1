param (
    $TestPublic = $true,
	
    $TestInternal = $true
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
Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force -Scope AllUsers
$modules = @("PSFramework", "PSScriptAnalyzer", "Az.Storage", "PSNotification", "PSOAuthHelper", "ImportExcel", "d365fo.tools", "Invoke-MsBuild","dbatools")
#Register-PSRepository -Default -Verbose
Set-PSRepository -Name PSGallery -InstallationPolicy Trusted
foreach ($module in  $modules) {
        Write-Host "..working on module" $module -ForegroundColor Yellow
        if ($null -eq $(Get-Command -Module $module)) {
            Write-Host "....installing module" $module -ForegroundColor Gray
            Install-Module -Name $module -SkipPublisherCheck -Scope AllUsers -AllowClobber
        }
        else {
            Write-Host "....updating module" $module -ForegroundColor Gray
            Update-Module -Name $module
        }
}
Set-DbatoolsConfig -Name Import.EncryptionMessageCheck -Value $false -PassThru | Register-DbatoolsConfig
Set-DbatoolsConfig -FullName 'sql.connection.trustcert' -Value $true -Register
#endregion Installing d365fo.tools and dbatools -->

Import-Module "Pester" -MaximumVersion 4.99.99 -Force

& "$PSScriptRoot\..\fscps.tools\tests\pester-PSScriptAnalyzer.ps1" -TestPublic $TestPublic -TestInternal $TestInternal