# Packe Tracer chocolatey recipe

## Follow this guide to create a chocolatey "ganache" recipe for internal enterprise distribution of Packet Tracer.

###Requirements:
- Software binary downloaded from Cisco Academy
- Chocolatey installed
- UNC path or equivant distribution point such as nuget server
- Know how to amend and build chocolatey packages (choco pack)

###Steps in chocolateyinstall.ps1:
1. Change $url to the path and filename of your Packet Tracer setup executable
2. Amend $silentargs if you wish to change anything. Default is fully silent and supresses a reboot at the end. 
3. If preferred use of Install-ChocolateyPackage instead of Install-ChocolateyInstallPackage, 
then checksums are relevant. sha256 for version 7.1.1 is included but this can be regenerated
using Get-FileHash against your chosen version's binary

###Steps in .nuspec
Change the version number to match the binary setup you are deploying and package owner as you wish

###Build
Open a powershell shell or cmd prompt to where this minitab directory is located and
use choco pack to build a nupkg which you can host on your UNC path or nuget server.
Ensure the path matches that in chocolateyinstall.ps1

###Deploy
Deploy with cinst packettracer -s \\your_UNC_path or equivalent