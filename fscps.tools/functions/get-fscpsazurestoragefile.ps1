
<#
    .SYNOPSIS
        Get a file from Azure
        
    .DESCRIPTION
        Get all files from an Azure Storage Account
        
    .PARAMETER AccountId
        Storage Account Name / Storage Account Id where you want to look for files
        
    .PARAMETER AccessToken
        The token that has the needed permissions for the search action
        
    .PARAMETER SAS
        The SAS key that you have created for the storage account or blob container
        
    .PARAMETER Container
        Name of the blob container inside the storage account where you want to look for files
        
    .PARAMETER Name
        Name of the file you are looking for
        
        Accepts wildcards for searching. E.g. -Name "Application*Adaptor"
        
        Default value is "*" which will search for all files
        
    .PARAMETER DestinationPath
        The destination folder of the Azure file to download. If empty just show the file information
        
    .PARAMETER Latest
        Instruct the cmdlet to only fetch the latest file from the Azure Storage Account
        
    .EXAMPLE
        PS C:\> Get-FSCPSAzureStorageFile -AccountId "miscfiles" -AccessToken "xx508xx63817x752xx74004x30705xx92x58349x5x78f5xx34xxxxx51" -Container "backupfiles"
        
        This will get the information of all files in the blob container "backupfiles".
        It will use the AccessToken "xx508xx63817x752xx74004x30705xx92x58349x5x78f5xx34xxxxx51" to gain access.
        
    .EXAMPLE
        PS C:\> Get-FSCPSAzureStorageFile -AccountId "miscfiles" -AccessToken "xx508xx63817x752xx74004x30705xx92x58349x5x78f5xx34xxxxx51" -Container "backupfiles" -Latest
        
        This will get the information of the latest (newest) file from the blob container "backupfiles".
        It will use the AccessToken "xx508xx63817x752xx74004x30705xx92x58349x5x78f5xx34xxxxx51" to gain access to the container.
        
    .EXAMPLE
        PS C:\> Get-FSCPSAzureStorageFile -AccountId "miscfiles" -AccessToken "xx508xx63817x752xx74004x30705xx92x58349x5x78f5xx34xxxxx51" -Container "backupfiles" -Name "*UAT*"
        
        This will get the information of all files in the blob container "backupfiles" that fits the "*UAT*" search value.
        It will use the AccessToken "xx508xx63817x752xx74004x30705xx92x58349x5x78f5xx34xxxxx51" to gain access to the container.
        
    .EXAMPLE
        PS C:\> Get-FSCPSAzureStorageFile -AccountId "miscfiles" -SAS "sv2018-03-28&siunlisted&src&sigAUOpdsfpoWE976ASDhfjkasdf(5678sdfhk" -Container "backupfiles" -Latest
        
        This will get the information of the latest (newest) file from the blob container "backupfiles".
        It will use the SAS key "sv2018-03-28&siunlisted&src&sigAUOpdsfpoWE976ASDhfjkasdf(5678sdfhk" to gain access to the container.
        
    .EXAMPLE
        PS C:\> Get-FSCPSAzureStorageFile -AccountId "miscfiles" -SAS "sv2018-03-28&siunlisted&src&sigAUOpdsfpoWE976ASDhfjkasdf(5678sdfhk" -Container "backupfiles" -Name "*UAT*" -DestinationPath "C:\Temp"
        
        This will get the information of all files in the blob container "backupfiles" that fits the "*UAT*" search value.
        It will also download all the files to the "C:\Temp" folder.
        It will use the SAS key "sv2018-03-28&siunlisted&src&sigAUOpdsfpoWE976ASDhfjkasdf(5678sdfhk" to gain access to the container.
        
    .NOTES
        Tags: Azure, Azure Storage, Token, Blob, File, Container
        
        This is a wrapper for the d365fo.tools functions Get-D365AzureStorageFile and Invoke-D365AzureStorageDownload to enable both retrieving file information from an Azure Storage Account and donwloading the files.
        
        Author: Oleksandr Nikolaiev (@onikolaiev)
        Author: Florian Hopfner (@FH-Inway)
#>
function Get-FSCPSAzureStorageFile {
    [CmdletBinding(DefaultParameterSetName = 'Default')]
    param (
        [string] $AccountId = $Script:AzureStorageAccountId,

        [string] $AccessToken = $Script:AzureStorageAccessToken,

        [string] $SAS = $Script:AzureStorageSAS,

        [Alias('Blob')]
        [Alias('Blobname')]
        [string] $Container = $Script:AzureStorageContainer,

        [Parameter(ParameterSetName = 'Default')]
        [Alias('FileName')]
        [string] $Name = "*",

        [string] $DestinationPath = "",

        [Parameter(Mandatory = $true, ParameterSetName = 'Latest')]
        [Alias('GetLatest')]
        [switch] $Latest
    )

    begin {
        Write-PSFMessage -Level Verbose -Message "Starting Get-FSCPSAzureStorageFile"
        Invoke-TimeSignal -Start
    }
    process {

        if (Test-PSFFunctionInterrupt) { return}

        $params = Get-ParameterValue |
            ConvertTo-PSFHashtable -ReferenceParameterSetName $PSCmdlet.ParameterSetName -ReferenceCommand Get-D365AzureStorageFile 
        $files = Get-D365AzureStorageFile @params

        try {

            $selectParams = @{
                TypeName = "FSCPS.TOOLS.Azure.Blob"
                Property =
                    "Name",
                    "Size",
                    "LastModified"
            }

            if (-not $DestinationPath) {
                $files | Select-PSFObject @selectParams
            }
            else {
                $d365AzureStorageDownloadParams = $params |
                    ConvertTo-PSFHashtable -ReferenceCommand Invoke-FSCPSAzureStorageDownload -ReferenceParameterSetName $PSCmdlet.ParameterSetName -Exclude Latest
                $d365AzureStorageDownloadParams.Force = $true
                foreach ($obj in $files) {
                    $null = Test-PathExists -Path $DestinationPath -Type Container -Create
                    $d365AzureStorageDownloadParams.Name = $obj.Name
                    $d365AzureStorageDownloadParams.Path = $DestinationPath
                    $null = Invoke-FSCPSAzureStorageDownload @d365AzureStorageDownloadParams
                    $destinationBlobPath = (Join-Path $DestinationPath ($obj.Name))
                    $selectParams.Property =
                        "Name",
                        "Size",
                        @{Name = "Path"; Expression = { [string]$destinationBlobPath } },
                        "LastModified"
                    $obj | Select-PSFObject @selectParams
                }
            }
        }
        catch {
            Write-PSFMessage -Level Warning -Message "Something broke" -ErrorRecord $_
        }
    }

    end {
        Invoke-TimeSignal -End
    }
}