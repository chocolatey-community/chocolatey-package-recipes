# Visual Studio 2017 Professional choco package

### Pre-Requisites 
* [certmgr](https://docs.microsoft.com/en-us/dotnet/framework/tools/certmgr-exe-certificate-manager-tool) for certificate management
* [oscdimg](https://docs.microsoft.com/en-us/windows-hardware/manufacture/desktop/oscdimg-command-line-options) for iso creation 

See Notes: for Additional information

The expected paths for these are (but can be easily modified):
* "C:\Program Files (x86)\Windows Kits\10\Assessment and Deployment Kit\Deployment Tools\amd64\oscdimg\oscdimg.exe
* "D:\chocopackages\vs2017-professional\certmgr.exe"

The updater requires a properly configured installation of [AU](https://github.com/majkinetor/au).  

### Quick start:

This package makes a few assumptions:
* Using the above tools for certificate management and iso creation
* Configures VS2017 fully offline with a predefined set of workloads

Workloads are defined in 2 places.  These can be totally customizable for your environment.  To prevent any internet access
make sure that no workloads specified in json are outside the set specified at build time.  Internet downloads may occur if
workloads are missing from the layout created.

Modify the following 2 workload locations to meet your needs.
* Line 26 of update.ps1 adds the workloads for build time
* json file is consumed by installer for install time

Substitute any instances of myco for your company name.

Simply run the updater to get things going.

### Notes:
certmgr.exe can be found in the [Windows 10 SDK](https://developer.microsoft.com/en-us/windows/downloads/windows-10-sdk)
oscdimg.exe can be found in the Deployment tools option within [Windows ADK](https://docs.microsoft.com/en-us/windows-hardware/get-started/adk-install)

My vars_default.ps1 are set to:

```
$Env:au_Push          = 'true'     #Push to chocolatey
$env:au_GalleryUrl    = 'https://chocolatey.myco.corp'
$env:au_SimpleServerPath = 'D:\tools\chocolatey.server\App_Data\Packages'
$env:au_chocopackagepath = 'D:\chocopackages'
$env:au_chocopackages = 'https://chocopackages.myco.corp'
$env:au_gitrepo = "D:\gitrepos\chocopackages"
```

Relish!
