
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
        [Parameter(Mandatory = $true)]
        [string] $Version
    )

    BEGIN {
        Invoke-TimeSignal -Start
        $versionsDefaultFile = Join-Path "$Script:DefaultTempPath" "versions.default.json"

        Invoke-FSCPSWebRequest -method GET -Uri "https://raw.githubusercontent.com/ciellosinc/FSC-PS/main/Actions/Helpers/versions.default.json" -outFile $versionsDefaultFile
        
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
                        if($version.data.PSobject.Properties.name -match "retailSDKURL")
                        {
                            if($version.data.retailSDKURL -ne "")
                            {
                                $versionDefault.data.retailSDKURL = $version.data.retailSDKURL
                            }
                        }
                        if($version.data.PSobject.Properties.name -match "retailSDKVersion")
                        {
                            if($version.data.retailSDKVersion -ne "")
                            {
                                $versionDefault.data.retailSDKVersion = $version.data.retailSDKVersion
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
        [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
        try {
            foreach($d in $versionsData)
            {
                if($d.version -eq $Version)
                {
                    $d.data | Select-PSFObject -TypeName "FSCPS.TOOLS.Versions" "*"
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