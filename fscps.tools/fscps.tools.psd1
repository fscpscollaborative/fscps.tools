@{
	# Script module or binary module file associated with this manifest
	RootModule = 'fscps.tools.psm1'
	
	# Version number of this module.
	ModuleVersion = '0.1.6'
	
	# ID used to uniquely identify this module
	GUID = '6b3d02bf-e176-4052-9b40-5012339c20b3'
	
	# Author of this module
	Author = 'Oleksandr Nikolaiev'
	
	# Company or vendor of this module
	CompanyName = 'Ciellos Inc.'
	
	# Copyright statement for this module
	Copyright = 'Copyright (c) 2024 Oleksandr Nikolaiev. All rights reserved.'
	
	# Description of the functionality provided by this module
	Description = 'fscps.tools'
	
	# Minimum version of the Windows PowerShell engine required by this module
	PowerShellVersion = '5.0'
	
	# Modules that must be imported into the global environment prior to importing
	# this module
	RequiredModules = @(
		  @{ ModuleName = 'PSFramework'; ModuleVersion = '1.10.318' }
		, @{ ModuleName = 'Az.Storage'; ModuleVersion = '1.11.0' }
		, @{ ModuleName = 'AzureAd'; ModuleVersion = '2.0.1.16' }
		, @{ ModuleName = 'd365fo.tools'; ModuleVersion = '0.7.9' }
		, @{ ModuleName = 'PSOAuthHelper'; ModuleVersion = '0.3.0' }
		, @{ ModuleName = 'ImportExcel'; ModuleVersion = '7.1.0' }
		, @{ ModuleName = 'Pester'; ModuleVersion = '5.5.0' }
	)
	
	# Assemblies that must be loaded prior to importing this module
	RequiredAssemblies = @('bin\fscps.tools.dll')
	
	# Type files (.ps1xml) to be loaded when importing this module
	#TypesToProcess = @('xml\fscps.tools.Types.ps1xml')
	
	# Format files (.ps1xml) to be loaded when importing this module
    FormatsToProcess = @('xml\fscps.tools.Format.ps1xml')
	
	# Functions to export from this module
	FunctionsToExport = @(
		 'Get-FSCPSSettings'
		 
		,'Install-FSCPSSoftware'
	)
	
	# Cmdlets to export from this module
	CmdletsToExport = ''
	
	# Variables to export from this module
	VariablesToExport = ''
	
	# Aliases to export from this module
	AliasesToExport = ''
	
	# List of all modules packaged with this module
	ModuleList = @()
	
	# List of all files packaged with this module
	FileList = @()
	
	# Private data to pass to the module specified in ModuleToProcess. This may also contain a PSData hashtable with additional module metadata used by PowerShell.
	PrivateData = @{
		
		#Support for PowerShellGet galleries.
		PSData = @{
			
			Tags                       = @('d365fo', 'd365fsc', 'Dynamics365', 'D365', 'Finance&Operations', 'FinanceOperations', 'FinanceAndOperations', 'Dynamics365FO', 'fscps', 'fsc-ps')

			# A URL to the license for this module.
			LicenseUri                 = "https://opensource.org/licenses/MIT"

			# A URL to the main website for this project.
			ProjectUri                 = 'https://github.com/onikolaiev/fscps.tools'
			
			# A URL to an icon representing this module.
			# IconUri = ''
			
			# ReleaseNotes of this module
			# ReleaseNotes = ''
			
		} # End of PSData hashtable
		
	} # End of PrivateData hashtable
}