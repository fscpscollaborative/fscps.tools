
<#
    .SYNOPSIS
        Get the list of D365FSC components versions
        
    .DESCRIPTION
        Get the list of D365FSC components versions (NuGets, Packages, Frameworks etc.)
        
        
    .PARAMETER Version
        The version of the D365FSC
        
    .EXAMPLE
        PS C:\> Get-FSCPSVersionInfo -Version "10.0.39"
        
        This will show the list of file versions for the FSCPS module of the 10.0.39 D365FSC.
        
    .NOTES
        Author: Oleksandr Nikolaiev (@onikolaiev)
        
#>

Function Get-FSCPSVersionInfo {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseShouldProcessForStateChangingFunctions", "")]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSAvoidUsingInvokeExpression", "")]
    [CmdletBinding()]
    param (
        [string] $Version
    )

    BEGIN {
        Invoke-TimeSignal -Start
        [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
        $VersionStrategy = Get-PSFConfigValue -FullName "fscps.tools.settings.all.versionStrategy"
        $versionsDefaultFile = Join-Path "$Script:DefaultTempPath" "versions.default.json"

        try {
            Invoke-FSCPSWebRequest -method GET -Uri "https://raw.githubusercontent.com/fscpscollaborative/fscps/main/Actions/Helpers/versions.default.json" -outFile $versionsDefaultFile
        }
        catch {
            Start-BitsTransfer -Source "https://raw.githubusercontent.com/fscpscollaborative/fscps/main/Actions/Helpers/versions.default.json" -Destination $versionsDefaultFile
        }       
        
        $versionsData = (Get-Content $versionsDefaultFile) | ConvertFrom-Json 

        # TODO CREATE GETPROJECTROOTFOLDER function
        <#
        $versionsFile = Join-Path $ENV:GITHUB_WORKSPACE '.FSC-PS\versions.json' 
        
        if(Test-Path $versionsFile)
        {
            $versions = (Get-Content $versionsFile) | ConvertFrom-Json
            ForEach($version in $versions)
            { 
                ForEach($versionDefault in $versionsData)
                {
                    if($version.version -eq $versionDefault.version)
                    {
            
                        if($version.data.PSobject.Properties.name -match "AppVersion")
                        {
                            if($version.data.AppVersion -ne "")
                            {
                                $versionDefault.data.AppVersion = $version.data.AppVersion
                            }
                        }
                        if($version.data.PSobject.Properties.name -match "PlatformVersion")
                        {
                            if($version.data.PlatformVersion -ne "")
                            {
                                $versionDefault.data.PlatformVersion = $version.data.PlatformVersion
                            }
                        }
                    }
                }
            }
        }
        #>
    }
    
    PROCESS {
        if (Test-PSFFunctionInterrupt) { return }      

        try {
            if($Version)
            {
                foreach($d in $versionsData)
                {
                    if($d.version -eq $Version)
                    {
                        $hash = @{
                            version = $Version
                            data = @{
                                AppVersion                      = $( if($VersionStrategy -eq 'GA') { $d.data.AppVersionGA } else { $d.data.AppVersionLatest } )
                                PlatformVersion                 = $( if($VersionStrategy -eq 'GA') { $d.data.PlatformVersionGA  } else { $d.data.PlatformVersionLatest } )
                                PlatformUpdate                  = $d.data.PlatformUpdate
                                FSCServiseUpdatePackageId       = $d.data.fscServiseUpdatePackageId
                                FSCPreviewVersionPackageId      = $d.data.fscPreviewVersionPackageId
                                FSCLatestQualityUpdatePackageId = $d.data.fscLatestQualityUpdatePackageId
                                FSCFinalQualityUpdatePackageId  = $d.data.fscFinalQualityUpdatePackageId
                                ECommerceMicrosoftRepoBranch    = $d.data.ecommerceMicrosoftRepoBranch
                            }
                        }                             
                        New-Object PSObject -Property $hash | Select-PSFObject -TypeName "FSCPS.TOOLS.Versions" "*"
                    }
                }
            }
            else
            {
                foreach($d in $versionsData)
                {
                        $hash = @{
                            version = $d.version
                            data = @{
                                AppVersion                      = $( if($VersionStrategy -eq 'GA') { $d.data.AppVersionGA } else { $d.data.AppVersionLatest } )
                                PlatformVersion                 = $( if($VersionStrategy -eq 'GA') { $d.data.PlatformVersionGA  } else { $d.data.PlatformVersionLatest } )
                                PlatformUpdate                  = $d.data.PlatformUpdate
                                FSCServiseUpdatePackageId       = $d.data.fscServiseUpdatePackageId
                                FSCPreviewVersionPackageId      = $d.data.fscPreviewVersionPackageId
                                FSCLatestQualityUpdatePackageId = $d.data.fscLatestQualityUpdatePackageId
                                FSCFinalQualityUpdatePackageId  = $d.data.fscFinalQualityUpdatePackageId
                                ECommerceMicrosoftRepoBranch    = $d.data.ecommerceMicrosoftRepoBranch
                            }
                        }                             
                        New-Object PSObject -Property $hash | Select-PSFObject -TypeName "FSCPS.TOOLS.Versions" "*"
                }
            }
        }
        catch {
            Write-PSFMessage -Level Host -Message "Something went wrong while getting the versionsData" -Exception $PSItem.Exception
            Stop-PSFFunction -Message "Stopping because of errors"
            return
        }
        finally{
            
        }
    }
    END {
        Invoke-TimeSignal -End
    }
}