
<#
    .SYNOPSIS
        Get the D365FSC NuGet package
        
    .DESCRIPTION
        Get the D365FSC NuGet package from storage account
        
        Full list of NuGet: https://lcs.dynamics.com/V2/SharedAssetLibrary and select NuGet packages
        
    .PARAMETER Version
        The version of the NuGet package to download
        
    .PARAMETER KnownVersion
        The short FNO version (e.g. "10.0.45"). The actual NuGet version will be resolved using the version info data and the KnownType parameter
        
    .PARAMETER KnownType
        The version strategy to use when resolving KnownVersion. Valid values are GA and Latest
        
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
        
    .EXAMPLE
        PS C:\> Get-FSCPSNuget -KnownVersion "10.0.45" -KnownType GA -Type PlatformCompilerPackage -Path "c:\temp"
        
        This will resolve the GA platform version for FNO 10.0.45 and download the PlatformCompilerPackage NuGet to c:\temp
        
    .EXAMPLE
        PS C:\> Get-FSCPSNuget -KnownVersion "10.0.45" -KnownType Latest -Type ApplicationDevALM -Path "c:\temp"
        
        This will resolve the Latest application version for FNO 10.0.45 and download the ApplicationDevALM NuGet to c:\temp
        
    .NOTES
        Author: Oleksandr Nikolaiev (@onikolaiev)
        
#>

function Get-FSCPSNuget {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseShouldProcessForStateChangingFunctions", "")]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSAvoidUsingInvokeExpression", "")]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseDeclaredVarsMoreThanAssignment", "")]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseDeclaredVarsMoreThanAssignments", "")]
    [OutputType([System.Collections.Hashtable])]
    [CmdletBinding(DefaultParameterSetName = 'Version')]
    param (
        [Parameter(Mandatory = $true, ParameterSetName = 'Version')]
        [string] $Version,
        [Parameter(Mandatory = $true, ParameterSetName = 'KnownVersion')]
        [string] $KnownVersion,
        [Parameter(Mandatory = $true, ParameterSetName = 'KnownVersion')]
        [VersionStrategy] $KnownType,
        [Parameter(Mandatory = $true)]
        [NuGetType] $Type,
        [string] $Path,
        [switch] $Force
    )

    BEGIN {
        Invoke-TimeSignal -Start
        $packageName = ""

        # Resolve version from KnownVersion + KnownType if provided
        if ($PSCmdlet.ParameterSetName -eq 'KnownVersion') {
            Write-PSFMessage -Level Verbose -Message "Resolving NuGet version for FNO version '$KnownVersion' with strategy '$KnownType'"
            $originalStrategy = Get-PSFConfigValue -FullName "fscps.tools.settings.all.versionStrategy"
            try {
                Set-PSFConfig -FullName "fscps.tools.settings.all.versionStrategy" -Value ($KnownType.ToString())
                $versionInfo = Get-FSCPSVersionInfo -Version $KnownVersion
                if (-not $versionInfo) {
                    Stop-PSFFunction -Message "Could not resolve version info for FNO version '$KnownVersion'. Make sure the version exists in the versions data."
                    return
                }
                # Determine the resolved version based on NuGet type
                switch ($Type) {
                    { $_ -in @([NuGetType]::PlatformCompilerPackage, [NuGetType]::PlatformDevALM) } {
                        $Version = $versionInfo.data.PlatformVersion
                    }
                    { $_ -in @([NuGetType]::ApplicationDevALM, [NuGetType]::ApplicationSuiteDevALM) } {
                        $Version = $versionInfo.data.AppVersion
                    }
                }
                Write-PSFMessage -Level Verbose -Message "Resolved NuGet version: '$Version'"
            }
            finally {
                Set-PSFConfig -FullName "fscps.tools.settings.all.versionStrategy" -Value $originalStrategy
            }
        }
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
        if($storageConfigs.Length -gt 0)
        {
            $activeStorageConfig = Get-FSCPSActiveAzureStorageConfig
            $storageConfigs | ForEach-Object {
                if($_.AccountId -eq $activeStorageConfig.AccountId -and $_.Container -eq $activeStorageConfig.Container -and $_.SAS -eq $activeStorageConfig.SAS)
                {
                    $activeStorageConfigName = $_.Name
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
            Set-FSCPSActiveAzureStorageConfig "NuGetStorage" -ErrorAction SilentlyContinue
            $destinationNugetFilePath = Join-Path $Path $packageName 
            
            $download = (-not(Test-Path $destinationNugetFilePath))

            if(!$download)
            {
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
                Invoke-FSCPSAzureStorageDownload -FileName $packageName -Path $Path -Force:$Force
            }
            return @{
                Package = $packageName
                Path = $Path
            }
        }
        catch {            
            Write-PSFMessage -Level Host -Message "Something went wrong while downloading NuGet package" -Exception $PSItem.Exception
            Stop-PSFFunction -Message "Stopping because of errors"
            return
        }
        finally{
            if((Get-FSCPSAzureStorageConfig $activeStorageConfigName -ErrorAction SilentlyContinue).Length -gt 0){
                Set-FSCPSActiveAzureStorageConfig $activeStorageConfigName -ErrorAction SilentlyContinue
            }
            else
            {
                Set-FSCPSActiveAzureStorageConfig "NuGetStorage" -ErrorAction SilentlyContinue
            }       
        }
    }
    END {
        Invoke-TimeSignal -End
    }
}