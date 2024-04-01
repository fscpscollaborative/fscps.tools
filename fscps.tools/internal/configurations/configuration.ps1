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


Set-PSFConfig -FullName "fscps.tools.path.sqlpackage" -Value "C:\Program Files (x86)\Microsoft SQL Server\140\DAC\bin\SqlPackage.exe" -Initialize -Description "Path to the default location where SqlPackage.exe is located."
Set-PSFConfig -FullName "fscps.tools.azure.common.oauth.token" -Value "https://login.microsoftonline.com/common/oauth2/token" -Initialize -Description "URI / URL for the Azure Active Directory OAuth 2.0 endpoint for tokens"

Set-PSFConfig -FullName 'fscps.tools.settings.fscpsSettingsFile' -Value 'settings.json' -Initialize -Description ''
Set-PSFConfig -FullName 'fscps.tools.settings.fscpsRepoSettingsFile' -Value 'FSC-PS-Settings.json' -Initialize -Description ''

Set-PSFConfig -FullName 'fscps.tools.settings.companyName' -Value '' -Initialize -Description ''
Set-PSFConfig -FullName 'fscps.tools.settings.fscpsFolder' -Value '.FSC-PS' -Initialize -Description ''
Set-PSFConfig -FullName 'fscps.tools.settings.type' -Value 'FSCM' -Initialize -Description ''
Set-PSFConfig -FullName 'fscps.tools.settings.runs-on' -Value '' -Initialize -Description ''
Set-PSFConfig -FullName 'fscps.tools.settings.fscPsVer' -Value 'v1.3' -Initialize -Description ''
Set-PSFConfig -FullName 'fscps.tools.settings.currentBranch' -Value '' -Initialize -Description ''
Set-PSFConfig -FullName 'fscps.tools.settings.sourceBranch' -Value '' -Initialize -Description ''
Set-PSFConfig -FullName 'fscps.tools.settings.repoName' -Value '' -Initialize -Description ''
Set-PSFConfig -FullName 'fscps.tools.settings.templateUrl' -Value 'https://github.com/ciellosinc/FSC-PS-Template' -Initialize -Description ''
Set-PSFConfig -FullName 'fscps.tools.settings.templateBranch' -Value 'main' -Initialize -Description ''
Set-PSFConfig -FullName 'fscps.tools.settings.githubRunner' -Value 'windows-latest' -Initialize -Description ''
Set-PSFConfig -FullName 'fscps.tools.settings.buildVersion' -Value '' -Initialize -Description ''
Set-PSFConfig -FullName 'fscps.tools.settings.solutionName' -Value '' -Initialize -Description ''
Set-PSFConfig -FullName 'fscps.tools.settings.exportModel' -Value $false -Initialize -Description ''
Set-PSFConfig -FullName 'fscps.tools.settings.uploadPackageToLCS' -Value $false -Initialize -Description ''
Set-PSFConfig -FullName 'fscps.tools.settings.models' -Value '' -Initialize -Description ''
Set-PSFConfig -FullName 'fscps.tools.settings.specifyModelsManually' -Value $false -Initialize -Description ''
Set-PSFConfig -FullName 'fscps.tools.settings.includeTestModel' -Value $false -Initialize -Description ''

Set-PSFConfig -FullName 'fscps.tools.settings.codeSignType' -Value 'notsign' -Initialize -Description ''
Set-PSFConfig -FullName 'fscps.tools.settings.codeSignDigiCertUrlSecretName' -Value 'SIGN_CERTIFICATE_URL' -Initialize -Description ''
Set-PSFConfig -FullName 'fscps.tools.settings.codeSignDigiCertPasswordSecretName' -Value 'SIGN_CERTIFICATE_PASSWORD' -Initialize -Description ''
Set-PSFConfig -FullName 'fscps.tools.settings.codeSignDigiCertAPISecretName' -Value 'SIGN_CERTIFICATE_API' -Initialize -Description ''
Set-PSFConfig -FullName 'fscps.tools.settings.codeSignDigiCertHashSecretName' -Value 'SIGN_CERTIFICATE_HASH' -Initialize -Description ''
Set-PSFConfig -FullName 'fscps.tools.settings.codeSighKeyVaultUri' -Value '' -Initialize -Description ''
Set-PSFConfig -FullName 'fscps.tools.settings.codeSignKeyVaultTenantId' -Value '' -Initialize -Description ''
Set-PSFConfig -FullName 'fscps.tools.settings.codeSignKeyVaultAppId' -Value '' -Initialize -Description ''
Set-PSFConfig -FullName 'fscps.tools.settings.codeSignKeyVaultCertificateName' -Value '' -Initialize -Description ''
Set-PSFConfig -FullName 'fscps.tools.settings.codeSignKeyVaultTimestampServer' -Value 'http://timestamp.digicert.com' -Initialize -Description ''
Set-PSFConfig -FullName 'fscps.tools.settings.codeSignKeyVaultClientSecretName' -Value 'SIGN_KV_CLIENTSECRET' -Initialize -Description ''

Set-PSFConfig -FullName 'fscps.tools.settings.nugetFeedName' -Value '' -Initialize -Description ''
Set-PSFConfig -FullName 'fscps.tools.settings.nugetFeedUserName' -Value '' -Initialize -Description ''
Set-PSFConfig -FullName 'fscps.tools.settings.nugetFeedUserSecretName' -Value '' -Initialize -Description ''
Set-PSFConfig -FullName 'fscps.tools.settings.nugetFeedPasswordSecretName' -Value '' -Initialize -Description ''
Set-PSFConfig -FullName 'fscps.tools.settings.nugetSourcePath' -Value '' -Initialize -Description ''
Set-PSFConfig -FullName 'fscps.tools.settings.nugetPackagesPath' -Value 'NuGets' -Initialize -Description ''
Set-PSFConfig -FullName 'fscps.tools.settings.useLocalNuGetStorage' -Value $true -Initialize -Description ''

