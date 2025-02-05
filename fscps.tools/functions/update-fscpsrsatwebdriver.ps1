
<#
    .SYNOPSIS
        Update the web drivers for Microsoft Edge and Google Chrome browsers.
        
    .DESCRIPTION
        This function checks the specified web drivers path. If the path doesn't exist, it uses a default path. It defines registry paths and URLs, retrieves the local web driver versions, and checks if an update is needed based on version comparison.
        
        The function updates the web drivers for both Microsoft Edge and Google Chrome browsers by downloading the latest versions from their respective official websites and extracting the files to the specified path.
        
    .PARAMETER webDriversPath
        The path where the web drivers are located. Default is "C:\Program Files (x86)\Regression Suite Automation Tool\Common\External\Selenium".
        
    .EXAMPLE
        Update-FSCPSRSATWebDriver -webDriversPath "C:\CustomPath\WebDrivers"

        This example will update the webdrivers for the RSAT tool located at the specified path.
#>

function Update-FSCPSRSATWebDriver {
    param (
        [string]$webDriversPath = "C:\Program Files (x86)\Regression Suite Automation Tool\Common\External\Selenium"
    )

    if (Test-Path $webDriversPath) {
        Write-Host "Web drivers path exists. Going to update the drivers."
    } else {
        $webDriversPath = "C:\Program Files\Regression Suite Automation Tool\Common\External\Selenium"
    }

    # Define registry paths and URLs
    $registryRoot        = "Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths"
    $edgeRegistryPath    = "$registryRoot\msedge.exe"
    $chromeRegistryPath  = "$registryRoot\chrome.exe"
    $edgeDriverPath      = "$webDriversPath\msedgedriver.exe"
    $chromeDriverPath    = "$webDriversPath\chromedriver.exe"
    $chromeDriverWebsite = "https://chromedriver.chromium.org/downloads"
    $chromeDriverUrlBase = "https://chromedriver.storage.googleapis.com"
    $chromeDriverUrlEnd  = "chromedriver_win32.zip"

    # Function to check driver version
    function Get-LocalDriverVersion{
        param(
            $pathToDriver                                               # direct path to the driver
        )
        try{
            $processInfo = New-Object System.Diagnostics.ProcessStartInfo   # need to pass the switch & catch the output, hence ProcessStartInfo is used

            $processInfo.FileName               = $pathToDriver
            $processInfo.RedirectStandardOutput = $true                     # need to catch the output - the version
            $processInfo.Arguments              = "-v"
            $processInfo.UseShellExecute        = $false                    # hide execution

            $process = New-Object System.Diagnostics.Process

            $process.StartInfo  = $processInfo
            $process.Start()    | Out-Null
            $process.WaitForExit()                                          # run synchronously, we need to wait for result
            $processStOutput    = $process.StandardOutput.ReadToEnd()

            if ($pathToDriver.Contains("msedgedriver")){
                return ($processStOutput -split " ")[3]                     # MS Edge returns version on 4th place in the output (be carefulm in old versions it was on 1st as well)... 
            }
            else {
                return ($processStOutput -split " ")[1]                     # ... while Chrome on 2nd place
            }
        }
        catch{}
    }
    # Function to evaluate if update is needed
    function Confirm-NeedForUpdate {
        param(
            [string]$v1,
            [string]$v2
        )
        if ([string]::IsNullOrWhiteSpace($v1) -or [string]::IsNullOrWhiteSpace($v2)) {
            return $false
        }
        $idx1 = $v1.LastIndexOf(".")
        $idx2 = $v2.LastIndexOf(".")
        if ($idx1 -lt 0 -or $idx2 -lt 0) {
            return $false
        }
        return $v1.Substring(0, $idx1) -ne $v2.Substring(0, $idx2)
    }

    # Function to update MS Edge driver
    function Update-EdgeDriver {
        param(
            [string]$EdgeVersion = (Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\EdgeUpdate\Clients\{F72FE3AA-9273-47A7-B9C2-5A379BFC7060}" -ErrorAction SilentlyContinue).pv,
            [Parameter(Mandatory=$true)]
            [string]$edgeDriverPath
        )
        if (-not $EdgeVersion) {
            Write-Error "Cannot retrieve installed Edge version."
            return
        }
    
        # Extract major version
        $baseUrl = "https://msedgedriver.azureedge.net"
        $driverZipUrl = "$baseUrl/$EdgeVersion/edgedriver_win64.zip"
        # Validate URL
        try {
            $response = Invoke-WebRequest -Uri $driverZipUrl -Method Head -ErrorAction Stop
        }
        catch {
            Write-Error "EdgeDriver download URL invalid or inaccessible."
            return
        }
    
        # Download and unzip
        $zipPath = Join-Path $env:TEMP "edgedriver_win64.zip"
        Invoke-WebRequest -Uri $driverZipUrl -OutFile $zipPath -UseBasicParsing
        Expand-Archive -Path $zipPath -DestinationPath $edgeDriverPath -Force
        Remove-Item $zipPath
    
        # (Optional) Update PATH
        Write-Host "EdgeDriver updated at $edgeDriverPath"
    }

    # Function to update Chrome driver
    
    function Update-ChromeDriver {
        param(
            [Parameter(Mandatory=$false)]
            [string]$chromeVersion = $null,
            [Parameter(Mandatory=$false)]
            [string]$chromeDriverWebsite = "https://chromedriver.chromium.org/downloads",
            [Parameter(Mandatory=$false)]
            [string]$chromeDriverUrlBase = "https://chromedriver.storage.googleapis.com",
            [Parameter(Mandatory=$false)]
            [string]$chromeDriverUrlEnd = "chromedriver_win32.zip",
            [Parameter(Mandatory=$false)]
            [string]$webDriversPath = "C:\WebDrivers"
        )
    $chromeDriverUrl = "https://storage.googleapis.com/chrome-for-testing-public/$chromeVersion/win64/chromedriver-win64.zip"
    $zipPath = Join-Path $env:TEMP "chromedriver_win32.zip"

    try {
        Write-Host "Downloading ChromeDriver version $exactOrFallbackVersion..."
        Invoke-WebRequest -Uri $chromeDriverUrl -OutFile $zipPath -UseBasicParsing
        # epand archive and replace the old file
        Expand-Archive -Path $zipPath -DestinationPath "$env:TEMP/chromeNewDriver/"  -Force        
        Move-Item      "$env:TEMP/chromeNewDriver/chromedriver-win64/chromedriver.exe" -Destination     "$($webDriversPath)\chromedriver.exe" -Force

        # clean-up
        #Remove-Item "$env:TEMP/chromedriver-win64.zip" -Force
        Remove-Item "$env:TEMP/chromeNewDriver" -Recurse -Force



        Remove-Item $zipPath
        Write-Host "ChromeDriver installed at $webDriversPath."
    }
    catch {
        Write-Error "No matching version found for download."
    }
    }

# Main script
$edgeVersion = (Get-Item (Get-ItemProperty $edgeRegistryPath).'(Default)').VersionInfo.ProductVersion
$chromeVersion = (Get-Item (Get-ItemProperty $chromeRegistryPath).'(Default)').VersionInfo.ProductVersion
$edgeDriverVersion = Get-LocalDriverVersion -pathToDriver $edgeDriverPath
$chromeDriverVersion = Get-LocalDriverVersion -pathToDriver $chromeDriverPath

if (-not (Test-Path $edgeDriverPath)) {
    Write-Host "EdgeDriver not found. Downloading..."
    Update-EdgeDriver -edgeVersion $edgeVersion -edgeDriverPath $webDriversPath
}
elseif ($edgeVersion -and $edgeDriverVersion -and (Confirm-NeedForUpdate -v1 $edgeVersion -v2 $edgeDriverVersion)) {
    Update-EdgeDriver -edgeVersion $edgeVersion -edgeDriverPath $webDriversPath
}

if (-not (Test-Path $chromeDriverPath)) {
    Write-Host "ChromeDriver not found. Downloading..."
    Update-ChromeDriver -chromeVersion $chromeVersion -webDriversPath $webDriversPath
}
elseif ($chromeVersion -and $chromeDriverVersion -and (Confirm-NeedForUpdate -v1 $chromeVersion -v2 $chromeDriverVersion)) {
   Update-ChromeDriver -chromeVersion $chromeVersion -webDriversPath $webDriversPath
}
}