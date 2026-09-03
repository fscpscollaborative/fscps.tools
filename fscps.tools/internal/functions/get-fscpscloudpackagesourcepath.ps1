function Get-FSCPSCloudPackageSourcePath {
    [CmdletBinding()]
    [OutputType([string])]
    param (
        [Parameter(Mandatory = $true)]
        [string] $PackagePath
    )

    if (-not (Test-Path -LiteralPath $PackagePath -PathType Container)) {
        throw "Cloud package path '$PackagePath' was not found."
    }

    $nestedPackagePath = Join-Path $PackagePath 'CloudDeployablePackage'
    if (Test-Path -LiteralPath $nestedPackagePath -PathType Container) {
        return $nestedPackagePath
    }

    return $PackagePath
}
