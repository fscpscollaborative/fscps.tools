
<#
    .SYNOPSIS
        Function to receive the Name of the model from descriptor
        
    .DESCRIPTION
        Function to receive the Name of the model from descriptor
        
    .PARAMETER _modelName
        Model name
        
    .PARAMETER _modelPath
        Model path
        
    .EXAMPLE
        PS C:\> Get-AXModelName ModelName "TestModel" ModelPath "c:\Temp\PackagesLocalDirectory"
        
        This will return the model name from descriptor
        
    .NOTES
        Author: Oleksandr Nikolaiev (@onikolaiev)
#>
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