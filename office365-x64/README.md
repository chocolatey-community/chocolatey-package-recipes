# Office 365 x64 choco package

### Pre-Requisites 
* [setup.exe](https://www.office.com) available on sign-in to 
* [7zip](https://www.7-zip.org/)

The updater requires a properly configured installation of [AU](https://github.com/majkinetor/au).  

### Quick start:

This package makes a few assumptions:
* Installs the latest monthly Office 365.

### Additional notes

* AU will create a zip file for each version, and download it and package the required files into a zip
* Chocolatey will unzip and run the appropriate installer method setup or OfficeC2RClient.exe for upgrades keeping it fully supportable
* Package is easily modifiable for visio, and other x86 installs with minimal changes to json.


My vars_default.ps1 are set to:

```
$Env:au_Push          = 'true'     #Push to chocolatey
$env:au_GalleryUrl    = 'https://chocolatey.myco.corp'
$env:au_SimpleServerPath = 'D:\tools\chocolatey.server\App_Data\Packages'
$env:au_chocopackagepath = 'D:\chocopackages'
$env:au_chocopackages = 'https://chocopackages.myco.corp'
$env:au_gitrepo = "D:\gitrepos\chocopackages"
```
