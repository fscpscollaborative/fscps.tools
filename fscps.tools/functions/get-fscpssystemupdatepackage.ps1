
<#
    .SYNOPSIS
        Downloads a system update package for D365FSC.
        
    .DESCRIPTION
        The `Get-FSCPSSystemUpdatePackage` function downloads a system update package for Dynamics 365 Finance and Supply Chain (D365FSC) based on the specified update type and version. The package is downloaded from Azure Storage using the specified storage account configuration and saved to the specified output path.
        
    .PARAMETER UpdateType
        Specifies the type of update package to download. Valid values are "SystemUpdate" and "Preview".
        
    .PARAMETER D365FSCVersion
        Specifies the version of the D365FSC package to download.
        
    .PARAMETER OutputPath
        Specifies the path where the downloaded package will be saved.
        
    .PARAMETER StorageAccountConfig
        Specifies the storage account configuration to use. Default is "PackageStorage".
        
    .PARAMETER Force
        Forces the operation to proceed without prompting for confirmation.
        
    .EXAMPLE
        Get-FSCPSSystemUpdatePackage -UpdateType SystemUpdate -D365FSCVersion "10.0.40" -OutputPath "C:\Packages\"
        
        Downloads the system update package for version 10.0.40 and saves it to "C:\Packages\".
        
    .NOTES
        Uses the `Get-FSCPSAzureStorageFile` function to download the package from Azure Storage.

        Author: Oleksandr Nikolaiev (@onikolaiev)
#>
function Get-FSCPSSystemUpdatePackage {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseShouldProcessForStateChangingFunctions", "")]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseSingularNouns", "")]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseOutputTypeCorrectly", "")]
    [CmdletBinding()]
    param (
        [UpdateType] $UpdateType = [UpdateType]::SystemUpdate,
        [string] $D365FSCVersion,
        [string] $OutputPath,
        [string] $StorageAccountConfig = "PackageStorage",
        [switch] $Force
    )

    begin {
        Invoke-TimeSignal -Start
        # Validate D365FSCVersion
        if (-not $D365FSCVersion) {
            throw "D365FSCVersion is required."
        }

        # Validate OutputPath
        if (-not $OutputPath) {
            throw "OutputPath is required."
        }

        # Validate StorageAccountConfig
        if (-not $StorageAccountConfig) {
            throw "StorageAccountConfig is required."
        }

        if (Test-PSFFunctionInterrupt) { return }

        $azureStorageConfigs = [hashtable] (Get-PSFConfigValue -FullName "fscps.tools.azure.storage.accounts")

        if(!$azureStorageConfigs)
        {
            Init-AzureStorageDefault
            $azureStorageConfigs = [hashtable](Get-PSFConfigValue -FullName "fscps.tools.azure.storage.accounts")
        }

        if (-not ($azureStorageConfigs.ContainsKey($StorageAccountConfig))) {
            Write-PSFMessage -Level Host -Message "An Azure Storage Config with that name <c='$StorageAccountConfig'> doesn't exists</c>."
            Stop-PSFFunction -Message "Stopping because an Azure Storage Config with that name doesn't exists."
            return
        }
        else {
            
            $azureDetails = $azureStorageConfigs[$StorageAccountConfig]

            $currentActiveStorageConfig = Get-FSCPSActiveAzureStorageConfig
            if ($currentActiveStorageConfig.SAS -ne $azureDetails.SAS) {
                Set-FSCPSActiveAzureStorageConfig -Name $StorageAccountConfig -Temporary
            }
        }

         # Set the destination file name based on the UpdateType
         if ($UpdateType -eq [UpdateType]::SystemUpdate) {
            $destinationFileName = "Service Update - $D365FSCVersion"
        } elseif ($UpdateType -eq [UpdateType]::Preview) {
            $destinationFileName = "Preview Version - $D365FSCVersion"
        } elseif ($UpdateType -eq [UpdateType]::FinalQualityUpdate) {
            $destinationFileName = "Final Quality Update - $D365FSCVersion"
        } elseif ($UpdateType -eq [UpdateType]::ProactiveQualityUpdate) {
            $destinationFileName = "Proactive Quality Update - $D365FSCVersion"
        }

        # Combine the OutputPath with the destination file name
        $destinationFilePath = Join-Path -Path $OutputPath -ChildPath $destinationFileName
    }

    process {
        if (Test-PSFFunctionInterrupt) { return }

        [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
        try {           
            
            $download = (-not(Test-Path $destinationFilePath))

            if(!$download)
            {
                Write-PSFMessage -Level Host -Message $destinationFileName
                try {
                    $blobFile = Get-FSCPSAzureStorageFile -Name $destinationFileName
                }
                catch {
                    Write-PSFMessage -Level Error -Message "File $destinationFileName is not found at $($azureDetails.Container)"
                    throw                    
                }
                
                $blobSize = $blobFile.Length
                $localSize = (Get-Item $destinationFilePath).length
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
                Invoke-FSCPSAzureStorageDownload -FileName $destinationFileName -Path $OutputPath -Force:$Force
                if (-not [System.IO.Path]::GetExtension($downloadedFilePath)) {
                    # Rename the file to have a .zip extension
                    $newFilePath = "$downloadedFilePath.zip"
                    Rename-Item -Path $downloadedFilePath -NewName $newFilePath
                    Write-PSFMessage -Level Host -Message "Package saved to $newFilePath"
                }                
            }                        
        }
        catch {            
            Write-PSFMessage -Level Host -Message "Something went wrong while downloading NuGet package" -Exception $PSItem.Exception
            Stop-PSFFunction -Message "Stopping because of errors"
            return
        }
    }
    end{
        if((Get-FSCPSAzureStorageConfig $activeStorageConfigName -ErrorAction SilentlyContinue).Length -gt 0){
            Set-FSCPSActiveAzureStorageConfig $activeStorageConfigName -ErrorAction SilentlyContinue
        }
        else
        {
            Set-FSCPSActiveAzureStorageConfig "NuGetStorage" -ErrorAction SilentlyContinue
        }     
        Invoke-TimeSignal -End
    }
}