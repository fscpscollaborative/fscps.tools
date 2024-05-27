This tutorial will show you how to list and search data of D365FSC versions that are available from the fscps.tools module.

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

## **List all data of available D365FSC versions**
If you want to see the entire list data of available D365FSC versions from the fscps.tools, you can ask PowerShell to list them for you. Type the following command:

```
Get-FSCPSVersionInfo

```

[[images/howto/How-To-Get-D365FSCVersion-List.gif]]


## **Get data for the specific D365FSC version**
If you want to search for command that contains a specific word or phrase, you can ask PowerShell to search for commands in the fscps.tools module. Type the following command:

```
$versionData = Get-FSCPSVersionInfo -Version 10.0.39
$versionData
$versionData.data
```

[[images/howto/How-To-Get-D365FSCVersion-Specific.gif]]

## **Closing comments**
In this tutorial we showed you how to list all of the functions that is part of the fscps.tools. We also showed how you can search for a specific keyword and find all commands containing that keyword.