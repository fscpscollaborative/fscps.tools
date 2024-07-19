
<#
    .SYNOPSIS
        Installation of Nuget CLI
        
    .DESCRIPTION
        Download latest Nuget CLI
        
    .PARAMETER MetadataPath
        Path to the local Metadata folder
        
    .PARAMETER Url
        Url/Uri to zip file contains code/package/axmodel
        
    .PARAMETER FileName
        The name of the file should be downloaded by the url. Use if the url doesnt contain the filename.
        
    .EXAMPLE
        PS C:\> Update-FSCPSISVSource MetadataPath "C:\temp\PackagesLocalDirectory" -Url "https://ciellosarchive.blob.core.windows.net/test/Main-Extension-10.0.39_20240516.263.zip?sv=2023-01-03&st=2024-05-21T14%3A26%3A41Z&se=2034-05-22T14%3A26%3A00Z&sr=b&sp=r&sig=W%2FbS1bQrr59i%2FBSHWsftkfNsE1HvFXTrICwZSFiUItg%3D""
        
        This will update the local metadata with the source from the downloaded zip archive.
        
    .NOTES
        Author: Oleksandr Nikolaiev (@onikolaiev)
#>
function Update-FSCPSISVSource {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseShouldProcessForStateChangingFunctions", "")]
    [CmdletBinding()]
    param (
        [Parameter(HelpMessage = "The path to the metadata", Mandatory = $true)]
        [string] $MetadataPath,
        [Parameter(HelpMessage = "The url to the file contains the D365FSC axmodel/modelSourceCode/deployablePackage", Mandatory = $true)]
        [string] $Url,
        [Parameter(HelpMessage = "The name of the downloading file", Mandatory = $false)]
        [string] $FileName
    )
    begin
    {
        try 
        {
            if([string]::IsNullOrEmpty($FileName))
            {
                $_tmpUrlPart = ([uri]$Url).Segments[-1]
                if($_tmpUrlPart.Contains("."))
                {
                    $FileName = $_tmpUrlPart
                }            
            }

            if([string]::IsNullOrEmpty($FileName))
            {
                throw "FileName is empty or cannot be parsed from the url. Please specify the FileName parameter."
            }
            
            if( (-not $FileName.Contains(".zip")) -and (-not $FileName.Contains(".axmodel")) )
            {
                throw "Only a zip or axmodel file can be processed."
            }

            if(Test-Path "$($MetadataPath)/PackagesLocalDirectory")
            {
                $MetadataPath = (Join-Path $($MetadataPath) "/PackagesLocalDirectory")
            }
            elseif(Test-Path "$($MetadataPath)/Metadata")
            {
                $MetadataPath = (Join-Path $($MetadataPath) "/Metadata")
            }

            #$script:DefaultTempPath 
            $tempPath = Join-Path -Path $script:DefaultTempPath -ChildPath "updateSource"

            #Cleanup existing temp folder
            Remove-Item -Path $tempPath -Recurse -Force -ErrorAction SilentlyContinue -Confirm:$false        
            $downloadPath = Join-Path -Path $tempPath -ChildPath $fileName
            if (-not (Test-PathExists -Path $tempPath -Type Container -Create)) { return }
        }
        catch {
            Write-PSFMessage -Level Host -Message "Error: " -Exception $PSItem.Exception
            Stop-PSFFunction -Message "Stopping because of errors" -EnableException $true
            return
        }
    }
    process
    {
        if (Test-PSFFunctionInterrupt) { return }
        $helperPath = Join-Path -Path $($Script:ModuleRoot) -ChildPath "\internal\scripts\helpers.ps1" -Resolve
        . ($helperPath)    
        try {
            
            Write-PSFMessage -Level Important -Message "Downloading $($FileName)" -Target $downloadPath
            [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
            #[System.Net.ServicePointManager]::ServerCertificateValidationCallback = {$true}

            Write-PSFMessage -Level Important -Message "Source: $Url"
            Write-PSFMessage -Level Important -Message "Destination $downloadPath"

            Start-BitsTransfer -Source $Url -Destination $downloadPath


            #check is archive contains few archives
            $packagesPaths = [System.Collections.ArrayList]@()
            $sourceCodePaths = [System.Collections.ArrayList]@()
            $axmodelsPaths = [System.Collections.ArrayList]@()

            if($downloadPath.EndsWith(".zip"))
            {            
                Unblock-File $downloadPath
                Expand-7zipArchive -Path $downloadPath -DestinationPath "$tempPath/archives"

                $ispackage = Get-ChildItem -Path "$tempPath/archives" -Filter 'AXUpdateInstaller.exe' -ErrorAction SilentlyContinue -Force    

                if($ispackage)
                {
                    $null = $packagesPaths.Add($downloadPath)
                }
                else
                {   
                    Get-ChildItem "$tempPath/archives" -Filter '*.zip' -Recurse  -ErrorAction SilentlyContinue -Force | ForEach-Object{
                        $archive = $_.FullName
                        
                        $tmpArchivePath = Join-Path "$tempPath/archives" $_.BaseName
                        
                        Unblock-File $archive
                        Expand-7zipArchive -Path $archive -DestinationPath $tmpArchivePath
                        $ispackage = Get-ChildItem -Path $tmpArchivePath -Filter 'AXUpdateInstaller.exe' -Recurse -ErrorAction SilentlyContinue -Force    
    
                        if($ispackage)
                        {
                            $null = $packagesPaths.Add($_.FullName)
                        }
                        else
                        {   
                            if($_.FullName -notlike "*dynamicsax-*.zip")
                            {
                                $null = $sourceCodePaths.Add($_.FullName)
                            }
                        }
                            
                    } 
                    #check axmodel files inside and add to list if found
                    Get-ChildItem "$tempPath/archives" -Filter '*.axmodel' -Recurse -ErrorAction SilentlyContinue -Force | ForEach-Object {
                        $null = $axmodelsPaths.Add($_.FullName)
                    }           
                } 
            }
            if($downloadPath.EndsWith(".axmodel"))
            {
                $null = $axmodelsPaths.Add($_.FullName)
            }

            foreach($package in $packagesPaths)
            {
                try {
                    $package = Get-ChildItem $package
                    Write-PSFMessage -Level Important -Message "The package $($package.BaseName) importing..."
                    $tmpPackagePath = Join-Path "$tempPath/packages" $package.BaseName
                    Unblock-File $package
                    Expand-7zipArchive -Path $package -DestinationPath $tmpPackagePath
                    $models = Get-ChildItem -Path $tmpPackagePath -Filter "dynamicsax-*.zip" -Recurse -ErrorAction SilentlyContinue -Force
                    foreach($model in $models)
                    {            
                        Write-PSFMessage -Level Important -Message "$($model.BaseName) processing..."
                        $zipFile = [IO.Compression.ZipFile]::OpenRead($model.FullName)
                        $zipFile.Entries | Where-Object {$_.FullName.Contains(".xref")} | ForEach-Object{
                            $modelName = $_.Name.Replace(".xref", "")
                            $targetModelPath = (Join-Path $MetadataPath "$modelName/")   
                            if(Test-Path $targetModelPath)
                            {
                                Remove-Item $targetModelPath -Recurse -Force
                            }      
                            Write-PSFMessage -Level Important -Message "'$($model.FullName)' to the $($targetModelPath)..."
                            Expand-7zipArchive -Path $model.FullName -DestinationPath $targetModelPath
                        }            
                        $zipFile.Dispose()
                    }
                    Write-PSFMessage -Level Important -Message "The package $($package) imported"
                }
                catch {
                    Write-PSFMessage -Level Host -Message "Error:" -Exception $PSItem.Exception
                    Write-PSFMessage -Level Important -Message "The package $($package) is not imported"
                }               
            }

            if(($axmodelsPaths.Count -gt 0) -and ($PSVersionTable.PSVersion.Major -gt 5)) {
                Write-PSFMessage -Level Warning -Message "The axmodel cannot be imported. Current PS version is $($PSVersionTable.PSVersion). The latest PS major version acceptable to import the axmodel is 5."
            }
            else {

                $PlatformVersion = (Get-FSCPSVersionInfo -Version 10.0.38).data.PlatformVersion
                $nugetsPath = Join-Path $tempPath "NuGets"
                $compilerNugetPath = Join-Path $nugetsPath "Microsoft.Dynamics.AX.Platform.CompilerPackage.$PlatformVersion.nupkg"
                $compilerPath = Join-Path $tempPath "Microsoft.Dynamics.AX.Platform.CompilerPackage.$PlatformVersion"

                $null = Test-PathExists -Path $compilerPath -Type Container -Create
                $null = Test-PathExists -Path $nugetsPath -Type Container -Create
                Write-PSFMessage -Level Important -Message "The $PlatformVersion Platform Version used."
                Get-FSCPSNuget -Version $PlatformVersion -Type PlatformCompilerPackage -Path $nugetsPath
                Write-PSFMessage -Level Important -Message "The PlatformCompiler NuGet were downloaded at $nugetsPath."
                Expand-7zipArchive -Path $compilerNugetPath -DestinationPath $compilerPath
                $curLocation = Get-Location
                Set-Location $compilerPath
                                
                try {
                    $miscPath = Join-Path -Path $($Script:ModuleRoot) -ChildPath "\internal\misc"
                    Copy-Item -Path "$miscPath\Microsoft.TeamFoundation.Client.dll" -Destination $compilerPath -Force
                    Copy-Item -Path "$miscPath\Microsoft.TeamFoundation.Common.dll" -Destination $compilerPath -Force               
                    Copy-Item -Path "$miscPath\Microsoft.TeamFoundation.Diff.dll" -Destination $compilerPath -Force
                    Copy-Item -Path "$miscPath\Microsoft.TeamFoundation.VersionControl.Client.dll" -Destination $compilerPath -Force
                    Copy-Item -Path "$miscPath\Microsoft.TeamFoundation.VersionControl.Common.dll" -Destination $compilerPath -Force
                }
                catch {
                    Write-PSFMessage -Level Important -Message $_.Exception.Message
                }

                foreach($axModel in $axmodelsPaths)
                {
                    try {
                        Write-PSFMessage -Level Important -Message "The axmodel $($axModel) importing..."
                        Enable-D365Exception
                        
                        #Import-D365Model -Path $axModel -MetaDataDir $MetadataPath -BinDir $compilerPath -Replace

                        Invoke-ModelUtil -Path $axModel -MetaDataDir $MetadataPath -BinDir $compilerPath -Command Replace


                        Disable-D365Exception
                        Write-PSFMessage -Level Important -Message "The axmodel $($axModel) imported."
                    }
                    catch {
                        Disable-D365Exception
                        Write-PSFMessage -Level Host -Message "Error:" -Exception $PSItem.Exception
                        Write-PSFMessage -Level Important -Message "The axmodel $($axModel) is not imported."
                    }                   
                }
                Set-Location $curLocation
            }            

            foreach($sourceCode in $sourceCodePaths)
            {
                try {
                    Write-PSFMessage -Level Important -Message "The source code $($sourceCode) importing..."
                    $zipFile = [IO.Compression.ZipFile]::OpenRead($sourceCode)
                        $zipFile.Entries | Where-Object {$_.FullName.Contains(".xref")} | ForEach-Object{
                            $modelName = $_.Name.Replace(".xref", "")
                            $targetModelPath = (Join-Path $MetadataPath "$modelName/")   
                            Remove-Item $targetModelPath -Recurse -Force 
                            Expand-7zipArchive -Path $($sourceCode) -DestinationPath $targetModelPath
                        }            
                        $zipFile.Dispose()
                    Write-PSFMessage -Level Important -Message "The source code $($sourceCode) imported"
                }
                catch {
                    Write-PSFMessage -Level Host -Message "Error:" -Exception $PSItem.Exception
                    Write-PSFMessage -Level Important -Message "The source code $($sourceCode) is not imported"
                }
            }

            ## Cleanup XppMetadata
            Get-ChildItem -Path $MetadataPath -Directory -Filter "*XppMetadata" -Recurse | ForEach-Object { Remove-Item -Path $_.FullName -Recurse -Force }
        }
        catch {
            Write-PSFMessage -Level Host -Message "Error:" -Exception $PSItem.Exception
            Stop-PSFFunction -Message "Stopping because of errors" -EnableException $true
            return
        }
    }
    end{

    } 
}