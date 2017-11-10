$packageName = 'vs2017-professional'
$fileType = 'EXE'
$adminFile = 'myco.json'
$checksum = '7AD648E0FD3EF2022B59CE5C15D02BE92C491BB6BFDF00AC7D276A90EAC279CA'
$ChecksumType = 'sha256'
$url = 'https://chocopackages.myco.corp/vs2017-professional/vs2017-15.7.4-myco-en-us-offline.iso'

$iso = $url | Split-Path -leaf


$downloadpath = "$env:temp\$env:ChocolateyPackageName\$env:ChocolateyPackageVersion"
If (!(Test-Path $downloadpath)) {New-Item $downloadpath -type directory}

$fullfile_iso = join-path $downloadpath $iso


Get-ChocolateyWebFile -PackageName $packageName -FileFullPath $fullfile_iso -url $url -url64bit $url -Checksum $checksum -ChecksumType $checksumType


# install vs studio 2017

$mountVolume = Mount-DiskImage -ImagePath $fullfile_iso

$driveLetter = ((Get-Volume -FileSystemLabel "vs2017-myco").DriveLetter) + ":"
$installpath = "$($driveletter)\vs2017"
Set-Location $installpath
$installFile = Join-Path $installpath 'vs_professional.exe'
$fullfile_admin = "$($installpath)\$($adminFile)"

$silentArgs = "--in $fullfile_admin --noweb --passive --wait --norestart"

start-process .\certmgr.exe -ArgumentList '-add -c certificates\manifestSignCertificates.p12 -n "Microsoft Code Signing PCA 2011" -s -r LocalMachine CA' -Wait -NoNewWindow
start-process .\certmgr.exe -ArgumentList '-add -c certificates\manifestSignCertificates.p12 -n "Microsoft Root Certificate Authority" -s -r LocalMachine root' -Wait -NoNewWindow
start-process .\certmgr.exe -ArgumentList '-add -c certificates\manifestCounterSignCertificates.p12 -n "Microsoft Time-Stamp PCA 2010" -s -r LocalMachine CA' -Wait -NoNewWindow
start-process .\certmgr.exe -ArgumentList '-add -c certificates\manifestCounterSignCertificates.p12 -n "Microsoft Root Certificate Authority" -s -r LocalMachine root' -Wait -NoNewWindow
start-process .\certmgr.exe -ArgumentList '-add -c certificates\vs_installer_opc.SignCertificates.p12 -n "Microsoft Code Signing PCA" -s -r LocalMachine CA' -Wait -NoNewWindow
start-process .\certmgr.exe -ArgumentList '-add -c certificates\vs_installer_opc.SignCertificates.p12 -n "Microsoft Root Certificate Authority" -s -r LocalMachine root' -Wait -NoNewWindow

start-process $installfile -ArgumentList $silentArgs -Wait -NoNewWindow


Set-Location C:\
Dismount-DiskImage -ImagePath $fullfile_iso
