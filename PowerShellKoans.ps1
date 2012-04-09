<# 
    Powershell Koans by Arjan van Rijn 2012

    Kōans is a Zen Buddhism word meaning the enlightenment or awakening of a person, usually through a puzzle or riddle. Learn by Doing.
    In programming this mostly means implementing broken Unit tests, this file won't bore you with that. 
#>
Write-Error "Don't run this script file. Use the Powershell-ISE, RUN SELECTION (Just like in Sql Management Studio!)(F8 is the shortcut) to easily test commands" -ErrorAction Stop


<# 
    - In the beginnings Project Monad was renamed and released as Powershell 1.0 en and needed to be seperatly installed on Windows XP and Vista.  
    - Since windows 7 and server 2008R2, powershell is installed by default, you can start it from any windows pc     
    - Powershell comes as part of the operating system and updates are installed as a microsoft update (.msu intaller). So it's not a normal executable installer wizard
    - Some people use the Powershell nickname 'Posh' in unofficial projects 
    - PowerShell 2.0 is located in the same 1.0 folder as the 2.0 and 3.0 versions are. This is confusing #>

$PSHOME

<#
    - It's Designed by Jeffrey Snover, PowerShell Architect, Lead windows server, distinguished microsoft Engineer
    - A console should be black and uses the consolas font. Ok maybe the blue ain't that bad, but the font should be changed on all powershell instances you encounter.
    - The default Powershell console host works like the old Command prompt, which is bad. 
    - You can't do normal Windows style text selection and copying. No Dropdownlist style Code completion / intellisense. It's Hard to keep track of your command history
    - This scares away normal people, nobody wants to be a unix commandline hacker. The console looks useless which powershell is not.
    - Windows comes with a Intergrated Scripting Environment for powershell, the ISE
    - ISE works reasonably well for creating scripts in text files 
    - But also typing commands directly in the commandline, or interactive prompt, or immediate window, console, or call it anything you want.
    - The Powershell ISE has a nice run selection feature and better debugging options. 
    - Every Powershell Tab runs in it's own host, with it's own runspace, with it's own state. #>

$host             # you could try F8 with this line selected in the ISE
$host.Runspace

<#
    - The Windows PowerShell host ($Host) runtime can be embedded inside other applications, 
    - Like it does in the Visual studio Nuget Package manager console or Exchange 2007
    - On Windows Server 2008R2 the ISE is not installed by default, you can enable the ISE by adding it as a 'windows feature'
    - Or by using the following command in the PowerShell console (The console is installed by default) #>

Import-Module ServerManager; Add-WindowsFeature PowerShell-ISE  #only works on server 2008

<# 
    - There are 32 bit and 64 bit powershell hosts on a 64 bit operating system
    - 32 Bit versions of the console and ISE are using the X86 postfix in there shortcuts
    - Use the size of a pointer to find out if you are in a 32 bit or 64 bit host. 
    - It's sometimes really hard to find out if you don't know this trick and can cause you headaches.
    - [IntPtr]::Size returns 4 for 32 bit and 8 for 64bit hosts #>

[IntPtr]::Size

<#  - 32-bit PowerShell is located in a folder with 64 in the name 
    - 64-bit PowerShell is located in a folder with 32 in the name
    - The powershell home folder shows a different location in a 32 bit file explorer than in a 64 bit file explorer, which took me some time to find out #>

explorer.exe C:\Windows\SysWOW64\WindowsPowerShell\v1.0\
explorer.exe C:\Windows\System32\WindowsPowerShell\v1.0\
TOTALCMD.EXE C:\Windows\System32\WindowsPowerShell\v1.0\  # Works only with totalcommander added to your enviroment path, but you get the idea

<#  
    - Some modules / snappins only work on 64 bit or 32 bit 
    - The nuget package manager console is 32 bit, because visual studio is 32 bit
    - The sharepoint snappin only works in 64 bit. So you can't load the Sharepoint snappin into the Nuget console 
    - If you launch a powershell script from a 32 bit application, like a browser, it will and can only run in a 32 bit host #>

Add-PSSnapin Microsoft.SharePoint.PowerShell #only works with sharepoint installed on a 64 bit host

<#
    - PowerShell v3 is shipped with windows 8 and server 8 and is at the moment in beta. 
    - Has workflows with Workflow foundation 4, simplified foreach variables, better ISE, Webbrowser host, etc
    - Todo #>

