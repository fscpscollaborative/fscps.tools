# **fscps.tools**

A PowerShell module to handle different management tasks related to Microsoft Dynamics 365 Finance & Operations (D365FO).
Read more about D365FO on [docs.microsoft.com](https://docs.microsoft.com/en-us/dynamics365/unified-operations/fin-and-ops/index).

Available on PowerShell Gallery:
[fscps.tools](https://www.powershellgallery.com/packages/fscps.tools).

## Table of contents
* [Getting started](#getting-started)
* [Getting help](#getting-help)
* [Contributing](#contributing)
* [Dependencies](#dependencies)

## Getting started
### Install the latest module
```PowerShell
Install-Module -Name fscps.tools
```

### Install without administrator privileges
```PowerShell
Install-Module -Name fscps.tools -Scope CurrentUser
```
### List all available commands / functions

```PowerShell
Get-Command -Module fscps.tools
```

### Update the module

```PowerShell
Update-Module -name fscps.tools
```

### Update the module - force

```PowerShell
Update-Module -name fscps.tools -Force
```
## Getting help

[The wiki](https://github.com/onikolaiev/fscps.tools/wiki) contains more details about installation and also guides to help you with some common tasks. It also contains documentation for all the module's commands. Expand the wiki's `Pages` control at the top of the content sidebar to view and search the list of command documentation pages.

Since the project started we have adopted and extended the comment based help inside each cmdlet / function. This means that every single command contains at least one fully working example on how to run it and what to expect from the cmdlet.

**Getting help inside the PowerShell console**

Getting help is as easy as writing **Get-Help CommandName**

```PowerShell
Get-Help Get-FSCPSSettings
```

*This will display the available default help.*

Getting the entire help is as easy as writing **Get-Help CommandName -Full**

```PowerShell
Get-Help Get-FSCPSSettings -Full
```

*This will display all available help content there is for the cmdlet / function*

Getting all the available examples for a given command is as easy as writing **Get-Help CommandName -Examples**

```PowerShell
Get-Help Get-FSCPSSettings -Examples
```

*This will display all the available **examples** for the cmdlet / function.*

We know that when you are learning about new stuff and just want to share your findings with your peers, working with help inside a PowerShell session isn't that great.

## Dependencies

This module depends on other modules. The dependencies are documented in the [dependency graph](https://github.com/onikolaiev/fscps.tools/network/dependencies) and the Dependencies section of the Package Details of the [package listing](https://www.powershellgallery.com/packages/fscps.tools) in the PowerShell Gallery.
