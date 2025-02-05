---
external help file: fscps.tools-help.xml
Module Name: fscps.tools
online version:
schema: 2.0.0
---

# Update-FSCPSRSATWebDriver

## SYNOPSIS
Update the web drivers for Microsoft Edge and Google Chrome browsers.

## SYNTAX

```
Update-FSCPSRSATWebDriver [[-webDriversPath] <String>]
```

## DESCRIPTION
This function checks the specified web drivers path.
If the path doesn't exist, it uses a default path.
It defines registry paths and URLs, retrieves the local web driver versions, and checks if an update is needed based on version comparison.

The function updates the web drivers for both Microsoft Edge and Google Chrome browsers by downloading the latest versions from their respective official websites and extracting the files to the specified path.

## EXAMPLES

### EXAMPLE 1
```
Update-FSCPSRSATWebDriver -webDriversPath "C:\CustomPath\WebDrivers"
```

## PARAMETERS

### -webDriversPath
The path where the web drivers are located.
Default is "C:\Program Files (x86)\Regression Suite Automation Tool\Common\External\Selenium".

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: C:\Program Files (x86)\Regression Suite Automation Tool\Common\External\Selenium
Accept pipeline input: False
Accept wildcard characters: False
```

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS
