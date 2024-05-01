function ClearExtension {
    param (
        [System.IO.DirectoryInfo]$filePath
    )
    Write-Output ($filePath.BaseName.Replace($filePath.Extension,""))
}
function Copy-ToDestination
{
    param(
        [string]$RelativePath,
        [string]$File,
        [string]$DestinationFullName
    )

    $searchFile = Get-ChildItem -Path $RelativePath -Filter $File -Recurse
    if (-NOT $searchFile) {
        throw "$File file was not found."
    }
    else {
        Copy-Item $searchFile.FullName -Destination "$DestinationFullName"
    }
}

function ConvertTo-HashTable {
    [CmdletBinding()]
    Param(
        [parameter(ValueFromPipeline)]
        [PSCustomObject] $object
    )
    $ht = @{}
    if ($object) {
        $object.PSObject.Properties | ForEach-Object { $ht[$_.Name] = $_.Value }
    }
    $ht
}
function Get-FolderHash
{
    [CmdletBinding()]
    Param(
        [string]$FolderPath
    )
    $hashString = (Get-ChildItem $FolderPath -Recurse -File | Get-FileHash -Algorithm MD5).Hash | Out-String
    return (Get-FileHash -Algorithm MD5 -InputStream ([IO.MemoryStream]::new([char[]]$hashString))).Hash
}

function Validate-FolderHash {
    [CmdletBinding()]
    Param(
        [string]$FolderPath,
        [string]$Hash
    )
    $currentHash = Get-FolderHash -FolderPath $FolderPath
    if($Hash -eq $currentHash)
    {
        return $true;
    }
    else
    {
        return $false;
    }
}

function Validate-FSCModelCache {
    [CmdletBinding()]
    Param(
        [string]$MetadataDirectory,
        [string]$RepoOwner,
        [string]$RepoName,
        [string]$ModelName,
        [string]$BranchName,
        [string]$Version
    )
    begin{
        $tempFolder = $Script:DefaultTempPath #"c:\temp\fscps.tools"
        Write-PSFMessage -Level Verbose -Message "Validating $ModelName cache."
        $storageConfigs = Get-FSCPSAzureStorageConfig
        $activeStorageConfigName = "ModelStorage"
        if($storageConfigs)
        {
            $activeStorageConfig = Get-FSCPSActiveAzureStorageConfig
            $storageConfigs | ForEach-Object {
                if($_.AccountId -eq $activeStorageConfig.AccountId -and $_.Container -eq $activeStorageConfig.Container -and $_.SAS -eq $activeStorageConfig.SAS)
                {
                    $activeStorageConfigName = $_.Name
                }
            }
        } 
        $null = Set-FSCPSActiveAzureStorageConfig ModelStorage
    }
    process{
        $modelRootPath = (Join-Path $MetadataDirectory $modelName)
        $hash = Get-FolderHash $modelRootPath
        $modelFileNameWithHash = "$($RepoOwner.ToLower())_$($RepoName.ToLower())_$($ModelName.ToLower())_$($BranchName.ToLower())_$($Version)_$($hash).7z"
        $modelFileNameWithoutHash = "$($RepoOwner.ToLower())_$($RepoName.ToLower())_$($ModelName.ToLower())_$($BranchName.ToLower())_$($Version)_*.7z"
    
        Write-PSFMessage -Level Verbose -Message "Looking for $modelFileNameWithHash blob."
        $modelFile = Get-FSCPSAzureStorageFile -Name $modelFileNameWithHash
    
        if($modelFile)
        {
            Write-PSFMessage -Level Important -Message "Blob $modelFileNameWithHash found.The model $ModelName will be skipped for building."
            $null = Invoke-FSCPSAzureStorageDownload -FileName $modelFileNameWithHash -Path $tempFolder -Force
    
            $modelFileTmpPath = (Join-Path $tempFolder $modelFileNameWithHash)
            Expand-7zipArchive -Path $modelFileTmpPath -DestinationPath $modelRootPath
            
            return $true;
        }
        else {
            Write-PSFMessage -Level Important -Message "Blob $modelFileNameWithHash not found.The model $ModelName will be compiled."

            Invoke-FSCPSAzureStorageDelete -FileName $modelFileNameWithoutHash

            return $false;
        }
        
    }
    end{
        Set-FSCPSActiveAzureStorageConfig $activeStorageConfigName
    }


    
}

