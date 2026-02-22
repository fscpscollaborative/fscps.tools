This tutorial will show you how to download D365FSC system update packages (service updates, previews, quality updates) using fscps.tools.

## **Prerequisites**
* PowerShell 5.1
* fscps.tools module installed
* Azure Storage Account configured with the update packages (see [[Work with Azure Storage Account]])

Please visit the [Install as a Administrator](https://github.com/fscpscollaborative/fscps.tools/wiki/Tutorial-Install-Administrator) or the [Install as a non-Administrator](https://github.com/fscpscollaborative/fscps.tools/wiki/Tutorial-Install-Non-Administrator) tutorials to learn how to install the tools.

## **Import module**

```
Import-Module -Name fscps.tools
```

## **Understanding update types**

The `Get-FSCPSSystemUpdatePackage` cmdlet supports the following update types:

| UpdateType | Description |
| :-- | :-- |
| **SystemUpdate** | The GA (General Availability) service update package |
| **Preview** | The preview version of a service update |
| **FinalQualityUpdate** | The final quality update for a version |
| **ProactiveQualityUpdate** | A proactive quality update |

## **Download a system update package**

### **Download the GA service update**

```
Get-FSCPSSystemUpdatePackage `
    -UpdateType SystemUpdate `
    -D365FSCVersion "10.0.40" `
    -OutputPath "C:\Packages\"
```

This will download the service update package for version 10.0.40 and save it to `C:\Packages\`.

### **Download a preview version**

```
Get-FSCPSSystemUpdatePackage `
    -UpdateType Preview `
    -D365FSCVersion "10.0.41" `
    -OutputPath "C:\Packages\"
```

### **Download a final quality update**

```
Get-FSCPSSystemUpdatePackage `
    -UpdateType FinalQualityUpdate `
    -D365FSCVersion "10.0.40" `
    -OutputPath "C:\Packages\"
```

### **Force re-download**

If the package already exists locally, use `-Force` to re-download:

```
Get-FSCPSSystemUpdatePackage `
    -UpdateType SystemUpdate `
    -D365FSCVersion "10.0.40" `
    -OutputPath "C:\Packages\" `
    -Force
```

### **Use a custom storage config**

By default the cmdlet uses the `PackageStorage` storage account configuration. You can specify a different one:

```
Get-FSCPSSystemUpdatePackage `
    -UpdateType SystemUpdate `
    -D365FSCVersion "10.0.40" `
    -OutputPath "C:\Packages\" `
    -StorageAccountConfig "MyCustomStorage"
```

## **Closing comments**
In this tutorial we showed you how to use `Get-FSCPSSystemUpdatePackage` to download different types of D365FSC update packages. Make sure your Azure Storage Account is configured with the correct packages before using this cmdlet (see [[Work with Azure Storage Account]]).
