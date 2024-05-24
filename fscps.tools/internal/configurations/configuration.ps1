<#
This is an example configuration file

By default, it is enough to have a single one of them,
however if you have enough configuration settings to justify having multiple copies of it,
feel totally free to split them into multiple files.
#>

<#
# Example Configuration
Set-PSFConfig -Module 'fscps.tools' -Name 'Example.Setting' -Value 10 -Initialize -Validation 'integer' -Handler { } -Description "Example configuration setting. Your module can then use the setting using 'Get-PSFConfigValue'"
#>

Set-PSFConfig -Module 'fscps.tools' -Name 'Import.DoDotSource' -Value $false -Initialize -Validation 'bool' -Description "Whether the module files should be dotsourced on import. By default, the files of this module are read as string value and invoked, which is faster but worse on debugging."
Set-PSFConfig -Module 'fscps.tools' -Name 'Import.IndividualFiles' -Value $false -Initialize -Validation 'bool' -Description "Whether the module files should be imported individually. During the module build, all module code is compiled into few files, which are imported instead by default. Loading the compiled versions is faster, using the individual files is easier for debugging and testing out adjustments."

Set-PSFConfig -FullName "fscps.tools.path.azcopy" -Value "C:\temp\fscps.tools\AzCopy\AzCopy.exe" -Initialize -Description "Path to the default location where AzCopy.exe is located."
Set-PSFConfig -FullName "fscps.tools.path.nuget" -Value "C:\temp\fscps.tools\nuget\nuget.exe" -Initialize -Description "Path to the default location where nuget.exe is located."
Set-PSFConfig -FullName 'fscps.tools.settings.github.templateUrl' -Value 'https://github.com/ciellosinc/FSC-PS-Template' -Initialize -Description ''
Set-PSFConfig -FullName 'fscps.tools.settings.github.templateBranch' -Value 'main' -Initialize -Description ''

Set-PSFConfig -FullName "fscps.tools.path.sqlpackage" -Value "C:\Program Files (x86)\Microsoft SQL Server\140\DAC\bin\SqlPackage.exe" -Initialize -Description "Path to the default location where SqlPackage.exe is located."
Set-PSFConfig -FullName "fscps.tools.azure.common.oauth.token" -Value "https://login.microsoftonline.com/common/oauth2/token" -Initialize -Description "URI / URL for the Azure Active Directory OAuth 2.0 endpoint for tokens"

Set-PSFConfig -FullName 'fscps.tools.settings.all.fscpsSettingsFile' -Value 'settings.json' -Initialize -Description 'The name of the file has custom fscps settings. JSON'
Set-PSFConfig -FullName 'fscps.tools.settings.all.fscpsRepoSettingsFile' -Value 'FSC-PS-Settings.json' -Initialize -Description 'The name of the file has custom fscps repo settings. JSON'

Set-PSFConfig -FullName 'fscps.tools.settings.all.companyName' -Value '' -Initialize -Description 'Company name used for generate the package name.'
Set-PSFConfig -FullName 'fscps.tools.settings.all.fscpsFolder' -Value '.FSC-PS' -Initialize -Description 'The name of the folder comtains the settings json scripts.'

Set-PSFConfig -FullName 'fscps.tools.settings.all.type' -Value '' -Initialize -Description 'Specifies the type of project. Allowed values are **FSCM**/**Commerce**/**ECommerce**.'
Set-PSFConfig -FullName 'fscps.tools.settings.github.runs-on' -Value '' -Initialize -Description 'Specifies which github runner will be used for all jobs in all workflows (except the Update FSC-PS System Files workflow). The default is to use the GitHub hosted runner Windows-latest. You can specify a special GitHub Runner for the build job using the GitHubRunner setting.'
Set-PSFConfig -FullName 'fscps.tools.settings.all.fscPsVer' -Value $script:ModuleVersion -Initialize -Description 'Version of the fscps.tools module'
Set-PSFConfig -FullName 'fscps.tools.settings.all.currentBranch' -Value '' -Initialize -Description 'The current execution branch name'
Set-PSFConfig -FullName 'fscps.tools.settings.all.sourceBranch' -Value '' -Initialize -Description 'The branch used to build and generate the package.'

