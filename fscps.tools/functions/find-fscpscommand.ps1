
<#
    .SYNOPSIS
        Finds fscps.tools commands searching through the inline help text
        
    .DESCRIPTION
        Finds fscps.tools commands searching through the inline help text, building a consolidated json index and querying it because Get-Help is too slow
        
    .PARAMETER Tag
        Finds all commands tagged with this auto-populated tag
        
    .PARAMETER Author
        Finds all commands tagged with this author
        
    .PARAMETER MinimumVersion
        Finds all commands tagged with this auto-populated minimum version
        
    .PARAMETER MaximumVersion
        Finds all commands tagged with this auto-populated maximum version
        
    .PARAMETER Rebuild
        Rebuilds the index
        
    .PARAMETER Pattern
        Searches help for all commands in fscps.tools for the specified pattern and displays all results
        
    .PARAMETER Confirm
        Confirms overwrite of index
        
    .PARAMETER WhatIf
        Displays what would happen if the command is run
        
    .PARAMETER EnableException
        By default, when something goes wrong we try to catch it, interpret it and give you a friendly warning message.
        This avoids overwhelming you with "sea of red" exceptions, but is inconvenient because it basically disables advanced scripting.
        Using this switch turns this "nice by default" feature off and enables you to catch exceptions with your own try/catch.
        
    .EXAMPLE
        PS C:\> Find-FSCPSCommand "snapshot"
        
        For lazy typers: finds all commands searching the entire help for "snapshot"
        
    .EXAMPLE
        PS C:\> Find-FSCPSCommand -Pattern "snapshot"
        
        For rigorous typers: finds all commands searching the entire help for "snapshot"
        
    .EXAMPLE
        PS C:\> Find-FSCPSCommand -Tag copy
        
        Finds all commands tagged with "copy"
        
    .EXAMPLE
        PS C:\> Find-FSCPSCommand -Tag copy,user
        
        Finds all commands tagged with BOTH "copy" and "user"
        
    .EXAMPLE
        PS C:\> Find-FSCPSCommand -Author Mötz
        
        Finds every command whose author contains "Mötz"
        
    .EXAMPLE
        PS C:\> Find-FSCPSCommand -Author Mötz -Tag copy
        
        Finds every command whose author contains "Mötz" and it tagged as "copy"
        
    .EXAMPLE
        PS C:\> Find-FSCPSCommand -Rebuild
        
        Finds all commands and rebuilding the index (good for developers)
        
        
    .NOTES
        Tags: Find, Help, Command
        Author: Mötz Jensen (@Splaxi)
        
        License: MIT https://opensource.org/licenses/MIT
        
        This cmdlet / function is copy & paste implementation based on the Find-DbaCommand from the dbatools.io project
        
        Original author: Simone Bizzotto (@niphold)
        
