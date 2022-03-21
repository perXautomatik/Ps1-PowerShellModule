<#
 * FileName: Microsoft.PowerShell_profile.ps1
 * Author: perXautomatik
 * Email: christoffer.broback@gmail.com
 * Date: 08/03/2022
 * Copyright: No copyright. You can use this code for anything with no warranty.
#>

#loadMessage
echo 'Microsoft.PowerShell_profile.ps1'

# Increase history
$MaximumHistoryCount = 10000

#------------------------------- Import Modules BEGIN -------------------------------
# ?? posh-git
Import-Module posh-git

# ?? oh-my-posh
Import-Module oh-my-posh

# ?? ps-read-line
Import-Module PSReadLine

# ?? PowerShell ??
 Set-PoshPrompt ys
Set-PoshPrompt paradox
#ps ecoArgs;
Import-Module echoargs ;
#pscx history;
Install-Module -Name Pscx
Import-Module -name pscx
#------------------------------- Import Modules END   -------------------------------


# Produce UTF-8 by default
$PSDefaultParameterValues['Out-File:Encoding']='utf8'

# Show selection menu for tab
Set-PSReadlineKeyHandler -Chord Tab -Function MenuComplete

#ps ExecutionPolicy;
#Set-ExecutionPolicy -ExecutionPolicy RemoteSigned

#https://stackoverflow.com/questions/47356782/powershell-capture-git-output
#Then stderr should be redirected to stdout.
#set GIT_REDIRECT_STDERR=2>&1

#------------------------------- Set Paths           -------------------------------

#ps setHistorySavePath
$historyPath = 'C:\Users\Användaren\AppData\Roaming\Microsoft\Windows\PowerShell\PSReadline\ConsoleHost_history.txt'
set-PSReadlineOption -HistorySavePath $historyPath
echo "historyPath: $historyPath"

# vscode Portable Path
#$path = [Environment]::GetEnvironmentVariable('PSModulePath', 'Machine')
$newpath = 'D:\portapps\6, Text,programming, x Editing\PortableApps\vscode-portable\vscode-portable.exe'
[Environment]::SetEnvironmentVariable('code', $newpath)

#------------------------------- Set Paths  end       -------------------------------
#-------------------------------  Set Hot-keys BEGIN  -------------------------------
# ?????????????
#Set-PSReadLineOption -PredictionSource History

# ????????,???????????
Set-PSReadLineOption -HistorySearchCursorMovesToEnd

# ?? Tab ?????? Intellisense
Set-PSReadLineKeyHandler -Key 'Tab' -Function MenuComplete

# ?? Ctrl+d ??? PowerShell
Set-PSReadlineKeyHandler -Key 'Ctrl+d' -Function ViExit

# ?? Ctrl+z ???
Set-PSReadLineKeyHandler -Key 'Ctrl+z' -Function Undo

# ??????????????
# ??????????????
# Autocompletion for arrow keys @ https://dev.to/ofhouse/add-a-bash-like-autocomplete-to-your-powershell-4257
Set-PSReadLineKeyHandler -Key UpArrow -Function HistorySearchBackward
Set-PSReadLineKeyHandler -Key DownArrow -Function HistorySearchForward
#-------------------------------  Set Hot-keys END    -------------------------------
# Helper Functions
#######################################################

function uptimef {
	Get-WmiObject win32_operatingsystem | select csname, @{LABEL='LastBootUpTime';
	EXPRESSION={$_.ConverttoDateTime($_.lastbootuptime)}}
}

function reloadProfile {
	& $profile
}

function find-file($name) {
	ls -recurse -filter '*${name}*' -ErrorAction SilentlyContinue | foreach {
		$place_path = $_.directory
		echo '${place_path}\${_}'
	}
}

function printpath {
	($Env:Path).Split(';')
}


function unzipf ($file) {
	$dirname = (Get-Item $file).Basename
	echo 'Extracting, $file, to, $dirname'
	New-Item -Force -ItemType directory -Path $dirname
	expand-archive $file -OutputPath $dirname -ShowProgress
}
#------------------------------- SystemMigration      -------------------------------

#choco check if installed
#path to list of aps to install
#choco ask to install if not present

#list of portable apps,download source
#path
#download and extract if not present, ask to confirm

#path to portable apps
#path to standard download location


#git Repos paths and origions,
#git systemwide profile folder
#git global path

#everything data folder
#autohotkey script to run on startup

#startup programs

#reg to add if not present

#------------------------------- SystemMigration end  -------------------------------


#-------------------------------  Set Hot-keys BEGIN  -------------------------------
# ?????????????
#Set-PSReadLineOption -PredictionSource History

# ????????,???????????
Set-PSReadLineOption -HistorySearchCursorMovesToEnd

# ?? Tab ?????? Intellisense
Set-PSReadLineKeyHandler -Key 'Tab' -Function MenuComplete

# ?? Ctrl+d ??? PowerShell
Set-PSReadlineKeyHandler -Key 'Ctrl+d' -Function ViExit

# ?? Ctrl+z ???
Set-PSReadLineKeyHandler -Key 'Ctrl+z' -Function Undo

# ??????????????
Set-PSReadLineKeyHandler -Key UpArrow -Function HistorySearchBackward

# ??????????????
Set-PSReadLineKeyHandler -Key DownArrow -Function HistorySearchForward
#-------------------------------  Set Hot-keys END    -------------------------------

#change selection to neongreen
#https://stackoverflow.com/questions/44758698/change-powershell-psreadline-menucomplete-functions-colors
$colors = @{
   'Selection' = '$([char]0x1b)[38;2;0;0;0;48;2;178;255;102m'
}

#Set-PSReadLineOption -Colors $colors
# Helper Functions
#######################################################

function uptime {
	Get-WmiObject win32_operatingsystem | select csname, @{LABEL='LastBootUpTime';
	EXPRESSION={$_.ConverttoDateTime($_.lastbootuptime)}}
}

function reload-profile {
	& $profile
}

function find-file($name) {
	ls -recurse -filter '*${name}*' -ErrorAction SilentlyContinue | foreach {
		$place_path = $_.directory
		echo '${place_path}\${_}'
	}
}

function print-path {
	($Env:Path).Split(';')
}

function unzip ($file) {
	$dirname = (Get-Item $file).Basename
	echo('Extracting', $file, 'to', $dirname)
	New-Item -Force -ItemType directory -Path $dirname
	expand-archive $file -OutputPath $dirname -ShowProgress
}







# Chocolatey profile
$ChocolateyProfile = '$env:ChocolateyInstall\helpers\chocolateyProfile.psm1'
if (Test-Path($ChocolateyProfile)) {
  Import-Module '$ChocolateyProfile'
}
