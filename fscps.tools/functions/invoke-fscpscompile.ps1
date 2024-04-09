
<#
    .SYNOPSIS
        Invoke the D365FSC models compilation
        
    .DESCRIPTION
        Invoke the D365FSC models compilation
        
    .PARAMETER Version
        The version of the D365FSC used to build
        
    .PARAMETER SourcesPath
        The folder contains a metadata files with binaries
        
    .PARAMETER BuildFolderPath
        The destination build folder
        
    .PARAMETER Force
        Cleanup destination build folder befor build
        
    .EXAMPLE
        PS C:\> Invoke-FSCPSCompile -Version "10.0.39"
        
        This will build D365FSC package with version "10.0.39" to the current folder
        
    .EXAMPLE
        PS C:\> Invoke-FSCPSCompile -Version "10.0.39" -Path "c:\Temp"
        
        This will build D365FSC package with version "10.0.39" to the Temp folder
        
    .NOTES
        Author: Oleksandr Nikolaiev (@onikolaiev)
        
#>

function Invoke-FSCPSCompile {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseShouldProcessForStateChangingFunctions", "")]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSAvoidUsingInvokeExpression", "")]
    [CmdletBinding()]
    param (
        [string] $Version,
        [Parameter(Mandatory = $true)]
        [string] $SourcesPath,
        [string] $BuildFolderPath = (Join-Path $script:DefaultTempPath _bld),
        [switch] $Force
    )

    BEGIN {
        Invoke-TimeSignal -Start
        try{
            $CMDOUT = @{
                Verbose = If ($PSBoundParameters.Verbose -eq $true) { $true } else { $false };
                Debug = If ($PSBoundParameters.Debug -eq $true) { $true } else { $false }
            }

            Write-PSFMessage -Level Important -Message "//=============================== Reading current FSC-PS settings ===============================//"
            $settings = Get-FSCPSSettings @CMDOUT
            if($Version -eq "")
            {
                $Version = $settings.buildVersion
            }
            if($Version -eq "")
            {
                throw "D365FSC Version should be specified."
            }
        # $settings | Select-PSFObject -TypeName "FSCPS.TOOLS.settings" "*"
            # Gather version info
            $versionData = Get-FSCPSVersionInfo -Version $Version @CMDOUT
            $PlatformVersion = $versionData.PlatformVersion
            $ApplicationVersion = $versionData.AppVersion

            $tools_package_name =  'Microsoft.Dynamics.AX.Platform.CompilerPackage.' + $PlatformVersion
            $plat_package_name =  'Microsoft.Dynamics.AX.Platform.DevALM.BuildXpp.' + $PlatformVersion
            $app_package_name =  'Microsoft.Dynamics.AX.Application.DevALM.BuildXpp.' + $ApplicationVersion
            $appsuite_package_name =  'Microsoft.Dynamics.AX.ApplicationSuite.DevALM.BuildXpp.' + $ApplicationVersion 

            $NuGetPackagesPath = (Join-Path $BuildFolderPath packages)
            $SolutionBuildFolderPath = (Join-Path $BuildFolderPath "$($Version)_build")
            $NuGetPackagesConfigFilePath = (Join-Path $SolutionBuildFolderPath packages.config)
            $NuGetConfigFilePath = (Join-Path $SolutionBuildFolderPath nuget.config)
            
            if(Test-Path "$($SourcesPath)/PackagesLocalDirectory")
            {
                $SourceMetadataPath = (Join-Path $($SourcesPath) "/PackagesLocalDirectory")
            }
            elseif(Test-Path "$($SourcesPath)/Metadata")
            {
                $SourceMetadataPath = (Join-Path $($SourcesPath) "/Metadata")
            }
            else {
                $SourceMetadataPath = $($SourcesPath)
            }
            
            $BuidPropsFile = (Join-Path $SolutionBuildFolderPath \Build\build.props)
            
            $msReferenceFolder = "$($NuGetPackagesPath)\$($app_package_name)\ref\net40;$($NuGetPackagesPath)\$($plat_package_name)\ref\net40;$($NuGetPackagesPath)\$($appsuite_package_name)\ref\net40;$($SourceMetadataPath);$($BuildFolderPath)\bin"
            $msBuildTasksDirectory = "$NuGetPackagesPath\$($tools_package_name)\DevAlm".Trim()
            $msMetadataDirectory = "$($SourceMetadataPath)".Trim()
            $msFrameworkDirectory = "$($NuGetPackagesPath)\$($tools_package_name)".Trim()
            $msReferencePath = "$($NuGetPackagesPath)\$($tools_package_name)".Trim()
            $msOutputDirectory = "$($BuildFolderPath)\bin".Trim()     

            Write-PSFMessage -Level Important -Message "//=============================== Getting the list of models to build ============================//"
            if($($settings.specifyModelsManually) -eq "true")
            {
                $mtdtdPath = ("$($SourcesPath)\$($settings.metadataPath)".Trim())
                $mdls = $($settings.models).Split(",")
                if($($settings.includeTestModel) -eq "true")
                {
                    $testModels = Get-FSCMTestModel -modelNames $($mdls -join ",") -metadataPath $mtdtdPath @CMDOUT
                    ($testModels.Split(",").ForEach({$mdls+=($_)}))
                }
                $models = $mdls -join ","
            }
            else {
                $models = Get-FSCModelList -MetadataPath $SourceMetadataPath -IncludeTest:($settings.includeTestModel -eq 'true') @CMDOUT
            }

            Write-PSFMessage -Level Important -Message "Models to build: $models"
        }
        catch {
            Write-PSFMessage -Level Host -Message "Something went wrong while compiling D365FSC package" -Exception $PSItem.Exception
            Stop-PSFFunction -Message "Stopping because of errors"
            return
        }
        finally{
            
        }
    }
    
    PROCESS {
        if (Test-PSFFunctionInterrupt) { return }
        [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
        try {            
            if($Force)
            {
                Write-PSFMessage -Level Important -Message "//=============================== Cleanup build folder ===========================================//"
                Remove-Item $BuildFolderPath -Recurse -Force -ErrorAction SilentlyContinue
            }

            Write-PSFMessage -Level Important -Message "//=============================== Generate solution folder =======================================//"
            Invoke-GenerateSolution -ModelsList $models -DynamicsVersion $Version -MetadataPath $SourceMetadataPath -SolutionFolderPath $BuildFolderPath @CMDOUT
            Write-PSFMessage -Level Important -Message "Generating complete"
    
            Write-PSFMessage -Level Important -Message "//=============================== Copy source files to the build folder ==========================//"            
            $null = Test-PathExists -Path $BuildFolderPath -Type Container -Create @CMDOUT
            $null = Test-PathExists -Path $SolutionBuildFolderPath -Type Container -Create @CMDOUT
            Copy-Item $SourcesPath\* -Destination $BuildFolderPath -Recurse -Force @CMDOUT
            #Copy-Item $SolutionBuildFolderPath -Destination $BuildFolderPath -Recurse -Force
            Write-PSFMessage -Level Important -Message "Copying complete"
    
            Write-PSFMessage -Level Important -Message "//=============================== Download NuGet packages ========================================//"
            if($settings.useLocalNuGetStorage)
            {
                $null = Test-PathExists -Path $NuGetPackagesPath -Type Container -Create @CMDOUT
                Get-FSCPSNuget -Version $PlatformVersion -Type PlatformCompilerPackage -Path $NuGetPackagesPath @CMDOUT
                Get-FSCPSNuget -Version $PlatformVersion -Type PlatformDevALM -Path $NuGetPackagesPath @CMDOUT
                Get-FSCPSNuget -Version $ApplicationVersion -Type ApplicationDevALM -Path $NuGetPackagesPath @CMDOUT
                Get-FSCPSNuget -Version $ApplicationVersion -Type ApplicationSuiteDevALM -Path $NuGetPackagesPath @CMDOUT
            }
            Write-PSFMessage -Level Important -Message "NuGet`s downloading complete"

            Write-PSFMessage -Level Important -Message "//=============================== Install NuGet packages ========================================//"
            #validata NuGet installation
            $nugetPath = Get-PSFConfigValue -FullName "fscps.tools.path.nuget"
            if(-not (Test-Path $nugetPath))
            {
                Install-FSCPSNugetCLI
            }
            ##update nuget config file
            $nugetNewContent = (Get-Content $NuGetConfigFilePath).Replace('c:\temp\packages', $NuGetPackagesPath)
            Set-Content $NuGetConfigFilePath $nugetNewContent
                
            & $nugetPath restore $NuGetPackagesConfigFilePath -PackagesDirectory $NuGetPackagesPath -ConfigFile $NuGetConfigFilePath
            Write-PSFMessage -Level Important -Message "NuGet`s installation complete"

            Write-PSFMessage -Level Important -Message "//=============================== Copy binaries to the build folder =============================//"
            Copy-Filtered -Source $SourceMetadataPath -Target (Join-Path $BuildFolderPath bin) -Filter *.*
            Write-PSFMessage -Level Important -Message "Copying binaries complete"

            Write-PSFMessage -Level Important -Message "//=============================== Build solution ================================================//"
            Set-Content $BuidPropsFile (Get-Content $BuidPropsFile).Replace('ReferenceFolders', $msReferenceFolder)

            $msbuildresult = Invoke-MsBuild -Path (Join-Path $SolutionBuildFolderPath "\Build\Build.sln") -P "/p:BuildTasksDirectory=$msBuildTasksDirectory /p:MetadataDirectory=$msMetadataDirectory /p:FrameworkDirectory=$msFrameworkDirectory /p:ReferencePath=$msReferencePath /p:OutputDirectory=$msOutputDirectory" -ShowBuildOutputInCurrentWindow @CMDOUT

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

        }
        catch {
            Write-PSFMessage -Level Host -Message "Something went wrong while compiling D365FSC package" -Exception $PSItem.Exception
            Stop-PSFFunction -Message "Stopping because of errors"
            return
        }
        finally{
            
        }
    }
    END {
        Invoke-TimeSignal -End
    }
}