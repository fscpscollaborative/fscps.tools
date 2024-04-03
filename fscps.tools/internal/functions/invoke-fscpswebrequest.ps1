
<#
.SYNOPSIS

.DESCRIPTION
Long description

.PARAMETER headers
Parameter description

.PARAMETER method
Parameter description

.PARAMETER body
    Parameter description

.PARAMETER outFile
    Parameter description

.PARAMETER uri
    Parameter description

.EXAMPLE
    PS C:\> Invoke-FSCPSWebRequest -Uri "google.com"

    This will invoke google.com

.NOTES
General notes
#>
function Invoke-FSCPSWebRequest {
    Param(
        [Hashtable] $headers,
        [string] $method,
        [string] $body,
        [string] $outFile,
        [string] $uri
    )

    try {
        $params = @{ "UseBasicParsing" = $true }
        if ($headers) {
            $params += @{ "headers" = $headers }
        }
        if ($method) {
            $params += @{ "method" = $method }
        }
        if ($body) {
            $params += @{ "body" = $body }
        }
        if ($outfile) {
            if(-not (Test-Path $outFile))
            {
                $null = New-Item -Path $outFile -Force
            }
            
            $params += @{ "outfile" = $outfile }
        }
        Invoke-WebRequest  @params -Uri $uri
    }
    catch {
        $errorRecord = $_
        $exception = $_.Exception
        $message = $exception.Message
        try {
            if ($errorRecord.ErrorDetails) {
                $errorDetails = $errorRecord.ErrorDetails | ConvertFrom-Json 
                $errorDetails.psObject.Properties.name | ForEach-Object {
                    $message += " $($errorDetails."$_")"
                }
                
            }
        }
        catch {
            Write-PSFMessage -Level Host -Message "Error occured"
        }
        throw $message
    }
}