# **Get help content for a command**

This tutorial will show you how to get the different kind of help content available for every command in the fscps.tools module.

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

## **List all available commands**
For us to have something to work with, we need to get the list of available functions in the module. Type the following command:

```
Get-Command -Module fscps.tools
```

[[images/tutorials/First-Time-List-Commands.gif]]

## **Get help content for a specific function**
If you want to know more about a specific command, you can pass the name of the desired command to `Get-Help`. Type the following command:

```
Get-Help Get-FSCPSNuget
```

[[images/tutorials/First-Time-Show-Help.gif]]

## **Get help content, including examples, for a specific function**
The help content for every function contains a high level explanation for each available parameter and examples. Type the following command:

```
Get-Help Get-FSCPSNuget -Full
```

[[images/tutorials/First-Time-Show-Help-Full.gif]]

## **Get examples only, for a specific function**
The help content for every function contains at least 1 example on how run the function. Type the following command:

```
Get-Help Get-FSCPSNuget -Examples
```

[[images/tutorials/First-Time-Show-Help-Examples-Only.gif]]


## **Closing comments**
In this tutorial we showed you how to list help content for a specific command, including the detailed parameter explanation and the examples.