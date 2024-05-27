
<#
    .SYNOPSIS
        Delete a file to Azure
        
    .DESCRIPTION
        Delete any file to an Azure Storage Account
        
    .PARAMETER AccountId
        Storage Account Name / Storage Account Id where you want to store the file
        
    .PARAMETER AccessToken
        The token that has the needed permissions for the delete action
        
    .PARAMETER SAS
        The SAS key that you have created for the storage account or blob container
        
    .PARAMETER Container
        Name of the blob container inside the storage account you want to store the file
        
    .PARAMETER FileName
        Path to the file you want to delete
        
    .PARAMETER Force
        Instruct the cmdlet to overwrite the file in the container if it already exists
        
    .PARAMETER EnableException
        This parameters disables user-friendly warnings and enables the throwing of exceptions
        This is less user friendly, but allows catching exceptions in calling scripts
        
    .EXAMPLE
        PS C:\> $AzureParams = Get-FSCActiveAzureStorageConfig
        PS C:\> New-D365Bacpac | Invoke-FSCPSAzureStorageDelete @AzureParams
        
        This will get the current Azure Storage Account configuration details and use them as parameters to delete the file from Azure Storage Account.
        
    .EXAMPLE
        PS C:\> Invoke-FSCPSAzureStorageDelete -AccountId "miscfiles" -SAS "sv2018-03-28&siunlisted&src&sigAUOpdsfpoWE976ASDhfjkasdf(5678sdfhk" -Container "backupfiles" -FileName "UAT_20180701.bacpac"
        
        This will delete the "UAT_20180701.bacpac" from the "backupfiles" container, inside the "miscfiles" Azure Storage Account.
        A SAS key is used to gain access to the container and deleteng the file.
        
    .NOTES
        Tags: Azure, Azure Storage, Config, Configuration, Token, Blob, File, Files, Bacpac, Container
        Author: Oleksandr Nikolaiev (@onikolaiev)
        
        The cmdlet supports piping and can be used in advanced scenarios. See more on github and the wiki pages.
        
#>
function Invoke-FSCPSAzureStorageDelete {
    [CmdletBinding(DefaultParameterSetName = 'Default')]
    param (
        [Parameter(Mandatory = $false)]
        [string] $AccountId = $Script:AzureStorageAccountId,

        [Parameter(Mandatory = $false)]
        [string] $AccessToken = $Script:AzureStorageAccessToken,

        [Parameter(Mandatory = $false)]
        [string] $SAS = $Script:AzureStorageSAS,

        [Parameter(Mandatory = $false)]
        [Alias('Blob')]
        [Alias('Blobname')]
        [string] $Container = $Script:AzureStorageContainer,

        [Parameter(Mandatory = $true, ParameterSetName = 'Default', ValueFromPipeline = $true)]
        [Parameter(Mandatory = $true, ParameterSetName = 'Pipeline', ValueFromPipelineByPropertyName = $true)]
        [Alias('File')]
        [string] $FileName,

        [switch] $Force,

        [switch] $EnableException
    )
    BEGIN {
        if (([string]::IsNullOrEmpty($AccountId) -eq $true) -or
            ([string]::IsNullOrEmpty($Container)) -or
            (([string]::IsNullOrEmpty($AccessToken)) -and ([string]::IsNullOrEmpty($SAS)))) {
            Write-PSFMessage -Level Host -Message "It seems that you are missing some of the parameters. Please make sure that you either supplied them or have the right configuration saved."
            Stop-PSFFunction -Message "Stopping because of missing parameters"
            return
        }
    }
    PROCESS {
        if (Test-PSFFunctionInterrupt) { return }

        Invoke-TimeSignal -Start
        try {

            if ([string]::IsNullOrEmpty($SAS)) {
                Write-PSFMessage -Level Verbose -Message "Working against Azure Storage Account with AccessToken"

                $storageContext = New-AzStorageContext -StorageAccountName $AccountId.ToLower() -StorageAccountKey $AccessToken
            }
            else {
                $conString = $("BlobEndpoint=https://{0}.blob.core.windows.net/;QueueEndpoint=https://{0}.queue.core.windows.net/;FileEndpoint=https://{0}.file.core.windows.net/;TableEndpoint=https://{0}.table.core.windows.net/;SharedAccessSignature={1}" -f $AccountId.ToLower(), $SAS)

                Write-PSFMessage -Level Verbose -Message "Working against Azure Storage Account with SAS" -Target $conString                
                $storageContext = New-AzStorageContext -ConnectionString $conString
            }

            Write-PSFMessage -Level Verbose -Message "Start deleting the file from Azure"

            $files = Get-FSCPSAzureStorageFile -Name $FileName
            foreach($file in $files)
            {
                $null = Remove-AzStorageBlob -Blob $file.Name -Container $($Container.ToLower()) -Context $storageContext -Force:$Force
                Write-PSFMessage -Level Verbose -Message "The blob $($file.Name) succesfully deleted."
            }
            if(-not $files)
            {
                Write-PSFMessage -Level Verbose -Message "Files with filter '$($FileName)' were not found in the Storage Account."
            }
        }
        catch {
            $messageString = "Something went wrong while <c='em'>uploading</c> the file to Azure."
            Write-PSFMessage -Level Host -Message $messageString -Exception $PSItem.Exception -Target $FileName
            Stop-PSFFunction -Message "Stopping because of errors." -Exception $([System.Exception]::new($($messageString -replace '<[^>]+>', ''))) -ErrorRecord $_
            return
        }
        finally {
            Invoke-TimeSignal -End
        }
    }

    END { }
}