Set-PSFConfig -FullName 'fscps.tools.settings.all.repoOwner' -Value '' -Initialize -Description 'The name of the repo owner. GitHub - repo owner. Azure - name of the organization'
Set-PSFConfig -FullName 'fscps.tools.settings.all.repoName' -Value '' -Initialize -Description 'The name of the repo. GitHub - name of the repo. Azure - name of the collection'
Set-PSFConfig -FullName 'fscps.tools.settings.all.repoProvider' -Value '' -Initialize -Description 'GitHub/AzureDevOps/Other'
Set-PSFConfig -FullName 'fscps.tools.settings.all.repositoryRootPath' -Value '' -Initialize -Description 'Dynamics value. Contains the path to the root of the repo'
Set-PSFConfig -FullName 'fscps.tools.settings.all.runId' -Value '' -Initialize -Description 'GitHub/Azure run_id'
Set-PSFConfig -FullName 'fscps.tools.settings.all.repoToken' -Value '' -Initialize -Description ''

Set-PSFConfig -FullName 'fscps.tools.settings.github.githubRunner' -Value 'windows-latest' -Initialize -Description ''
Set-PSFConfig -FullName 'fscps.tools.settings.all.workflowName' -Value '' -Initialize -Description 'The name of the GitHub Workflow/AzureDO Task'

Set-PSFConfig -FullName 'fscps.tools.settings.all.buildVersion' -Value '' -Initialize -Description 'The default D365 FSC version used to build and generate the package.'
Set-PSFConfig -FullName 'fscps.tools.settings.all.solutionName' -Value '' -Initialize -Description ''
Set-PSFConfig -FullName 'fscps.tools.settings.all.enableBuildCaching' -Value $false -Initialize -Description ''
Set-PSFConfig -FullName 'fscps.tools.settings.all.exportModel' -Value $false -Initialize -Description 'Option to generate axmodel file. IMPORTANT!!! generatePackages option should be set to True'
Set-PSFConfig -FullName 'fscps.tools.settings.all.uploadPackageToLCS' -Value $false -Initialize -Description 'Option to upload the generated package to the LCS after the build and generate process. IMPORTANT!!! generatePackages option should be set to True'
Set-PSFConfig -FullName 'fscps.tools.settings.all.models' -Value '' -Initialize -Description 'Comma-delimited array of models.'
Set-PSFConfig -FullName 'fscps.tools.settings.all.specifyModelsManually' -Value $false -Initialize -Description 'If you need to build only specific models, set to true'
Set-PSFConfig -FullName 'fscps.tools.settings.all.includeTestModel' -Value $false -Initialize -Description 'Include unit test models into the package.'

Set-PSFConfig -FullName 'fscps.tools.settings.github.codeSignType' -Value 'notsign' -Initialize -Description ''
Set-PSFConfig -FullName 'fscps.tools.settings.github.codeSignDigiCertUrlSecretName' -Value 'SIGN_CERTIFICATE_URL' -Initialize -Description ''
Set-PSFConfig -FullName 'fscps.tools.settings.github.codeSignDigiCertPasswordSecretName' -Value 'SIGN_CERTIFICATE_PASSWORD' -Initialize -Description ''
Set-PSFConfig -FullName 'fscps.tools.settings.github.codeSignDigiCertAPISecretName' -Value 'SIGN_CERTIFICATE_API' -Initialize -Description ''
Set-PSFConfig -FullName 'fscps.tools.settings.github.codeSignDigiCertHashSecretName' -Value 'SIGN_CERTIFICATE_HASH' -Initialize -Description ''
Set-PSFConfig -FullName 'fscps.tools.settings.github.codeSighKeyVaultUri' -Value '' -Initialize -Description ''
Set-PSFConfig -FullName 'fscps.tools.settings.github.codeSignKeyVaultTenantId' -Value '' -Initialize -Description ''
Set-PSFConfig -FullName 'fscps.tools.settings.github.codeSignKeyVaultAppId' -Value '' -Initialize -Description ''
Set-PSFConfig -FullName 'fscps.tools.settings.github.codeSignKeyVaultCertificateName' -Value '' -Initialize -Description ''
Set-PSFConfig -FullName 'fscps.tools.settings.github.codeSignKeyVaultTimestampServer' -Value 'http://timestamp.digicert.com' -Initialize -Description ''
Set-PSFConfig -FullName 'fscps.tools.settings.github.codeSignKeyVaultClientSecretName' -Value 'SIGN_KV_CLIENTSECRET' -Initialize -Description ''

