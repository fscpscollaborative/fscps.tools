# Settings
The behavior of FSCPS is very much controlled by the settings in settings files.

## How to configure if running on the GitHub
When running a workflow or a local script, the settings are applied by reading one or more settings files. Last applied settings file wins. The following lists the settings files and their location:

**.FSC-PS\\settings.json** is the root repository settings file. The .FSC-PS folder should be in the root folder of the repository.

**.github\\FSC-PS-settings.json** is the repository settings file. This settings file contains settings for the repository. If a settings in the repository settings file is found in a subsequent settings file, it will be overridden by the new value.

**.FSC-PS\\\<workflow\>.settings.json** is the workflow-specific settings file. This option is used for the build, ci and deploy workflows to determine artifacts and build numbers when running these workflows.

**.FSC-PS\\\<username\>.settings.json** is the user-specific settings file. This option is rarely used, but if you have special settings, which should only be used for one specific user (potentially in the local scripts), these settings can be added to a settings file with the name of the user followed by `.settings.json`.

**.FSC-PS\\environments.json** is the environment settings file. This settings file contains the list on the environments with the environment specific settings(branch, FSC version, etc.).

## How to configure if running on the Azure DevOps
All the important settings is added to the Azure DevOps action [FSCPS for Azure DevOps](https://marketplace.visualstudio.com/items?itemName=fscps.ado)

## How to configure if on localhost
The settings file can be everywhere and provided to the fscps.tools through the Set-FSCPSSettings applet. Find more details [here](https://github.com/fscpscollaborative/fscps.tools/wiki/How-To-Compile-ISV-model).

## Basic settings
| Name | Description | Project | System | Default value |
| :-- | :-- | :-- | :-- | :-- |
| type | Specifies the type of project. Allowed values are **FSCM** or **Commerce** or **ECommerce**. This value comes with the default repository. | All | All | FSCM |
| companyName | Company name using for generate the package name.  | All | All | |
| buildVersion | The default D365 FSC version used to build and generate the package. | All | All | |
| buildPath | The FSC-PS system will copy the {github.workspace} into this folder and will do the build from it. The folder will be located inside C:\Temp\  | All | All | _bld |
| metadataPath | Specify the folder contains the FSC models  {github.workspace}\{metadataPath} | FSCM | All | PackagesLocalDirectory |
| includeTestModel | Include unit test models into the package. | FSCM | All | false |
| generatePackages | Option to enable a packages generation functionality. Often used in build, deploy and release workflows | All | All | true |
| createRegularPackage | Option to generate an LCS Deployable Package after build. The "generatePackages" option should be enabled. | All | All | true |
| createCloudPackage | Option to generate a Power Platform Unified Package after build. The "generatePackages" option should be enabled. | All | All | false |
| uploadPackageToLCS | Option to upload generated package to the LCS after build and generate process. IMPORTANT!!! generatePackages option should be set to True | FSCM | All | false |
| exportModel | Option to generate axmodel file. IMPORTANT!!! generatePackages option should be set to True | FSCM | All | false |
| specifyModelsManually | If you need to build only specific models, set to true  | FSCM | All | false |
| models | Comma-delimited array of models.  | FSCM | All | "" |
| currentBranch | The current execution branch name | All | All | {current execution branch} |
| nugetPackagesPath | The name of the directory where Nuget packages will be stored  | All | All | NuGet |
| deployScheduleCron | CRON schedule for when deploy workflow should run. Default is execute each first minute of hour, only manual trigger. Build your CRON string here: https://crontab.guru | All | GitHub | 1 * * * * |
| deployOnlyNew | Deploy environments while schedule only if the related environment branch has changes yongest then latest deploy  | All | GitHub | true |
| deploymentScheduler | Enable/Disable the deployment schedule | All | GitHub | true |
| sourceBranch | The branch used to build and generate the package. | All | GitHub | {branch name from .FSC-PS\environments.json settings} |
| templateUrl | Defines the URL of the template repository used to create this project and is used for checking and downloading updates to FSC-PS System files. | All | GitHub | {template url} |
| templateBranch | Defines the branchranch of the template repository used to create this project and is used for checking and downloading updates to FSC-PS System files. | All | GitHub | main |
| runs-on | Specifies which github runner will be used for all jobs in all workflows (except the Update FSC-PS System Files workflow). The default is to use the GitHub hosted runner Windows-latest. You can specify a special GitHub Runner for the build job using the GitHubRunner setting. Read [this](SelfHostedGitHubRunner.md) for more information. | All | GitHub | windows-latest |
| githubAgentName | Specifies which github runner will be used for the build/ci/deploy/release job in workflows. This is the most time consuming task. By default this job uses the Windows-latest github runner (unless overridden by the runs-on setting). This settings takes precedence over runs-on so that you can use different runners for the build job and the housekeeping jobs. See runs-on setting. | All | GitHub | windows-latest |
| azTenantId | The Guid of the Azure tenant  | All | GitHub | |
| azClientId | The Guid of the AAD registered application  | All | GitHub |  |
| azClientsecretSecretname | The github secret name that contains ClientSecret of the registered application  | All | GitHub | AZ_CLIENTSECRET | 
| lcsEnvironmentId | The Guid of the LCS environment | All | GitHub | |
| lcsProjectId | The ID of the LCS project | All | GitHub | |
| lcsClientId | The ClientId of the azure application what has access to the LCS | All | GitHub | |
| lcsUsernameSecretname | The github secret name that contains the username what has at least Owner access to the LCS project. It is a highly recommend to create a separate AAD user for this purposes. E.g. lcsadmin@contoso.com | All | GitHub | AZ_TENANT_USERNAME |
| lcsPasswordSecretname | The github secret name that contains the password of the LCS user. | All | GitHub | AZ_TENANT_PASSWORD |
| FSCPreviewVersionPackageId | The AssetId of the Preview package of the FSC. Depends on the FSC Version(version.default.json). | All | GitHub | "" |
| FSCServiseUpdatePackageId | The AssetId of the Service Update (GA) package of the FSC. Depends on the FSC Version(version.default.json). | All | GitHub | "" |
| ecommerceMicrosoftRepoUrl | The Msdyn365.Commerce.OnlineSDK repo URL what will use to build the ECommerce pacage. | Ecommerce | GitHub | "" |
| ecommerceMicrosoftRepoBranch | The Msdyn365.Commerce.OnlineSDK repo branch. | Ecommerce | GitHub | "" |
| namingStrategy | The package naming strategy. Custom value means the result package will have the name specified in the packageName variable. Default / Custom / ModelVersion | All | All | Default |
| packageName | Name of the package | All | All | "" |
| versionSourceModelName | The model name to be used as version source for package naming when namingStrategy is set to "ModelVersion". This model will be used to retrieve the metadata version number for package name generation. | FSCM | All | "" |
| versionStrategy | This value means the version of the NuGet packages that will be taken to build the D365FSC code. GA - the NuGets from the GA version of the FSC will be taken (e.g. 10.0.39). Latest - latest available packages. Values: GA/Latest | FSCM | All | GA |
| cleanupNugets | Cleanup Commerce compiled NuGet packages with microsoft artifacts | Commerce | All | false |
| cleanupAfterBuild | Cleanup build cache after build | All | All | true |
| cleanupCSUPackage | Cleanup CSU (Commerce Scale Unit) package after build | Commerce | All | false |
| solutionName | Name of the solution | All | All | "" |
| artifactsPath | The destination artifacts path | All | All | "" |
| artifactsFolderName | The name of the folder contains the result artifacts | All | All | artifacts |
| signArtifacts | Option to sign generated artifacts | All | All | false |
| repoToken | Repository access token | All | All | "" |
| fscPsVer | Version of the fscps.tools module | All | All | {current module version} |
| enableBuildCaching | If true, will "cache" FSC models after build and upload it to the ModelStorage storage account. If next build triggered fscps will check the CRC of each model folder and if its equal with the cached CRC the folder with the model binaries will be extracted to the source folder, and target model will be skipped to the build. | FSCM | All | false |


## Environments settings
| Name | Description | Default value |
| :-- | :-- | :-- |
| Name | The LCS environment name | |
| settings | The environment specific settings which will override the basic settings in the .\FSC-PS\settings.json file.  | |
| settings.buildVersion | The FSC version (e.g. 10.0.29). Will be used to build the package and deploy to this environment  | buildVersion value from the .\FSC-PS\settings.json file |
| settings.sourceBranch | The source branch name (e.g. main). Will be used to get the latest source code, build the package and deploy to this environment  | main |
| settings.lcsEnvironmentId | The LCS EnvironmentID. Will be used to identify the environment to deploy the package  | |
| settings.azVmname | The Azure VM name. Will be used to identify the current status of the VM and to Start or Stop it.  | |
| settings.azVmrg | The Azure VM ResourceGrop. Will be used to identify the current status of the VM and to Start or Stop it.  | |
| settings.cron | The Cron string. Will be used to identify the time to schedule the deployment. (UTC)  | |
| settings.deploy | Deploy environment while schedule  | true |
| settings.deployOnlyNew | Deploy environment while schedule only if the related branch has changes yongest then latest deploy  | true |
| settings.includeTestModel | FSC specific. Include unit test models into the package. | false |

## Advanced settings
| Name | Description | Default value |
| :-- | :-- | :-- |
| repoTokenSecretName | Specifies the name (**NOT the secret**) of the REPO_TOKEN secret. Default is REPO_TOKEN. FSC-PS for GitHub will look for a secret with this name in GitHub Secrets or Azure KeyVault to use as Personal Access Token with permission to modify workflows when running the Update FSC-PS System Files workflow. | REPO_TOKEN |
| codeSignDigiCertUrlSecretName<br />codeSignDigiCertPasswordSecretName | Specifying the secure URL from which your codesigning certificate pfx file can be downloaded and the password for this certificate. These settings specifies the names (**NOT the secrets**) of the code signing certificate url and password. Default is to look for secrets called codeSignDigiCertUrl and codeSignDigiCertPassword.  | codeSignDigiCertUrl<br />codeSignDigiCertPassword |