#>
function Find-FSCPSCommand {

        [CmdletBinding(SupportsShouldProcess = $true)]
        param (
            [String]$Pattern,
            [String[]]$Tag,
            [String]$Author,
            [String]$MinimumVersion,
            [String]$MaximumVersion,
            [switch]$Rebuild,
            [Alias('Silent')]
            [switch]$EnableException
        )
        begin {
            function Get-FSCPSTrimmedString($Text) {
                return $Text.Trim() -replace '(\r\n){2,}', "`n"
            }
    
            $tagsRex = ([regex]'(?m)^[\s]{0,15}Tags:(.*)$')
            $authorRex = ([regex]'(?m)^[\s]{0,15}Author:(.*)$')
            $minverRex = ([regex]'(?m)^[\s]{0,15}MinimumVersion:(.*)$')
            $maxverRex = ([regex]'(?m)^[\s]{0,15}MaximumVersion:(.*)$')
    
            function Get-FSCPSHelp([String]$commandName) {
                $thishelp = Get-Help $commandName -Full
                $thebase = @{ }
                $thebase.CommandName = $commandName
                $thebase.Name = $thishelp.Name
    
                $alias = Get-Alias -Definition $commandName -ErrorAction SilentlyContinue
                $thebase.Alias = $alias.Name -Join ','
    
                ## fetch the description
                $thebase.Description = $thishelp.Description.Text
    
                ## fetch examples
                $thebase.Examples = Get-FSCPSTrimmedString -Text ($thishelp.Examples | Out-String -Width 200)
    
                ## fetch help link
                $thebase.Links = ($thishelp.relatedLinks).NavigationLink.Uri
    
                ## fetch the synopsis
                $thebase.Synopsis = $thishelp.Synopsis
    
                ## fetch the syntax
                $thebase.Syntax = Get-FSCPSTrimmedString -Text ($thishelp.Syntax | Out-String -Width 600)
    
                ## store notes
                $as = $thishelp.AlertSet | Out-String -Width 600
    
                ## fetch the tags
                $tags = $tagsrex.Match($as).Groups[1].Value
                if ($tags) {
                    $thebase.Tags = $tags.Split(',').Trim()
                }
                ## fetch the author
                $author = $authorRex.Match($as).Groups[1].Value
                if ($author) {
                    $thebase.Author = $author.Trim()
                }
    
                ## fetch MinimumVersion
                $MinimumVersion = $minverRex.Match($as).Groups[1].Value
                if ($MinimumVersion) {
                    $thebase.MinimumVersion = $MinimumVersion.Trim()
                }
    
                ## fetch MaximumVersion
                $MaximumVersion = $maxverRex.Match($as).Groups[1].Value
                if ($MaximumVersion) {
                    $thebase.MaximumVersion = $MaximumVersion.Trim()
                }
    
                ## fetch Parameters
                $parameters = $thishelp.parameters.parameter
                $command = Get-Command $commandName
                $params = @()
                foreach($p in $parameters) {
                    $paramAlias = $command.parameters[$p.Name].Aliases
                    $paramDescr = Get-FSCPSTrimmedString -Text ($p.Description | Out-String -Width 200)
                    $params += , @($p.Name, $paramDescr, ($paramAlias -Join ','), ($p.Required -eq $true), $p.PipelineInput, $p.DefaultValue)
                }
    
                $thebase.Params = $params
    
                [pscustomobject]$thebase
            }
    
            function Get-FSCPSIndex() {
                if ($Pscmdlet.ShouldProcess($dest, "Recreating index")) {
                    $dbamodule = Get-Module -Name fscps.tools
                    $allCommands = $dbamodule.ExportedCommands.Values | Where-Object CommandType -EQ 'Function'
    
                    $helpcoll = New-Object System.Collections.Generic.List[System.Object]
                    foreach ($command in $allCommands) {
                        $x = Get-FSCPSHelp "$command"
                        $helpcoll.Add($x)
                    }
                    # $dest = Get-DbatoolsConfigValue -Name 'Path.TagCache' -Fallback "$(Resolve-Path $PSScriptRoot\..)\dbatools-index.json"
                    $dest = "$moduleDirectory\bin\fscps.tools-index.json"
                    $helpcoll | ConvertTo-Json -Depth 4 | Out-File $dest -Encoding UTF8
                }
            }
    
            $moduleDirectory = (Get-Module -Name fscps.tools).ModuleBase
        }
        process {
            $Pattern = $Pattern.TrimEnd("s")
            $idxFile = "$moduleDirectory\bin\fscps.tools-index.json"
            if (!(Test-Path $idxFile) -or $Rebuild) {
                Write-PSFMessage -Level Verbose -Message "Rebuilding index into $idxFile"
                $swRebuild = [system.diagnostics.stopwatch]::StartNew()
                Get-FSCPSIndex
                Write-PSFMessage -Level Verbose -Message "Rebuild done in $($swRebuild.ElapsedMilliseconds)ms"
            }
            $consolidated = Get-Content -Raw $idxFile | ConvertFrom-Json
            $result = $consolidated
            if ($Pattern.Length -gt 0) {
                $result = $result | Where-Object { $_.PsObject.Properties.Value -like "*$Pattern*" }
            }
    
            if ($Tag.Length -gt 0) {
                foreach ($t in $Tag) {
                    $result = $result | Where-Object Tags -Contains $t
                }
            }
    
            if ($Author.Length -gt 0) {
                $result = $result | Where-Object Author -Like "*$Author*"
            }
    
            if ($MinimumVersion.Length -gt 0) {
                $result = $result | Where-Object MinimumVersion -GE $MinimumVersion
            }
    
            if ($MaximumVersion.Length -gt 0) {
                $result = $result | Where-Object MaximumVersion -LE $MaximumVersion
            }
    
            Select-DefaultView -InputObject $result -Property CommandName, Synopsis
        }
    }