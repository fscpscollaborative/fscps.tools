
<#
    .SYNOPSIS
        Invoke the D365FSC models compilation
        
    .DESCRIPTION
        Invoke the D365FSC models compilation
        
    .PARAMETER Version
        The version of the D365FSC used to build
    
    .PARAMETER Type
        The type of the FSCPS project to build
        
    .PARAMETER SourcesPath
        The folder contains a metadata files with binaries
        
    .PARAMETER BuildFolderPath
        The destination build folder
        
    .PARAMETER Force
        Cleanup destination build folder befor build
        
    .EXAMPLE
        PS C:\> Invoke-FSCPSCompile -Version "10.0.39" -Type FSCM
        
        Example output:
        
        msMetadataDirectory  : D:\a\8\s\Metadata
        msFrameworkDirectory : C:\temp\buildbuild\packages\Microsoft.Dynamics.AX.Platform.CompilerPackage.7.0.7120.99
        msOutputDirectory    : C:\temp\buildbuild\bin
        solutionFolderPath   : C:\temp\buildbuild\10.0.39_build
        nugetPackagesPath    : C:\temp\buildbuild\packages
        buildLogFilePath     : C:\Users\VssAdministrator\AppData\Local\Temp\Build.sln.msbuild.log
        PACKAGE_NAME         : MAIN TEST-DeployablePackage-10.0.39-78
        PACKAGE_PATH         : C:\temp\buildbuild\artifacts\MAIN TEST-DeployablePackage-10.0.39-78.zip
        ARTIFACTS_PATH       : C:\temp\buildbuild\artifacts
        ARTIFACTS_LIST       : ["C:\temp\buildbuild\artifacts\MAIN TEST-DeployablePackage-10.0.39-78.zip"]
        
        This will build D365FSC package with version "10.0.39" to the Temp folder
        
    .EXAMPLE
        PS C:\> Invoke-FSCPSCompile -Version "10.0.39" -Path "c:\Temp"
        
        Example output:
        
        msMetadataDirectory  : D:\a\8\s\Metadata
        msFrameworkDirectory : C:\temp\buildbuild\packages\Microsoft.Dynamics.AX.Platform.CompilerPackage.7.0.7120.99
        msOutputDirectory    : C:\temp\buildbuild\bin
        solutionFolderPath   : C:\temp\buildbuild\10.0.39_build
        nugetPackagesPath    : C:\temp\buildbuild\packages
        buildLogFilePath     : C:\Users\VssAdministrator\AppData\Local\Temp\Build.sln.msbuild.log
        PACKAGE_NAME         : MAIN TEST-DeployablePackage-10.0.39-78
        PACKAGE_PATH         : C:\temp\buildbuild\artifacts\MAIN TEST-DeployablePackage-10.0.39-78.zip
        ARTIFACTS_PATH       : C:\temp\buildbuild\artifacts
        ARTIFACTS_LIST       : ["C:\temp\buildbuild\artifacts\MAIN TEST-DeployablePackage-10.0.39-78.zip"]
        
        This will build D365FSC package with version "10.0.39" to the Temp folder
        
    .NOTES
        Author: Oleksandr Nikolaiev (@onikolaiev)
        
#>

function Invoke-FSCPSCompile {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseShouldProcessForStateChangingFunctions", "")]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSAvoidUsingInvokeExpression", "")]
    [CmdletBinding()]
    [OutputType([System.Collections.Specialized.OrderedDictionary])]
    param (
        [string] $Version,
        [Parameter(Mandatory = $true)]
        [string] $SourcesPath,
        [FSCPSType]$Type,
        [string] $BuildFolderPath = (Join-Path $script:DefaultTempPath _bld),
        [switch] $Force
    )

    BEGIN {
        Invoke-TimeSignal -Start
        try {            
            $settings = Get-FSCPSSettings -OutputAsHashtable 
            $responseObject = [Ordered]@{}

            if($settings.type -eq '' -and ($null -eq $Type))
            {
                throw "Project type should be provided!"
            }

            if($settings.type -eq '')
            {
                $settings.type = $Type
            }
        }
        catch {
            Write-PSFMessage -Level Host -Message "Something went wrong while compiling " -Exception $PSItem.Exception
            Stop-PSFFunction -Message "Stopping because of errors" -EnableException $true
            return
        }

    }
    
    PROCESS {
        if (Test-PSFFunctionInterrupt) { return }
        try {            
            switch($settings.type)
            {
                'FSCM' { 
                    $responseObject = (Invoke-FSCCompile -Version $Version -SourcesPath $SourcesPath -BuildFolderPath $BuildFolderPath -Force:$Force )
                    break;
                }
                'ECommerce' { 
                    #$responseObject = (Invoke-ECommerceCompile -Version $Version -SourcesPath $SourcesPath -BuildFolderPath $BuildFolderPath -Force:$Force)
                    #break;
                }
                'Commerce' { 
                    $responseObject = (Invoke-CommerceCompile -Version $Version -SourcesPath $SourcesPath -BuildFolderPath $BuildFolderPath -Force:$Force) 
                    break;
                }
                Default{
                    throw "Project type should be provided!"
                }
            }
        }
        catch {
            Write-PSFMessage -Level Host -Message "Something went wrong while compiling " -Exception $PSItem.Exception
            Stop-PSFFunction -Message "Stopping because of errors" -EnableException $true
            return
        }
        finally{
            $responseObject
        }
    }
    END {
        Invoke-TimeSignal -End
    }
}