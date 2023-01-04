# Battle.net chocolatey package

### Pre-Requisites

This package requires the `autohotkey` chocolatey package
This package requires the `chocolatey-misc-helpers.extension` chocolatey package

The updater requires a properly configured installation of [AU](https://github.com/majkinetor/au)

### Quick start:

This package makes a few assumptions:

- Installs using the English language
- Installs to the default path

For a different language or path, the AutoHotKey install script would need to be updated for the new language or path

### Notes:

The Battle.net Launcher is built on demand when downloaded, so the checksum will be calculated on demand to be provided to `Install-ChocolateyPackage`

My update_vars.ps1 are set to:

```
$Env:au_Push = 'true'     #Push to chocolatey
$Env:au_PushUrl = 'https://chocolatey.zdl.io/chocolatey'
$Env:au_GalleryPackageRootUrl = 'https://chocolatey.zdl.io/chocolatey/Packages'
```
