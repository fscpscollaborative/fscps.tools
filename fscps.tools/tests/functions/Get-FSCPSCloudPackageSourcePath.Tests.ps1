. "$PSScriptRoot\..\..\internal\functions\get-fscpscloudpackagesourcepath.ps1"

Describe "Get-FSCPSCloudPackageSourcePath Unit Tests" -Tag "Unit" {
    BeforeEach {
        $testRoot = Join-Path $env:TEMP ('cloud-package-' + [guid]::NewGuid())
        $null = New-Item -Path $testRoot -ItemType Directory -Force
    }

    It "returns the package path when the package is already at the root" {
        Get-FSCPSCloudPackageSourcePath -PackagePath $testRoot | Should Be $testRoot
    }

    It "returns the nested CloudDeployablePackage path when present" {
        $nestedPath = Join-Path $testRoot 'CloudDeployablePackage'
        $null = New-Item -Path $nestedPath -ItemType Directory

        Get-FSCPSCloudPackageSourcePath -PackagePath $testRoot | Should Be $nestedPath
    }

    It "throws when the package path does not exist" {
        $threw = $false
        try {
            Get-FSCPSCloudPackageSourcePath -PackagePath (Join-Path $env:TEMP ('missing-' + [guid]::NewGuid()))
        }
        catch {
            $threw = $true
        }

        $threw | Should Be $true
    }
}
