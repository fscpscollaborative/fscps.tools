
<#
    .SYNOPSIS
        Invoke the D365Commerce compilation
        
    .DESCRIPTION
        Invoke the D365Commerce compilation
        
    .PARAMETER Version
        The version of the D365Commerce used to build
        
    .PARAMETER SourcesPath
        The folder contains a metadata files with binaries
        
    .PARAMETER BuildFolderPath
        The destination build folder
        
    .PARAMETER Force
        Cleanup destination build folder befor build
        
    .EXAMPLE
        PS C:\> Invoke-FSCPSCompile -Version 10.0.39
        
        Example output:
        
        BUILD_FOLDER_PATH : c:\temp\fscps.tools\_bld\10.0.39_build
        BUILD_LOG_FILE_PATH  : C:\Users\Administrator\AppData\Local\Temp\ScaleUnit.sln.msbuild.log
        CSU_ZIP_PATH      : c:\temp\fscps.tools\_bld\artifacts\CloudScaleUnitExtensionPackage.Master-ContosoForD365Commerce-10.0.39_20240530.48.zip
        HW_INSTALLER_PATH : c:\temp\fscps.tools\_bld\artifacts\Contoso.HardwareStation.Installer.Master-ContosoForD365Commerce-10.0.39_20240530.48.exe
        SC_INSTALLER_PATH : c:\temp\fscps.tools\_bld\artifacts\Contoso.StoreCommerce.Installer.Master-ContosoForD365Commerce-10.0.39_20240530.48.exe
        SU_INSTALLER_PATH : c:\temp\fscps.tools\_bld\artifacts\Contoso.ScaleUnit.Installer.Master-ContosoForD365Commerce-10.0.39_20240530.48.exe
        PACKAGE_NAME      : Master-ContosoForD365Commerce-10.0.39_20240530.48
        ARTIFACTS_PATH    : c:\temp\fscps.tools\_bld\artifacts
        ARTIFACTS_LIST    : ["C:\\temp\\fscps.tools\\_bld\\artifacts\\CloudScaleUnitExtensionPackage.Master-ContosoForD365Commerce-10.0.39_20240530.48.zip",
        "C:\\temp\\fscps.tools\\_bld\\artifacts\\POS.2.2.63.1.nupkg",
        "C:\\temp\\fscps.tools\\_bld\\artifacts\\Contoso.Commerce.Runtime.Master-ContosoForD365Commerce-10.2.2.63.1.nupkg",
        "C:\\temp\\fscps.tools\\_bld\\artifacts\\Contoso.HardwareStation.Installer.Master-ContosoForD365Commerce-10.0.39_20240530.48.exe",
        "C:\\temp\\fscps.tools\\_bld\\artifacts\\Contoso.ScaleUnit.2.2.63.1.nupkg",
        "C:\\temp\\fscps.tools\\_bld\\artifacts\\Contoso.ScaleUnit.Installer.Master-ContosoForD365Commerce-10.0.39_20240530.48.exe",
        "C:\\temp\\fscps.tools\\_bld\\artifacts\\Contoso.StoreCommerce.Installer.Master-ContosoForD365Commerce-10.0.39_20240530.48.exe",
        "C:\\temp\\fscps.tools\\_bld\\artifacts\\ContosoAddressWebService.2.2.63.1.nupkg",
        "C:\\temp\\fscps.tools\\_bld\\artifacts\\ContosoWebService.2.2.63.1.nupkg"]
        
        This will build D365FSC package with version "10.0.39" to the Temp folder
        
    .EXAMPLE
        PS C:\> Invoke-FSCPSCompile -SourcesPath "D:\Sources\connector-d365-commerce\"
        
        Example output:
        
        BUILD_FOLDER_PATH : c:\temp\fscps.tools\_bld\10.0.39_build
        BUILD_LOG_FILE_PATH  : C:\Users\Administrator\AppData\Local\Temp\ScaleUnit.sln.msbuild.log
        CSU_ZIP_PATH      : c:\temp\fscps.tools\_bld\artifacts\CloudScaleUnitExtensionPackage.Master-ContosoForD365Commerce-10.0.39_20240530.48.zip
        HW_INSTALLER_PATH : c:\temp\fscps.tools\_bld\artifacts\Contoso.HardwareStation.Installer.Master-ContosoForD365Commerce-10.0.39_20240530.48.exe
        SC_INSTALLER_PATH : c:\temp\fscps.tools\_bld\artifacts\Contoso.StoreCommerce.Installer.Master-ContosoForD365Commerce-10.0.39_20240530.48.exe
        SU_INSTALLER_PATH : c:\temp\fscps.tools\_bld\artifacts\Contoso.ScaleUnit.Installer.Master-ContosoForD365Commerce-10.0.39_20240530.48.exe
        PACKAGE_NAME      : Master-ContosoForD365Commerce-10.0.39_20240530.48
        ARTIFACTS_PATH    : c:\temp\fscps.tools\_bld\artifacts
        ARTIFACTS_LIST    : ["C:\\temp\\fscps.tools\\_bld\\artifacts\\CloudScaleUnitExtensionPackage.Master-ContosoForD365Commerce-10.0.39_20240530.48.zip",
        "C:\\temp\\fscps.tools\\_bld\\artifacts\\POS.2.2.63.1.nupkg",
        "C:\\temp\\fscps.tools\\_bld\\artifacts\\Contoso.Commerce.Runtime.Master-ContosoForD365Commerce-10.2.2.63.1.nupkg",
        "C:\\temp\\fscps.tools\\_bld\\artifacts\\Contoso.HardwareStation.Installer.Master-ContosoForD365Commerce-10.0.39_20240530.48.exe",
        "C:\\temp\\fscps.tools\\_bld\\artifacts\\Contoso.ScaleUnit.2.2.63.1.nupkg",
        "C:\\temp\\fscps.tools\\_bld\\artifacts\\Contoso.ScaleUnit.Installer.Master-ContosoForD365Commerce-10.0.39_20240530.48.exe",
        "C:\\temp\\fscps.tools\\_bld\\artifacts\\Contoso.StoreCommerce.Installer.Master-ContosoForD365Commerce-10.0.39_20240530.48.exe",
        "C:\\temp\\fscps.tools\\_bld\\artifacts\\ContosoAddressWebService.2.2.63.1.nupkg",
        "C:\\temp\\fscps.tools\\_bld\\artifacts\\ContosoWebService.2.2.63.1.nupkg"]
        
        This will build D365FSC package with version "10.0.39" to the Temp folder
        
    .NOTES
        Author: Oleksandr Nikolaiev (@onikolaiev)
        
