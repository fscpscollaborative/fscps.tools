Write-Host "Working on the machine named: $($env:computername)"
Write-Host "The user running is: $($env:UserName)"

Install-Module "Pester" -Force -Scope CurrentUser -AllowClobber -SkipPublisherCheck

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
