<#
 * FileName: Microsoft.PowerShell_profile.ps1
 * Author: perXautomatik
 * Email: christoffer.broback@gmail.com
 * Date: 08/03/2022
 * Copyright: No copyright. You can use this code for anything with no warranty.
#>

#loadMessage
echo "Microsoft.PowerShell_profile.ps1"

# Increase history
$MaximumHistoryCount = 10000


#src: https://stackoverflow.com/a/34098997/7595318
function Test-IsInteractive {
    # Test each Arg for match of abbreviated '-NonInteractive' command.
    $NonInteractiveFlag = [Environment]::GetCommandLineArgs() | Where-Object{ $_ -like '-NonInteractive' }
    if ( (-not [Environment]::UserInteractive) -or ( $NonInteractiveFlag -ne $null ) ) {
        return $false
    }
    return $true
}

#if ( Test-IsInteractive )  { 	(preferably use -noLogo) } # Clear-Host # remove advertisements 


function Download-Latest-Profile {
    New-Item $( Split-Path $($PROFILE.CurrentUserCurrentHost) ) -ItemType Directory -ea 0
    if ( $(Get-Content "$($PROFILE.CurrentUserCurrentHost)" | Select-String "62a71500a0f044477698da71634ab87b" | Out-String) -eq "" ) {
        Move-Item -Path "$($PROFILE.CurrentUserCurrentHost)" -Destination "$($PROFILE.CurrentUserCurrentHost).bak"
    }
    Invoke-WebRequest -Uri "https://gist.githubusercontent.com/apfelchips/62a71500a0f044477698da71634ab87b/raw/Profile.ps1" -OutFile "$($PROFILE.CurrentUserCurrentHost)"
    Reload-Profile
}

# Produce UTF-8 by default

if ( $PSVersionTable.PSVersion.Major -lt 7 ) {
	# https://docs.microsoft.com/en-us/powershell/scripting/gallery/installing-psget
	
	$PSDefaultParameterValues['Out-File:Encoding'] = 'utf8' # Fix Encoding for PS 5.1 https://stackoverflow.com/a/40098904
}	

#------------------------------- Set Paths           -------------------------------

$paths = join-path -Path (split-path $profile -Parent)  -ChildPath 'setPaths.ps1'

Import-Module  $paths
#------------------------------- Set Paths  end       -------------------------------

#------------------------------- Import Modules BEGIN -------------------------------

$profileFolder = (split-path $profile -Parent)
$pos = join-path -Path $profileFolder -ChildPath 'importModules.ps1'
 Import-Module $pos
#------------------------------- Import Modules END   -------------------------------


#------------------------------- overloading begin

#https://www.sapien.com/blog/2014/10/21/a-better-tostring-method-for-hash-tables/

#better hashtable ToString method
  Update-TypeData -TypeName "System.Collections.HashTable"   `
  -MemberType ScriptMethod `
  -MemberName "ToString" -Value { $hashstr = "@{"; $keys = $this.keys; foreach ($key in $keys) { $v = $this[$key];
	     if ($key -match "\s") { $hashstr += "`"$key`"" + "=" + "`"$v`"" + ";" }
	     else { $hashstr += $key + "=" + "`"$v`"" + ";" } }; $hashstr += "}";
	     return $hashstr }
#-------------------------------  overloading end

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

#------------------------------- Styling begin --------------------------------------					      
#change selection to neongreen
#https://stackoverflow.com/questions/44758698/change-powershell-psreadline-menucomplete-functions-colors
$colors = @{
   "Selection" = "$([char]0x1b)[38;2;0;0;0;48;2;178;255;102m"
}
Set-PSReadLineOption -Colors $colors

# Style default PowerShell Console
$shell = $Host.UI.RawUI

$shell.WindowTitle= "PS"

$shell.BackgroundColor = "Black"
$shell.ForegroundColor = "White"

# Load custom theme for Windows Terminal
#Set-Theme LazyAdmin
