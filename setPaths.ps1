
#ps setHistorySavePath
if (-not $env:XDG_CONFIG_HOME) { $env:XDG_CONFIG_HOME = Join-Path -Path "$HOME" -ChildPath ".config" }; $XDG_CONFIG_HOME = $env:XDG_CONFIG_HOME
if (-not $env:XDG_DATA_HOME) { $env:XDG_DATA_HOME = Join-Path -Path "$HOME" -ChildPath ".local/share" }; $XDG_DATA_HOME = $env:XDG_DATA_HOME
if (-not $env:XDG_CACHE_HOME) { $env:XDG_CACHE_HOME = Join-Path -Path "$HOME" -ChildPath ".cache" }; $XDG_CACHE_HOME = $env:XDG_CACHE_HOME

if (-not $env:DESKTOP_DIR) { $env:DESKTOP_DIR = Join-Path -Path "$HOME" -ChildPath "desktop" }; $DESKTOP_DIR = $env:DESKTOP_DIR

if (-not $env:NOTES_DIR) { $env:NOTES_DIR = Join-Path -Path "$HOME" -ChildPath "notes" }; $NOTES_DIR = $env:NOTES_DIR
if (-not $env:CHEATS_DIR) { $env:CHEATS_DIR = Join-Path -Path "$env:NOTES_DIR" -ChildPath "cheatsheets" }; $CHEATS_DIR = $env:CHEATS_DIR
if (-not $env:TODO_DIR) { $env:TODO_DIR = Join-Path -Path "$env:NOTES_DIR" -ChildPath "_ToDo" }; $TODO_DIR = $env:TODO_DIR

if (-not $env:DEVEL_DIR) { $env:DEVEL_DIR = Join-Path -Path "$HOME" -ChildPath "devel" }; $DEVEL_DIR = $env:DEVEL_DIR
if (-not $env:PORTS_DIR) { $env:PORTS_DIR = Join-Path -Path "$HOME" -ChildPath "ports" }; $PORTS_DIR = $env:PORTS_DIR

# Load scripts from the following locations   

$profileFolder = (split-path $profile -Parent)
$EnvPath = join-path -Path $profileFolder -ChildPath 'Snipps'
echo "EnvPath: $EnvPath"

#$env:Path += ";$EnvPath"

$historyPath = "C:\Users\crbk01\AppData\Roaming\Microsoft\Windows\PowerShell\PSReadline\ConsoleHost_history.txt"
set-PSReadlineOption -HistorySavePath $historyPath
echo "historyPath: $historyPath"

$path = [Environment]::GetEnvironmentVariable('PSModulePath', 'Machine')

# vscode Portable Path
$vscodepath = 'D:\portapps\6, Text,programming, x Editing\PortableApps\vscode-portable\vscode-portable.exe'
[Environment]::SetEnvironmentVariable("code", $vscodepath)

#sqlite dll
$workpath = "C:\Users\crbk01\AppData\Local\GMap.NET\DllCache\SQLite_v103_NET4_x64\System.Data.SQLite.DLL"  ; 
$alternative = (everything 'System.Data.SQLite.DLL' | select -first 1) ;
 $p = if(check-path $workpath){$workpath} else {$alternative} ;
Add-Type -Path $p

### global variables
$whatPulseQuery = "select rightstr(path,instr(reverse(path),'/')-1) exe,path from (select max(path) path,max(cast(replace(version,'.','') as integer)) version from applications group by case when online_app_id = 0 then name else online_app_id end)"
$whatPulseDbPath = (Search-Everything -filter 'whatpulse.db' -global | select -first 1)
$datagripPath = 'D:\Users\crbk01\AppData\Roaming\JetBrains\DataGrip2021.1'
$datagripProjectPaths = "$datagripPath\projects"
$bComparePath = 'D:\PortableApps\2. fileOrganization\PortableApps\Beyond Compare 4'

echo "paths set"