function Update-7ZipInstallation
{
        # Modern websites require TLS 1.2
        [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
        
        #requires -RunAsAdministrator
        
        # Let's go directly to the website and see what it lists as the current version
        $BaseUri = "https://www.7-zip.org/"
        $BasePage = Invoke-WebRequest -Uri ( $BaseUri + 'download.html' ) -UseBasicParsing
        # Determine bit-ness of O/S and download accordingly
        if ( [System.Environment]::Is64BitOperatingSystem ) {
            # The most recent 'current' (non-beta/alpha) is listed at the top, so we only need the first.
            $ChildPath = $BasePage.Links | Where-Object { $_.href -like '*7z*-x64.msi' } | Select-Object -First 1 | Select-Object -ExpandProperty href
        } else {
            # The most recent 'current' (non-beta/alpha) is listed at the top, so we only need the first.
            $ChildPath = $BasePage.Links | Where-Object { $_.href -like '*7z*.msi' } | Select-Object -First 1 | Select-Object -ExpandProperty href
        }
        
        # Let's build the required download link
        $DownloadUrl = $BaseUri + $ChildPath
        
        Write-Host "Downloading the latest 7-Zip to the temp folder"
        Invoke-WebRequest -Uri $DownloadUrl -OutFile "$env:TEMP\$( Split-Path -Path $DownloadUrl -Leaf )" | Out-Null
        Write-Host "Installing the latest 7-Zip"
        Start-Process -FilePath "$env:SystemRoot\system32\msiexec.exe" -ArgumentList "/package", "$env:TEMP\$( Split-Path -Path $DownloadUrl -Leaf )", "/passive" -Wait
}

function Compress-7zipArchive {
    Param (
        [Parameter(Mandatory = $true)]
        [string] $Path,
        [string] $DestinationPath
    )

    $7zipPath = "$env:ProgramFiles\7-Zip\7z.exe"
    if(-not (Test-Path $7zipPath))
    {
        Update-7ZipInstallation
    }


    $use7zip = $false
    if (Test-Path -Path $7zipPath -PathType Leaf) {
        try {
            $use7zip = [System.Diagnostics.FileVersionInfo]::GetVersionInfo($7zipPath).FileMajorPart -ge 19
        }
        catch {
            $use7zip = $false
        }
    }

    if ($use7zip) {
        Write-PSFMessage -Level Debug -Message "Using 7zip"
        Set-Alias -Name 7z -Value $7zipPath
        $command = '7z a -t7z "{0}" "{1}"' -f $DestinationPath, $Path
        Invoke-Expression -Command $command | Out-Null
    }
    else {
        Write-PSFMessage -Level Debug -Message "Using Compress-Archive"
        Compress-Archive -Path $Path -DestinationPath "$DestinationPath" -Force
    }
}

function Expand-7zipArchive {
    Param (
        [Parameter(Mandatory = $true)]
        [string] $Path,
        [string] $DestinationPath
    )
    $7zipPath = "$env:ProgramFiles\7-Zip\7z.exe"
    if(-not (Test-Path $7zipPath))
    {
        Update-7ZipInstallation
    }

    $use7zip = $false
    if (Test-Path -Path $7zipPath -PathType Leaf) {
        try {
            $use7zip = [System.Diagnostics.FileVersionInfo]::GetVersionInfo($7zipPath).FileMajorPart -ge 19
        }
        catch {
            $use7zip = $false
        }
    }

    if ($use7zip) {
        Write-PSFMessage -Level Debug -Message "Using 7zip"
        Set-Alias -Name 7z -Value $7zipPath
        $command = '7z x "{0}" -o"{1}" -aoa -r' -f $Path, $DestinationPath
        Invoke-Expression -Command $command | Out-Null
    }
    else {
        Write-PSFMessage -Level Debug -Message "Using Expand-Archive"
        Expand-Archive -Path $Path -DestinationPath "$DestinationPath" -Force
    }
}

function Get-MediaTypeByFilename {
    [CmdletBinding()]
    param(
      [Parameter(Mandatory, ValueFromPipeline)]
      [string[]] $Filename
    )
    begin { 
      # Download and parse the list of media types (MIME types) via
      # https://github.com/jshttp/mime-db.
      # NOTE: 
      #  * For better performance consider caching the JSON file.
      #  * A fixed release is targeted, to ensure that future changes to the JSON
      #    format do not break the command.
      $mediaTypes = (
        Invoke-RestMethod https://cdn.jsdelivr.net/gh/jshttp/mime-db@v1.52.0/db.json
      ).psobject.Properties
    }
    process {
      foreach ($name in $Filename) {
        # Find the matching media type by filename extension.
        $matchingMediaType = 
          $mediaTypes.Where(
            { $_.Value.extensions -contains [IO.Path]::GetExtension($name).Substring(1) }, 
            'First'
          ).Name
        # Use a fallback type, if no match was found.
        if (-not $matchingMediaType) { $matchingMediaType = 'application/octet-stream' }
        $matchingMediaType # output
      }
    }
  }