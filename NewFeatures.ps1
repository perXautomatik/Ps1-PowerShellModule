#### Package Management: Chocolatey
#Chocolatey is a powerful package manager for Windows, working sort of like apt-get or homebrew. Let's get that first. Fire up CMD.exe as Administrator and run:
#@powershell -NoProfile -ExecutionPolicy Bypass -Command "iex ((new-object net.webclient).DownloadString('https://chocolatey.org/install.ps1'))" && SET PATH=%PATH%;%ALLUSERSPROFILE%\chocolatey\bin
# Once done, you can install packages by running `cinst` (short for `choco install`). Most packages below will be installed with Chocolatey.
###### Bonus: Use Windows 10 & OneGet
#Windows 10 comes with [OneGet](https://github.com/OneGet/oneget), a universal package manager that can use Chocolatey to find and install packages. To install, run:
Get-PackageProvider -name chocolatey
#Once done, you can look for all Chrome packages by typing `Find-Package -Name Chrome` or install it by typing `Install-Package -Name GoogleChrome`.

# Runs all .ps1 files in this module's directory
Get-ChildItem -Path $PSScriptRoot\*.ps1 | ? name -NotMatch 'Microsoft.PowerShell_profile' | Foreach-Object { . $_.FullName }
$env:path = @(
    $env:path
    'C:\Program Files (x86)\Notepad++\'
    'C:\Users\admin\AppData\Local\GitHub\PortableGit_c7e0cbde92ba565cb218a521411d0e854079a28c\cmd'
    'C:\Users\admin\AppData\Local\GitHub\PortableGit_c7e0cbde92ba565cb218a521411d0e854079a28c\usr\bin'
    'C:\Users\admin\AppData\Local\GitHub\PortableGit_c7e0cbde92ba565cb218a521411d0e854079a28c\usr\share\git-tfs'
    'C:\Users\admin\AppData\Local\Apps\2.0\C31EKMVW.15A\TWAQ6XY3.BAX\gith..tion_317444273a93ac29_0003.0000_328216539257acd4'
    'C:\Users\admin\AppData\Local\GitHub\lfs-amd64_1.1.0;C:\WINDOWS\Microsoft.NET\Framework\v4.0.30319'
) -join ';'
# http://blogs.msdn.com/b/powershell/archive/2006/06/24/644987.aspx
Update-TypeData "$PSScriptRoot\My.Types.Ps1xml"
# http://get-powershell.com/post/2008/06/25/Stuffing-the-output-of-the-last-command-into-an-automatic-variable.aspx
function Out-Default {
    if ($input.GetType().ToString() -ne 'System.Management.Automation.ErrorRecord') {
	try {
	    $input | Tee-Object -Variable global:lastobject | Microsoft.PowerShell.Core\Out-Default
	} catch {
	    $input | Microsoft.PowerShell.Core\Out-Default
	}
    } else {
	$input | Microsoft.PowerShell.Core\Out-Default
    }
}
function getjob { Get-Job | select id, name, state | ft -a }
function stopjob ($id = '*') { Get-Job $id | Stop-Job; gj }
function rmjob { Get-Job | ? state -match 'comp' | Remove-Job }
# https://community.spiceworks.com/topic/1570654-what-s-in-your-powershell-profile?page=1#entry-5746422
function Test-Administrator {
    $user = [Security.Principal.WindowsIdentity]::GetCurrent()
    (New-Object Security.Principal.WindowsPrincipal $user).IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)
}
function Start-PsElevatedSession {
    # Open a new elevated powershell window
    if (!(Test-Administrator)) {
	if ($host.Name -match 'ISE') {
	    start PowerShell_ISE.exe -Verb runas
	} else {
	    start powershell -Verb runas -ArgumentList $('-noexit ' + ($args | Out-String))
	}
    } else {
	Write-Warning 'Session is already elevated'
    }
}
Set-Alias -Name su -Value Start-PsElevatedSession

