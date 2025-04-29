
<#
    .SYNOPSIS
        Function to sign the files with digicert
        
    .DESCRIPTION
        Function to sign the files with digicert
        
    .PARAMETER SM_HOST
        Digicert host URL. Default value "https://clientauth.one.digicert.com"
        
    .PARAMETER SM_API_KEY
        The DigiCert API Key
        
    .PARAMETER SM_CLIENT_CERT_FILE
        The DigiCert certificate local path (p12)
        
    .PARAMETER SM_CLIENT_CERT_FILE_URL
        The DigiCert certificate URL (p12)
        
    .PARAMETER SM_CLIENT_CERT_PASSWORD
        The DigiCert certificate password
        
    .PARAMETER SM_CODE_SIGNING_CERT_SHA1_HASH
        The DigiCert certificate thumbprint(fingerprint)
        
    .PARAMETER FILE
        A file to sign
        
    .EXAMPLE
        PS C:\> Invoke-FSCPSDigiCertSignFile -SM_API_KEY "$codeSignDigiCertAPISecretName" `
            -SM_CLIENT_CERT_FILE_URL "$codeSignDigiCertUrlSecretName" `
            -SM_CLIENT_CERT_PASSWORD $(ConvertTo-SecureString $codeSignDigiCertPasswordSecretName -AsPlainText -Force) `
            -SM_CODE_SIGNING_CERT_SHA1_HASH "$codeSignDigiCertHashSecretName" `
            -FILE "$filePath"
        
        This will sign the target file with the DigiCert certificate
    .NOTES
        Author: Oleksandr Nikolaiev (@onikolaiev)
