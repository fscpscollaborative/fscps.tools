
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
        PS C:\> Invoke-FSCCompile -Version "10.0.39"
        
        Example output:
        
        METADATA_DIRECTORY  : D:\a\8\s\Metadata
        FRAMEWORK_DIRECTORY : C:\temp\buildbuild\packages\Microsoft.Dynamics.AX.Platform.CompilerPackage.7.0.7120.99
        BUILD_OUTPUT_DIRECTORY    : C:\temp\buildbuild\bin
        NUGETS_FOLDER    : C:\temp\buildbuild\packages
        BUILD_LOG_FILE_PATH     : C:\Users\VssAdministrator\AppData\Local\Temp\Build.sln.msbuild.log
        PACKAGE_NAME         : MAIN TEST-DeployablePackage-10.0.39-78
        PACKAGE_PATH         : C:\temp\buildbuild\artifacts\MAIN TEST-DeployablePackage-10.0.39-78.zip
        ARTIFACTS_PATH       : C:\temp\buildbuild\artifacts
        ARTIFACTS_LIST       : ["C:\temp\buildbuild\artifacts\MAIN TEST-DeployablePackage-10.0.39-78.zip"]
        
        This will build D365FSC package with version "10.0.39" to the Temp folder
        
    .EXAMPLE
        PS C:\> Invoke-FSCCompile -Version "10.0.39" -Path "c:\Temp"
        
        Example output:
        
        METADATA_DIRECTORY  : D:\a\8\s\Metadata
        FRAMEWORK_DIRECTORY : C:\temp\buildbuild\packages\Microsoft.Dynamics.AX.Platform.CompilerPackage.7.0.7120.99
        BUILD_OUTPUT_DIRECTORY    : C:\temp\buildbuild\bin
        NUGETS_FOLDER    : C:\temp\buildbuild\packages
        BUILD_LOG_FILE_PATH     : C:\Users\VssAdministrator\AppData\Local\Temp\Build.sln.msbuild.log
        PACKAGE_NAME         : MAIN TEST-DeployablePackage-10.0.39-78
        PACKAGE_PATH         : C:\temp\buildbuild\artifacts\MAIN TEST-DeployablePackage-10.0.39-78.zip
        ARTIFACTS_PATH       : C:\temp\buildbuild\artifacts
        ARTIFACTS_LIST       : ["C:\temp\buildbuild\artifacts\MAIN TEST-DeployablePackage-10.0.39-78.zip"]
        
        This will build D365FSC package with version "10.0.39" to the Temp folder
        
    .NOTES
        Author: Oleksandr Nikolaiev (@onikolaiev)
        
#>

