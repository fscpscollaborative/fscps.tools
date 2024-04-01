
<#
    .SYNOPSIS
        Get the LCS configuration details
        
    .DESCRIPTION
        Get the LCS configuration details from the configuration store
        
        All settings retrieved from this cmdlets is to be considered the default parameter values across the different cmdlets
        
    .PARAMETER RepositoryRootPath
        Set root path of the project folder
        
    .PARAMETER OutputAsHashtable
        Instruct the cmdlet to return a hashtable object

    .EXAMPLE
        PS C:\> Get-FSCPSSettings
        
        This will output the current LCS API configuration.
        The object returned will be a PSCustomObject.
        
    .EXAMPLE
        PS C:\> Get-FSCPSSettings -OutputAsHashtable
        
        This will output the current LCS API configuration.
        The object returned will be a Hashtable.
        
    .LINK
        Set-D365LcsApiConfig
        
    .NOTES
        Tags: Environment, Url, Config, Configuration, LCS, Upload, ClientId
        
        Author: Mötz Jensen (@Splaxi)
        
#>

function Get-FSCPSSettings {
    [CmdletBinding()]
    [OutputType()]
    param (
        [string] $RepositoryRootPath,
        [switch] $OutputAsHashtable
    )
    begin{
        $fscpsFolderName = (Get-PSFConfig -FullName "fscps.tools.settings.fscpsFolder").Value
        $fscmSettingsFile = (Get-PSFConfig -FullName "fscps.tools.settings.fscpsSettingsFile").Value
        $fscmRepoSettingsFile = (Get-PSFConfig -FullName "fscps.tools.settings.fscpsRepoSettingsFile").Value

        $fscpsFolderPath = ""
        $settingsFiles = @()
        $res = [Ordered]@{}

        $reposytoryName = ""
        $currentBranchName = ""

        if($env:GITHUB_REPOSITORY)# If GitHub context
        {
            if($RepositoryRootPath -eq "")
            {
                $RepositoryRootPath = "$env:GITHUB_WORKSPACE"
            }
            $fscpsFolderPath = Join-Path $RepositoryRootPath $fscpsFolderName
            $reposytoryName = "$env:GITHUB_REPOSITORY"
            $branchName = "$env:GITHUB_REF"
            $currentBranchName = [regex]::Replace($branchName.Replace("refs/heads/","").Replace("/","_"), '(?i)(?:^|-|_)(\p{L})', { $args[0].Groups[1].Value.ToUpper() })      
            $gitHubFolder = ".github"
            if (!(Test-Path (Join-Path $RepositoryRootPath $gitHubFolder) -PathType Container)) {
                $fscmRepoSettingsFile = "..\$fscmRepoSettingsFile"
                $gitHubFolder = "..\$gitHubFolder"
            }
            $workflowName = "$env:GITHUB_WORKFLOW"
            $workflowName = ($workflowName.Split([System.IO.Path]::getInvalidFileNameChars()) -join "").Replace("(", "").Replace(")", "").Replace("/", "")

            $settingsFiles += $fscmRepoSettingsFile
            $settingsFiles += (Join-Path $fscpsFolderName $fscmSettingsFile)
            $settingsFiles += (Join-Path $gitHubFolder "$workflowName.settings.json")
            $settingsFiles += (Join-Path $fscpsFolderPath "$userName.settings.json")
            $settingsFiles += (Join-Path $fscpsFolderPath "$userName.settings.json")
            
        }
        elseif($env:AGENT_ID)# If Azure DevOps context
        {
            if($RepositoryRootPath -eq "")
            {
                $RepositoryRootPath = "$env:PIPELINE_WORKSPACE"
            }
            $fscpsFolderPath = Join-Path $RepositoryRootPath $fscpsFolderName
            $reposytoryName = "$env:SYSTEM_TEAMPROJECT"
            $branchName = "$env:BUILD_SOURCEBRANCHNAME"
            $currentBranchName = [regex]::Replace($branchName.Replace("refs/heads/","").Replace("/","_"), '(?i)(?:^|-|_)(\p{L})', { $args[0].Groups[1].Value.ToUpper() })   

            $settingsFiles += $fscmRepoSettingsFile
            $settingsFiles += (Join-Path $fscpsFolderName $fscmSettingsFile)
            $settingsFiles += (Join-Path $fscpsFolderPath "$userName.settings.json")
            $settingsFiles += (Join-Path $fscpsFolderPath "$userName.settings.json")

        }
        else { # If Desktop or other
            Write-PSFMessage -Level Warning -Message "Running on desktop"
            if($RepositoryRootPath -eq "")
            {
                throw "RepositoryRootPath variable should be passed if running on the cloud/personal computer"
            }
            $reposytoryName = "windows host"
            $settingsFiles += (Join-Path $fscpsFolderName $fscmSettingsFile)
        }
        Set-PSFConfig -FullName 'fscps.tools.settings.currentBranch' -Value $currentBranchName
        Set-PSFConfig -FullName 'fscps.tools.settings.repoName' -Value $reposytoryName

        
        function MergeCustomObjectIntoOrderedDictionary {
            Param(
                [System.Collections.Specialized.OrderedDictionary] $dst,
                [PSCustomObject] $src
            )
        
            # Add missing properties in OrderedDictionary
        
            $src.PSObject.Properties.GetEnumerator() | ForEach-Object {
                $prop = $_.Name
                $srcProp = $src."$prop"
                $srcPropType = $srcProp.GetType().Name
                if (-not $dst.Contains($prop)) {
                    if ($srcPropType -eq "PSCustomObject") {
                        $dst.Add("$prop", [ordered]@{})
                    }
                    elseif ($srcPropType -eq "Object[]") {
                        $dst.Add("$prop", @())
                    }
                    else {
                        $dst.Add("$prop", $srcProp)
                    }
                }
            }
        
            @($dst.Keys) | ForEach-Object {
                $prop = $_
                if ($src.PSObject.Properties.Name -eq $prop) {
                    $dstProp = $dst."$prop"
                    $srcProp = $src."$prop"
                    $dstPropType = $dstProp.Value.GetType().Name
                    $srcPropType = $srcProp.GetType().Name
                    if($dstPropType -eq 'Int32' -and $srcPropType -eq 'Int64')
                    {
                        $dstPropType = 'Int64'
                    }
                    
                    if ($srcPropType -eq "PSCustomObject" -and $dstPropType -eq "OrderedDictionary") {
                        MergeCustomObjectIntoOrderedDictionary -dst $dst."$prop".Value -src $srcProp
                    }
                    elseif ($dstPropType -ne $srcPropType) {
                        throw "property $prop should be of type $dstPropType, is $srcPropType."
                    }
                    else {
                        if ($srcProp -is [Object[]]) {
                            $srcProp | ForEach-Object {
                                $srcElm = $_
                                $srcElmType = $srcElm.GetType().Name
                                if ($srcElmType -eq "PSCustomObject") {
                                    $ht = [ordered]@{}
                                    $srcElm.PSObject.Properties | Sort-Object -Property Name -Culture "iv-iv" | ForEach-Object { $ht[$_.Name] = $_.Value }
                                    $dst."$prop" += @($ht)
                                }
                                else {
                                    $dst."$prop" += $srcElm
                                }
                            }
                        }
                        else {
                            Set-PSFConfig -FullName $dstProp.FullName -Value $srcProp
                            #$dst."$prop" = $srcProp
                        }
                    }
                }
            }
        }
    }
    process{
        Invoke-TimeSignal -Start
        Write-PSFMessage -Level Verbose -Message "//------------------------------- Reading current FSC-PS settings -------------------------------//"
    
        foreach ($config in Get-PSFConfig -FullName "fscps.tools.settings.*") {
            $propertyName = $config.FullName.ToString().Replace("fscps.tools.settings.", "")
            $res.$propertyName = $config
        }
        
        $settingsFiles | ForEach-Object {
            $settingsFile = $_
            $settingsPath = Join-Path $RepositoryRootPath $settingsFile
            Write-PSFMessage -Level Verbose -Message "Checking $settingsFile"
            if (Test-Path $settingsPath) {
                try {
                    Write-PSFMessage -Level Verbose -Message "Reading $settingsFile"
                    $settingsJson = Get-Content $settingsPath -Encoding UTF8 | ConvertFrom-Json
           
                    # check settingsJson.version and do modifications if needed
             
                    MergeCustomObjectIntoOrderedDictionary -dst $res -src $settingsJson
    
                    <#if ($settingsJson.PSObject.Properties.Name -eq "ConditionalSettings") {
                        $settingsJson.ConditionalSettings | ForEach-Object {
                            $conditionalSetting = $_
                            if ($conditionalSetting.branches | Where-Object { $ENV:GITHUB_REF_NAME -like $_ }) {
                                Write-Host "Applying conditional settings for $ENV:GITHUB_REF_NAME"
                                MergeCustomObjectIntoOrderedDictionary -dst $settings -src $conditionalSetting.settings
                            }
                        }
                    }#>
                }
                catch {
                    throw "Settings file $settingsFile, is wrongly formatted. Error is $($_.Exception.Message)."
                }
            }
        }

        #readSettingsAgain
        foreach ($config in Get-PSFConfig -FullName "fscps.tools.settings.*") {
            $propertyName = $config.FullName.ToString().Replace("fscps.tools.settings.", "")
            $res.$propertyName = $config.Value
        }

        if($OutputAsHashtable) {
            $res
        } else {
            [PSCustomObject]$res
        }
    
        Invoke-TimeSignal -End
    }
    end{

    }

}