#>
function Invoke-FSCPSDigiCertSignFile {
    param (
        [Parameter(HelpMessage = "The DigiCert host", Mandatory = $false)]
        [string] $SM_HOST = "https://clientauth.one.digicert.com",
        [Parameter(HelpMessage = "The DigiCert API Key", Mandatory = $true)]
        [string] $SM_API_KEY,
        [Parameter(HelpMessage = "The DigiCert certificate local path (p12)", Mandatory = $false)]
        [string] $SM_CLIENT_CERT_FILE = "c:\temp\digicert.p12",
        [Parameter(HelpMessage = "The DigiCert certificate URL (p12)", Mandatory = $false)]
        [string] $SM_CLIENT_CERT_FILE_URL,
        [Parameter(HelpMessage = "The DigiCert certificate password", Mandatory = $true)]
        [SecureString] $SM_CLIENT_CERT_PASSWORD,
        [Parameter(HelpMessage = "The DigiCert certificate thumbprint(fingerprint)", Mandatory = $true)]
        [string] $SM_CODE_SIGNING_CERT_SHA1_HASH,    
        [Parameter(HelpMessage = "A file to sign", Mandatory = $true)]
        [string] $FILE
    )
    begin{
        $tempDirectory = "c:\temp"
        if (!(Test-Path -Path $tempDirectory))
        {
            [System.IO.Directory]::CreateDirectory($tempDirectory)
        }
        $certLocation = "$tempDirectory\digicert.p12"
        if(-not (Test-Path $FILE ))
        {
            Write-Error "File $FILE is not found! Check the path."
            exit 1;
        }
        if(-not (Test-Path $SM_CLIENT_CERT_FILE ))
        {            
            if(![string]::IsNullOrEmpty($SM_CLIENT_CERT_FILE_URL))
            {
                $certLocation = Join-Path $tempDirectory "digiCert.p12"
                Invoke-WebRequest -Uri "$SM_CLIENT_CERT_FILE_URL" -OutFile $certLocation
                if(Test-Path $certLocation)
                {
                    $SM_CLIENT_CERT_FILE = $certLocation
                }
            }

            if(-not (Test-Path $SM_CLIENT_CERT_FILE ))
            {
                Write-Error "Certificate $SM_CLIENT_CERT_FILE is not found! Check the path."
                exit 1;
            }
        }

        $currentLocation = Get-Location
        $signMessage = ""
        #set env variables
        $env:SM_CLIENT_CERT_FILE = $SM_CLIENT_CERT_FILE
        $env:SM_HOST = $SM_HOST 
        $env:SM_API_KEY = $SM_API_KEY
        $BSTR = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($SM_CLIENT_CERT_PASSWORD)
        $UnsecurePassword = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($BSTR)
        $env:SM_CLIENT_CERT_PASSWORD = $UnsecurePassword       
        Set-Location $tempDirectory
        if(-not (Test-Path -Path .\smtools-windows-x64.msi ))
        {
            Write-Output "===============smtools-windows-x64.msi================"
            $smtools = "smtools-windows-x64.msi"
            Write-Output "The '$smtools' not found. Downloading..."
            Invoke-WebRequest -Method Get https://one.digicert.com/signingmanager/api-ui/v1/releases/smtools-windows-x64.msi/download -Headers @{ "x-api-key" = "$($SM_API_KEY)"}  -OutFile .\$smtools -Verbose
            Write-Output "Downloaded. Installing..."
            msiexec /i $smtools /quiet /qn /le smtools.log
            Get-Content smtools.log -ErrorAction SilentlyContinue
            Write-Output "Installed."
            Start-Sleep -Seconds 5
        }
        Write-Output "Checking DigiCert location..."
        $smctlLocation = (Get-ChildItem "$Env:Programfiles\DigiCert" -Recurse | Where-Object { $_.BaseName -like "smctl" })
        
        if(Test-Path $smctlLocation.FullName)
        {
            Write-Output "DigiCert directory found at: $($smctlLocation.Directory)"
        }
        else
        {
            Write-Error "DigiCert directory not found. Check the installation."
            exit 1
        }
        $appCertKitPath = "${env:ProgramFiles(x86)}\Windows Kits\10\App Certification Kit" 
        Set-PathVariable -Scope Process -RemovePath $appCertKitPath -ErrorAction SilentlyContinue
        Set-PathVariable -Scope Process -AddPath  $appCertKitPath -ErrorAction SilentlyContinue

        & certutil.exe -csp "DigiCert Software Trust Manager KSP" -key -user

        & $($smctlLocation.FullName) windows certsync

    }
    process{
        try {     
            try {
                if($PSCmdlet.MyInvocation.BoundParameters["Verbose"].IsPresent){
                    Write-Output "===============Healthcheck================"
                    & $($smctlLocation.FullName) healthcheck
                    Write-Output "===============KeyPair list================"
                    & $($smctlLocation.FullName) keypair ls 
                }  
            }
            catch {   
                Write-Output "Healchcheck failed. please check it"
            }  

            Write-Output "Set-Location of DigiCert" 
            Set-Location $($smctlLocation.Directory)

            $signMessage = $(& $($smctlLocation.FullName) sign --fingerprint $SM_CODE_SIGNING_CERT_SHA1_HASH --input $FILE --verbose)
            Write-Output $($signMessage)
            if($signMessage.Contains("FAILED")){
                Write-Output (Get-Content "$env:USERPROFILE\.signingmanager\logs\smctl.log" -ErrorAction SilentlyContinue)
                throw;
            }
            if($PSCmdlet.MyInvocation.BoundParameters["Verbose"].IsPresent){
                & $($smctlLocation.FullName) sign verify --input $FILE
            }        
            
            Write-Output "File '$($FILE)' was signed successful!"
        }
        catch {
            
            Write-Output "Something went wrong! Read the healthcheck."
           # & $smctlLocation.FullName healthcheck
        }
    }
    end{
        Clear-Content $env:SM_HOST -Force -ErrorAction SilentlyContinue
        Clear-Content $env:SM_API_KEY -Force -ErrorAction SilentlyContinue
        Clear-Content $env:SM_CLIENT_CERT_PASSWORD -Force -ErrorAction SilentlyContinue
        Set-Location $currentLocation
        if((Test-Path $certLocation ))
        {  
            Remove-Item $certLocation -Force -ErrorAction SilentlyContinue
        }
    }
}