function Get-MediaTypeByFilename {
  [CmdletBinding()]
  param(
    [Parameter(Mandatory, ValueFromPipeline)]
    [string[]] $Filename
  )
  begin {
    # Download and parse the list of media types (MIME types) via
    # https://github.com/jshttp/mime-db.
    # NOTE:
    #  * For better performance consider caching the JSON file.
    #  * A fixed release is targeted, to ensure that future changes to the JSON
    #    format do not break the command.
    $mediaTypes = (
      Invoke-RestMethod https://cdn.jsdelivr.net/gh/jshttp/mime-db@v1.53.0/db.json
    ).psobject.Properties
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