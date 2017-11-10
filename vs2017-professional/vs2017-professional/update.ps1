import-module au

$releaseurl = "https://docs.microsoft.com/en-us/visualstudio/releasenotes/vs2017-relnotes"

function global:au_BeforeUpdate() {

  $client = New-Object System.Net.WebClient

    if (!(Test-Path "$($env:au_chocopackagepath)\$($Latest.packagename)\$($Latest.version)\$($Latest.filename)")) {
      mkdir "$($env:au_chocopackagepath)\$($Latest.packagename)\$($Latest.version)" -ea silentlycontinue
    }


    
  $client = New-Object System.Net.WebClient
  $thinInstaller="https://aka.ms/vs/15/release/vs_Professional.exe"
  $thinInstallerfilename=$thinInstaller -split '/' | Select-Object -Last 1 
  $client.DownloadFile($thinInstaller, "$($env:au_chocopackagepath)\$($Latest.packagename)\$($Latest.version)\$($thinInstallerFilename)")
  
  $workdir = "$($env:au_chocopackagepath)\$($Latest.packagename)\$($Latest.version)"
  Push-location $workdir
  
  new-item "$($env:au_chocopackagepath)\$($Latest.packagename)\layouts\$($Latest.version)" -type Directory -ea silentlycontinue
  new-item "$($env:au_chocopackagepath)\$($Latest.packagename)\layouts\$($Latest.version)\vs2017" -type Directory -ea silentlycontinue
  
  .\vs_Professional.exe --layout "$($env:au_chocopackagepath)\$($Latest.packagename)\layouts\$($Latest.version)\vs2017" --passive --includeRecommended --add Microsoft.VisualStudio.Workload.Azure --add Microsoft.Net.Component.4.7.1.SDK --add Microsoft.Net.Component.4.7.1.TargetingPack --add Microsoft.VisualStudio.Workload.Data --add Microsoft.VisualStudio.Workload.DataScience --add Microsoft.VisualStudio.Workload.ManagedDesktop --add Microsoft.VisualStudio.Workload.NetCoreTools --add Microsoft.VisualStudio.Workload.NetWeb --add Microsoft.VisualStudio.Workload.Node --add Microsoft.VisualStudio.Workload.Office --add Microsoft.VisualStudio.Workload.Python --add Component.GitHub.VisualStudio --lang en-US
  start-sleep 5
  Wait-Process -Name "vs_Professional"
  copy-item D:\chocopackages\vs2017-professional\certmgr.exe "$($env:au_chocopackagepath)\$($Latest.packagename)\layouts\$($Latest.version)\vs2017"
  copy-item D:\chocopackages\vs2017-professional\myco.json "$($env:au_chocopackagepath)\$($Latest.packagename)\layouts\$($Latest.version)\vs2017"

  $ISOFileName = "$($env:au_chocopackagepath)\$($Latest.packagename)\$($Latest.filename)"

  &"C:\Program Files (x86)\Windows Kits\10\Assessment and Deployment Kit\Deployment Tools\amd64\oscdimg\oscdimg.exe" -o -u2 -lvs2017-TP "$($env:au_chocopackagepath)\$($Latest.packagename)\layouts\$($Latest.version)" $ISOFileName -m
  Pop-Location
  
  $Latest.ChecksumType = "sha256"
  $Latest.Checksum = Get-FileHash -Algorithm $Latest.ChecksumType -Path $ISOFileName | ForEach-Object Hash
  remove-item "$($env:au_chocopackagepath)\$($Latest.packagename)\layouts\$($Latest.version)" -recurse -force
}



function global:au_SearchReplace {
@{
  'tools\chocolateyInstall.ps1' = @{
    "(^[$]url\s*=\s*)('.*')" = "`$1'$($Latest.internalsite)'"
    "(^[$]checksum\s*=\s*)('.*')" = "`$1'$($Latest.Checksum)'"
  }
 }
}


function global:au_GetLatest {
  $packagename = "vs2017-professional"
  $releasePage = Invoke-WebRequest -Uri $releaseUrl -UseBasicParsing
  $versionRegEx = 'Visual Studio 2017 version ([0-9\.]+).*<img src="media/new_button_bg2.svg"'
  $versionInfo = $releasePage.Content -match $versionRegEx
  $version = $matches[1]

  $filename = "vs2017-$($version)-myco-en-us-offline.iso"

  $is =  "$($env:au_chocopackages)/$($packagename)/$($filename)"
  #no URL since we run setup.exe
  $url = $is
  @{
      Version       = $version
      URL           = $url
      packagename   = $packagename
      filename      = $filename
      internalsite  = $is
  }
}


# we get our own checksum since we download and handle in beforeupdate
Update-Package -ChecksumFor none -NoCheckUrl