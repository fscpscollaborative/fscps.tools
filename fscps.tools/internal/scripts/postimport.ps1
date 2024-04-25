<#
Add all things you want to run after importing the main function code

WARNING: ONLY provide paths to files!

After building the module, this file will be completely ignored, adding anything but paths to files ...
- Will not work after publishing
- Could break the build process
#>

# Load Configurations
foreach ($file in (Get-ChildItem "$ModuleRoot\internal\configurations\*.ps1" -ErrorAction Ignore)) {
	. Import-ModuleFile -Path $file.FullName
}

# Load Tab Expansion
foreach ($file in (Get-ChildItem "$ModuleRoot\internal\tepp\*.tepp.ps1" -ErrorAction Ignore)) {
	. Import-ModuleFile -Path $file.FullName
}

# Load Scriptblocks
(Get-ChildItem "$ModuleRoot\internal\scriptblocks\*.ps1" -ErrorAction Ignore).FullName

# Load Tab Expansion Assignment
. Import-ModuleFile -Path "$ModuleRoot\internal\tepp\assignment.ps1"

# Load License
#."$ModuleRoot\internal\scripts\license.ps1"

# Load Variables
. Import-ModuleFile -Path "$ModuleRoot\internal\scripts\variables.ps1"

# Load dot net assemblies
. Import-ModuleFile -Path "$ModuleRoot\internal\scripts\load-dotnet-assemblies.ps1"

# Load helpers
. Import-ModuleFile -Path "$ModuleRoot\internal\scripts\helpers.ps1"