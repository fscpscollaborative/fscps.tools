# **D365FSC. Compile ISV model**

This tutorial will show you how to compile a D365FSC module and generate the package.

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

## **Compile**


```
$settingsFile = @"
{
    "type":"FSCM",
    "packageName": "ContosoExtension",
    "buildVersion": "10.0.39"
}
"@
Set-FSCPSSettings -SettingsJsonString $settingsFile
Invoke-FSCPSCompile -SourcesPath "C:\Users\Admindc78f9f766\Desktop\ContosoExt-main\PackagesLocalDirectory"

```

[[images/howto/How-To-Compile-ISV-model.gif]]

## **Closing comments**
In this tutorial we showed you how to compile a D365FSC module and generate the package. Note: Please refer to [this description](https://github.com/fscpscollaborative/fscps.tools/wiki/settings) to learn more about the settings file and how you can modify default behaviors. 