This tutorial will show you how to sign D365FSC deployable packages and other files using code signing certificates.

## **Prerequisites**
* PowerShell 5.1
* fscps.tools module installed
* A valid code signing certificate (DigiCert or Azure KeyVault)

Please visit the [Install as a Administrator](https://github.com/fscpscollaborative/fscps.tools/wiki/Tutorial-Install-Administrator) or the [Install as a non-Administrator](https://github.com/fscpscollaborative/fscps.tools/wiki/Tutorial-Install-Non-Administrator) tutorials to learn how to install the tools.

## **Start PowerShell**
Locate the PowerShell icon, if you don't have it on your desktop or in the task pane, we can locate it in the Windows Start Menu. Search for it or type PowerShell.

[[images/tutorials/First-Time-Start-PowerShell-Non-Administrator.gif]]

## **Import module**
You need to import / load the fscps.tools module into the current PowerShell console. Type the following command:

```
Import-Module -Name fscps.tools
```

## **Sign files with DigiCert**

If you have a DigiCert code signing certificate, you can use the `Invoke-FSCPSDigiCertSignFile` cmdlet.

You will need:
* **SM_API_KEY** — your DigiCert API key
* **SM_CLIENT_CERT_FILE_URL** or **SM_CLIENT_CERT_FILE** — URL or local path to the `.p12` certificate file
* **SM_CLIENT_CERT_PASSWORD** — the certificate password (as SecureString)
* **SM_CODE_SIGNING_CERT_SHA1_HASH** — the certificate thumbprint (fingerprint)

```
$certPassword = ConvertTo-SecureString "YourPassword" -AsPlainText -Force

Invoke-FSCPSDigiCertSignFile `
    -SM_API_KEY "your-api-key" `
    -SM_CLIENT_CERT_FILE "c:\certs\digicert.p12" `
    -SM_CLIENT_CERT_PASSWORD $certPassword `
    -SM_CODE_SIGNING_CERT_SHA1_HASH "your-cert-thumbprint" `
    -FILE "c:\packages\MyPackage.zip"
```

If you have the certificate hosted remotely, use `-SM_CLIENT_CERT_FILE_URL` instead of `-SM_CLIENT_CERT_FILE`:

```
Invoke-FSCPSDigiCertSignFile `
    -SM_API_KEY "your-api-key" `
    -SM_CLIENT_CERT_FILE_URL "https://your-storage/digicert.p12" `
    -SM_CLIENT_CERT_PASSWORD $certPassword `
    -SM_CODE_SIGNING_CERT_SHA1_HASH "your-cert-thumbprint" `
    -FILE "c:\packages\MyPackage.zip"
```

## **Sign files with Azure KeyVault**

If you store your signing certificate in Azure KeyVault, use the `Invoke-FSCPSAzureSignToolSignFile` cmdlet.

You will need:
* **Uri** — the KeyVault URL (e.g. `https://my-vault.vault.azure.net`)
* **TenantId** — your Azure AD tenant ID
* **CertificateName** — the name of the certificate in KeyVault
* **ClientId** — the Azure AD application (service principal) client ID
* **ClientSecret** — the client secret (as SecureString)

```
$clientSecret = ConvertTo-SecureString "your-client-secret" -AsPlainText -Force

Invoke-FSCPSAzureSignToolSignFile `
    -Uri "https://my-vault.vault.azure.net" `
    -TenantId "01234567-abcd-ef01-0000-0123456789ab" `
    -CertificateName "my-signing-cert" `
    -ClientId "01234567-abcd-ef01-0000-0123456789ab" `
    -ClientSecret $clientSecret `
    -FILE "c:\packages\MyPackage.zip"
```

## **Closing comments**
In this tutorial we showed you two ways to sign files:
- **DigiCert** — using `Invoke-FSCPSDigiCertSignFile` for DigiCert-hosted certificates
- **Azure KeyVault** — using `Invoke-FSCPSAzureSignToolSignFile` for certificates stored in Azure KeyVault

Both approaches are suitable for signing deployable packages, DLLs, and other artifacts in your CI/CD pipeline.
