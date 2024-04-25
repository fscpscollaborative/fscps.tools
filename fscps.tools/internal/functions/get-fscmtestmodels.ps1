
<#
    .SYNOPSIS
        Get the list of D365FSC components versions
        
    .DESCRIPTION
        Get the list of D365FSC components versions (NuGets, Packages, Frameworks etc.)
        
        
    .PARAMETER ModelsList
        The list of D365FSC models
        
    .PARAMETER MetadataPath
        The path to the D365FSC metadata
        
    .EXAMPLE
        PS C:\> Get-FSCMTestModel -ModelsList "test" $MetadataPath "c:\temp\Metadata"
        
        This will show the list of test models.
        
    .NOTES
        Author: Oleksandr Nikolaiev (@onikolaiev)
        
#>
function Get-FSCMTestModel
{
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string] $ModelsList,
        [Parameter(Mandatory = $true)]
        [string] $MetadataPath
    )
    begin{
        $testModelsList = @()
        function Get-AXModelReference
        {
            [CmdletBinding()]
            param (
                [string]
                $descriptorPath
            )
            if(Test-Path "$descriptorPath")
            {
                [xml]$xmlData = Get-Content $descriptorPath
                $modelDisplayName = $xmlData.SelectNodes("//AxModelInfo/ModuleReferences")
                return $modelDisplayName.string 
            }
        }
    }
    process{
        $ModelsList.Split(",") | ForEach-Object {
            $modelName = $_
            (Get-ChildItem -Path $MetadataPath) | ForEach-Object{ 
                $mdlName = $_.BaseName        
                if($mdlName -eq $modelName){ return; } 
                $checkTest = $($mdlName.Contains("Test"))
                if(-not $checkTest){ return; }        
                Write-PSFMessage -Level Debug -Message "ModelName: $mdlName"
                $descriptorSearchPath = (Join-Path $_.FullName "Descriptor")
                $descriptor = (Get-ChildItem -Path $descriptorSearchPath -Filter '*.xml')
                if($descriptor)
                {
                    $refmodels = (Get-AXModelReference -descriptorPath $descriptor.FullName)
                    Write-PSFMessage -Level Debug -Message "RefModels: $refmodels"
                    foreach($ref in $refmodels)
                    {
                        if($modelName -eq $ref)
                        {
                            if(-not $testModelsList.Contains("$mdlName"))
                            {
                                $testModelsList += ("$mdlName")
                            }
                        }
                    }
                }
            }
        }
    }
    end{
        return $testModelsList -join ","
    } 
}