Set-PSFConfig -FullName 'fscps.tools.settings.all.nugetPackagesPath' -Value 'NuGets' -Initialize -Description 'The name of the directory where Nuget packages will be stored'

Set-PSFConfig -FullName 'fscps.tools.settings.github.githubSecrets' -Value '' -Initialize -Description ''
Set-PSFConfig -FullName 'fscps.tools.settings.github.githubAgentName' -Value '' -Initialize -Description 'Specifies which github runner will be used for the build/ci/deploy/release job in workflows. This is the most time consuming task. By default this job uses the Windows-latest github runner '
Set-PSFConfig -FullName 'fscps.tools.settings.all.buildPath' -Value '_bld' -Initialize -Description 'The FSC-PS system will copy the sources into this folder and will build from it. '
Set-PSFConfig -FullName 'fscps.tools.settings.all.metadataPath' -Value 'PackagesLocalDirectory' -Initialize -Description 'Specify the folder contains the sources'

Set-PSFConfig -FullName 'fscps.tools.settings.github.lcsEnvironmentId' -Value '' -Initialize -Description 'The Guid of the LCS environment'
Set-PSFConfig -FullName 'fscps.tools.settings.github.lcsProjectId' -Value 123456 -Initialize -Description 'The ID of the LCS project'
Set-PSFConfig -FullName 'fscps.tools.settings.github.lcsClientId' -Value '' -Initialize -Description 'The ClientId of the Azure application what has access to the LCS'
Set-PSFConfig -FullName 'fscps.tools.settings.github.lcsUsernameSecretname' -Value 'AZ_TENANT_USERNAME' -Initialize -Description 'The GitHub secret name that contains the username that has at least Owner access to the LCS project. It is a highly recommend to create a separate AAD user for this purposes. E.g. lcsadmin@contoso.com'
Set-PSFConfig -FullName 'fscps.tools.settings.github.lcsPasswordSecretname' -Value 'AZ_TENANT_PASSWORD' -Initialize -Description 'The GitHub secret name that contains the password of the LCS user.'

Set-PSFConfig -FullName 'fscps.tools.settings.github.azTenantId' -Value '' -Initialize -Description 'The Guid of the Azure tenant'
Set-PSFConfig -FullName 'fscps.tools.settings.github.azClientId' -Value '' -Initialize -Description 'The Guid of the AAD registered application'
Set-PSFConfig -FullName 'fscps.tools.settings.github.azClientsecretSecretname' -Value 'AZ_CLIENTSECRET' -Initialize -Description 'The github secret name that contains ClientSecret of the registered application'
Set-PSFConfig -FullName 'fscps.tools.settings.github.azVmname' -Value '' -Initialize -Description ''
Set-PSFConfig -FullName 'fscps.tools.settings.github.azVmrg' -Value '' -Initialize -Description ''

