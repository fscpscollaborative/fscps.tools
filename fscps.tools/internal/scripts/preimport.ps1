<#
Add all things you want to run before importing the main function code.

WARNING: ONLY provide paths to files!

After building the module, this file will be completely ignored, adding anything but paths to files ...
- Will not work after publishing
- Could break the build process
#>


# Load the strings used in messages
. Import-ModuleFile -Path "$ModuleRoot\internal\scripts\strings.ps1"

# Load Enums
. Import-ModuleFile -Path "$ModuleRoot\internal\scripts\enums.ps1"

