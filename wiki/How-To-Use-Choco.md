# **Use Choco**

This tutorial will show you how to install/upgrade choco packages.

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

## **Install choco package**


```
Invoke-FSCPSChoco install powershell-core -y

```

[[images/howto/How-To-Install-Choco-Package.gif]]

## **Upgrade choco package**


```
Invoke-FSCPSChoco upgrade powershell-core -y

```

[[images/howto/How-To-Upgrade-Choco-Package.gif]]

## **Closing comments**
In this tutorial we showed you how to install/upgrade choco packages. 