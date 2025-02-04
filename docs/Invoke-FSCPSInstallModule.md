---
external help file: fscps.tools-help.xml
Module Name: fscps.tools
online version:
schema: 2.0.0
---

# Invoke-FSCPSInstallModule

## SYNOPSIS
Installs and imports specified PowerShell modules, with special handling for the "Az" module.

## SYNTAX

```
Invoke-FSCPSInstallModule [[-modules] <String[]>]
```

## DESCRIPTION
The \`Invoke-FSCPSInstallModules\` function takes an array of module names, installs them if they are not already installed, and then imports them.
It also handles the uninstallation of the "AzureRm" module if "Az" is specified.
Real-time monitoring is temporarily disabled during the installation process to speed it up.

## EXAMPLES

### EXAMPLE 1
```
Invoke-FSCPSInstallModules -modules @("Az", "Pester")
```

This example installs and imports the "Az" and "Pester" modules.

## PARAMETERS

### -modules
An array of module names to be installed and imported.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

## INPUTS

## OUTPUTS

## NOTES
- Real-time monitoring is disabled during the installation process to improve performance.
- The "AzureRm" module is uninstalled if "Az" is specified.

## RELATED LINKS
