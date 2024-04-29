
<#
    .SYNOPSIS
        Get the D365FSC NuGet package
        
    .DESCRIPTION
        Get the D365FSC NuGet package from storage account
        
        Full list of NuGet: https://lcs.dynamics.com/V2/SharedAssetLibrary and select NuGet packages
        
    .PARAMETER Version
        The version of the NuGet package to download
        
    .PARAMETER Type
        The type of the NuGet package to download
        
    .PARAMETER Path
        The destination folder of the NuGet package to download
        
    .PARAMETER Force
        Instruct the cmdlet to override the package if exists
        
    .EXAMPLE
        PS C:\> Get-FSCPSNuget -Version "10.0.1777.99" -Type PlatformCompilerPackage
        
        This will download the NuGet package with version "10.0.1777.99" and type "PlatformCompilerPackage" to the current folder
        
    .EXAMPLE
        PS C:\> Get-FSCPSNuget -Version "10.0.1777.99" -Type PlatformCompilerPackage -Path "c:\temp"
        
        This will download the NuGet package with version "10.0.1777.99" and type "PlatformCompilerPackage" to the c:\temp folder
        
    .EXAMPLE
        PS C:\> Get-FSCPSNuget -Version "10.0.1777.99" -Type PlatformCompilerPackage -Path "c:\temp" -Force
        
        This will download the NuGet package with version "10.0.1777.99" and type "PlatformCompilerPackage" to the c:\temp folder and override if the package with the same name exists.
        
    .NOTES
        Author: Oleksandr Nikolaiev (@onikolaiev)
        
#>

function Get-FSCPSNuget {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseShouldProcessForStateChangingFunctions", "")]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSAvoidUsingInvokeExpression", "")]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseDeclaredVarsMoreThanAssignment", "")]
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string] $Version,
        [Parameter(Mandatory = $true)]
        [NuGetType] $Type,
        [string] $Path,
        [switch] $Force
    )

    BEGIN {
        Invoke-TimeSignal -Start
        $packageName = ""
        switch ($Type) {
            ([NugetType]::ApplicationSuiteDevALM)
            { 
                $packageName = "Microsoft.Dynamics.AX.ApplicationSuite.DevALM.BuildXpp.$Version.nupkg"
                break;
            }
            ([NugetType]::ApplicationDevALM)
            { 
                $packageName = "Microsoft.Dynamics.AX.Application.DevALM.BuildXpp.$Version.nupkg"
                break;
            }
           ([NugetType]::PlatformDevALM)
            { 
                $packageName = "Microsoft.Dynamics.AX.Platform.DevALM.BuildXpp.$Version.nupkg"
                break;
            }
            ([NugetType]::PlatformCompilerPackage)
            { 
                $packageName = "Microsoft.Dynamics.AX.Platform.CompilerPackage.$Version.nupkg"
                break;
            }
            Default {}
        }

        $storageConfigs = Get-FSCPSAzureStorageConfig
        $activeStorageConfigName = "NugetStorage"
        if($storageConfigs)
        {
            $activeStorageConfig = Get-FSCPSActiveAzureStorageConfig
            $storageConfigs | ForEach-Object {
                if($_.AccountId -eq $activeStorageConfig.AccountId -and $_.Container -eq $activeStorageConfig.Container -and $_.SAS -eq $activeStorageConfig.SAS)
                {
                    $activeStorageConfigName = $_.Name
                    $activeStorageConfigName
                }
            }
        }        
        Write-PSFMessage -Level Verbose -Message "ActiveStorageConfigName: $activeStorageConfigName"
        if($Force)
        {
            $null = Test-PathExists $Path -Create -Type Container 
        }
        else{
            $null = Test-PathExists $Path -Type Container
        }
    }
    
    PROCESS {
        if (Test-PSFFunctionInterrupt) { return }
        [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
        try {
            Set-FSCPSActiveAzureStorageConfig "NuGetStorage"

            $destinationNugetFilePath = Join-Path $Path $packageName 
            
            $download = (-not(Test-Path $destinationNugetFilePath))

            if(!$download)
            {
                Write-PSFMessage -Level Host -Message $packageName
                $blobFile = Get-FSCPSAzureStorageFile -Name $packageName
                $blobSize = $blobFile.Length
                $localSize = (Get-Item $destinationNugetFilePath).length
                Write-PSFMessage -Level Verbose -Message "BlobSize is: $blobSize"
                Write-PSFMessage -Level Verbose -Message "LocalSize is: $blobSize"
                $download = $blobSize -ne $localSize
            }

            if($Force)
            {
                $download = $true
            }

            if($download)
            {
                Invoke-FSCPSAzureStorageDownload -FileName $packageName -Path $Path
            }
        }
        catch {            
            Write-PSFMessage -Level Host -Message "Something went wrong while downloading NuGet package" -Exception $PSItem.Exception
            Stop-PSFFunction -Message "Stopping because of errors"
            return
        }
        finally{
            if($activeStorageConfigName){
                Set-FSCPSActiveAzureStorageConfig $activeStorageConfigName
            }
            else
            {
                Set-FSCPSActiveAzureStorageConfig "NuGetStorage"
            }
            
        }
    }
    END {
        Invoke-TimeSignal -End
    }
}