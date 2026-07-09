This tutorial will show you how to read and update D365FSC model versions using fscps.tools.

## **Prerequisites**
* PowerShell 5.1
* fscps.tools module installed
* A D365FSC metadata folder with model descriptors

Please visit the [Install as a Administrator](https://github.com/fscpscollaborative/fscps.tools/wiki/Tutorial-Install-Administrator) or the [Install as a non-Administrator](https://github.com/fscpscollaborative/fscps.tools/wiki/Tutorial-Install-Non-Administrator) tutorials to learn how to install the tools.

## **Import module**

```
Import-Module -Name fscps.tools
```

## **Get model version**

Use `Get-FSCPSModelVersion` to read the current version of a model from its descriptor file. You only need to specify the model folder — the cmdlet will automatically find the descriptor XML inside the `Descriptor` subfolder.

```
Get-FSCPSModelVersion -ModelPath "c:\temp\PackagesLocalDirectory\MyCustomModel"
```

This will return an object with:
- **ModelName** — the name of the model
- **Version** — the full version string (e.g. `2.1.5.0`)
- **Layer** — the model layer (e.g. `ISV`, `VAR`, `CUS`)

### **Example: Get versions for all models**

```
$metadataPath = "c:\temp\PackagesLocalDirectory"

Get-ChildItem -Path $metadataPath -Directory | ForEach-Object {
    $versionInfo = Get-FSCPSModelVersion -ModelPath $_.FullName
    if ($versionInfo) {
        Write-Host "$($versionInfo.ModelName) - Version: $($versionInfo.Version) - Layer: $($versionInfo.Layer)"
    }
}
```

## **Update model version**

Use `Update-FSCPSModelVersion` to change the version of one or more models. This is useful in CI/CD pipelines to stamp build numbers into the model metadata before compilation.

Parameters:
- **xppSourcePath** — path to the root metadata folder
- **xppDescriptorSearch** — search pattern for the model descriptor (e.g. `MyModel\Descriptor\*.xml`)
- **xppLayer** — minimum layer to update (e.g. `ISV` will update ISV and above)
- **versionNumber** — the new version in `#.#.#.#` format

```
Update-FSCPSModelVersion `
    -xppSourcePath "c:\temp\PackagesLocalDirectory" `
    -xppDescriptorSearch "MyCustomModel\Descriptor\*.xml" `
    -xppLayer "ISV" `
    -versionNumber "2.1.6.0"
```

### **Example: Update all ISV+ models to a build version**

```
$metadataPath = "c:\temp\PackagesLocalDirectory"
$buildVersion = "3.0.$(Get-Date -Format 'yyMM').$(Get-Date -Format 'ddHH')"

# Update all models at ISV layer and above
Get-ChildItem -Path $metadataPath -Directory | ForEach-Object {
    $descriptorPattern = "$($_.Name)\Descriptor\*.xml"
    Update-FSCPSModelVersion `
        -xppSourcePath $metadataPath `
        -xppDescriptorSearch $descriptorPattern `
        -xppLayer "ISV" `
        -versionNumber $buildVersion
}
```

## **Closing comments**
In this tutorial we showed you how to:
- **Read** model versions using `Get-FSCPSModelVersion`
- **Update** model versions using `Update-FSCPSModelVersion`

These cmdlets are especially useful in automated build pipelines to track and stamp version numbers into your D365FSC models.