#>

function Invoke-CommerceCompile {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseShouldProcessForStateChangingFunctions", "")]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSAvoidUsingInvokeExpression", "")]
    [CmdletBinding()]
    [OutputType([System.Collections.Specialized.OrderedDictionary])]
    param (
        [string] $Version,
        [Parameter(Mandatory = $true)]
        [string] $SourcesPath,
        [string] $BuildFolderPath = (Join-Path $script:DefaultTempPath _bld),
        [switch] $Force
    )

    BEGIN {
        Invoke-TimeSignal -Start
        $helperPath = Join-Path -Path $($Script:ModuleRoot) -ChildPath "\internal\scripts\helpers.ps1" -Resolve
        . ($helperPath)        
        try{
            $CMDOUT = @{
                Verbose = If ($PSBoundParameters.Verbose -eq $true) { $true } else { $false };
                Debug = If ($PSBoundParameters.Debug -eq $true) { $true } else { $false }
            }
            $responseObject = [Ordered]@{}
            Convert-FSCPSTextToAscii -Text "Reading current FSC-PS settings" -Font "Small" -BorderType DoubleDots -ScreenWigth 80 -HorizontalLayout Fitted
            $settings = Get-FSCPSSettings @CMDOUT
            Write-PSFMessage -Level Important -Message "Complete"
            #if($Force)
            #{
                Convert-FSCPSTextToAscii -Text "Cleanup build folder" -Font "Small" -BorderType DoubleDots -HorizontalLayout Fitted
                Remove-Item $BuildFolderPath -Recurse -Force -ErrorAction SilentlyContinue
                Write-PSFMessage -Level Important -Message "Complete"
            #}

            if($settings.artifactsPath -eq "")
            {
                $artifactDirectory = (Join-Path $BuildFolderPath $settings.artifactsFolderName)
            }
            else {
                $artifactDirectory = $settings.artifactsPath
            }

            Convert-FSCPSTextToAscii -Text "FSCPS $($settings.fscPsVer)" -Font "Big" -BorderType DoubleDots -HorizontalLayout Fitted 

            if (Test-Path -Path $artifactDirectory -ErrorAction SilentlyContinue)
            {
                Remove-Item -Path $artifactDirectory -Recurse -Force -ErrorAction SilentlyContinue
                
            }

            if (!(Test-Path -Path $artifactDirectory))
            {
                $null = [System.IO.Directory]::CreateDirectory($artifactDirectory)
            }
            Get-ChildItem $artifactDirectory -Recurse
            if($Version -eq "")
            {
                $Version = $settings.buildVersion
            }

            if($Version -eq "")
            {
                throw "D365FSC Version should be specified."
            }            

            # Gather version info
            #$versionData = Get-FSCPSVersionInfo -Version $Version @CMDOUT

            $SolutionBuildFolderPath = (Join-Path $BuildFolderPath "$($Version)_build")
            $responseObject.BUILD_FOLDER_PATH = $SolutionBuildFolderPath
        }
        catch {
            Write-PSFMessage -Level Host -Message "Error: " -Exception $PSItem.Exception
            Stop-PSFFunction -Message "Stopping because of errors" -EnableException $true
            return
        }
        finally{
            
        }
    }
    
    PROCESS {
        if (Test-PSFFunctionInterrupt) { return }
        [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
        try {               
            Convert-FSCPSTextToAscii -Text "Copy source files to the build folder" -Font "Small" -BorderType DoubleDots -HorizontalLayout Fitted -ScreenWigth 110           
            $null = Test-PathExists -Path $BuildFolderPath -Type Container -Create @CMDOUT
            $null = Test-PathExists -Path $SolutionBuildFolderPath -Type Container -Create @CMDOUT
            Copy-Item $SourcesPath\* -Destination $SolutionBuildFolderPath -Recurse -Force @CMDOUT
            Write-PSFMessage -Level Important -Message "Complete"

            Convert-FSCPSTextToAscii -Text "Build the solution" -Font "Small" -BorderType DoubleDots -HorizontalLayout Fitted

            $msbuildpath = & "C:\Program Files (x86)\Microsoft Visual Studio\Installer\vswhere.exe" -products * -requires Microsoft.Component.MSBuild -property installationPath -latest

            $origLocation = Get-Location
            Set-Location $SolutionBuildFolderPath

            if($msbuildpath -ne "")
            {
                $msbuildexepath = Join-Path $msbuildpath "MSBuild\Current\Bin\MSBuild.exe"
                $msbuildresult = Invoke-MsBuild -Path (Join-Path $SolutionBuildFolderPath $settings.solutionName) -MsBuildParameters "/t:restore,rebuild /property:Configuration=Release /property:NuGetInteractive=true /property:BuildingInsideVisualStudio=false" -MsBuildFilePath "$msbuildexepath" -ShowBuildOutputInCurrentWindow -BypassVisualStudioDeveloperCommandPrompt @CMDOUT
            }
            else
            {
                $msbuildresult = Invoke-MsBuild -Path (Join-Path $SolutionBuildFolderPath $settings.solutionName) -MsBuildParameters "/t:restore,rebuild /property:Configuration=Release /property:NuGetInteractive=true /property:BuildingInsideVisualStudio=false" -ShowBuildOutputInCurrentWindow @CMDOUT
            }

            $responseObject.BUILD_LOG_FILE_PATH = $msbuildresult.BuildLogFilePath

            if ($msbuildresult.BuildSucceeded -eq $true)
            {
                Write-PSFMessage -Level Host -Message ("Build completed successfully in {0:N1} seconds." -f $msbuildresult.BuildDuration.TotalSeconds)
            }
            elseif ($msbuildresult.BuildSucceeded -eq $false)
            {
               throw ("Build failed after {0:N1} seconds. Check the build log file '$($msbuildresult.BuildLogFilePath)' for errors." -f $msbuildresult.BuildDuration.TotalSeconds)
            }
            elseif ($null -eq $msbuildresult.BuildSucceeded)
            {
                throw "Unsure if build passed or failed: $($msbuildresult.Message)"
            }
            Set-Location $origLocation
            if($settings.generatePackages)
            {
                Convert-FSCPSTextToAscii -Text "Generate package" -Font "Small" -BorderType DoubleDots -HorizontalLayout Fitted

                switch ($settings.namingStrategy) {
                    { $settings.namingStrategy -eq "Default" }
                    {
                        $packageNamePattern = $settings.packageNamePattern;
                        if($settings.packageName.Contains('.zip'))
                        {
                            $packageName = $settings.packageName
                        }
                        else {
                            $packageName = $settings.packageName
                        }
                        $packageNamePattern = $packageNamePattern.Replace("BRANCHNAME", $($settings.sourceBranch))
                        if($settings.deploy)
                        {
                            $packageNamePattern = $packageNamePattern.Replace("PACKAGENAME", $settings.azVMName)
                        }
                        else
                        {
                            $packageNamePattern = $packageNamePattern.Replace("PACKAGENAME", $packageName)
                        }
                        $packageNamePattern = $packageNamePattern.Replace("FNSCMVERSION", $Version)
                        $packageNamePattern = $packageNamePattern.Replace("DATE", (Get-Date -Format "yyyyMMdd").ToString())
                        
                        $packageNamePattern = $packageNamePattern.Replace("RUNNUMBER", $settings.runId)

                        $packageName = $packageNamePattern
                        break;
                    }
                    { $settings.namingStrategy -eq "Custom" }
                    {
                        if($settings.packageName.Contains('.zip'))
                        {
                            $packageName = $settings.packageName
                        }
                        else {
                            $packageName = $settings.packageName + ".zip"
                        }
                        
                        break;
                    }
                    Default {
                        $packageName = $settings.packageName
                        break;
                    }
                }             
                

                [System.IO.DirectoryInfo]$csuZipPackagePath = Get-ChildItem -Path $SolutionBuildFolderPath -Recurse | Where-Object {$_.FullName -match "bin.*.Release.*ScaleUnit.*.zip$"} | ForEach-Object {$_.FullName}
                [System.IO.DirectoryInfo]$hWSInstallerPath = Get-ChildItem -Path $SolutionBuildFolderPath -Recurse | Where-Object {$_.FullName -match "bin.*.Release.*HardwareStation.*.exe$"} | ForEach-Object {$_.FullName}
                [System.IO.DirectoryInfo]$sCInstallerPath = Get-ChildItem -Path $SolutionBuildFolderPath -Recurse | Where-Object {$_.FullName -match "bin.*.Release.*StoreCommerce.*.exe$"} | ForEach-Object {$_.FullName}
                [System.IO.DirectoryInfo]$sUInstallerPath = Get-ChildItem -Path $SolutionBuildFolderPath -Recurse | Where-Object {$_.FullName -match "bin.*.Release.*ScaleUnit.*.exe$"} | ForEach-Object {$_.FullName}
                
                Convert-FSCPSTextToAscii -Text "Copy packages to the artifacts folder" -Font "Small" -BorderType DoubleDots -HorizontalLayout Fitted 
                if($csuZipPackagePath)
                {    
                    Write-PSFMessage -Level Important -Message "CSU Package processing..."
                    Write-PSFMessage -Level Important -Message $csuZipPackagePath
                    if($settings.cleanupCSUPackage)
                    {
                        $null = [Reflection.Assembly]::LoadWithPartialName('System.IO.Compression')
                        $zipfile = $csuZipPackagePath
                        $stream = New-Object IO.FileStream($zipfile, [IO.FileMode]::Open)
                        $mode   = [IO.Compression.ZipArchiveMode]::Update
                        $zip    = New-Object IO.Compression.ZipArchive($stream, $mode)
                        ($zip.Entries | Where-Object { $_.Name -match 'Azure' }) | ForEach-Object { $_.Delete() }
                        ($zip.Entries | Where-Object { $_.Name -match 'Microsoft' }) | ForEach-Object { $_.Delete() }
                        ($zip.Entries | Where-Object { $_.Name -match 'System'  -and $_.Name -notmatch 'System.Runtime.Caching' -and $_.Name -notmatch 'System.ServiceModel.Http' -and $_.Name -notmatch 'System.ServiceModel.Primitives' -and $_.Name -notmatch 'System.Private.ServiceModel' -and $_.Name -notmatch 'System.Configuration.ConfigurationManager' -and $_.Name -notmatch 'System.Security.Cryptography.ProtectedData' -and $_.Name -notmatch 'System.Security.Permissions' -and $_.Name -notmatch 'System.Security.Cryptography.Xml' -and $_.Name -notmatch 'System.Security.Cryptography.Pkcs' }) | ForEach-Object { $_.Delete() }
                        ($zip.Entries | Where-Object { $_.Name -match 'Newtonsoft' }) | ForEach-Object { $_.Delete() }
                        $zip.Dispose()
                        $stream.Close()
                        $stream.Dispose()
                    }
                    $destinationFullName = (Join-Path $($artifactDirectory) "$(ClearExtension($csuZipPackagePath)).$($packageName).zip")
                    Copy-ToDestination -RelativePath $csuZipPackagePath.Parent.FullName -File $csuZipPackagePath.BaseName -DestinationFullName $destinationFullName
                    $responseObject.CSU_ZIP_PATH = $destinationFullName
                }
                if($hWSInstallerPath)
                {    
                    Write-PSFMessage -Level Important -Message "HW Package processing..."
                    Write-PSFMessage -Level Important -Message $hWSInstallerPath
                    $destinationFullName = (Join-Path $($artifactDirectory) "$(ClearExtension($hWSInstallerPath)).$($packageName).exe")
                    Copy-ToDestination -RelativePath $hWSInstallerPath.Parent.FullName -File $hWSInstallerPath.BaseName -DestinationFullName $destinationFullName
                    $responseObject.HW_INSTALLER_PATH = $destinationFullName
                }
                if($sCInstallerPath)
                {    
                    Write-PSFMessage -Level Important -Message "SC Package processing..."
                    Write-PSFMessage -Level Important -Message $sCInstallerPath
                    $destinationFullName = (Join-Path $($artifactDirectory) "$(ClearExtension($sCInstallerPath)).$($packageName).exe")
                    Copy-ToDestination -RelativePath $sCInstallerPath.Parent.FullName -File $sCInstallerPath.BaseName -DestinationFullName $destinationFullName
                    $responseObject.SC_INSTALLER_PATH = $destinationFullName
                }
                if($sUInstallerPath)
                {    
                    Write-PSFMessage -Level Important -Message "SU Package processing..."
                    Write-PSFMessage -Level Important -Message $sUInstallerPath
                    $destinationFullName = (Join-Path $($artifactDirectory) "$(ClearExtension($sUInstallerPath)).$($packageName).exe")
                    Copy-ToDestination -RelativePath $sUInstallerPath.Parent.FullName -File $sUInstallerPath.BaseName -DestinationFullName $destinationFullName
                    $responseObject.SU_INSTALLER_PATH = $destinationFullName
                }

                Convert-FSCPSTextToAscii -Text "Export NuGets" -Font "Small" -BorderType DoubleDots -HorizontalLayout Fitted
                Get-ChildItem -Path $BuildFolderPath -Recurse | Where-Object {$_.FullName -match "bin.*.Release.*.nupkg$"} | ForEach-Object {
                    if($settings.cleanupNugets)
                    {                
                        $zipfile = $_
                        # Cleanup NuGet file
                        $null = [Reflection.Assembly]::LoadWithPartialName('System.IO.Compression')            
                        $stream = New-Object IO.FileStream($zipfile.FullName, [IO.FileMode]::Open)
                        $mode   = [IO.Compression.ZipArchiveMode]::Update
                        $zip    = New-Object IO.Compression.ZipArchive($stream, $mode)
                        ($zip.Entries | Where-Object { $_.Name -match 'Azure' }) | ForEach-Object { $_.Delete() }
                        ($zip.Entries | Where-Object { $_.Name -match 'Microsoft' }) | ForEach-Object { $_.Delete() }
                        ($zip.Entries | Where-Object { $_.Name -match 'System' }) | ForEach-Object { $_.Delete() }
                        ($zip.Entries | Where-Object { $_.Name -match 'Newtonsoft' }) | ForEach-Object { $_.Delete() }
                        $zip.Dispose()
                        $stream.Close()
                        $stream.Dispose()
                    }
                    Copy-ToDestination -RelativePath $_.Directory -File $_.Name -DestinationFullName "$($artifactDirectory)\$($_.BaseName).nupkg"        
                }

                $responseObject.PACKAGE_NAME = $packageName
                $responseObject.ARTIFACTS_PATH = $artifactDirectory


                $artifacts = Get-ChildItem $artifactDirectory
                $artifactsList = $artifacts.FullName -join ","

                if($artifactsList.Contains(','))
                {
                    $artifacts = $artifactsList.Split(',') | ConvertTo-Json -compress
                }
                else
                {
                    $artifacts = '["'+$($artifactsList).ToString()+'"]'

                }

                $responseObject.ARTIFACTS_LIST = $artifacts
                        
            }
        }
        catch {
            Write-PSFMessage -Level Host -Message "Error: " -Exception $PSItem.Exception
            Stop-PSFFunction -Message "Stopping because of errors" -EnableException $true
            return
        }
        finally{
            try {
                if($SolutionBuildFolderPath)
                {
                    if (Test-Path -Path $SolutionBuildFolderPath -ErrorAction SilentlyContinue)
                    {
                        Remove-Item -Path $SolutionBuildFolderPath -Recurse -Force -ErrorAction SilentlyContinue
                    }
                }
                if($NuGetPackagesPath)
                {
                    if (Test-Path -Path $NuGetPackagesPath -ErrorAction SilentlyContinue)
                    {
                        Remove-Item -Path $NuGetPackagesPath -Recurse -Force -ErrorAction SilentlyContinue
                    }
                }
                if($outputDir)
                {
                    if (Test-Path -Path $outputDir -ErrorAction SilentlyContinue)
                    {
                        Remove-Item -Path $outputDir -Recurse -Force -ErrorAction SilentlyContinue
                    }
                }
                if($tempCombinedPackage)
                {
                    if (Test-Path -Path $tempCombinedPackage -ErrorAction SilentlyContinue)
                    {
                        Remove-Item -Path $tempCombinedPackage -Recurse -Force -ErrorAction SilentlyContinue
                    }
                }
                Set-Location $origLocation
            }
            catch {
                Write-PSFMessage -Level Verbose -Message "Cleanup warning: $($PSItem.Exception)" 
            }
            $responseObject
        }
    }
    END {
        Invoke-TimeSignal -End
    }
}