
<#
    .SYNOPSIS
        This uploads the D365FSC nugets from the LCS to the active storage account
        
    .DESCRIPTION
        This uploads the D365FSC nugets from the LCS to the active NuGet storage account
        
    .PARAMETER LCSUserName
        The LCS username
        
    .PARAMETER LCSUserPassword
        The LCS password
        
    .PARAMETER LCSProjectId
        The LCS project ID
        
    .PARAMETER LCSClientId
        The ClientId what has access to the LCS
        
    .PARAMETER FSCMinimumVersion
        The minimum version of the FSC to update the NuGet`s
        
    .EXAMPLE
        PS C:\> Update-FSCPSNugetsFromLCS -LCSUserName "admin@contoso.com" -LCSUserPassword "superSecureString" -LCSProjectId "123456" -LCSClientId "123ebf68-a86d-4392-ae38-57b2172ee789" -FSCMinimumVersion "10.0.38"
        
        this will uploads the D365FSC nugets from the LCS to the active storage account
    .NOTES
        Author: Oleksandr Nikolaiev (@onikolaiev)
        
#>
function Update-FSCPSNugetsFromLCS {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseShouldProcessForStateChangingFunctions", "")]
    [CmdletBinding()]
    param(
        [Parameter()]
        [string]$LCSUserName,
        [Parameter()]
        [SecureString]$LCSUserPassword,
        [Parameter()]
        [string]$LCSProjectId,
        [Parameter()]
        [string]$LCSClientId,
        [Parameter()]
        [string]$FSCMinimumVersion
    )

    begin{
        Invoke-TimeSignal -Start
        $BSTR = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($LCSUserPassword)
        $UnsecureLCSUserPassword = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($BSTR)

        Get-D365LcsApiToken -ClientId $LCSClientId -Username $LCSUserName -Password $UnsecureLCSUserPassword -LcsApiUri "https://lcsapi.lcs.dynamics.com" | Set-D365LcsApiConfig -ProjectId $LCSProjectId -ClientId $LCSClientId

    }
    process{
    
        try
        {

            Get-D365LcsApiConfig
            $assetList = Get-D365LcsSharedAssetFile -FileType NuGetPackage

            $assetList | Sort-Object{$_.ModifiedDate} | ForEach-Object {
            #$fileName = $_.FileName
            
            $fscVersion = Get-FSCVersionFromPackageName $_.Name
            if($fscVersion -gt $FSCMinimumVersion -and $fscVersion.Length -gt 6)
            {
                Write-PSFMessage -Level Host -Message "#################### $fscVersion #####################"
                try
                {
                    #ProcessingNuGet -FSCVersion $fscVersion -AssetId $_.Id -AssetName $fileName -ProjectId $lcsProjectId -LCSToken $lcstoken -StorageSAStoken $StorageSAStoken -LCSAssetName $_.Name
                }
                catch
                {
                    $_.Exception.Message
                }
            }
        }

<#

            $assetList = Get-D365LcsSharedAssetFile -FileType NuGetPackage 

            [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
            $destinationNugetFilePath = Join-Path $PackageDestination $AssetName  
    
            #get download link asset
            $uri = "https://lcsapi.lcs.dynamics.com/box/fileasset/GetFileAsset/$($ProjectId)?assetId=$($AssetId)"
            $assetJson = (Invoke-RestMethod -Method Get -Uri $uri -Headers $header)
    
            if(Test-Path $destinationNugetFilePath)
            {
                $regex = [regex] "\b(([0-9]*[0-9])\.){3}(?:[0-9]*[0-9]?)\b"
                $filenameVersion = $regex.Match($AssetName).Value
                $version = Get-NuGetVersion $destinationNugetFilePath
                if($filenameVersion -ne "")
                {
                    $newdestinationNugetFilePath = ($destinationNugetFilePath).Replace(".$filenameVersion.nupkg", ".nupkg") 
                }
                else { $newdestinationNugetFilePath = $destinationNugetFilePath }
                $newdestinationNugetFilePath = ($newdestinationNugetFilePath).Replace(".nupkg",".$version.nupkg")
                if(-not(Test-Path $newdestinationNugetFilePath))
                {
                    Rename-Item -Path $destinationNugetFilePath -NewName ([System.IO.DirectoryInfo]$newdestinationNugetFilePath).FullName -Force -PassThru
                }
                $destinationNugetFilePath = $newdestinationNugetFilePath
            }
            $download = (-not(Test-Path $destinationNugetFilePath))
    
            $blob = Get-AzStorageBlob -Context $ctx -Container $storageContainer -Blob $AssetName -ConcurrentTaskCount 10 -ErrorAction SilentlyContinue
           
            if(!$blob)
            {
                if($download)
                {               
                    Invoke-D365AzCopyTransfer -SourceUri $assetJson.FileLocation -DestinationUri "$destinationNugetFilePath"
    
                    if(Test-Path $destinationNugetFilePath)
                    {
                        $regex = [regex] "\b(([0-9]*[0-9])\.){3}(?:[0-9]*[0-9]?)\b"
                        $filenameVersion = $regex.Match($AssetName).Value
                        $version = Get-NuGetVersion $destinationNugetFilePath
                        if($filenameVersion -ne "")
                        {
                            $newdestinationNugetFilePath = ($destinationNugetFilePath).Replace(".$filenameVersion.nupkg", ".nupkg") 
                        }
                        else { $newdestinationNugetFilePath = $destinationNugetFilePath }
                        $newdestinationNugetFilePath = ($newdestinationNugetFilePath).Replace(".nupkg",".$version.nupkg")
                        if(-not(Test-Path $newdestinationNugetFilePath))
                        {
                            Rename-Item -Path $destinationNugetFilePath -NewName ([System.IO.DirectoryInfo]$newdestinationNugetFilePath).FullName -Force -PassThru
                        }
                        $destinationNugetFilePath = $newdestinationNugetFilePath
                    }
                    #Invoke-D365AzCopyTransfer $assetJson.FileLocation "$destinationNugetFilePath"
                }
            }
            else
            {
                if($download)
                {
                    $blob = Get-AzStorageBlobContent -Context $ctx -Container $storageContainer -Blob $AssetName -Destination $destinationNugetFilePath -ConcurrentTaskCount 10 -Force
                    $blob.Name
                }
                Write-PSFMessage -Level Host "Blob was found!"
            }
    
            $regex = [regex] "\b(([0-9]*[0-9])\.){3}(?:[0-9]*[0-9]?)\b"
            $filenameVersion = $regex.Match($AssetName).Value
            $version = Get-NuGetVersion $destinationNugetFilePath
            $AssetName = ($AssetName).Replace(".$filenameVersion.nupkg", ".nupkg") 
            $AssetName = ($AssetName).Replace(".nupkg",".$version.nupkg")
            Write-PSFMessage -Level Host "FSCVersion:  $FSCVersion"
            Write-PSFMessage -Level Host "AssetName:  $AssetName"
    
            Set-AzStorageBlobContent -Context $ctx -Container $storageContainer -Blob "$AssetName" -File "$destinationNugetFilePath" -StandardBlobTier Hot -ConcurrentTaskCount 10 -Force


#>


        }
        catch {
            Write-PSFMessage -Level Host -Message "Something went wrong while updating D365FSC package versiob" -Exception $PSItem.Exception
            Stop-PSFFunction -Message "Stopping because of errors" -EnableException $true
            return
        }
        finally{

        }

    }
    end{
        Invoke-TimeSignal -End
    }          
}