Set-PSFConfig -FullName 'fscps.tools.settings.all.artifactsPath' -Value '' -Initialize -Description 'The destination artifacts path'
Set-PSFConfig -FullName 'fscps.tools.settings.all.artifactsFolderName' -Value 'artifacts' -Initialize -Description 'The name of the folder contains the result artifacts'
Set-PSFConfig -FullName 'fscps.tools.settings.all.generatePackages' -Value $true -Initialize -Description 'Option to generate a package after build.'
Set-PSFConfig -FullName 'fscps.tools.settings.all.namingStrategy' -Value 'Default' -Initialize -Description 'The package naming strategy. Custom value means the result package will have the name specified in the packageName variable. Default / Custom'
Set-PSFConfig -FullName 'fscps.tools.settings.all.packageNamePattern' -Value 'BRANCHNAME-PACKAGENAME-FNSCMVERSION_DATE.RUNNUMBER' -Initialize -Description ''
Set-PSFConfig -FullName 'fscps.tools.settings.all.packageName' -Value '' -Initialize -Description 'Name of the package'

Set-PSFConfig -FullName 'fscps.tools.settings.github.fscFinalQualityUpdatePackageId' -Value '' -Initialize -Description 'The AssetId of the Final Quality Update (Latest) package of the FSC.'
Set-PSFConfig -FullName 'fscps.tools.settings.github.fscPreviewVersionPackageId' -Value '' -Initialize -Description 'The AssetId of the Preview package of the FSC.'
Set-PSFConfig -FullName 'fscps.tools.settings.github.fscServiseUpdatePackageId' -Value '' -Initialize -Description 'The AssetId of the Service Update (GA) package of the FSC.'
Set-PSFConfig -FullName 'fscps.tools.settings.all.versionStrategy' -Value 'GA' -Initialize -Description 'Values: GA/Latest'

Set-PSFConfig -FullName 'fscps.tools.settings.all.ecommerceMicrosoftRepoUrl' -Value 'https://github.com/microsoft/Msdyn365.Commerce.Online.git' -Initialize -Description 'The Msdyn365.Commerce.OnlineSDK repo URL what will use to build the ECommerce pacage.'
Set-PSFConfig -FullName 'fscps.tools.settings.all.ecommerceMicrosoftRepoBranch' -Value 'master' -Initialize -Description 'The Msdyn365.Commerce.OnlineSDK repo branch.'

Set-PSFConfig -FullName 'fscps.tools.settings.github.repoTokenSecretName' -Value 'REPO_TOKEN' -Initialize -Description ''
Set-PSFConfig -FullName 'fscps.tools.settings.github.ciBranches' -Value 'master,develop' -Initialize -Description ''
Set-PSFConfig -FullName 'fscps.tools.settings.github.deployScheduleCron' -Value '1 * * * *' -Initialize -Description ''
Set-PSFConfig -FullName 'fscps.tools.settings.github.deploy' -Value $false -Initialize -Description ''
Set-PSFConfig -FullName 'fscps.tools.settings.github.deployOnlyNew' -Value $true -Initialize -Description ''
Set-PSFConfig -FullName 'fscps.tools.settings.github.deploymentScheduler' -Value $true -Initialize -Description ''
Set-PSFConfig -FullName 'fscps.tools.settings.all.signArtifacts' -Value $false -Initialize -Description ''

Set-PSFConfig -FullName 'fscps.tools.settings.all.cleanupNugets' -Value $false -Initialize -Description 'Cleanup Commerce compiled NuGet packages with microsoft artifacts'
Set-PSFConfig -FullName 'fscps.tools.settings.all.cleanupCSUPackage' -Value $false -Initialize -Description ''
Set-PSFConfig -FullName 'fscps.tools.settings.github.secretsList' -Value @('nugetFeedPasswordSecretName','nugetFeedUserSecretName','lcsUsernameSecretname','lcsPasswordSecretname','azClientsecretSecretname','repoTokenSecretName','codeSignDigiCertUrlSecretName','codeSignDigiCertPasswordSecretName','codeSignDigiCertAPISecretName','codeSignDigiCertHashSecretName','codeSignKeyVaultClientSecretName') -Initialize -Description ''

Set-PSFConfig -FullName "fscps.tools.azure.storage.accounts" -Value @{} -Initialize -Description "Object that stores different Azure Storage Account and their details."
Set-PSFConfig -FullName "fscps.tools.active.azure.storage.account" -Value @{} -Initialize -Description "Object that stores the Azure Storage Account details that should be used during the module."
