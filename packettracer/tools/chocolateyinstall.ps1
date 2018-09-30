$ErrorActionPreference = 'Stop';
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$url        = "PATH_TO_UNC_PATH_OR_NUGET_SERVER" 

$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  unzipLocation = $toolsDir
  fileType      = 'exe'
  url           = $url
  file          = $url

  softwareName  = 'packettracer*' 


  checksum      = 'E41A5664241B6EF4341AF57BD8867D4787D618841ECCC8D98854EC7341B83263'
  checksumType  = 'sha256' 
 
  silentArgs    = "/VERYSILENT /SUPPRESSMSGBOXES /NORESTART /SP-"
  validExitCodes= @(0, 3010, 1641)
  
}

Install-ChocolateyInstallPackage @packageArgs 

