
<#
    .SYNOPSIS
        Finds files using match patterns.
        
    .DESCRIPTION
        Determines the find root from a list of patterns. Performs the find and then applies the glob patterns. Supports interleaved exclude patterns. Unrooted patterns are rooted using defaultRoot, unless matchOptions.matchBase is specified and the pattern is a basename only. For matchBase cases, the defaultRoot is used as the find root.
        
    .PARAMETER DefaultRoot
        Default path to root unrooted patterns. Falls back to System.DefaultWorkingDirectory or current location.
        
    .PARAMETER Pattern
        Patterns to apply. Supports interleaved exclude patterns.
        
    .PARAMETER FindOptions
        When the FindOptions parameter is not specified, defaults to (New-FindOptions -FollowSymbolicLinksTrue). Following soft links is generally appropriate unless deleting files.
        
    .PARAMETER MatchOptions
        When the MatchOptions parameter is not specified, defaults to (New-MatchOptions -Dot -NoBrace -NoCase).
        
    .EXAMPLE
        PS C:\> Find-FSCPSMatch -DefaultRoot "c:\temp\PackagesLocalDirectory" -Pattern '*.*' -FindOptions FollowSymbolicLinksTrue
        
        This will return all files
        
    .NOTES
        This if refactored Find-VSTSMatch function
        Author: Oleksandr Nikolaiev (@onikolaiev)
