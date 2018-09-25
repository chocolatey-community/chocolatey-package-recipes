# Minitab chocolatey recipe

## Follow this guide to create a chocolatey "ganache" recipe for internal enterprise distribution of Minitab statistical software.

###Requirements:
- Software binary
- Licence and licence server
- chocolatey installed
- UNC path or equivant distribution point such as nuget server

###Steps in chocolateyinstall.ps1:
1. Amend variable $chocoshare to be a UNC path or nuget server etc
2. Change $url to the filename of your minitab setup executable name
3. Amend $silentargs as you require with particular attention to LICENSE_SERVER which should be set to hostname/ip of your licence server
4. Enter your registration details under "Registration". This writes an ini file so that users do not get prompted in a multiuser system situation.

###Steps in Minitab.nuspec
Change the version number to match the binary setup you are deploying and package owner as you wish

###Build
Open a powershell shell or cmd prompt to where this minitab directory is located and
use choco pack to build a nupkg which you can host on your UNC path or nuget server.
Ensure the path matches that in chocolateyinstall.ps1

###Deploy
Deploy with cinst minitab -s \\your_UNC_path or equivalent