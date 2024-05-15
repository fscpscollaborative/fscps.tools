# Settings
The behavior of FSCPS is very much controlled by the settings in settings files.

## Basic settings
| Name | Description | Project | Default value |
| :-- | :-- | :-- | :-- |
| type | Specifies the type of project. Allowed values are **FSCM** or **Commerce** or **ECommerce**. This value comes with the default repository. | All | FSCM |
| companyName | Company name using for generate the package name.  | All | |
| buildVersion | The default D365 FSC version used to build and generate the package. | All | |
| buildPath | The FSC-PS system will copy the {github.workspace} into this folder and will do the build from it. The folder will be located inside C:\Temp\  | All | _bld |
| metadataPath | Specify the folder contains the FSC models  {github.workspace}\{metadataPath} | FSC | PackagesLocalDirectory |
| includeTestModel | Include unit test models into the package. | FSC | false |
| generatePackages | Option to generate a package after build. Often used in build, deploy and release workflows | All | true |
| uploadPackageToLCS | Option to upload generated package to the LCS after build and generate process. IMPORTANT!!! generatePackages option should be set to True | All | false |
| exportModel | Option to generate axmodel file. IMPORTANT!!! generatePackages option should be set to True | FSC | false |
| specifyModelsManually | If you need to build only specific models, set to true  | FSC | false |
| models | Comma-delimited array of models.  | FSC | "" |
| currentBranch | The current execution branch name | All | {current execution branch} |

## GitHub specific settings
### Basic
| Name | Description | Project | Default value |
| :-- | :-- | :-- | :-- |
| deployScheduleCron | CRON schedule for when deploy workflow should run. Default is execute each first minute of hour, only manual trigger. Build your CRON string here: https://crontab.guru | All | 1 * * * * |
| deployOnlyNew | Deploy environments while schedule only if the related environment branch has changes yongest then latest deploy  | All | true |
| deploymentScheduler | Enable/Disable the deployment schedule | All | true |
| sourceBranch | The branch used to build and generate the package. | All | {branch name from .FSC-PS\environments.json settings} |

### Repository settings
The repository settings are only read from the repository settings file (.github\FSC-PS-Settings.json)
| Name | Description | Default value |
| :-- | :-- | :-- |
| templateUrl | Defines the URL of the template repository used to create this project and is used for checking and downloading updates to FSC-PS System files. | https://github.com/fscpscollaborative/fscps.fsctpl |
| templateBranch | Defines the branchranch of the template repository used to create this project and is used for checking and downloading updates to FSC-PS System files. | main |
| runs-on | Specifies which github runner will be used for all jobs in all workflows (except the Update FSC-PS System Files workflow). The default is to use the GitHub hosted runner Windows-latest. You can specify a special GitHub Runner for the build job using the GitHubRunner setting. Read [this](SelfHostedGitHubRunner.md) for more information. | windows-latest |
| githubAgentName | Specifies which github runner will be used for the build/ci/deploy/release job in workflows. This is the most time consuming task. By default this job uses the Windows-latest github runner (unless overridden by the runs-on setting). This settings takes precedence over runs-on so that you can use different runners for the build job and the housekeeping jobs. See runs-on setting. | windows-latest |

### Azure settings
These Azure settings should contain the tenant configuration what will use by default for all deployments. Used for checking the VM status in the deploy workflow. AAD Application should have "DevTest labs" permitions for the Azure sebscription. Can be overrided in the environments settings.
| Name | Description | Default value |
| :-- | :-- |  :-- |
| azTenantId | The Guid of the Azure tenant  |  |
| azClientId | The Guid of the AAD registered application  |  |
| azClientsecretSecretname | The github secret name that contains ClientSecret of the registered application  | AZ_CLIENTSECRET |

### LCS settings
These LCS settings should contain the tenant configuration what will use by default for all deployments. Can be overrided in the .FSC-PS\environments.jsom settings.
| Name | Description | Default value |
| :-- | :-- | :-- |
| lcsEnvironmentId | The Guid of the LCS environment | |
| lcsProjectId | The ID of the LCS project | |
| lcsClientId | The ClientId of the azure application what has access to the LCS | |
| lcsUsernameSecretname | The github secret name that contains the username what has at least Owner access to the LCS project. It is a highly recommend to create a separate AAD user for this purposes. E.g. lcsadmin@contoso.com | AZ_TENANT_USERNAME |
| lcsPasswordSecretname | The github secret name that contains the password of the LCS user. | AZ_TENANT_PASSWORD |
| FSCPreviewVersionPackageId | The AssetId of the Preview package of the FSC. Depends on the FSC Version(version.default.json). | "" |
| FSCServiseUpdatePackageId | The AssetId of the Service Update (GA) package of the FSC. Depends on the FSC Version(version.default.json). | "" |
| FSCFinalQualityUpdatePackageId | The AssetId of the Final Quality Update (Latest) package of the FSC. Depends on the FSC Version(version.default.json). | "" |

### NuGet settings
The custom NuGet repository settings contains the D365 FSC nuget packages for build. The packages can be downloaded from the LCS Shared Asset Library

| Name | Description | System | Default value |
| :-- | :-- | :-- | :-- |
| nugetFeedName | The name of the Nuget feed.  | |
| nugetSourcePath | The URL of the Nuget feed.  | |
| nugetFeedUserName | The username credential of the NuGet feed. | |
| nugetFeedUserSecretName | The github secret name contains the username credential of the NuGet feed. If specified will be used instead of nugetFeedUserName parameter | |
| nugetFeedPasswordSecretName | The github secret name contains the password credential of the NuGet feed. | |
| nugetPackagesPath | The name of the directory where Nuget packages will be stored  | NuGet |

### ECommerce settings
The ECommerce settings.
| Name | Description | Project | Default value |
| :-- | :-- | :-- | :-- |
| ecommerceMicrosoftRepoUrl | The Msdyn365.Commerce.OnlineSDK repo URL what will use to build the ECommerce pacage. | Ecommerce | |
| EcommerceMicrosoftRepoBranch | The Msdyn365.Commerce.OnlineSDK repo branch. | Ecommerce | |

## Environments settings
| Name | Description | Default value |
| :-- | :-- | :-- |
| Name | The LCS environment name ||
| settings | The environment specific settings which will override the basic settings in the .\FSC-PS\settings.json file.  ||
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
| versioningStrategy |	under development | 0 |
| repoTokenSecretName | Specifies the name (**NOT the secret**) of the REPO_TOKEN secret. Default is REPO_TOKEN. FSC-PS for GitHub will look for a secret with this name in GitHub Secrets or Azure KeyVault to use as Personal Access Token with permission to modify workflows when running the Update FSC-PS System Files workflow. | REPO_TOKEN |
| failOn | Specifies what the pipeline will fail on. Allowed values are none, warning and error | error |
| codeSignDigiCertUrlSecretName<br />codeSignDigiCertPasswordSecretName | Specifying the secure URL from which your codesigning certificate pfx file can be downloaded and the password for this certificate. These settings specifies the names (**NOT the secrets**) of the code signing certificate url and password. Default is to look for secrets called codeSignDigiCertUrl and codeSignDigiCertPassword.  | codeSignDigiCertUrl<br />codeSignDigiCertPassword |
