# Script to format the comments/documentation of the cmdlets used for the commend based help.
# based on https://gist.github.com/Splaxi/ff7485a24f6ed9937f3e8da76b5d4840
# See also https://github.com/fscpscollaborative/fscps.tools/wiki/Building-tools
$path = "$PSScriptRoot\..\fscps.tools"
# Path to the .psd1 file
$psd1Path = "$path\fscps.tools.psd1"
$psd1Data = Import-PowerShellDataFile -Path $psd1Path
# Extract the Author field
$author = $psd1Data.Author
function Get-Header ($text) {
    $start = $text.IndexOf('<#')
    $temp = $start - 2
    if($temp -gt 0) {
        $text.SubString(0, $start - 2)
    }
    else {
    ""
    }
}
function Format-Help ($text) {   
    
    $start = $text.IndexOf('<#')
    $end = $text.IndexOf('#>')
    $help = $text.SubString($start + 2, $end - $start - 3)
    
    #$skipfirst = $null # to avoid trailing spaces
    $formattedHelp = @() # Collect formatted lines
    $indentLevel = 0 # Track indentation level


    foreach ($newline in $help.Split("`n")) {
        #if (-not $skipfirst) { $skipfirst = $true; continue }
        $trimmed = $newline.Trim()

        # Adjust indentation based on closing braces
        if ($trimmed -match '^\}') { $indentLevel = [math]::Max(0, $indentLevel - 1) }

        if ($trimmed.StartsWith(".")) 
        {            
            $trimmed = "    $($trimmed.Replace("  ", ''))"
        }
        elseif ($trimmed.StartsWith("-")) {
            $trimmed = "            $($trimmed.Trim())"
        }
        elseif ($trimmed.StartsWith("@{")) {
            $trimmed = "            $($trimmed.Trim())"
        }
        else {
            $trimmed = "        $trimmed"
        }

        # Apply indentation
        $indentedLine = (' ' * ($indentLevel * 4)) + $trimmed

        $formattedHelp += $indentedLine

        # Adjust indentation based on opening braces
        if ($trimmed -match '\{$') { $indentLevel++ }
    }
    $cnt = 0
    $lines = $formattedHelp.Split("`n")

    foreach ($line in $lines) {
        if($cnt -eq 0 -and (($line -match '^[\s]*$'))) {
            $cnt++
            continue
        }

        # Check for .NOTES node
        if ($line -match '\.NOTES') {
            $foundNotes = $true
        }

        # Check if the author is already present
        if ($line -match [regex]::Escape($author)) {
            $foundAuthor = $true
        }

        # If it's the last line and .NOTES exists but no author, add the author
        if ($cnt -eq $lines.Length - 1 -and $foundNotes -and -not $foundAuthor) {
            $line
            Write-Host "Adding author to .NOTES section."
            $line = "        Author: $author"
        }

        $line
        $cnt++
    }

}

function Get-Body ($text) {
    $end = $text.IndexOf('#>')
    $text.SubString($end, $text.Length - $end)
}

$files = New-Object System.Collections.ArrayList
$filesPublic = @(Get-ChildItem -Path "$path\functions\*.ps1")
$files.AddRange($filesPublic)
$filesInternal = @(Get-ChildItem -Path "$path\internal\functions\*.ps1")
$files.AddRange($filesInternal)

foreach ($file in $files) {
    $text = ($file | Get-Content -Raw).Trim()
    Set-Content -Path $file.FullName -Encoding UTF8 -Value (Get-Header $text).TrimEnd()
    Add-Content -Path $file.FullName -Encoding UTF8 -Value "<#".Trim()
    Add-Content -Path $file.FullName -Encoding UTF8 -Value (Format-Help $text)
    Add-Content -Path $file.FullName -Encoding UTF8 -Value (Get-Body $text).TrimEnd() -NoNewline
}