<#  
    - Default ExecutionPolicy is restricted. So you can't run evil scripts #>

Get-ExecutionPolicy
Set-ExecutionPolicy 'RemoteSigned'
[Microsoft.PowerShell.ExecutionPolicy]::Restricted    

<#
    - Powershell uses commandlets, ea cmdlets 
    - Cmdlets are discoverable by there naming syntax (Verb-Noun)
    - Use powershell approved verbs only in your own commands. The verbs are found with Get-Verb cmdlet #>

Get-Verb

<# 
    - Powershell has Tab-Completion
    - TODO #>
Get-  

<#
    - If you want Pick a prefix for your company. let's say, 'Montfoort IT', a prefix could be 'Mnt', and your function name would be Get-MntLocation #>

function Get-MntLocation { Write-Host "Utrecht, the Netherlands" }

<# 
    - Providers are data stores addressable using unique paths.
    - The FileSystem is a provider, and provides acces to the files on your harddisk partitions #>

Get-PSProvider

<# 
    - Drives Are 'instances' of a provider
    - All your harddisk partitions have filesystem drive by default #>

Get-PsDrive
D:

<#
    - You can make your own drives #>
    
new-PSDrive -name font -PSProvider filesystem  -root(resolve-Path C:\Windows\Fonts\)

<# 
    - Your enviroment variable is exposed as a drive by default and is called env
    - Other default drives are for Registry, command Aliases, Gloabel functions, Public variables #>

dir env:
dir hkcu:,  

<#  - List all (global) functions functions which are in scope. #>
function Foo {"Hey dude !"}
dir function:

<#  - List all (global) variables which are in scope.
    - There are some default variables in every powrshell host
    - Your own variables are added as well #>

$bar = "No problem !"
dir variable:

<#
    - $PWD is a example of a default global variable and defines the 'Present Working Directory', which is convient and the same as the 'Get-Location' scriplet
    - '.' Represents the current location as well #>

Get-Location
explorer.exe .

<#
    - D: is a default global function with a definition of set-location c:, 
    - That's why 'font:' doesn't work by default for a drive and 'cd font:' does work  #>

cd font:
dir function:D:
function font: { Set-Location font: }

<#
    - cd is an alias for Set-Location
    - dir is an alias for Get-ChildItem 
    - And so is 'ls' (unix bash style) and 'gci'
    - A lot of familiar MS-DOS commands are Aliases, but are essiantly default powershell commands which operate on the Provider, That's why you can call 'dir env:'
    - dir, cd, copy, del, move, echo #>

Get-Alias dir
Get-Alias -Definition Get-ChildItem
Get-Alias

<#
    - Dir returns an array of .Net System.IO.FileInfo and DirectoryInfo objects  
    - An array has an interget indexer, which you can call with the square brackets
#>

dir
(dir).GetType()
(dir)[0].tostring()
(dir)[0].GetType()
(dir)[0].FullName

dir cert: -Recurse -CodeSigningCert

<#
    - Powershell cmdlets return fully typed .Net objects, which is a lot more than the text you see in the Hosts output panel
    - This is one of the reasons powershell is brilliant
    - The displaying of types is specified with formatters and view definitions which are located in format.ps1xml files. 
    - $pshome\FileSystem.format.ps1xml defines the table display for File and DirectoryInfo types
    - This is how the 'dir' ouput looks the same as in the old Command prompt
    - If no view definition is defined, Powershell calls the ToString() on the object to display it.
#>

psEdit $pshome\FileSystem.format.ps1xml 

<# 
    - $pwd returns a path info object and not a string 
    - Only the Path property returns a stirng
    - The ToString() methode is overridden to do the sam #>

$PWD.GetType()
$PWD.Path.GetType()
$PWD.tostring()

<#
    - Change something in your registry #>
Set-ItemProperty -path "HKLM:\Software\CompanyName\ApplicationName" -name "InstallLocation" -value "C:\Program Files\CompanyName"

#=========================================================

<#
    - All Powershell hosts load profile .ps1 files at host startup 
    - The location of the Profile is stored in $profile.
    - You can create seperated $profiles for each Powershell Host / All Users / Current User.
    - Reload the Profile by dot sourcing it, if you don't want to restart the host:  . $profile #>
    
notepad $profile
. $profile
psedit $profile.AllUsersAllHosts

