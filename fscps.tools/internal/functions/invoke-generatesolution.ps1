
<#
    .SYNOPSIS
        Generate the D365FSC build solution
        
    .DESCRIPTION
        Invoke the D365FSC generation build solution
        
    .PARAMETER ModelsList
        The list of models to generate a solution

    .PARAMETER DynamicsVersion
        The version of the D365FSC to build

    .PARAMETER MetadataPath
        The path to the metadata folder

    .PARAMETER SolutionBasePath
        The path to the generated solution folder. Dafault is c:\temp\fscps.tools\

    .EXAMPLE
        PS C:\> Invoke-GenerateSolution -Models "Test, SuperTest, SuperTestExtension" -Version "10.0.39" -MetadataPath "c:\temp\TestMetadataFolder" 
        
        This will generate a solution of 10.0.39 version
               
    .NOTES
        Author: Oleksandr Nikolaiev (@onikolaiev)
        
#>
function Invoke-GenerateSolution {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [Alias('Models')]
        [string[]]$ModelsList,
        [Parameter(Mandatory = $true)]
        [Alias('Version')]
        [string]$DynamicsVersion,
        [Parameter(Mandatory = $true)]
        [string]$MetadataPath,
        [Alias('SolutionFolderPath')]
        [string]$SolutionBasePath = $script:DefaultTempPath
    )


    BEGIN
    {
        $miscFolder = (Join-Path $script:ModuleRoot "\internal\misc")
        $buildSolutionTemplateFolder = (Join-Path $miscFolder \Build)
        $buildProjectTemplateFolder = (Join-Path $buildSolutionTemplateFolder \Build)

        #Set-Location $buildProjectTemplateFolder
        Write-PSFMessage -Level Debug -Message  "MetadataPath: $MetadataPath"

        $ProjectPattern = 'Project("{FC65038C-1B2F-41E1-A629-BED71D161FFF}") = "ModelNameBuild (ISV) [ModelDisplayName]", "ModelName.rnrproj", "{62C69717-A1B6-43B5-9E86-24806782FEC2}"'
        $ActiveCFGPattern = '		{62C69717-A1B6-43B5-9E86-24806782FEC2}.Debug|Any CPU.ActiveCfg = Debug|Any CPU'
        $BuildPattern = '		{62C69717-A1B6-43B5-9E86-24806782FEC2}.Debug|Any CPU.Build.0 = Debug|Any CPU'

        $SolutionFileName =  'Build.sln'
        $NugetFolderPath =  Join-Path $SolutionBasePath "$($DynamicsVersion)_build"
        $SolutionFolderPath = Join-Path  $NugetFolderPath 'Build'
        $NewSolutionName = Join-Path  $SolutionFolderPath 'Build.sln'

        function Get-AXModelDisplayName {
            param (
                [Alias('ModelName')]
                [string]$_modelName,
                [Alias('ModelPath')]
                [string]$_modelPath
            )
            process{
                $descriptorSearchPath = (Join-Path $_modelPath (Join-Path $_modelName "Descriptor"))
                $descriptor = (Get-ChildItem -Path $descriptorSearchPath -Filter '*.xml')
                if($descriptor)
                {
                    Write-PSFMessage -Level Verbose -Message "Descriptor found at $descriptor"
                    [xml]$xmlData = Get-Content $descriptor.FullName
                    $modelDisplayName = $xmlData.SelectNodes("//AxModelInfo/DisplayName")
                    return $modelDisplayName.InnerText
                }
            }
        }
        function GenerateProjectFile {
            [CmdletBinding()]
            param (
                [string]$ModelName,
                [string]$MetadataPath,
                [string]$ProjectGuid
            )
        
            $ProjectFileName =  'Build.rnrproj'
            $ModelProjectFileName = $ModelName + '.rnrproj'
            $NugetFolderPath =  Join-Path $SolutionBasePath "$($DynamicsVersion)_build"
            $SolutionFolderPath = Join-Path  $NugetFolderPath 'Build'
            $ModelProjectFile = Join-Path $SolutionFolderPath $ModelProjectFileName
            #$modelDisplayName = Get-AXModelDisplayName -ModelName $ModelName -ModelPath $MetadataPath 
            $modelDescriptorName = Get-AXModelName -ModelName $ModelName -ModelPath $MetadataPath 
            #generate project file
        
            if($modelDescriptorName -eq "")
            {
                $ProjectFileData = (Get-Content $buildProjectTemplateFolder\$ProjectFileName).Replace('ModelName', $ModelName).Replace('62C69717-A1B6-43B5-9E86-24806782FEC2'.ToLower(), $ProjectGuid.ToLower())
            }
            else {
                $ProjectFileData = (Get-Content $buildProjectTemplateFolder\$ProjectFileName).Replace('ModelName', $modelDescriptorName).Replace('62C69717-A1B6-43B5-9E86-24806782FEC2'.ToLower(), $ProjectGuid.ToLower())
            }
            #$ProjectFileData = (Get-Content $ProjectFileName).Replace('ModelName', $modelDescriptorName).Replace('62C69717-A1B6-43B5-9E86-24806782FEC2'.ToLower(), $ProjectGuid.ToLower())
             
            Set-Content $ModelProjectFile $ProjectFileData
        }
        function Get-AXModelName {
            param (
                [Alias('ModelName')]
                [string]$_modelName,
                [Alias('ModelPath')]
                [string]$_modelPath
            )
            process{
                $descriptorSearchPath = (Join-Path $_modelPath (Join-Path $_modelName "Descriptor"))
                $descriptor = (Get-ChildItem -Path $descriptorSearchPath -Filter '*.xml')
                Write-PSFMessage -Level Verbose -Message "Descriptor found at $descriptor"
                [xml]$xmlData = Get-Content $descriptor.FullName
                $modelDisplayName = $xmlData.SelectNodes("//AxModelInfo/Name")
                return $modelDisplayName.InnerText
            }
        }
    }

    PROCESS
    {    

        New-Item -ItemType Directory -Path $SolutionFolderPath -ErrorAction SilentlyContinue
        Copy-Item $buildProjectTemplateFolder\build.props -Destination $SolutionFolderPath -force

    
        [String[]] $SolutionFileData = @() 
    
        $projectGuids = @{};
        Write-PSFMessage -Level Debug -Message  "Generate projects GUIDs..."
        Foreach($model in $ModelsList.Split(','))
        {
            $projectGuids.Add($model, ([string][guid]::NewGuid()).ToUpper())
        }
        Write-PSFMessage -Level Debug -Message $projectGuids
    
        #generate project files file
        $FileOriginal = Get-Content $buildProjectTemplateFolder\$SolutionFileName
            
        Write-PSFMessage -Level Debug -Message  "Parse files"
        Foreach ($Line in $FileOriginal)
        {   
            $SolutionFileData += $Line
            Foreach($model in $ModelsList.Split(','))
            {
                $projectGuid = $projectGuids.Item($model)
    
                if ($Line -eq $ProjectPattern) 
                {
                    Write-PSFMessage -Level Debug -Message  "Get AXModel Display Name"
                    $modelDisplayName = Get-AXModelDisplayName -ModelName $model -ModelPath $MetadataPath 
                    Write-PSFMessage -Level Debug -Message  "AXModel Display Name is $modelDisplayName"
                    Write-PSFMessage -Level Debug -Message  "Update Project line"
                    $newLine = $ProjectPattern -replace 'ModelName', $model
                    $newLine = $newLine -replace 'ModelDisplayName', $modelDisplayName
                    $newLine = $newLine -replace 'Build.rnrproj', ($model+'.rnrproj')
                    $newLine = $newLine -replace '62C69717-A1B6-43B5-9E86-24806782FEC2', $projectGuid
                    #Add Lines after the selected pattern 
                    $SolutionFileData += $newLine                
                    $SolutionFileData += "EndProject"
            
                } 
                if ($Line -eq $ActiveCFGPattern) 
                { 
                    Write-PSFMessage -Level Debug -Message  "Update Active CFG line"
                    $newLine = $ActiveCFGPattern -replace '62C69717-A1B6-43B5-9E86-24806782FEC2', $projectGuid
                    $SolutionFileData += $newLine
                } 
                if ($Line -eq $BuildPattern) 
                {
                    Write-PSFMessage -Level Debug -Message  "Update Build line"
                    $newLine = $BuildPattern -replace '62C69717-A1B6-43B5-9E86-24806782FEC2', $projectGuid
                    $SolutionFileData += $newLine
                } 
            }
        }
        Write-PSFMessage -Level Debug -Message  "Save solution file"
        #save solution file 
        Set-Content $NewSolutionName $SolutionFileData;
        #cleanup solution file
        $tempFile = Get-Content $NewSolutionName
        $tempFile | Where-Object {$_ -ne $ProjectPattern} | Where-Object {$_ -ne $ActiveCFGPattern} | Where-Object {$_ -ne $BuildPattern} | Set-Content -Path $NewSolutionName 
    
        #generate project files
        Foreach($project in $projectGuids.GetEnumerator())
        {
            GenerateProjectFile -ModelName $project.Name -ProjectGuid $project.Value -MetadataPath $MetadataPath 
        }
    
        #Set-Location $buildSolutionTemplateFolder
        #generate nuget.config
        $NugetConfigFileName = 'nuget.config'
        $NewNugetFile = Join-Path $NugetFolderPath $NugetConfigFileName
        if($NugetFeedName)
        {
            $tempFile = (Get-Content $buildSolutionTemplateFolder\$NugetConfigFileName).Replace('NugetFeedName', $NugetFeedName).Replace('NugetSourcePath', $NugetSourcePath)
        }
        else {
            $tempFile = (Get-Content $buildSolutionTemplateFolder\$NugetConfigFileName).Replace('<add key="NugetFeedName" value="NugetSourcePath" />', '')
        }
        Set-Content $NewNugetFile $tempFile    
    
        $version = Get-FSCPSVersionInfo -Version $DynamicsVersion
    
        #generate packages.config
        $PackagesConfigFileName = 'packages.config'
        $NewPackagesFile = Join-Path $NugetFolderPath $PackagesConfigFileName
        $tempFile = (Get-Content $buildSolutionTemplateFolder\$PackagesConfigFileName).Replace('PlatformVersion', $version.PlatformVersion).Replace('ApplicationVersion', $version.AppVersion)
        Set-Content $NewPackagesFile $tempFile
    }   

    END{

    }
    
}