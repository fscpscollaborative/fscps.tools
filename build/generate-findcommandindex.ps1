$path = "$PSScriptRoot\.."

Import-Module "$path\fscps.tools" -Force

$null = Find-FSCPSCommand -Rebuild -Verbose