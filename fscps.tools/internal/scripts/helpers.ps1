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