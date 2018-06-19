$packageName = 'office365-x64'
$downloadpath = "$env:temp\$env:ChocolateyPackageName"
$finalpath = "$env:temp\$env:ChocolateyPackageName\$env:ChocolateyPackageVersion"
$PSScriptRoot = Split-Path -Parent $MyInvocation.MyCommand.Definition
Import-Module (Join-Path $PSScriptRoot 'functions.ps1')

$zipArgs = @{
  packagename = $packagename
  url = 'https://chocopackages.myco.corp/office365-x64/16.0.9330.2124/office365.zip'
  UnzipLocation = $finalpath
  checksum = 'AE1B54828C44179451A8EF886729EF5ECA29128EC02AABEB3240B5D6981DCE93'
  checksumType = "sha256"
}

If (!(Test-Path $finalpath)) {New-Item $finalpath -type directory}

$installExe = Join-Path $finalpath 'setup.exe'

# Download and Unzip
Install-ChocolateyZipPackage @zipArgs

#edit the xml update filepath to the package version
[xml]$cfgdeploy = Get-Content "$($finalpath)\config-deploy.xml"
$cfgdeploy.Configuration.Add.SourcePath="%temp%\office365-x64\$env:ChocolateyPackageVersion\Monthly"
$cfgdeploy.Configuration.Updates.UpdatePath="%temp%\office365-x64\$env:ChocolateyPackageVersion\Monthly"
$cfgdeploy.Save("$($finalpath)\config-deploy.xml")

# ensure the correct v64.cab is used (version specific)
copy-item "$finalpath\Monthly\Office\Data\v64_$env:ChocolateyPackageVersion.cab" "$finalpath\Monthly\Office\Data\v64.cab" -force

$packageArgs = @{
  packageName   = $packageName
  fileType      = 'EXE'
  file          = $installExe
  silentArgs    = "/configure config-deploy.xml"
  validExitCodes = @(0,3010)
}

# Set-Location "C:\Program Files\Common Files\microsoft shared\ClickToRun"
# .\OfficeC2RClient.exe /Update User displaylevel=True
$isInstalled = Get-UninstallRegistryKey -softwareName "Microsoft Office 365 ProPlus - en-us"

# blogs.technet.microsoft.com/odsupport/2015/04/27/updating-office-365-clients-from-a-network-location/

if ($isInstalled) {
  Set-Location "C:\Program Files\Common Files\microsoft shared\ClickToRun"
  $updateURL = "$env:temp\office365\$env:ChocolateyPackageVersion\Monthly"
  Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Office\ClickToRun\Configuration" -Name "UpdateURL" -Type String -Value $updateURL
  &.\OfficeC2RClient.exe /Update User displaylevel=False forceappshutdown=true updatepromptuser=False
  # shared function from github: OfficeDev/Office-IT-Pro-Deployment-Scripts 
  Wait-ForOfficeCTRUpadate
  
}
else {
  Set-Location $finalpath
  Install-ChocolateyInstallPackage @packageArgs
}

remove-item "$finalpath\office365.zip" -force -erroraction silentlycontinue
