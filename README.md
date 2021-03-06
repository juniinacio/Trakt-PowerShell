﻿## Trakt-PowerShell
PowerShell v3 interface for the [Trakt.TV](https://trakt.tv/) [API](http://docs.trakt.apiary.io/#).

### Prerequisites ###
In order to use this module you need to have PowerShell installed on your system, which you can download [here][download-powershell].

[download-powershell]: https://github.com/PowerShell/PowerShell

### New to PowerShell? ###
If you are new to PowerShell and would like to learn more, I recommend reviewing the [getting started][getting-started] documentation.

[getting-started]: https://github.com/PowerShell/PowerShell/tree/master/docs/learning-powershell

### Installation ###
1. Download or clone this repository on your desktop.
2. Copy the directory Trakt-PowerShell to one of the following directories:
  * $env:USERPROFILE\Documents\WindowsPowerShell\Modules
  * C:\Program Files\WindowsPowerShell\Modules
  * C:\Windows\system32\WindowsPowerShell\v1.0\Modules

*Notice: For a up to date list where you can copy the module directory, execute the following command at the Windows PowerShell command prompt:*
```powershell
$Env:PSMODULEPATH -Split ";"
```

### Getting started ###
To use the module you first need to import it in your current PowerShell session:
```powershell
Import-Module -Name Trakt-PowerShell
```
To view all cmdlets, enter:
```powershell
Get-Command -Module Trakt-PowerShell
```