function Invoke-FSCCompile {
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
        try{
            $helperPath = Join-Path -Path $($Script:ModuleRoot) -ChildPath "\internal\scripts\helpers.ps1" -Resolve
            . ($helperPath)
                    
            $CMDOUT = @{
                Verbose = If ($PSBoundParameters.Verbose -eq $true) { $true } else { $false };
                Debug = If ($PSBoundParameters.Debug -eq $true) { $true } else { $false }
            }
            $responseObject = [Ordered]@{}
            Write-PSFMessage -Level Important -Message "//================= Reading current FSC-PS settings ============================//"
            Write-PSFMessage -Level Important -Message "IsOneBox: $($Script:IsOnebox)"
            if($Script:IsOnebox)
            {
                Write-PSFMessage -Level Important -Message "EnvironmentType: $($Script:EnvironmentType)"
                Write-PSFMessage -Level Important -Message "HostName: $($environment.Infrastructure.HostName)"
                Write-PSFMessage -Level Important -Message "AOSPath: $($Script:AOSPath)"
                Write-PSFMessage -Level Important -Message "DatabaseServer: $($Script:DatabaseServer)"
                Write-PSFMessage -Level Important -Message "PackageDirectory: $($Script:PackageDirectory)"
                Write-PSFMessage -Level Important -Message "BinDirTools: $($Script:BinDirTools)"
                Write-PSFMessage -Level Important -Message "MetaDataDir: $($Script:MetaDataDir)"
            }
            $settings = Get-FSCPSSettings @CMDOUT

            if([string]::IsNullOrEmpty($Version))
            {
                $Version = $settings.buildVersion
            }
            
            if([string]::IsNullOrEmpty($Version))
            {
                throw "D365FSC Version should be specified."
            }

            if([string]::IsNullOrEmpty($BuildFolderPath))
            {
                $BuildFolderPath = (Join-Path $script:DefaultTempPath _bld)
            }

            if([string]::IsNullOrEmpty($settings.sourceBranch))
            {
                $settings.sourceBranch = $settings.currentBranch
            }

            if([string]::IsNullOrEmpty($settings.artifactsPath))
            {
                $artifactDirectory = (Join-Path $BuildFolderPath $settings.artifactsFolderName)
            }            
            else {
                $artifactDirectory = $settings.artifactsPath
            }

            if (Test-Path -Path $artifactDirectory)
            {
                Remove-Item -Path $artifactDirectory -Recurse -Force
                $null = [System.IO.Directory]::CreateDirectory($artifactDirectory)
            }

            $buildLogsDirectory = (Join-Path $artifactDirectory "Logs")
            if (Test-Path -Path $buildLogsDirectory)
            {
                Remove-Item -Path $buildLogsDirectory -Recurse -Force
                $null = [System.IO.Directory]::CreateDirectory($buildLogsDirectory)
            }

            # Gather version info
            $versionData = Get-FSCPSVersionInfo -Version $Version @CMDOUT
            $PlatformVersion = $versionData.data.PlatformVersion
            $ApplicationVersion = $versionData.data.AppVersion

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

            $responseObject.METADATA_DIRECTORY = $msMetadataDirectory
            $responseObject.FRAMEWORK_DIRECTORY = $msFrameworkDirectory
            $responseObject.BUILD_OUTPUT_DIRECTORY = $msOutputDirectory
            $responseObject.BUILD_FOLDER_PATH = $BuildFolderPath

            Write-PSFMessage -Level Important -Message "//================= Getting the list of models to build ========================//"
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
                $modelsToPackage = $models
            }
            else {
                $models = Get-FSCModelList -MetadataPath $SourceMetadataPath -IncludeTest:($settings.includeTestModel -eq 'true') @CMDOUT         
                
                if($settings.enableBuildCaching)
                {
                    Write-PSFMessage -Level Important -Message "Model caching is enabled."
                    if(($settings.repoProvider -eq "GitHub") -or ($settings.repoProvider -eq "AzureDevOps"))
                    {
                        $modelsHash = [Ordered]@{}
                        $modelsToCache = @()
                        Write-PSFMessage -Level Important -Message "Running in $($settings.repoProvider). Start processing"

                        foreach ($model in $models.Split(","))
                        {                            
                            $modelName = $model
                            Write-PSFMessage -Level Important -Message "Model: $modelName cache validation"
                            $modelRootPath = (Join-Path $SourceMetadataPath $modelName )
                            $modelHash = Get-FolderHash $modelRootPath
                            $modelsHash.$modelName = $modelHash

                            $validation = Validate-FSCModelCache -MetadataDirectory $SourceMetadataPath -RepoOwner $settings.repoOwner -RepoName $settings.repoName -ModelName $modelName -Version $Version -BranchName $settings.sourceBranch
                            if(-not $validation)
                            {
                                $modelsToCache += ($modelName)
                            }
                        }
                        if($modelsToCache)
                        {
                            $modelsToBuild = $modelsToCache -join ","
                        }
                    }
                    else {
                        $modelsToBuild = $models
                    }
                }
                else {
                    $modelsToBuild = $models
                }
                $modelsToPackage = Get-FSCModelList -MetadataPath $SourceMetadataPath -IncludeTest:($settings.includeTestModel -eq 'true') -All @CMDOUT    
            }
            if(-not $modelsToBuild){$modelsToBuild = ""}
            Write-PSFMessage -Level Important -Message "Models to build: $modelsToBuild"
            Write-PSFMessage -Level Important -Message "Models to package: $modelsToPackage"
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
            if($Force)
            {
                Write-PSFMessage -Level Important -Message "//================= Cleanup build folder =======================================//"
                Remove-Item $BuildFolderPath -Recurse -Force -ErrorAction SilentlyContinue
            }

            Write-PSFMessage -Level Important -Message "//================= Generate solution folder ===================================//"
            $null = Invoke-GenerateSolution -ModelsList $modelsToBuild -Version "$Version" -MetadataPath $SourceMetadataPath -SolutionFolderPath $BuildFolderPath @CMDOUT
            Write-PSFMessage -Level Important -Message "Complete"

            Write-PSFMessage -Level Important -Message "//================= Copy source files to the build folder ======================//"            
            $null = Test-PathExists -Path $BuildFolderPath -Type Container -Create @CMDOUT
            $null = Test-PathExists -Path $SolutionBuildFolderPath -Type Container -Create @CMDOUT
            Write-PSFMessage -Level Important -Message "Source folder: $SourcesPath"
            Write-PSFMessage -Level Important -Message "Destination folder: $BuildFolderPath"
            Copy-Item $SourcesPath\* -Destination $BuildFolderPath -Recurse -Force @CMDOUT
            Write-PSFMessage -Level Important -Message "Complete"
    
            Write-PSFMessage -Level Important -Message "//================= Download NuGet packages ====================================//"
            $null = Test-PathExists -Path $NuGetPackagesPath -Type Container -Create @CMDOUT
            $null = Get-FSCPSNuget -Version $PlatformVersion -Type PlatformCompilerPackage -Path $NuGetPackagesPath -Force @CMDOUT
            $null = Get-FSCPSNuget -Version $PlatformVersion -Type PlatformDevALM -Path $NuGetPackagesPath -Force @CMDOUT
            $null = Get-FSCPSNuget -Version $ApplicationVersion -Type ApplicationDevALM -Path $NuGetPackagesPath -Force @CMDOUT
            $null = Get-FSCPSNuget -Version $ApplicationVersion -Type ApplicationSuiteDevALM -Path $NuGetPackagesPath -Force @CMDOUT

            Write-PSFMessage -Level Important -Message "Complete"
            $responseObject.NUGETS_FOLDER = $NuGetPackagesPath
            
            Write-PSFMessage -Level Important -Message "//================= Install NuGet packages =====================================//"
            #validata NuGet installation
            $nugetPath = Get-PSFConfigValue -FullName "fscps.tools.path.nuget"
            if(-not (Test-Path $nugetPath))
            {
                Install-FSCPSNugetCLI
            }
            ##update nuget config file
            $nugetNewContent = (Get-Content $NuGetConfigFilePath).Replace('c:\temp\packages', $NuGetPackagesPath)
            Set-Content $NuGetConfigFilePath $nugetNewContent
                
            $null = (& $nugetPath restore $NuGetPackagesConfigFilePath -PackagesDirectory $NuGetPackagesPath -ConfigFile $NuGetConfigFilePath)
            Write-PSFMessage -Level Important -Message "Complete"

            Write-PSFMessage -Level Important -Message "//================= Copy binaries to the build folder ==========================//"
            Copy-Filtered -Source $SourceMetadataPath -Target (Join-Path $BuildFolderPath bin) -Filter *.*
            Write-PSFMessage -Level Important -Message "Complete"

            if($modelsToBuild)
            {
                Write-PSFMessage -Level Important -Message "//================= Build solution =============================================//"
                
                Set-Content $BuidPropsFile (Get-Content $BuidPropsFile).Replace('ReferenceFolders', $msReferenceFolder)

                $msbuildresult = Invoke-MsBuild -Path (Join-Path $SolutionBuildFolderPath "\Build\Build.sln") -P "/p:BuildTasksDirectory=$msBuildTasksDirectory /p:MetadataDirectory=$msMetadataDirectory /p:FrameworkDirectory=$msFrameworkDirectory /p:ReferencePath=$msReferencePath /p:OutputDirectory=$msOutputDirectory" -ShowBuildOutputInCurrentWindow @CMDOUT

                $responseObject.BUILD_LOG_FILE_PATH = $msbuildresult.BuildLogFilePath

                Copy-Filtered -Source (Join-Path $SolutionBuildFolderPath "Build") -Target $buildLogsDirectory -Filter *Dynamics.AX.*.xppc.*
                Copy-Filtered -Source (Join-Path $SolutionBuildFolderPath "Build") -Target $buildLogsDirectory -Filter *Dynamics.AX.*.labelc.*
                Copy-Filtered -Source (Join-Path $SolutionBuildFolderPath "Build") -Target $buildLogsDirectory -Filter *Dynamics.AX.*.reportsc.*

                Get-ChildItem -Path $buildLogsDirectory | ForEach-Object { if($_.Length -eq 0) {$_.Delete()}}

                
                if ($msbuildresult.BuildSucceeded -eq $true)
                {
                    Write-PSFMessage -Level Host -Message ("Build completed successfully in {0:N1} seconds." -f $msbuildresult.BuildDuration.TotalSeconds)
                    if($settings.enableBuildCaching)
                    {
                        Write-PSFMessage -Level Important -Message "//================= Upload cached models to the storageaccount ================//"
                        foreach ($model in $modelsToBuild.Split(","))
                        {
                            $modelName = $model
                            $modelHash = $modelsHash.$modelName
                            $modelBinPath = (Join-Path $msOutputDirectory $modelName)
                            $modelFileNameWithHash = "$(($settings.repoOwner).ToLower())_$(($settings.repoName).ToLower())_$($modelName.ToLower())_$($settings.sourceBranch.ToLower())_$($Version)_$($modelHash).7z".Replace(" ", "-")
                            $modelArchivePath = (Join-Path $BuildFolderPath $modelFileNameWithHash)

                            $storageConfigs = Get-FSCPSAzureStorageConfig
                            $activeStorageConfigName = "ModelStorage"
                            if($storageConfigs)
                            {
                                $activeStorageConfig = Get-FSCPSActiveAzureStorageConfig
                                $storageConfigs | ForEach-Object {
                                    if($_.AccountId -eq $activeStorageConfig.AccountId -and $_.Container -eq $activeStorageConfig.Container -and $_.SAS -eq $activeStorageConfig.SAS)
                                    {
                                        if($activeStorageConfigName)
                                        {
                                            $activeStorageConfigName = $_.Name
                                        }
                                    }
                                }
                            }
                            Write-PSFMessage -Level Host -Message "Uploading compiled model binaries: $modelName"
                            Write-PSFMessage -Level Host -Message "File: $modelFileNameWithHash"
                            Compress-7zipArchive -Path $modelBinPath\* -DestinationPath $modelArchivePath
                            Set-FSCPSActiveAzureStorageConfig ModelStorage
                            $null = Invoke-FSCPSAzureStorageUpload -FilePath $modelArchivePath
                            if(-not [string]::IsNullOrEmpty($activeStorageConfigName)){
                                Set-FSCPSActiveAzureStorageConfig $activeStorageConfigName
                            }

                        }
                        Write-PSFMessage -Level Important -Message "Complete"
                    }
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
            
            if($settings.generatePackages)
            {
                if($PSVersionTable.PSVersion.Major -gt 5) {
                    Write-PSFMessage -Level Warning -Message "Current PS version is $($PSVersionTable.PSVersion). The latest PS version acceptable to generate the D365FSC deployable package is 5."
                }
                else {                
                    Write-PSFMessage -Level Important -Message "//================= Generate package ==========================================//"

                    $createRegularPackage = $settings.createRegularPackage
                    $createCloudPackage = $settings.createCloudPackage

                    switch ($settings.namingStrategy) {
                        { $settings.namingStrategy -eq "Default" }
                        {
                            $packageNamePattern = $settings.packageNamePattern;
                            if($settings.packageName.Contains('.zip'))
                            {
                                $packageName = $settings.packageName
                            }
                            else {
                                $packageName = $settings.packageName# + ".zip"
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

                            $packageName = $packageNamePattern + ".zip"
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

                    $xppToolsPath = $msFrameworkDirectory
                    $xppBinariesPath = (Join-Path $($BuildFolderPath) bin)
                    $xppBinariesSearch = $modelsToPackage
                    $deployablePackagePath = Join-Path $artifactDirectory ($packageName)

                    if ($xppBinariesSearch.Contains(","))
                    {
                        [string[]]$xppBinariesSearch = $xppBinariesSearch -split ","
                    }

                    $potentialPackages = Find-FSCPSMatch -DefaultRoot $xppBinariesPath -Pattern $xppBinariesSearch | Where-Object { (Test-Path -LiteralPath $_ -PathType Container) }
                    $packages = @()
                    if ($potentialPackages.Length -gt 0)
                    {
                        Write-PSFMessage -Level Verbose -Message "Found $($potentialPackages.Length) potential folders to include:"
                        foreach($package in $potentialPackages)
                        {
                            $packageBinPath = Join-Path -Path $package -ChildPath "bin"
                            
                            # If there is a bin folder and it contains *.MD files, assume it's a valid X++ binary
                            try {
                                if ((Test-Path -Path $packageBinPath) -and ((Get-ChildItem -Path $packageBinPath -Filter *.md).Count -gt 0))
                                {
                                    Write-PSFMessage -Level Verbose -Message $packageBinPath
                                    Write-PSFMessage -Level Verbose -Message "  - $package"
                                    $packages += $package
                                }
                            }
                            catch
                            {
                                Write-PSFMessage -Level Verbose -Message "  - $package (not an X++ binary folder, skip)"
                            }
                        }

                        Import-Module (Join-Path -Path $xppToolsPath -ChildPath "CreatePackage.psm1")
                        $outputDir = Join-Path -Path $BuildFolderPath -ChildPath ((New-Guid).ToString())

                        New-Item -Path $outputDir -ItemType Directory > $null
                        Write-PSFMessage -Level Verbose -Message "Creating binary packages"
                        Invoke-FSCAssembliesImport $xppToolsPath -Verbose

                        foreach($packagePath in $packages)
                        {
                            $packageName = (Get-Item $packagePath).Name
                            Write-PSFMessage -Level Verbose -Message "  - '$packageName'"
                            $version = ""
                            $packageDll = Join-Path -Path $packagePath -ChildPath "bin\Dynamics.AX.$packageName.dll"
                            if (Test-Path $packageDll)
                            {
                                $version = (Get-Item $packageDll).VersionInfo.FileVersion
                            }
                            if (!$version)
                            {
                                $version = "1.0.0.0"
                            }
                            $null = New-XppRuntimePackage -packageName $packageName -packageDrop $packagePath -outputDir $outputDir -metadataDir $xppBinariesPath -packageVersion $version -binDir $xppToolsPath -enforceVersionCheck $True
                        }
                        
                        if ($createRegularPackage)
                        {
                            $tempCombinedPackage = Join-Path -Path $BuildFolderPath -ChildPath "$((New-Guid).ToString()).zip"
                            try
                            {
                                Write-PSFMessage -Level Important "Creating deployable package"
                                Add-Type -Path "$xppToolsPath\Microsoft.Dynamics.AXCreateDeployablePackageBase.dll"
                                Write-PSFMessage -Level Important "  - Creating combined metadata package"
                                $null = [Microsoft.Dynamics.AXCreateDeployablePackageBase.BuildDeployablePackages]::CreateMetadataPackage($outputDir, $tempCombinedPackage)
                                Write-PSFMessage -Level Important "  - Creating merged deployable package"
                                $null = [Microsoft.Dynamics.AXCreateDeployablePackageBase.BuildDeployablePackages]::MergePackage("$xppToolsPath\BaseMetadataDeployablePackage.zip", $tempCombinedPackage, $deployablePackagePath, $true, [String]::Empty)
                                Write-PSFMessage -Level Important "Deployable package '$deployablePackagePath' successfully created."

                                $pname = ($deployablePackagePath.SubString("$deployablePackagePath".LastIndexOf('\') + 1)).Replace(".zip","")
                                $responseObject.PACKAGE_NAME = $pname
                                $responseObject.PACKAGE_PATH = $deployablePackagePath
                                $responseObject.ARTIFACTS_PATH = $artifactDirectory
                            }
                            catch {
                                throw $_.Exception.Message
                            }
                        }

                        if ($createCloudPackage)
                        {
                            $tempPathForCloudPackage = [System.IO.Path]::GetTempPath()
                            $tempDirRoot = Join-Path -Path $tempPathForCloudPackage -ChildPath ((New-Guid).ToString())
                            New-Item -Path $tempDirRoot -ItemType Directory > $null
                            $copyDir = [System.IO.Path]::Combine($outputDir, "files")

                            # Define regex patterns
                            $regexInit = [System.Text.RegularExpressions.Regex]::new("dynamicsax-(.+?)(?=\.\d+\.\d+\.\d+\.\d+$)")

                            # Process each zip file in the directory
                            $ziplist = Get-ChildItem -Path $copyDir -Filter "*.zip"
                            foreach ($zipFileentry in $ziplist) 
                            {
                                $modelZipFile = $zipFileentry.FullName
                                $modelDirNewName = [System.IO.Path]::GetFileNameWithoutExtension($modelZipFile) # rename pattern: dynamicsax-fleetmanagement.7.0.5030.16453
                                $modelOrgDirName = $modelDirNewName
                                if ($modelDirNewName -match $regexInit) {
                                    $modelDirNewName = $matches[1]
                                    Write-PSFMessage -Level Important $modelDirNewName
                                }
                                try 
                                {
                                    $destinationPath = [System.IO.Path]::Combine($tempDirRoot, $modelDirNewName)
                                    if (Test-Path -Path $destinationPath -PathType Container) 
                                    {
                                        throw [System.Exception]::new("Duplicate model directory: $modelOrgDirName")
                                    }
                                    else 
                                    {
                                        Expand-Archive -Path $modelZipFile -DestinationPath $destinationPath
                                    }
                                }
                                catch 
                                {
                                    Write-PSFMessage -Level Host -Message "Exception extracting: $modelZipFile"
                                    Write-PSFMessage -Level Host -Message $_.Exception.Message
                                    throw
                                }
                            }
                        
                            try
                            {
                                Write-PSFMessage -Level Important  "Creating cloud runtime deployable package"
                                Invoke-CloudRuntimeAssembliesImport
                                $miscPath = Join-Path -Path $($Script:ModuleRoot) -ChildPath "\internal\misc"
                                $assemblies = ("System", "$miscPath\CloudRuntimeDlls\Microsoft.PowerPlatform.VSShared.Util.dll")   
                                
                                $id = get-random
                                $code = 
@"
    using Microsoft.PowerPlatform.VSShared.Util;
    using System;
    using System.Threading.Tasks;
    namespace PackageCreation
    {
        public class Program$id
        {
            public static async Task<string> MainCreate(string[] args)
            {
                var createPkg = new PipelineOperation();
                var pkgLoc = await createPkg.PerformCreatePackageOperation(args[0], args[1], args[2], Guid.Empty.ToString());
                return pkgLoc;
            }
        }
    }
"@
                            
                                try
                                { 
                                    $cloudDeployablePackageArtifactsPath = Join-Path $artifactDirectory CloudDeployablePackage
                                    if(-not (Test-Path $cloudDeployablePackageArtifactsPath))
                                    {                
                                        $null = [System.IO.Directory]::CreateDirectory($cloudDeployablePackageArtifactsPath)
                                    }
                                    Write-PSFMessage -Level Important -Message  "Starting package creation:"
                                    Add-Type -ReferencedAssemblies $assemblies -TypeDefinition $code -Language CSharp
                                    [System.AppContext]::SetSwitch('Switch.System.IO.Compression.ZipFile.UseBackslash', $false)
                                    Invoke-Expression "[PackageCreation.Program$id]::MainCreate(@('$tempDirRoot', '$PlatformVersion', '$ApplicationVersion'))" | Tee-Object -Var packageLocation
                                    Write-PSFMessage -Level Host -Message $packageLocation.Result
                                    Write-PSFMessage -Level Host -Message "Ending package creation"
                                    Write-PSFMessage -Level Host -Message "Placing package to package output location"
                                    
                                    Copy-Item -Path (Join-Path $packageLocation.Result '\*') -Destination $cloudDeployablePackageArtifactsPath -Recurse
                                }
                                catch
                                {
                                    throw
                                }                          
}
                            catch
                            {
                                throw
                            }
                        }
                    }
                    else
                    {
                        throw "No X++ binary package(s) found"
                    }
                    Write-PSFMessage -Level Important -Message "Complete"
                }
            }
            if($settings.exportModel)
            {
                Write-PSFMessage -Level Important -Message "//================= Export models ===========================================//"

                try {
                    $axModelFolder = Join-Path $artifactDirectory AxModels
                    $null = Test-PathExists -Path $axModelFolder -Type Container -Create
                    Write-PSFMessage -Level Verbose -Message "$axModelFolder created"

                    if($models.Split(","))
                    {                                
                        $modelsList = $models.Split(",")
                        foreach ($currentModel in $modelsList) {
                            Write-PSFMessage -Level Verbose -Message "Exporting $currentModel model..."
                            $modelName = (Get-AXModelName -ModelName $currentModel -ModelPath $msMetadataDirectory)
                            if($modelName)
                            {
                                $modelFilePath = Export-D365Model -Path $axModelFolder -Model $modelName -BinDir $msFrameworkDirectory -MetaDataDir $msMetadataDirectory -ShowOriginalProgress 
                                $modelFile = Get-Item $modelFilePath.File
                                Rename-Item $modelFile.FullName (($currentModel)+($modelFile.Extension)) -Force
                            }
                            else
                            {
                                Write-PSFMessage -Level Verbose -Message "The model $modelName doesn`t have the source code. Skipped."
                            }
                        }
                    }
                    else {
                        Write-PSFMessage -Level Verbose -Message "Exporting $models model..."
                        $modelName = (Get-AXModelName -ModelName $models -ModelPath $msMetadataDirectory)
                        if($modelName)
                        {
                            $modelFilePath = Export-D365Model -Path $axModelFolder -Model $modelName -BinDir $msFrameworkDirectory -MetaDataDir $msMetadataDirectory
                            $modelFile = Get-Item $modelFilePath.File
                            Rename-Item $modelFile.FullName (($models)+($modelFile.Extension)) -Force
                        }
                        else
                        {
                            Write-PSFMessage -Level Verbose -Message "The model $models doesn`t have the source code. Skipped."
                        }
                    }
                }
                catch {
                    Write-PSFMessage -Level Important -Message $_.Exception.Message
                }
                Write-PSFMessage -Level Important -Message "Complete"
                
            }
            $artifacts = Get-ChildItem $artifactDirectory -File -Recurse
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
        catch {
            Write-PSFMessage -Level Host -Message "Error: " -Exception $PSItem.Exception
            Stop-PSFFunction -Message "Stopping because of errors" -EnableException $true
            return
        }
        finally
        {
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