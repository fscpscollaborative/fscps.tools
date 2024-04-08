
<#
    .SYNOPSIS
        Get list of the D365FSC models from metadata path
        
    .DESCRIPTION
        Get list of the D365FSC models from metadata path prepared to build
        
    .PARAMETER MetadataPath
        Path to the metadata folder (PackagesLocalDirectory)

    .PARAMETER IncludeTest
        Includes test models

    .PARAMETER All
        Return all models even without source code
        
    .EXAMPLE
        PS C:\> Get-FSCModels -MetadataPath "J:\AosService\PackagesLocalDirectory"
        
        This will return the list of models without test models and models without source code

    .EXAMPLE
        PS C:\> Get-FSCModels -MetadataPath "J:\AosService\PackagesLocalDirectory" -IncludeTest
        
        This will return the list of models with test models and models without source code

    .EXAMPLE
        PS C:\> Get-FSCModels -MetadataPath "J:\AosService\PackagesLocalDirectory" -IncludeTest -All
        
        This will return the list of all models
        
    .NOTES
        Author: Oleksandr Nikolaiev (@onikolaiev)
        
#>
function Get-FSCModelList
{
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string]  $MetadataPath,
        [switch]  $IncludeTest = $false,
        [switch]  $All = $false
    )
    if(Test-Path "$MetadataPath")
    {
        $modelsList = @()

        (Get-ChildItem -Directory "$MetadataPath") | ForEach-Object {

            $testModel = ($_.BaseName -match "Test")

            if ($testModel -and $IncludeTest) {
                $modelsList += ($_.BaseName)
            }
            if((Test-Path ("$MetadataPath/$($_.BaseName)/Descriptor")) -and !$testModel) {
                $modelsList += ($_.BaseName)
            }
            if(!(Test-Path ("$MetadataPath/$($_.BaseName)/Descriptor")) -and !$testModel -and $All) {
                $modelsList += ($_.BaseName)
            }
        }
        return $modelsList -join ","
    }
    else 
    {
        Write-PSFMessage -Level Host -Message "Something went wrong while downloading NuGet package" -Exception "Folder $MetadataPath with metadata doesnot exists"
        Stop-PSFFunction -Message "Stopping because of errors"
        return
    }
}