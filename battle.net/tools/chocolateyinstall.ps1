$ErrorActionPreference = 'Stop';
$toolsDir     = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$ahkExe       = 'AutoHotKey'
$ahkFile      = "$toolsDir\battle.net_install.ahk"
$url          = 'https://us.battle.net/download/getInstaller?os=win&installer=Battle.net-Setup.exe&id=undefined'
$fileLocation = Join-Path $toolsDir 'Battle.net-Setup.exe'
$checksumType = 'sha256'

Invoke-WebRequest $url -OutFile $fileLocation -UseBasicParsing
$checksum = (Get-FileHash $fileLocation -Algorithm $checksumType).Hash

$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  unzipLocation = $toolsDir
  fileType      = 'EXE'
  file          = $fileLocation
  softwareName  = 'Battle.net*'
  checksum      = $checksum
  checksumType  = $checksumType
  silentArgs    = ""
  validExitCodes= @(0, 3010, 1641)
}

Start-Process $ahkExe $ahkFile
Install-ChocolateyPackage @packageArgs
Start-WaitandStop "Battle.net"