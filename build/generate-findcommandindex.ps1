# Script to generate the comment based markdown help files.
# See also https://github.com/d365collaborative/d365fo.tools/wiki/Building-tools
$path = "$PSScriptRoot\.."

Import-Module "$path\fscps.tools" -Force

$null = Find-D365Command -Rebuild -Verbose