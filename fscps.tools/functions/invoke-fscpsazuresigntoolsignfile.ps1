
<#
    .SYNOPSIS
        Function to sign the files with KeyVault
        
    .DESCRIPTION
        Function to sign the files with KeyVault
        
    .PARAMETER Uri
        A fully qualified URL of the key vault with the certificate that will be used for signing. An example value might be https://my-vault.vault.azure.net.
        
    .PARAMETER TenantId
        This is the tenant id used to authenticate to Azure, which will be used to generate an access token.
        
    .PARAMETER CertificateName
        The name of the certificate used to perform the signing operation.
        
    .PARAMETER ClientId
        This is the client ID used to authenticate to Azure, which will be used to generate an access token.
        
    .PARAMETER ClientSecret
        This is the client secret used to authenticate to Azure, which will be used to generate an access token.
        
    .PARAMETER TimestampServer
        A URL to an RFC3161 compliant timestamping service.
        
    .PARAMETER FILE
        A file to sign
        
    .EXAMPLE
        PS C:\> Invoke-FSCPSAzureSignToolSignFile -Uri "https://my-vault.vault.azure.net" `
            -TenantId "01234567-abcd-ef012-0000-0123456789ab" `
            -CertificateName "my-key-name" `
            -ClientId "01234567-abcd-ef012-0000-0123456789ab" `
            -ClientSecret "secret" `
            -FILE "$filePath"
        
        This will sign the target file with the KeyVault certificate
    .NOTES
        Author: Oleksandr Nikolaiev (@onikolaiev)
#>
function Invoke-FSCPSAzureSignToolSignFile {
    param (
        [Parameter(HelpMessage = "A fully qualified URL of the key vault with the certificate that will be used for signing.", Mandatory = $false)]
        [string] $Uri,
        [Parameter(HelpMessage = "This is the tenant id used to authenticate to Azure, which will be used to generate an access token.", Mandatory = $true)]
        [string] $TenantId,
        [Parameter(HelpMessage = "The name of the certificate used to perform the signing operation.", Mandatory = $false)]
        [string] $CertificateName,
        [Parameter(HelpMessage = "This is the client ID used to authenticate to Azure, which will be used to generate an access token.", Mandatory = $false)]
        [string] $ClientId,
        [Parameter(HelpMessage = "This is the client secret used to authenticate to Azure, which will be used to generate an access token.", Mandatory = $true)]
        [SecureString] $ClientSecret,
        [Parameter(HelpMessage = "A URL to an RFC3161 compliant timestamping service.", Mandatory = $true)]
        [string] $TimestampServer = "http://timestamp.digicert.com",    
        [Parameter(HelpMessage = "A file to sign", Mandatory = $true)]
        [string] $FILE
    )
    begin{
        $tempDirectory = "c:\temp"
        if (!(Test-Path -Path $tempDirectory))
        {
            [System.IO.Directory]::CreateDirectory($tempDirectory)
        }
        
        if(-not (Test-Path $FILE ))
        {
            Write-Error "File $FILE is not found! Check the path."
            exit 1;
        }
        try {
            & dotnet tool install --global AzureSignTool;
        }
        catch {
            Write-PSFMessage -Level Host -Message "Something went wrong while installing AzureSignTool" -Exception $PSItem.Exception
        }


    }
    process{
        try {
            & azuresigntool sign -kvu "$($Uri)" -kvt "$($TenantId)" -kvc "$($CertificateName)" -kvi "$($ClientId)" -kvs "$($ClientSecret)" -tr "$($TimestampServer)" -td sha256 "$FILE"
        }
        catch {
            
            Write-PSFMessage -Level Host -Message "Something went wrong while signing file. " -Exception $PSItem.Exception
            Stop-PSFFunction -Message "Stopping because of errors" -EnableException $true
            return
        }
    }
    end{

    }
}