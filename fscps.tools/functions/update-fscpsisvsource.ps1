
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

            #$script:DefaultTempPath 
            $tempPath = Join-Path -Path "c:\temp" -ChildPath "updateSource"

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

        try {
            
            Write-PSFMessage -Level Verbose -Message "Downloading $($FileName)" -Target $downloadPath
            [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
            [System.Net.ServicePointManager]::ServerCertificateValidationCallback = {$true}
            Invoke-WebRequest -Uri $Url -OutFile $downloadPath

            #check is archive contains few archives
            $packagesPaths = [System.Collections.ArrayList]@()
            $sourceCodePaths = [System.Collections.ArrayList]@()
            $axmodelsPaths = [System.Collections.ArrayList]@()

            if($downloadPath.EndsWith(".zip"))
            {            
                Unblock-File $downloadPath
                Expand-7zipArchive -Path $downloadPath -DestinationPath "$tempPath/archives"
                Get-ChildItem "$tempPath/archives" -Filter '*.zip'  -ErrorAction SilentlyContinue -Force | ForEach-Object{
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
                        $null = $sourceCodePaths.Add($_.FullName)
                    }
                        
                } 
                #check axmodel files inside and add to list if found
                Get-ChildItem "$tempPath/archives" -Filter '*.axmodel' -Recurse -ErrorAction SilentlyContinue -Force | ForEach-Object {
                    $null = $axmodelsPaths.Add($_.FullName)
                }                      
    
            }
            if($downloadPath.EndsWith(".axmodel"))
            {
                $null = $axmodelsPaths.Add($_.FullName)
            }

            foreach($package in $packagesPaths)
            {
                try {
                    Write-PSFMessage -Level Important -Message "The package $($package) importing..."
                    $tmpPackagePath = Join-Path "$tempPath/packages" $package.BaseName
                    Unblock-File $package
                    Expand-7zipArchive -Path $package -DestinationPath $tmpPackagePath
                    $models = Get-ChildItem -Path $tmpPackagePath -Filter "dynamicsax-*.zip" -Recurse -ErrorAction SilentlyContinue -Force
                    foreach($model in $models)
                    {            
                        $zipFile = [IO.Compression.ZipFile]::OpenRead($model.FullName)
                        $zipFile.Entries | Where-Object {$_.FullName.Contains(".xref")} | ForEach-Object{
                            $modelName = $_.Name.Replace(".xref", "")
                            $targetModelPath = (Join-Path $MetadataPath "$modelName/")   
                            Remove-Item $targetModelPath -Recurse -Force 
                            Expand-7zipArchive -Path $models.FullName -DestinationPath $targetModelPath
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
                foreach($axModel in $axmodelsPaths)
                {
                    try {
                        Write-PSFMessage -Level Important -Message "The axmodel $($axModel) importing..."
                        $PlatformVersion = "7.0.7198.66"
                        $nugetsPath = Join-Path $tempPath "NuGets"
                        $compilerNugetPath = Join-Path $nugetsPath "Microsoft.Dynamics.AX.Platform.CompilerPackage.$PlatformVersion.nupkg"
                        $compilerPath = Join-Path $tempPath "Microsoft.Dynamics.AX.Platform.CompilerPackage.$PlatformVersion"
        
                        $null = Test-PathExists -Path $compilerPath -Type Container -Create
                        $null = Test-PathExists -Path $nugetsPath -Type Container -Create
        
                        $null = Get-FSCPSNuget -Version $PlatformVersion -Type PlatformCompilerPackage -Path $nugetsPath
                        Expand-7zipArchive -Path $compilerNugetPath -DestinationPath $compilerPath
                        Enable-D365Exception
                        Import-D365Model -Path $axModel -MetaDataDir $MetadataPath -BinDir $compilerPath -Replace
                        Disable-D365Exception
                        Write-PSFMessage -Level Important -Message "The axmodel $($package) imported."
                    }
                    catch {
                        Disable-D365Exception
                        Write-PSFMessage -Level Host -Message "Error:" -Exception $PSItem.Exception
                        Write-PSFMessage -Level Important -Message "The axmodel $($package) is not imported."
                    }                   
                }
            }            

            foreach($sourceCode in $sourceCodePaths)
            {
                try {
                    Write-PSFMessage -Level Important -Message "The source code $($sourceCode) importing..."
                    Write-PSFMessage -Level Important -Message "The source code $($sourceCode) imported"
                }
                catch {
                    Write-PSFMessage -Level Host -Message "Error:" -Exception $PSItem.Exception
                    Write-PSFMessage -Level Important -Message "The source code $($sourceCode) is not imported"
                }
            }
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