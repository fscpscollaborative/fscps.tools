
<#
    .SYNOPSIS
        This gets the D365FSC model version
        
    .DESCRIPTION
        This gets the D365FSC model version from the descriptor file by automatically finding the descriptor in the model path
        
    .PARAMETER ModelPath
        Path to the model folder (automatically searches for Descriptor\*.xml inside)
        
    .EXAMPLE
        PS C:\> Get-FSCPSModelVersion -ModelPath "c:\temp\metadata\TestModel"
        
        This will get the version information of the TestModel by automatically finding the descriptor file
        
    .EXAMPLE
        PS C:\> Get-FSCPSModelVersion -ModelPath "c:\temp\PackagesLocalDirectory\MyCustomModel"
        
        This will get the version information of MyCustomModel including layer name
        
    .NOTES
        Author: Oleksandr Nikolaiev (@onikolaiev)
#>
function Get-FSCPSModelVersion {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]$ModelPath
    )

    begin{
        Invoke-TimeSignal -Start
        Write-PSFMessage -Level Important -Message "ModelPath: $ModelPath"
        
        # Validate that the model path exists
        if (-not (Test-Path -LiteralPath $ModelPath -PathType Container)) {
            throw "Model path '$ModelPath' does not exist or is not a directory"
        }
        
        # Function to convert layer number to layer name
        function Get-LayerName {
            param([int]$LayerNumber)
            
            switch ($LayerNumber) {
                0 { return "SYS" }
                1 { return "SYP" }
                2 { return "GLS" }
                3 { return "GLP" }
                4 { return "FPK" }
                5 { return "FPP" }
                6 { return "SLN" }
                7 { return "SLP" }
                8 { return "ISV" }
                9 { return "ISP" }
                10 { return "VAR" }
                11 { return "VAP" }
                12 { return "CUS" }
                13 { return "CUP" }
                14 { return "USR" }
                15 { return "USP" }
                default { return "Unknown" }
            }
        }
    }
    
    process{
        # Look for descriptor file in the model path
        $descriptorPath = Join-Path -Path $ModelPath -ChildPath "Descriptor"
        $descriptorFiles = @()
        
        if (Test-Path -Path $descriptorPath -PathType Container) {
            $descriptorFiles = Get-ChildItem -Path $descriptorPath -Filter "*.xml" -File
        }
        
        if ($descriptorFiles.Count -eq 0) {
            Write-PSFMessage -Level Warning -Message "No descriptor XML files found in '$descriptorPath'"
            return $null
        }
        
        if ($descriptorFiles.Count -gt 1) {
            Write-PSFMessage -Level Warning -Message "Multiple descriptor files found, using the first one: $($descriptorFiles[0].Name)"
        }
        
        $descriptorFile = $descriptorFiles[0].FullName
        Write-PSFMessage -Level Verbose -Message "Found descriptor file: $descriptorFile"
        
        try {
            [xml]$xml = Get-Content $descriptorFile -Encoding UTF8
            
            $modelInfo = $xml.SelectNodes("/AxModelInfo")
            if ($modelInfo.Count -ne 1) {
                throw "File '$descriptorFile' is not a valid model descriptor file"
            }
            
            # Extract model information
            $modelName = ($xml.SelectNodes("/AxModelInfo/Name")).InnerText
            $layerId = [int]($xml.SelectNodes("/AxModelInfo/Layer")[0].InnerText)
            $layerName = Get-LayerName -LayerNumber $layerId
            
            $versionMajor = ($xml.SelectNodes("/AxModelInfo/VersionMajor")).InnerText
            $versionMinor = ($xml.SelectNodes("/AxModelInfo/VersionMinor")).InnerText
            $versionBuild = ($xml.SelectNodes("/AxModelInfo/VersionBuild")).InnerText
            $versionRevision = ($xml.SelectNodes("/AxModelInfo/VersionRevision")).InnerText
            
            $fullVersion = "$versionMajor.$versionMinor.$versionBuild.$versionRevision"
            
            $modelVersion = [PSCustomObject]@{
                ModelName = $modelName
                Version = $fullVersion
                LayerId = $layerId
                LayerName = $layerName
                DescriptorPath = $descriptorFile
                ModelPath = $ModelPath
                VersionMajor = [int]$versionMajor
                VersionMinor = [int]$versionMinor
                VersionBuild = [int]$versionBuild
                VersionRevision = [int]$versionRevision
            }
            
            Write-PSFMessage -Level Important -Message "Found model '$modelName' version $fullVersion in layer $layerName ($layerId)"
            return $modelVersion
        }
        catch {
            Write-PSFMessage -Level Host -Message "Something went wrong while reading D365FSC model version from '$descriptorFile'" -Exception $PSItem.Exception
            Stop-PSFFunction -Message "Stopping because of errors" -EnableException $true
            return
        }
    }
    
    end{
        Invoke-TimeSignal -End
    }          
}

$curModelVersion = Get-FSCPSModelVersion -ModelPath "D:\Sources\vertex\connector-d365-unified-connector\PackagesLocalDirectory\Vertex"
$curModelVersion.Version