Set-PSFConfig -FullName 'fscps.tools.settings.githubSecrets' -Value '' -Initialize -Description ''
Set-PSFConfig -FullName 'fscps.tools.settings.githubAgentName' -Value '' -Initialize -Description ''
Set-PSFConfig -FullName 'fscps.tools.settings.buildPath' -Value '_bld' -Initialize -Description ''
Set-PSFConfig -FullName 'fscps.tools.settings.metadataPath' -Value 'PackagesLocalDirectory' -Initialize -Description ''

Set-PSFConfig -FullName 'fscps.tools.settings.lcsEnvironmentId' -Value '' -Initialize -Description ''
Set-PSFConfig -FullName 'fscps.tools.settings.lcsProjectId' -Value 123456 -Initialize -Description ''
Set-PSFConfig -FullName 'fscps.tools.settings.lcsClientId' -Value '' -Initialize -Description ''
Set-PSFConfig -FullName 'fscps.tools.settings.lcsUsernameSecretname' -Value 'AZ_TENANT_USERNAME' -Initialize -Description ''
Set-PSFConfig -FullName 'fscps.tools.settings.lcsPasswordSecretname' -Value 'AZ_TENANT_PASSWORD' -Initialize -Description ''

Set-PSFConfig -FullName 'fscps.tools.settings.azTenantId' -Value '' -Initialize -Description ''
Set-PSFConfig -FullName 'fscps.tools.settings.azClientId' -Value '' -Initialize -Description ''
Set-PSFConfig -FullName 'fscps.tools.settings.azClientsecretSecretname' -Value 'AZ_CLIENTSECRET' -Initialize -Description ''
Set-PSFConfig -FullName 'fscps.tools.settings.azVmname' -Value '' -Initialize -Description ''
Set-PSFConfig -FullName 'fscps.tools.settings.azVmrg' -Value '' -Initialize -Description ''

Set-PSFConfig -FullName 'fscps.tools.settings.artifactsPath' -Value 'artifacts' -Initialize -Description ''
Set-PSFConfig -FullName 'fscps.tools.settings.generatePackages' -Value $true -Initialize -Description ''
Set-PSFConfig -FullName 'fscps.tools.settings.packageNamePattern' -Value 'BRANCHNAME-PACKAGENAME-FNSCMVERSION_DATE.RUNNUMBER' -Initialize -Description ''
Set-PSFConfig -FullName 'fscps.tools.settings.packageName' -Value '' -Initialize -Description ''

Set-PSFConfig -FullName 'fscps.tools.settings.retailSDKVersion' -Value '' -Initialize -Description ''
Set-PSFConfig -FullName 'fscps.tools.settings.retailSDKZipPath' -Value 'C:\RSDK' -Initialize -Description ''
Set-PSFConfig -FullName 'fscps.tools.settings.retailSDKBuildPath' -Value 'C:\Temp\RetailSDK' -Initialize -Description ''
Set-PSFConfig -FullName 'fscps.tools.settings.retailSDKURL' -Value '' -Initialize -Description ''

Set-PSFConfig -FullName 'fscps.tools.settings.ecommerceMicrosoftRepoUrl' -Value 'https://github.com/microsoft/Msdyn365.Commerce.Online.git' -Initialize -Description ''
Set-PSFConfig -FullName 'fscps.tools.settings.ecommerceMicrosoftRepoBranch' -Value 'master' -Initialize -Description ''

Set-PSFConfig -FullName 'fscps.tools.settings.repoTokenSecretName' -Value 'REPO_TOKEN' -Initialize -Description ''
Set-PSFConfig -FullName 'fscps.tools.settings.ciBranches' -Value 'master,develop' -Initialize -Description ''
Set-PSFConfig -FullName 'fscps.tools.settings.deployScheduleCron' -Value '1 * * * *' -Initialize -Description ''
Set-PSFConfig -FullName 'fscps.tools.settings.deploy' -Value $false -Initialize -Description ''
Set-PSFConfig -FullName 'fscps.tools.settings.deployOnlyNew' -Value $true -Initialize -Description ''
Set-PSFConfig -FullName 'fscps.tools.settings.deploymentScheduler' -Value $true -Initialize -Description ''
Set-PSFConfig -FullName 'fscps.tools.settings.signArtifacts' -Value $false -Initialize -Description ''
Set-PSFConfig -FullName 'fscps.tools.settings.fscFinalQualityUpdatePackageId' -Value '' -Initialize -Description ''
Set-PSFConfig -FullName 'fscps.tools.settings.fscPreviewVersionPackageId' -Value '' -Initialize -Description ''
Set-PSFConfig -FullName 'fscps.tools.settings.fscServiseUpdatePackageId' -Value '' -Initialize -Description ''
Set-PSFConfig -FullName 'fscps.tools.settings.cleanupNugets' -Value $false -Initialize -Description ''
Set-PSFConfig -FullName 'fscps.tools.settings.cleanupCSUPackage' -Value $false -Initialize -Description ''
Set-PSFConfig -FullName 'fscps.tools.settings.secretsList' -Value @('nugetFeedPasswordSecretName','nugetFeedUserSecretName','lcsUsernameSecretname','lcsPasswordSecretname','azClientsecretSecretname','repoTokenSecretName','codeSignDigiCertUrlSecretName','codeSignDigiCertPasswordSecretName','codeSignDigiCertAPISecretName','codeSignDigiCertHashSecretName','codeSignKeyVaultClientSecretName') -Initialize -Description ''