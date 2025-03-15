<#
    .SYNOPSIS
        Get the media type (MIME type) of a file based on its filename extension.

    .DESCRIPTION
        This commandlet retrieves the media type (MIME type) of a file based on its filename extension.
        The media type is determined by matching the extension to the list of media types (MIME types) from the MIME database https://github.com/jshttp/mime-db

    .PARAMETER Filename
        The filename(s) for which to determine the media type.

    .EXAMPLE
        PS C:\> Get-MediaTypeByFilename -Filename 'example.jpg'

        This will return 'image/jpeg' as the media type for the file 'example.jpg'.

    .NOTES
        Tags: Media type, MIME type, File extension, Filename

        Author: Oleksandr Nikolaiev (@onikolaiev)
        Author: Florian Hopfner (@FH-Inway)
#>
function Get-MediaTypeByFilename {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, ValueFromPipeline)]
        [string[]] $Filename
    )
    begin {
        # Download and parse the list of media types (MIME types) via
        # https://github.com/jshttp/mime-db.
        # NOTE: A fixed release is targeted, to ensure that future changes to the JSON format do not break the command.
        if (-not (Test-PathExists -Path $Script:MediaTypesPath -Type Leaf -WarningAction SilentlyContinue)) {
            $mediaTypesFolder = Split-Path -Path $Script:MediaTypesPath -Parent
            $null = Test-PathExists -Path $mediaTypesFolder -Type Container -Create
            Invoke-RestMethod -Uri https://cdn.jsdelivr.net/gh/jshttp/mime-db@v1.53.0/db.json -OutFile $Script:MediaTypesPath
        }
        $mediaTypes = (Get-Content -Path $Script:MediaTypesPath | ConvertFrom-Json).psobject.Properties
    }
    process {
        foreach ($name in $Filename) {
            # Find the matching media type by filename extension.
            $matchingMediaType =
                $mediaTypes.Where(
                    { $_.Value.extensions -contains [IO.Path]::GetExtension($name).Substring(1) },
                    'First'
                ).Name
            # Use a fallback type, if no match was found.
            if (-not $matchingMediaType) { $matchingMediaType = 'application/octet-stream' }
            $matchingMediaType # output
        }
    }
}