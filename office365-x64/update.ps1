import-module au

$releaseurl = "https://support.office.com/en-us/article/Version-and-build-numbers-of-update-channel-releases-ae942449-1fca-4484-898b-a933ea23def7#bkmk_bydate"

function global:au_BeforeUpdate() {

  $client = New-Object System.Net.WebClient

    if (!(Test-Path "$($env:au_chocopackagepath)\$($Latest.packagename)\$($Latest.version)\$($Latest.filename)")) {
      mkdir "$($env:au_chocopackagepath)\$($Latest.packagename)\$($Latest.version)" -ea silentlycontinue
    }


    $workdir = "$($env:au_chocopackagepath)\$($Latest.packagename)"
    Push-location $workdir
    .\setup.exe /download .\config-download.xml


    $ZIPFileName = "$($env:au_chocopackagepath)\$($Latest.packagename)\$($Latest.version)\$($Latest.filename)"

    $FilesToZip = @("config-deploy.xml",
     "config-download.xml",
     "officedeploymenttool.exe",
     "setup.exe",
     "Monthly\Office\Data\$($Latest.version)\*.*",
     "Monthly\Office\Data\v64.cab",
     "Monthly\Office\Data\v64_$($Latest.version).cab"
     )

    & 'C:\Program Files\7-Zip\7z.exe' a -spf $ZipFileName @FilesToZip

    Pop-Location
  


  $Latest.ChecksumType = "sha256"
  $Latest.Checksum = Get-FileHash -Algorithm $Latest.ChecksumType -Path "$($env:au_chocopackagepath)\$($Latest.packagename)\$($Latest.version)\$($Latest.filename)" | ForEach-Object Hash

}



function global:au_SearchReplace {
@{
  'tools\chocolateyInstall.ps1' = @{
    "(^\s*url\s*=\s*)('.*')"      = "`$1'$($Latest.internalsite)'"
    "(^\s*checksum\s*=\s*)('.*')" = "`$1'$($Latest.checksum)'"
  }
 }
}


function global:au_GetLatest {
  $packagename = "office365-x64"
  $releasePage = Invoke-WebRequest -Uri $releaseUrl -UseBasicParsing
  
  $fml = ($releasePage.Links | ? outerhtml -like '<a href="monthly*')[0]
  $versionregex = '(Build ([0-9\.]+))'
  $versioninfo = $fml -match $versionRegEx
  $version = "16.0.$($matches[2])"

  $filename = "office365.zip"

  $is =  "$($env:au_chocopackages)/$($packagename)/$($version)/$($filename)"
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