
<#
    .SYNOPSIS
        Get the list of D365FSC components versions
        
    .DESCRIPTION
        Get the list of D365FSC components versions (NuGets, Packages, Frameworks etc.)

        
    .PARAMETER Version
        The version of the D365FSC

    .EXAMPLE
        PS C:\> Get-FSCPSVersionInfo -Version "10.0.39"
        
        This will show the list of file versions for the FSCPS module of the 10.0.39 D365FSC.
        
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