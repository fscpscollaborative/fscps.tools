
<#
    .SYNOPSIS
        Get the FSCPS configuration details
        
    .DESCRIPTION
        Get the FSCPS configuration details from the configuration store
        
        All settings retrieved from this cmdlets is to be considered the default parameter values across the different cmdlets
        
    .PARAMETER RepositoryRootPath
        Set root path of the project folder
        
    .PARAMETER OutputAsHashtable
        Instruct the cmdlet to return a hashtable object

    .EXAMPLE
        PS C:\> Get-FSCPSSettings
        
        This will output the current FSCPS configuration.
        The object returned will be a PSCustomObject.
        
    .EXAMPLE
        PS C:\> Get-FSCPSSettings -OutputAsHashtable
        
        This will output the current FSCPS configuration.
        The object returned will be a Hashtable.
        
    .LINK
        Set-FSCPSSettings
        
    .NOTES
        Tags: Environment, Url, Config, Configuration, LCS, Upload, ClientId
        
        Author: Oleksandr Nikolaiev (@onikolaiev)
        
#>

function Get-FSCPSSettings {
    [CmdletBinding()]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseShouldProcessForStateChangingFunctions", "")]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseSingularNouns", "")]
    [OutputType([System.Collections.Specialized.OrderedDictionary])]
    param (
        [string] $RepositoryRootPath,
        [switch] $OutputAsHashtable
    )
    begin{
        $fscpsFolderName = Get-PSFConfigValue -FullName "fscps.tools.settings.fscpsFolder"
        $fscmSettingsFile = Get-PSFConfigValue -FullName "fscps.tools.settings.fscpsSettingsFile"
        $fscmRepoSettingsFile = Get-PSFConfigValue -FullName "fscps.tools.settings.fscpsRepoSettingsFile"

        $settingsFiles = @()
        $res = [Ordered]@{}

        $reposytoryName = ""
        $currentBranchName = ""

        if($env:GITHUB_REPOSITORY)# If GitHub context
        {
            Write-PSFMessage -Level Important -Message "Running on GitHub"
            if($RepositoryRootPath -eq "")
            {
                $RepositoryRootPath = "$env:GITHUB_WORKSPACE"
                Write-PSFMessage -Level Important -Message "GITHUB_WORKSPACE is: $RepositoryRootPath"
            }

            $reposytoryName = "$env:GITHUB_REPOSITORY"
            Write-PSFMessage -Level Important -Message "GITHUB_REPOSITORY is: $reposytoryName"
            $branchName = "$env:GITHUB_REF"
            Write-PSFMessage -Level Important -Message "GITHUB_REF is: $branchName"
            $currentBranchName = [regex]::Replace($branchName.Replace("refs/heads/","").Replace("/","_"), '(?i)(?:^|-|_)(\p{L})', { $args[0].Groups[1].Value.ToUpper() })      
            $gitHubFolder = ".github"

            $workflowName = "$env:GITHUB_WORKFLOW"
            Write-PSFMessage -Level Important -Message "GITHUB_WORKFLOW is: $workflowName"
            $workflowName = ($workflowName.Split([System.IO.Path]::getInvalidFileNameChars()) -join "").Replace("(", "").Replace(")", "").Replace("/", "")

            $settingsFiles += (Join-Path $fscpsFolderName $fscmSettingsFile)
            $settingsFiles += (Join-Path $gitHubFolder $fscmRepoSettingsFile)            
            $settingsFiles += (Join-Path $gitHubFolder "$workflowName.settings.json")
            
        }
        elseif($env:AGENT_ID)# If Azure DevOps context
        {
            Write-PSFMessage -Level Important -Message "Running on Azure"
            if($RepositoryRootPath -eq "")
            {
                $RepositoryRootPath = "$env:PIPELINE_WORKSPACE"
                Write-PSFMessage -Level Important -Message "RepositoryRootPath is: $RepositoryRootPath"
            }
            
            $reposytoryName = "$env:SYSTEM_TEAMPROJECT"
            $branchName = "$env:BUILD_SOURCEBRANCHNAME"
            $currentBranchName = [regex]::Replace($branchName.Replace("refs/heads/","").Replace("/","_"), '(?i)(?:^|-|_)(\p{L})', { $args[0].Groups[1].Value.ToUpper() })   

            #$settingsFiles += $fscmRepoSettingsFile
            $settingsFiles += (Join-Path $fscpsFolderName $fscmSettingsFile)

        }
        else { # If Desktop or other
            Write-PSFMessage -Level Important -Message "Running on desktop"
            if($RepositoryRootPath -eq "")
            {
                #throw "RepositoryRootPath variable should be passed if running on the cloud/personal computer"
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
                    $dstPropType = $dstProp.GetType().Name
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
                            Set-PSFConfig -FullName fscps.tools.settings.$prop -Value $srcProp
                            #$dst."$prop" = $srcProp
                        }
                    }
                }
            }
        }
    }
    process{
        Invoke-TimeSignal -Start    
        foreach ($config in Get-PSFConfig -FullName "fscps.tools.settings.*") {
            $propertyName = $config.FullName.ToString().Replace("fscps.tools.settings.", "")
            $res.$propertyName = $config.Value
        }
        if(Test-Path $RepositoryRootPath)
        {
            $settingsFiles | ForEach-Object {
                $settingsFile = $_
                $settingsPath = Join-Path $RepositoryRootPath $settingsFile
                Write-PSFMessage -Level Important -Message "Settings file '$settingsPath' - $(If (Test-Path $settingsPath) {"exists. Processing..."} Else {"not exists. Skip."})"
                if (Test-Path $settingsPath) {
                    try {
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
                        Write-PSFMessage -Level Host -Message "Settings file $settingsFile, is wrongly formatted." -Exception $PSItem.Exception
                        Stop-PSFFunction -Message "Stopping because of errors"
                        return
                        throw 
                    }
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