#>
function Find-FSCPSMatch {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseSingularNouns", "")]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseShouldProcessForStateChangingFunctions", "")]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSPossibleIncorrectUsageOfAssignmentOperator", "")]
    [OutputType('System.Object[]')]
    [CmdletBinding()]
    param(
        [Parameter()]
        [string]$DefaultRoot,
        [Parameter()]
        [string[]]$Pattern,
        $FindOptions,
        $MatchOptions)

    begin{
        Invoke-TimeSignal -Start
        $ErrorActionPreference = 'Stop'        
        Write-PSFMessage -Level Verbose -Message "DefaultRoot: '$DefaultRoot'"

        ##===========================internal functions start==========================##
        function New-FindOptions {
            [CmdletBinding()]
            param(
                [switch]$FollowSpecifiedSymbolicLink,
                [switch]$FollowSymbolicLinks)
        
            return New-Object psobject -Property @{
                FollowSpecifiedSymbolicLink = $FollowSpecifiedSymbolicLink.IsPresent
                FollowSymbolicLinks = $FollowSymbolicLinks.IsPresent
            }
        }
        function New-MatchOptions {
            [CmdletBinding()]
            param(
                [switch]$Dot,
                [switch]$FlipNegate,
                [switch]$MatchBase,
                [switch]$NoBrace,
                [switch]$NoCase,
                [switch]$NoComment,
                [switch]$NoExt,
                [switch]$NoGlobStar,
                [switch]$NoNegate,
                [switch]$NoNull)
        
            return New-Object psobject -Property @{
                Dot = $Dot.IsPresent
                FlipNegate = $FlipNegate.IsPresent
                MatchBase = $MatchBase.IsPresent
                NoBrace = $NoBrace.IsPresent
                NoCase = $NoCase.IsPresent
                NoComment = $NoComment.IsPresent
                NoExt = $NoExt.IsPresent
                NoGlobStar = $NoGlobStar.IsPresent
                NoNegate = $NoNegate.IsPresent
                NoNull = $NoNull.IsPresent
            }
        }
        function ConvertTo-NormalizedSeparators {
            [CmdletBinding()]
            param([string]$Path)
        
            # Convert slashes.
            $Path = "$Path".Replace('/', '\')
        
            # Remove redundant slashes.
            $isUnc = $Path -match '^\\\\+[^\\]'
            $Path = $Path -replace '\\\\+', '\'
            if ($isUnc) {
                $Path = '\' + $Path
            }
        
            return $Path
        }
        function Get-FindInfoFromPattern {
            [CmdletBinding()]
            param(
                [Parameter(Mandatory = $true)]
                [string]$DefaultRoot,
                [Parameter(Mandatory = $true)]
                [string]$Pattern,
                [Parameter(Mandatory = $true)]
                $MatchOptions)
        
            if (!$MatchOptions.NoBrace) {
                throw "Get-FindInfoFromPattern expected MatchOptions.NoBrace to be true."
            }
        
            # For the sake of determining the find path, pretend NoCase=false.
            $MatchOptions = Copy-MatchOptions -Options $MatchOptions
            $MatchOptions.NoCase = $false
        
            # Check if basename only and MatchBase=true
            if ($MatchOptions.MatchBase -and
                !(Test-Rooted -Path $Pattern) -and
                ($Pattern -replace '\\', '/').IndexOf('/') -lt 0) {
        
                return New-Object psobject -Property @{
                    AdjustedPattern = $Pattern
                    FindPath = $DefaultRoot
                    StatOnly = $false
                }
            }
        
            # The technique applied by this function is to use the information on the Minimatch object determine
            # the findPath. Minimatch breaks the pattern into path segments, and exposes information about which
            # segments are literal vs patterns.
            #
            # Note, the technique currently imposes a limitation for drive-relative paths with a glob in the
            # first segment, e.g. C:hello*/world. It's feasible to overcome this limitation, but is left unsolved
            # for now.
            $minimatchObj = New-Object Minimatch.Minimatcher($Pattern, (ConvertTo-MinimatchOptions -Options $MatchOptions))
        
            # The "set" field is a two-dimensional enumerable of parsed path segment info. The outer enumerable should only
            # contain one item, otherwise something went wrong. Brace expansion can result in multiple items in the outer
            # enumerable, but that should be turned off by the time this function is reached.
            #
            # Note, "set" is a private field in the .NET implementation but is documented as a feature in the nodejs
            # implementation. The .NET implementation is a port and is by a different author.
            $setFieldInfo = $minimatchObj.GetType().GetField('set', 'Instance,NonPublic')
            [object[]]$set = $setFieldInfo.GetValue($minimatchObj)
            if ($set.Count -ne 1) {
                throw "Get-FindInfoFromPattern expected Minimatch.Minimatcher(...).set.Count to be 1. Actual: '$($set.Count)'"
            }
        
            [string[]]$literalSegments = @( )
            [object[]]$parsedSegments = $set[0]
            foreach ($parsedSegment in $parsedSegments) {
                if ($parsedSegment.GetType().Name -eq 'LiteralItem') {
                    # The item is a LiteralItem when the original input for the path segment does not contain any
                    # unescaped glob characters.
                    $literalSegments += $parsedSegment.Source;
                    continue
                }
        
                break;
            }
        
            # Join the literal segments back together. Minimatch converts '\' to '/' on Windows, then squashes
            # consequetive slashes, and finally splits on slash. This means that UNC format is lost, but can
            # be detected from the original pattern.
            $joinedSegments = [string]::Join('/', $literalSegments)
            if ($joinedSegments -and ($Pattern -replace '\\', '/').StartsWith('//')) {
                $joinedSegments = '/' + $joinedSegments # restore UNC format
            }
        
            # Determine the find path.
            $findPath = ''
            if ((Test-Rooted -Path $Pattern)) { # The pattern is rooted.
                $findPath = $joinedSegments
            } elseif ($joinedSegments) { # The pattern is not rooted, and literal segements were found.
                $findPath = [System.IO.Path]::Combine($DefaultRoot, $joinedSegments)
            } else { # The pattern is not rooted, and no literal segements were found.
                $findPath = $DefaultRoot
            }
        
            # Clean up the path.
            if ($findPath) {
                $findPath = [System.IO.Path]::GetDirectoryName(([System.IO.Path]::Combine($findPath, '_'))) # Hack to remove unnecessary trailing slash.
                $findPath = ConvertTo-NormalizedSeparators -Path $findPath
            }
        
            return New-Object psobject -Property @{
                AdjustedPattern = Get-RootedPattern -DefaultRoot $DefaultRoot -Pattern $Pattern
                FindPath = $findPath
                StatOnly = $literalSegments.Count -eq $parsedSegments.Count
            }
        }
        function Get-FindResult {
            [CmdletBinding()]
            param(
                [Parameter(Mandatory = $true)]
                [string]$Path,
                [Parameter(Mandatory = $true)]
                $Options)
        
            if (!(Test-Path -LiteralPath $Path)) {
                Write-PSFMessage -Level Verbose -Message 'Path not found.'
                return
            }
        
            $Path = ConvertTo-NormalizedSeparators -Path $Path
        
            # Push the first item.
            [System.Collections.Stack]$stack = New-Object System.Collections.Stack
            $stack.Push((Get-Item -LiteralPath $Path))
        
            $count = 0
            while ($stack.Count) {
                # Pop the next item and yield the result.
                $item = $stack.Pop()
                $count++
                $item.FullName
        
                # Traverse.
                if (($item.Attributes -band 0x00000010) -eq 0x00000010) { # Directory
                    if (($item.Attributes -band 0x00000400) -ne 0x00000400 -or # ReparsePoint
                        $Options.FollowSymbolicLinks -or
                        ($count -eq 1 -and $Options.FollowSpecifiedSymbolicLink)) {
        
                        $childItems = @( Get-ChildItem -Path "$($Item.FullName)/*" -Force )
                        [System.Array]::Reverse($childItems)
                        foreach ($childItem in $childItems) {
                            $stack.Push($childItem)
                        }
                    }
                }
            }
        }
        function Get-RootedPattern {
            [OutputType('System.String')]
            [CmdletBinding()]
            param(
                [Parameter(Mandatory = $true)]
                [string]$DefaultRoot,
                [Parameter(Mandatory = $true)]
                [string]$Pattern)
        
            if ((Test-Rooted -Path $Pattern)) {
                return $Pattern
            }
        
            # Normalize root.
            $DefaultRoot = ConvertTo-NormalizedSeparators -Path $DefaultRoot
        
            # Escape special glob characters.
            $DefaultRoot = $DefaultRoot -replace '(\[)(?=[^\/]+\])', '[[]' # Escape '[' when ']' follows within the path segment
            $DefaultRoot = $DefaultRoot.Replace('?', '[?]')     # Escape '?'
            $DefaultRoot = $DefaultRoot.Replace('*', '[*]')     # Escape '*'
            $DefaultRoot = $DefaultRoot -replace '\+\(', '[+](' # Escape '+('
            $DefaultRoot = $DefaultRoot -replace '@\(', '[@]('  # Escape '@('
            $DefaultRoot = $DefaultRoot -replace '!\(', '[!]('  # Escape '!('
        
            if ($DefaultRoot -like '[A-Z]:') { # e.g. C:
                return "$DefaultRoot$Pattern"
            }
        
            # Ensure root ends with a separator.
            if (!$DefaultRoot.EndsWith('\')) {
                $DefaultRoot = "$DefaultRoot\"
            }
        
            return "$DefaultRoot$Pattern"
        }
        function Test-Rooted {
            [OutputType('System.Boolean')]
            [CmdletBinding()]
            param(
                [Parameter(Mandatory = $true)]
                [string]$Path)
        
            $Path = ConvertTo-NormalizedSeparators -Path $Path
            return $Path.StartsWith('\') -or # e.g. \ or \hello or \\hello
                $Path -like '[A-Z]:*'        # e.g. C: or C:\hello
        }
        function Copy-MatchOptions {
            [CmdletBinding()]
            param($Options)
        
            return New-Object psobject -Property @{
                Dot = $Options.Dot -eq $true
                FlipNegate = $Options.FlipNegate -eq $true
                MatchBase = $Options.MatchBase -eq $true
                NoBrace = $Options.NoBrace -eq $true
                NoCase = $Options.NoCase -eq $true
                NoComment = $Options.NoComment -eq $true
                NoExt = $Options.NoExt -eq $true
                NoGlobStar = $Options.NoGlobStar -eq $true
                NoNegate = $Options.NoNegate -eq $true
                NoNull = $Options.NoNull -eq $true
            }
        }
        function ConvertTo-MinimatchOptions {
            [CmdletBinding()]
            param($Options)
        
            $opt = New-Object Minimatch.Options
            $opt.AllowWindowsPaths = $true
            $opt.Dot = $Options.Dot -eq $true
            $opt.FlipNegate = $Options.FlipNegate -eq $true
            $opt.MatchBase = $Options.MatchBase -eq $true
            $opt.NoBrace = $Options.NoBrace -eq $true
            $opt.NoCase = $Options.NoCase -eq $true
            $opt.NoComment = $Options.NoComment -eq $true
            $opt.NoExt = $Options.NoExt -eq $true
            $opt.NoGlobStar = $Options.NoGlobStar -eq $true
            $opt.NoNegate = $Options.NoNegate -eq $true
            $opt.NoNull = $Options.NoNull -eq $true
            return $opt
        }
        function Get-LocString {
            [OutputType('System.String')]
            [CmdletBinding()]
            param(
                [Parameter(Mandatory = $true, Position = 1)]
                [string]$Key,
                [Parameter(Position = 2)]
                [object[]]$ArgumentList = @( ))
        
            # Due to the dynamically typed nature of PowerShell, a single null argument passed
            # to an array parameter is interpreted as a null array.
            if ([object]::ReferenceEquals($null, $ArgumentList)) {
                $ArgumentList = @( $null )
            }
        
            # Lookup the format string.
            $format = ''
            if (!($format = $script:resourceStrings[$Key])) {
                # Warn the key was not found. Prevent recursion if the lookup key is the
                # "string resource key not found" lookup key.
                $resourceNotFoundKey = 'PSLIB_StringResourceKeyNotFound0'
                if ($key -ne $resourceNotFoundKey) {
                    Write-PSFMessage -Level Warning -Message (Get-LocString -Key $resourceNotFoundKey -ArgumentList $Key)
                }
        
                # Fallback to just the key itself if there aren't any arguments to format.
                if (!$ArgumentList.Count) { return $key }
        
                # Otherwise fallback to the key followed by the arguments.
                $OFS = " "
                return "$key $ArgumentList"
            }
        
            # Return the string if there aren't any arguments to format.
            if (!$ArgumentList.Count) { return $format }
        
            try {
                [string]::Format($format, $ArgumentList)
            } catch {
                Write-PSFMessage -Level Warning -Message (Get-LocString -Key 'PSLIB_StringFormatFailed')
                $OFS = " "
                "$format $ArgumentList"
            }
        }
        function ConvertFrom-LongFormPath {
            [OutputType('System.String')]
            [CmdletBinding()]
            param([string]$Path)
        
            if ($Path) {
                if ($Path.StartsWith('\\?\UNC')) {
                    # E.g. \\?\UNC\server\share -> \\server\share
                    return $Path.Substring(1, '\?\UNC'.Length)
                } elseif ($Path.StartsWith('\\?\')) {
                    # E.g. \\?\C:\directory -> C:\directory
                    return $Path.Substring('\\?\'.Length)
                }
            }
        
            return $Path
        }
        function ConvertTo-LongFormPath {
            [OutputType('System.String')]
            [CmdletBinding()]
            param(
                [Parameter(Mandatory = $true)]
                [string]$Path)
        
            [string]$longFormPath = Get-FullNormalizedPath -Path $Path
            if ($longFormPath -and !$longFormPath.StartsWith('\\?')) {
                if ($longFormPath.StartsWith('\\')) {
                    # E.g. \\server\share -> \\?\UNC\server\share
                    return "\\?\UNC$($longFormPath.Substring(1))"
                } else {
                    # E.g. C:\directory -> \\?\C:\directory
                    return "\\?\$longFormPath"
                }
            }
        
            return $longFormPath
        }
        function Get-FullNormalizedPath {
            [OutputType('System.String')]
            [CmdletBinding()]
            param(
                [Parameter(Mandatory = $true)]
                [string]$Path)
        
            [string]$outPath = $Path
            [uint32]$bufferSize = [VstsTaskSdk.FS.NativeMethods]::GetFullPathName($Path, 0, $null, $null)
            [int]$lastWin32Error = [System.Runtime.InteropServices.Marshal]::GetLastWin32Error()
            if ($bufferSize -gt 0) {
                $absolutePath = New-Object System.Text.StringBuilder([int]$bufferSize)
                [uint32]$length = [VstsTaskSdk.FS.NativeMethods]::GetFullPathName($Path, $bufferSize, $absolutePath, $null)
                $lastWin32Error = [System.Runtime.InteropServices.Marshal]::GetLastWin32Error()
                if ($length -gt 0) {
                    $outPath = $absolutePath.ToString()
                } else  {
                    throw (New-Object -TypeName System.ComponentModel.Win32Exception -ArgumentList @(
                        $lastWin32Error
                        Get-LocString -Key PSLIB_PathLengthNotReturnedFor0 -ArgumentList $Path
                    ))
                }
            } else {
                throw (New-Object -TypeName System.ComponentModel.Win32Exception -ArgumentList @(
                    $lastWin32Error
                    Get-LocString -Key PSLIB_PathLengthNotReturnedFor0 -ArgumentList $Path
                ))
            }
        
            if ($outPath.EndsWith('\') -and !$outPath.EndsWith(':\')) {
                $outPath = $outPath.TrimEnd('\')
            }
        
            $outPath
        }
        ##===========================internal functions end============================##
    }
    process
    {
        try 
        {            
            if (!$FindOptions) {
                $FindOptions = New-FindOptions -FollowSpecifiedSymbolicLink -FollowSymbolicLinks
            }
    
    
            if (!$MatchOptions) {
                $MatchOptions = New-MatchOptions -Dot -NoBrace -NoCase
            }
    
            $miscFolder = (Join-Path $script:ModuleRoot "\internal\misc")        
            [string]$code = Get-Content "$miscFolder\Minimatch.cs" -Raw
            Add-Type -TypeDefinition $code -Language CSharp 
    
            # Normalize slashes for root dir.
            $DefaultRoot = ConvertTo-NormalizedSeparators -Path $DefaultRoot
    
            $results = @{ }
            $originalMatchOptions = $MatchOptions
            foreach ($pat in $Pattern) {
                Write-PSFMessage -Level Verbose -Message "Pattern: '$pat'"
    
                # Trim and skip empty.
                $pat = "$pat".Trim()
                if (!$pat) {
                    Write-PSFMessage -Level Verbose -Message 'Skipping empty pattern.'
                    continue
                }
    
                # Clone match options.
                $MatchOptions = Copy-MatchOptions -Options $originalMatchOptions
    
                # Skip comments.
                if (!$MatchOptions.NoComment -and $pat.StartsWith('#')) {
                    Write-PSFMessage -Level Verbose -Message 'Skipping comment.'
                    continue
                }
    
                # Set NoComment. Brace expansion could result in a leading '#'.
                $MatchOptions.NoComment = $true
    
                # Determine whether pattern is include or exclude.
                $negateCount = 0
                if (!$MatchOptions.NoNegate) {
                    while ($negateCount -lt $pat.Length -and $pat[$negateCount] -eq '!') {
                        $negateCount++
                    }
    
                    $pat = $pat.Substring($negateCount) # trim leading '!'
                    if ($negateCount) {
                        Write-PSFMessage -Level Verbose -Message "Trimmed leading '!'. Pattern: '$pat'"
                    }
                }
    
                $isIncludePattern = $negateCount -eq 0 -or
                    ($negateCount % 2 -eq 0 -and !$MatchOptions.FlipNegate) -or
                    ($negateCount % 2 -eq 1 -and $MatchOptions.FlipNegate)
    
                # Set NoNegate. Brace expansion could result in a leading '!'.
                $MatchOptions.NoNegate = $true
                $MatchOptions.FlipNegate = $false
    
                # Trim and skip empty.
                $pat = "$pat".Trim()
                if (!$pat) {
                    Write-PSFMessage -Level Verbose -Message 'Skipping empty pattern.'
                    continue
                }
    
                # Expand braces - required to accurately interpret findPath.
                $expanded = $null
                $preExpanded = $pat
                if ($MatchOptions.NoBrace) {
                    $expanded = @( $pat )
                } else {
                    # Convert slashes on Windows before calling braceExpand(). Unfortunately this means braces cannot
                    # be escaped on Windows, this limitation is consistent with current limitations of minimatch (3.0.3).
                    Write-PSFMessage -Level Verbose -Message "Expanding braces."
                    $convertedPattern = $pat -replace '\\', '/'
                    $expanded = [Minimatch.Minimatcher]::BraceExpand(
                        $convertedPattern,
                        (ConvertTo-MinimatchOptions -Options $MatchOptions))
                }
    
                # Set NoBrace.
                $MatchOptions.NoBrace = $true
    
                foreach ($pat in $expanded) {
                    if ($pat -ne $preExpanded) {
                        Write-PSFMessage -Level Verbose -Message "Pattern: '$pat'"
                    }
    
                    # Trim and skip empty.
                    $pat = "$pat".Trim()
                    if (!$pat) {
                        Write-PSFMessage -Level Verbose -Message "Skipping empty pattern."
                        continue
                    }
    
                    if ($isIncludePattern) {
                        # Determine the findPath.
                        $findInfo = Get-FindInfoFromPattern -DefaultRoot $DefaultRoot -Pattern $pat -MatchOptions $MatchOptions
                        $findPath = $findInfo.FindPath
                        Write-PSFMessage -Level Verbose -Message "FindPath: '$findPath'"
    
                        if (!$findPath) {
                            Write-PSFMessage -Level Verbose -Message "Skipping empty path."
                            continue
                        }
    
                        # Perform the find.
                        Write-PSFMessage -Level Verbose -Message "StatOnly: '$($findInfo.StatOnly)'"
                        [string[]]$findResults = @( )
                        if ($findInfo.StatOnly) {
                            # Simply stat the path - all path segments were used to build the path.
                            if ((Test-Path -LiteralPath $findPath)) {
                                $findResults += $findPath
                            }
                        } else {
                            $findResults = Get-FindResult -Path $findPath -Options $FindOptions
                        }
    
                        Write-PSFMessage -Level Verbose -Message "Found $($findResults.Count) paths."
    
                        # Apply the pattern.
                        Write-PSFMessage -Level Verbose -Message "Applying include pattern."
                        if ($findInfo.AdjustedPattern -ne $pat) {
                            Write-PSFMessage -Level Verbose -Message "AdjustedPattern: '$($findInfo.AdjustedPattern)'"
                            $pat = $findInfo.AdjustedPattern
                        }
    
                        $matchResults = [Minimatch.Minimatcher]::Filter(
                            $findResults,
                            $pat,
                            (ConvertTo-MinimatchOptions -Options $MatchOptions))
    
                        # Union the results.
                        $matchCount = 0
                        foreach ($matchResult in $matchResults) {
                            $matchCount++
                            $results[$matchResult.ToUpperInvariant()] = $matchResult
                        }
    
                        Write-PSFMessage -Level Verbose -Message "$matchCount matches"
                    } else {
                        # Check if basename only and MatchBase=true.
                        if ($MatchOptions.MatchBase -and
                            !(Test-Rooted -Path $pat) -and
                            ($pat -replace '\\', '/').IndexOf('/') -lt 0) {
    
                            # Do not root the pattern.
                            Write-PSFMessage -Level Verbose -Message "MatchBase and basename only."
                        } else {
                            # Root the exclude pattern.
                            $pat = Get-RootedPattern -DefaultRoot $DefaultRoot -Pattern $pat
                            Write-PSFMessage -Level Verbose -Message "After Get-RootedPattern, pattern: '$pat'"
                        }
    
                        # Apply the pattern.
                        Write-PSFMessage -Level Verbose -Message 'Applying exclude pattern.'
                        $matchResults = [Minimatch.Minimatcher]::Filter(
                            [string[]]$results.Values,
                            $pat,
                            (ConvertTo-MinimatchOptions -Options $MatchOptions))
    
                        # Subtract the results.
                        $matchCount = 0
                        foreach ($matchResult in $matchResults) {
                            $matchCount++
                            $results.Remove($matchResult.ToUpperInvariant())
                        }
    
                        Write-PSFMessage -Level Verbose -Message "$matchCount matches"
                    }
                }
            }
    
            $finalResult = @( $results.Values | Sort-Object )
            Write-PSFMessage -Level Verbose -Message  "$($finalResult.Count) final results"
            return $finalResult
        }         
        catch {
            Write-PSFMessage -Level Host -Message "Something went wrong while finding-matches" -Exception $PSItem.Exception
            Stop-PSFFunction -Message "Stopping because of errors" -EnableException $true
            return
        }
        finally{
            
        }
    }
    END {
        Invoke-TimeSignal -End
    }   
    
}