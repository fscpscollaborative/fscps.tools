
<#
    .SYNOPSIS
        Download a file to Azure
        
    .DESCRIPTION
        Download any file to an Azure Storage Account
        
    .PARAMETER AccountId
        Storage Account Name / Storage Account Id where you want to fetch the file from
        
    .PARAMETER AccessToken
        The token that has the needed permissions for the download action
        
    .PARAMETER SAS
        The SAS key that you have created for the storage account or blob container
        
    .PARAMETER Container
        Name of the blob container inside the storage account you where the file is
        
    .PARAMETER FileName
        Name of the file that you want to download
        
    .PARAMETER Path
        Path to the folder / location you want to save the file
        
        The default path is "c:\temp\fscps.tools"
        
    .PARAMETER Latest
        Instruct the cmdlet to download the latest file from Azure regardless of name
        
    .PARAMETER Force
        Instruct the cmdlet to overwrite the local file if it already exists
        
    .PARAMETER EnableException
        This parameters disables user-friendly warnings and enables the throwing of exceptions
        This is less user friendly, but allows catching exceptions in calling scripts
        
    .EXAMPLE
        PS C:\> Invoke-FSCPSAzureStorageDownload -AccountId "miscfiles" -AccessToken "xx508xx63817x752xx74004x30705xx92x58349x5x78f5xx34xxxxx51" -Container "backupfiles" -FileName "OriginalUAT.bacpac" -Path "c:\temp"
        
        Will download the "OriginalUAT.bacpac" file from the storage account and save it to "c:\temp\OriginalUAT.bacpac"
        
    .EXAMPLE
        PS C:\> Invoke-FSCPSAzureStorageDownload -AccountId "miscfiles" -AccessToken "xx508xx63817x752xx74004x30705xx92x58349x5x78f5xx34xxxxx51" -Container "backupfiles" -Path "c:\temp" -Latest
        
        Will download the file with the latest modified datetime from the storage account and save it to "c:\temp\".
        The complete path to the file will returned as output from the cmdlet.
        
    .EXAMPLE
        PS C:\> $AzureParams = Get-FSCPSActiveAzureStorageConfig
        PS C:\> Invoke-FSCPSAzureStorageDownload @AzureParams -Path "c:\temp" -Latest
        
        This will get the current Azure Storage Account configuration details
        and use them as parameters to download the latest file from an Azure Storage Account
        
        Will download the file with the latest modified datetime from the storage account and save it to "c:\temp\".
        The complete path to the file will returned as output from the cmdlet.
        
    .EXAMPLE
        PS C:\> Invoke-FSCPSAzureStorageDownload -Latest
        
        This will use the default parameter values that are based on the configuration stored inside "Get-FSCPSActiveAzureStorageConfig".
        Will download the file with the latest modified datetime from the storage account and save it to "c:\temp\fscps.tools".
        
    .EXAMPLE
        PS C:\> Invoke-FSCPSAzureStorageDownload -AccountId "miscfiles" -SAS "sv2018-03-28&siunlisted&src&sigAUOpdsfpoWE976ASDhfjkasdf(5678sdfhk" -Container "backupfiles" -Path "c:\temp" -Latest
        
        Will download the file with the latest modified datetime from the storage account and save it to "c:\temp\".
        A SAS key is used to gain access to the container and downloading the file from it.
        The complete path to the file will returned as output from the cmdlet.
        
    .NOTES
        Tags: Azure, Azure Storage, Config, Configuration, Token, Blob, File, Files, Latest, Bacpac, Container

        This is a wrapper for the d365fo.tools function Invoke-D365AzureStorageDownload.

        Author: Oleksandr Nikolaiev (@onikolaiev)
        Author: Florian Hopfner (@FH-Inway)

        The cmdlet supports piping and can be used in advanced scenarios. See more on github and the wiki pages.
        
#>
function Invoke-FSCPSAzureStorageDownload {
    [CmdletBinding(DefaultParameterSetName = 'Default')]
    param (
        [Parameter(Mandatory = $false)]
        [string] $AccountId = $Script:AzureStorageAccountId,

        [Parameter(Mandatory = $false)]
        [string] $AccessToken = $Script:AzureStorageAccessToken,

        [Parameter(Mandatory = $false)]
        [string] $SAS = $Script:AzureStorageSAS,

        [Alias('Blob')]
        [Alias('Blobname')]
        [string] $Container = $Script:AzureStorageContainer,

        [Parameter(Mandatory = $true, ParameterSetName = 'Default', ValueFromPipelineByPropertyName = $true)]
        [Alias('Name')]
        [string] $FileName,

        [string] $Path = $Script:DefaultTempPath,

        [Parameter(Mandatory = $true, ParameterSetName = 'Latest', Position = 4 )]
        [Alias('GetLatest')]
        [switch] $Latest,

        [switch] $Force,

        [switch] $EnableException
    )

    PROCESS {
        $params = Get-ParameterValue |
            ConvertTo-PSFHashtable -ReferenceCommand Invoke-D365AzureStorageDownload
        Invoke-D365AzureStorageDownload @params
    }
}