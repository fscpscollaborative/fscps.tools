
<#
    .SYNOPSIS
        This updates the D365FSC model version
        
    .DESCRIPTION
        This updates the D365FSC model version
        
    .PARAMETER xppSourcePath
        Path to the xpp metadata folder
        
    .PARAMETER xppDescriptorSearch
        Descriptor search pattern
        
    .PARAMETER xppLayer
        Layer of the code
        
    .PARAMETER versionNumber
        Target model version change to
        
    .EXAMPLE
        PS C:\> Update-FSCPSModelVersion -xppSourcePath "c:\temp\metadata" -xppLayer "ISV" -versionNumber "5.4.8.4" -xppDescriptorSearch $("TestModel"+"\Descriptor\*.xml")
        
        this will change the version of the TestModel to 5.4.8.4
    .NOTES
        Author: Oleksandr Nikolaiev (@onikolaiev)
#>
function Update-FSCPSModelVersion {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseShouldProcessForStateChangingFunctions", "")]
    [CmdletBinding()]
    param(
        [Parameter()]
        [string]$xppSourcePath,
        [Parameter()]
        [string]$xppDescriptorSearch,
        $xppLayer,
        $versionNumber
    )

    begin{
        Invoke-TimeSignal -Start
        Write-PSFMessage -Level Important -Message "xppSourcePath: $xppSourcePath"
        Write-PSFMessage -Level Important -Message "xppDescriptorSearch: $xppDescriptorSearch"
        Write-PSFMessage -Level Important -Message "xppLayer: $xppLayer"
        Write-PSFMessage -Level Important -Message "versionNumber: $versionNumber"

        if ($xppDescriptorSearch.Contains("`n"))
        {
            [string[]]$xppDescriptorSearch = $xppDescriptorSearch -split "`n"
        }
        
        Test-Path -LiteralPath $xppSourcePath -PathType Container
            
        if ($versionNumber -match "^\d+\.\d+\.\d+\.\d+$")
        {
            $versions = $versionNumber.Split('.')
        }
        else
        {
            throw "Version Number '$versionNumber' is not of format #.#.#.#"
        }
        switch ( $xppLayer )
        {
            "SYS" { $xppLayer = 0 }
            "SYP" { $xppLayer = 1 }
            "GLS" { $xppLayer = 2 }
            "GLP" { $xppLayer = 3 }
            "FPK" { $xppLayer = 4 }
            "FPP" { $xppLayer = 5 }
            "SLN" { $xppLayer = 6 }
            "SLP" { $xppLayer = 7 }
            "ISV" { $xppLayer = 8 }
            "ISP" { $xppLayer = 9 }
            "VAR" { $xppLayer = 10 }
            "VAP" { $xppLayer = 11 }
            "CUS" { $xppLayer = 12 }
            "CUP" { $xppLayer = 13 }
            "USR" { $xppLayer = 14 }
            "USP" { $xppLayer = 15 }
        }
        
    }
    process{
# Discover packages
    #$BuildModuleDirectories = @(Get-ChildItem -Path $BuildMetadataDir -Directory)
    #foreach ($BuildModuleDirectory in $BuildModuleDirectories)
    #{
        $potentialDescriptors = Find-FSCPSMatch -DefaultRoot $xppSourcePath -Pattern $xppDescriptorSearch | Where-Object { (Test-Path -LiteralPath $_ -PathType Leaf) }
        if ($potentialDescriptors.Length -gt 0)
        {
            Write-PSFMessage -Level Verbose -Message "Found $($potentialDescriptors.Length) potential descriptors"
    
            foreach ($descriptorFile in $potentialDescriptors)
            {
                try
                {
                    [xml]$xml = Get-Content $descriptorFile -Encoding UTF8
    
                    $modelInfo = $xml.SelectNodes("/AxModelInfo")
                    if ($modelInfo.Count -eq 1)
                    {
                        $layer = $xml.SelectNodes("/AxModelInfo/Layer")[0]
                        $layerid = $layer.InnerText
                        $layerid = [int]$layerid
    
                        $modelName = ($xml.SelectNodes("/AxModelInfo/Name")).InnerText
                            
                        # If this model's layer is equal or above lowest layer specified
                        if ($layerid -ge $xppLayer)
                        {
                            $version = $xml.SelectNodes("/AxModelInfo/VersionMajor")[0]
                            $version.InnerText = $versions[0]
    
                            $version = $xml.SelectNodes("/AxModelInfo/VersionMinor")[0]
                            $version.InnerText = $versions[1]
    
                            $version = $xml.SelectNodes("/AxModelInfo/VersionBuild")[0]
                            $version.InnerText = $versions[2]
    
                            $version = $xml.SelectNodes("/AxModelInfo/VersionRevision")[0]
                            $version.InnerText = $versions[3]
    
                            $xml.Save($descriptorFile)
    
                            Write-PSFMessage -Level Verbose -Message " - Updated model $modelName version to $versionNumber in $descriptorFile"
                        }
                        else
                        {
                            Write-PSFMessage -Level Verbose -Message " - Skipped $modelName because it is in a lower layer in $descriptorFile"
                        }
                    }
                    else
                    {
                        Write-PSFMessage -Level Error -Message "File '$descriptorFile' is not a valid descriptor file"
                    }
                }
                catch {
                    Write-PSFMessage -Level Host -Message "Something went wrong while updating D365FSC package versiob" -Exception $PSItem.Exception
                    Stop-PSFFunction -Message "Stopping because of errors" -EnableException $true
                    return
                }
                finally{

                }
            }
        }
    #}    
    }
    end{
        Invoke-TimeSignal -End
    }          
}