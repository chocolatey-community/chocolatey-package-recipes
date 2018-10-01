# Chocolatey Ganache

Chocolatey Ganache - Chocolatey repository full of package recipes and patterns.

In here you will find multiple patterns for packages that an organization can use internally. This is great for software packages and other types of packages that really don't have a place or the ability to be hosted on the community repository.



## Contributing
Please create package folder

In the folder, please include a `README.md` and a `_TODO.md`. The README should be in the format of explaining the package and what the software is. The TODO should explain how an organization can take the recipe and add in the additional elements to convert it into a full fledged package.

NOTE: You are agreeing to release your contributions here under an Apache v2 license. 

Example structure:

~~~
visualstudio2017
 |
 | - visualstudio2017.nuspec
 | - README.md
 | - _TODO.md
 | - tools
 |  |
 |  | - chocolateyInstall.ps1
 |  | - chocolateyBeforeModify.ps1
 |  | - chocolateyUninstall.ps1
 |  | - LICENSE.txt (software license file)
~~~