# http://www.lavinski.me/my-powershell-profile/
function Elevate-Process {
    $file, [string]$arguments = $args
    $psi = new-object System.Diagnostics.ProcessStartInfo $file
    $psi.Arguments = $arguments
    $psi.Verb = 'runas'

    $psi.WorkingDirectory = Get-Location
    [System.Diagnostics.Process]::Start($psi)
}
Set-Alias sudo Elevate-Process
# https://www.reddit.com/r/PowerShell/comments/49ahc1/what_are_your_cool_powershell_profile_scripts/
# http://kevinmarquette.blogspot.com/2015/11/here-is-my-custom-powershell-prompt.html
# https://www.reddit.com/r/PowerShell/comments/46hetc/powershell_profile_config/
$PSLogPath = ("{0}\Documents\WindowsPowerShell\log\{1:yyyyMMdd}-{2}.log" -f $env:USERPROFILE, (Get-Date), $PID)
if (!(Test-Path $(Split-Path $PSLogPath))) { md $(Split-Path $PSLogPath) }
Add-Content -Value "# $(Get-Date) $env:username $env:computername" -Path $PSLogPath
Add-Content -Value "# $(Get-Location)" -Path $PSLogPath
function prompt {
    # KevMar logging
    $LastCmd = Get-History -Count 1
    if ($LastCmd) {
	$lastId = $LastCmd.Id
	Add-Content -Value "# $($LastCmd.StartExecutionTime)" -Path $PSLogPath
	Add-Content -Value "$($LastCmd.CommandLine)" -Path $PSLogPath
	Add-Content -Value '' -Path $PSLogPath
	$howlongwasthat = $LastCmd.EndExecutionTime.Subtract($LastCmd.StartExecutionTime).TotalSeconds
    }
    # Kerazy_POSH propmt
    # Get Powershell version information
    $MajorVersion = $PSVersionTable.PSVersion.Major
    $MinorVersion = $PSVersionTable.PSVersion.Minor
    # Detect if the Shell is 32- or 64-bit host
    if ([System.IntPtr]::Size -eq 8) {
	$ShellBits = 'x64 (64-bit)'
    } elseif ([System.IntPtr]::Size -eq 4) {
	$ShellBits = 'x86 (32-bit)'
    }
    # Set Window Title to display Powershell version info, Shell bits, username and computername
    $host.UI.RawUI.WindowTitle = "PowerShell v$MajorVersion.$MinorVersion $ShellBits | $env:USERNAME@$env:USERDNSDOMAIN | $env:COMPUTERNAME | $env:LOGONSERVER"
    # Set Prompt Line 1 - include Date, file path location
    Write-Host(Get-Date -UFormat "%Y/%m/%d %H:%M:%S ($howlongwasthat) | ") -NoNewline -ForegroundColor DarkGreen
    Write-Host(Get-Location) -ForegroundColor DarkGreen
    # Set Prompt Line 2
    # Check for Administrator elevation
    if (Test-Administrator) {
	Write-Host '# ADMIN # ' -NoNewline -ForegroundColor Cyan
    } else {
	Write-Host '# User # ' -NoNewline -ForegroundColor DarkCyan
    }
    Write-Host '»' -NoNewLine -ForeGroundColor Green
    ' ' # need this space to avoid the default white PS>
}
# http://stackoverflow.com/questions/3097589/getting-my-public-ip-via-api
# https://www.reddit.com/r/PowerShell/comments/4parze/formattable_help/
function wimi {
    ((iwr http://www.realip.info/api/p/realip.php).content | ConvertFrom-Json).IP
}
<#
((iwr http://www.realip.info/api/p/realip.php).content | ConvertFrom-Json).IP
((iwr https://api.ipify.org/?format=json).content | ConvertFrom-Json).IP
(iwr http://ipv4bot.whatismyipaddress.com/).content
(iwr http://icanhazip.com/).content.trim()
(iwr http://ifconfig.me/ip).content.trim() # takes a long time
(iwr http://checkip.dyndns.org/).content -replace '[^\d.]+' # takes a long time
#>
#function Format-List {$input | Tee-Object -Variable global:lastformat | Microsoft.PowerShell.Utility\Format-List}
#function Format-Table {$input | Tee-Object -Variable global:lastformat | Microsoft.PowerShell.Utility\Format-Table}
#if ($LastFormat) {$global:lastobject=$LastFormat; $LastFormat=$Null}

<#
# sal stop stop-process
sal ss select-string
sal wh write-host
sal no New-Object
sal add Add-Member
#>