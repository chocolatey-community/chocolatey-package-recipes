$chocoshare = 'UNC_PATH_OR_HTTP_PATH'
$name = 'Minitab'
$installerType = 'exe'
$url = "$chocoshare\minitab18.1.0.0setup.exe"
$silentArgs = '/exenoui /exelang 1033 /qn ACCEPT_EULA=1 DISABLE_UPDATES=1 LICENSE_SERVER=YOUR_LICENCEMANAGER_IP'

Install-ChocolateyInstallPackage $name $installerType $silentArgs $url

# Registration
$regEmail = 'YOUR@EMAILADDRESS'
$regFirstname = 'YOURFIRSTNAME'
$regLastname = 'YOURLASTNAME'

@("[Minitab 18]","EMail=$regEmail","firstName=$regFirstname","lastName=$regLastname")  | Out-File -Filepath $env:ProgramData\Minitab\License.ini