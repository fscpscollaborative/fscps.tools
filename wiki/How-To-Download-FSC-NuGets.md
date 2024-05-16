# **D365FSC. Download FSC NuGets**

This tutorial will show you how to download D365FSC nuget packages.

## **Prerequisites**
* PowerShell 5.1
* fscps.tools module installed

Please visit the [Install as a Administrator](https://github.com/fscpscollaborative/fscps.tools/wiki/Tutorial-Install-Administrator) or the [Install as a Administrator](https://github.com/fscpscollaborative/fscps.tools/wiki/Tutorial-Install-Non-Administrator) tutorials to learn how to install the tools.

## **Start PowerShell**
Locate the PowerShell icon, if you don't have it on your desktop or in the task pane, we can locate it in the Windows Start Menu. Search for it or type PowerShell.

[[images/tutorials/First-Time-Start-PowerShell-Non-Administrator.gif]]

## **Import module**
You need to import / load the fscps.tools module into the current PowerShell console. Type the following command:

```
Import-Module -Name fscps.tools
```

[[images/tutorials/Import-Module-Administrator.gif]]

## **Download NuGets**


```
$DynamicsVersion = "10.0.39"
$PackagesDirectory = "C:\Temp\NuGets"
$versionData = Get-FSCPSVersionInfo -Version $DynamicsVersion
$PlatformVersion = $versionData.data.PlatformVersion
$ApplicationVersion = $versionData.data.AppVersion

Get-FSCPSNuget -Version $PlatformVersion -Type PlatformCompilerPackage -Path $PackagesDirectory -Force
Get-FSCPSNuget -Version $PlatformVersion -Type PlatformDevALM -Path $PackagesDirectory -Force
Get-FSCPSNuget -Version $ApplicationVersion -Type ApplicationDevALM -Path $PackagesDirectory -Force
Get-FSCPSNuget -Version $ApplicationVersion -Type ApplicationSuiteDevALM -Path $PackagesDirectory -Force
Get-ChildItem $PackagesDirectory

```

[[images/howto/How-To-Download-FSC-NuGets.gif]]

## **Closing comments**
In this tutorial we showed you how to download D365FSC nuget packages.