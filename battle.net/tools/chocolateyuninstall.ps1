$ErrorActionPreference = 'Stop';
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$ahkExe     = 'AutoHotKey'
$ahkFile    = "$toolsDir\battle.net_uninstall.ahk"

$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  softwareName  = 'Battle.net*'
  fileType      = 'EXE'
  silentArgs    = '--lang=enUS --uid=battle.net --displayname="Battle.net"'
  validExitCodes= @(0, 3010, 1605, 1614, 1641)
  file          = 'C:\ProgramData\Battle.net\Agent\Blizzard Uninstaller.exe'
}

Start-Process $ahkExe $ahkFile
Uninstall-ChocolateyPackage @packageArgs