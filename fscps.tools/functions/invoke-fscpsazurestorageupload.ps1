
<#
    .SYNOPSIS
        Upload a file to Azure
        
    .DESCRIPTION
        Upload any file to an Azure Storage Account
        
    .PARAMETER AccountId
        Storage Account Name / Storage Account Id where you want to store the file
        
    .PARAMETER AccessToken
        The token that has the needed permissions for the upload action
        
    .PARAMETER SAS
        The SAS key that you have created for the storage account or blob container
        
    .PARAMETER Container
        Name of the blob container inside the storage account you want to store the file
        
    .PARAMETER Filepath
        Path to the file you want to upload
        
    .PARAMETER ContentType
        Media type of the file that is going to be uploaded
        
        The value will be used for the blob property "Content Type".
        If the parameter is left empty, the commandlet will try to automatically determined the value based on the file's extension.
        The content type "application/octet-stream" will be used as fallback if no value can be determined.
        Valid media type values can be found here: https://github.com/jshttp/mime-db
        
    .PARAMETER Force
        Instruct the cmdlet to overwrite the file in the container if it already exists
        
    .PARAMETER DeleteOnUpload
        Switch to tell the cmdlet if you want the local file to be deleted after the upload completes
        
    .PARAMETER EnableException
        This parameters disables user-friendly warnings and enables the throwing of exceptions
        This is less user friendly, but allows catching exceptions in calling scripts
        
    .EXAMPLE
        PS C:\> Invoke-FSCPSAzureStorageUpload -AccountId "miscfiles" -AccessToken "xx508xx63817x752xx74004x30705xx92x58349x5x78f5xx34xxxxx51" -Container "backupfiles" -Filepath "c:\temp\bacpac\UAT_20180701.bacpac"  -DeleteOnUpload
        
        This will upload the "c:\temp\bacpac\UAT_20180701.bacpac" up to the "backupfiles" container, inside the "miscfiles" Azure Storage Account that is access with the "xx508xx63817x752xx74004x30705xx92x58349x5x78f5xx34xxxxx51" token.
        After upload the local file will be deleted.
        
    .EXAMPLE
        PS C:\> $AzureParams = Get-D365ActiveAzureStorageConfig
        PS C:\> New-D365Bacpac | Invoke-FSCPSAzureStorageUpload @AzureParams
        
        This will get the current Azure Storage Account configuration details and use them as parameters to upload the file to an Azure Storage Account.
        
    .EXAMPLE
        PS C:\> New-D365Bacpac | Invoke-FSCPSAzureStorageUpload
        
        This will generate a new bacpac file using the "New-D365Bacpac" cmdlet.
        The file will be uploaded to an Azure Storage Account using the "Invoke-FSCPSAzureStorageUpload" cmdlet.
        This will use the default parameter values that are based on the configuration stored inside "Get-D365ActiveAzureStorageConfig" for the "Invoke-FSCPSAzureStorageUpload" cmdlet.
        
    .EXAMPLE
        PS C:\> Invoke-FSCPSAzureStorageUpload -AccountId "miscfiles" -SAS "sv2018-03-28&siunlisted&src&sigAUOpdsfpoWE976ASDhfjkasdf(5678sdfhk" -Container "backupfiles" -Filepath "c:\temp\bacpac\UAT_20180701.bacpac"
        
        This will upload the "c:\temp\bacpac\UAT_20180701.bacpac" up to the "backupfiles" container, inside the "miscfiles" Azure Storage Account.
        A SAS key is used to gain access to the container and uploading the file to it.
        
    .NOTES
        Tags: Azure, Azure Storage, Config, Configuration, Token, Blob, File, Files, Bacpac, Container
        
        This is a wrapper for the d365fo.tools function Invoke-D365AzureStorageUpload to enable uploading files to an Azure Storage Account.
        
        Author: Oleksandr Nikolaiev (@onikolaiev)
        Author: Florian Hopfner (@FH-Inway)
        
        The cmdlet supports piping and can be used in advanced scenarios. See more on github and the wiki pages.
        
#>
function Invoke-FSCPSAzureStorageUpload {
    [CmdletBinding(DefaultParameterSetName = 'Default')]
    param (
        [string] $AccountId = $Script:AzureStorageAccountId,

        [string] $AccessToken = $Script:AzureStorageAccessToken,

        [string] $SAS = $Script:AzureStorageSAS,

        [Alias('Blob')]
        [Alias('Blobname')]
        [string] $Container = $Script:AzureStorageContainer,

        [Parameter(Mandatory = $true, ParameterSetName = 'Default', ValueFromPipeline = $true)]
        [Parameter(Mandatory = $true, ParameterSetName = 'Pipeline', ValueFromPipelineByPropertyName = $true)]
        [Alias('File')]
        [Alias('Path')]
        [string] $Filepath,

        [string] $ContentType,

        [switch] $Force,

        [switch] $DeleteOnUpload,

        [switch] $EnableException
    )

    PROCESS {
        if (Test-PSFFunctionInterrupt) { return }

        Invoke-TimeSignal -Start
        try {
            if ([string]::IsNullOrEmpty($ContentType)) {
                $FileName = Split-Path -Path $Filepath -Leaf
                $ContentType = Get-MediaTypeByFilename $FileName

                Write-PSFMessage -Level Verbose -Message "Content Type is automatically set to value: $ContentType"
            }
            $params = Get-ParameterValue |
                ConvertTo-PSFHashtable -ReferenceCommand Invoke-D365AzureStorageUpload -ReferenceParameterSetName $PSCmdlet.ParameterSetName

            Invoke-D365AzureStorageUpload @params
        }
        finally {
            Invoke-TimeSignal -End
        }
    }
}