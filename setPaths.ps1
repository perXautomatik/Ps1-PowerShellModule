
#ps setHistorySavePath

# Load scripts from the following locations
#$env:Path += ";D:\SysAdmin\scripts\PowerShellBasics"
#$env:Path += ";D:\SysAdmin\scripts\Connectors"
#$env:Path += ";D:\SysAdmin\scripts\Office365"

$historyPath = "C:\Users\crbk01\AppData\Roaming\Microsoft\Windows\PowerShell\PSReadline\ConsoleHost_history.txt"
set-PSReadlineOption -HistorySavePath $historyPath
echo "historyPath: $historyPath"

$path = [Environment]::GetEnvironmentVariable('PSModulePath', 'Machine')

# vscode Portable Path
$path = [Environment]::GetEnvironmentVariable('PSModulePath', 'Machine')
$newpath = 'D:\portapps\6, Text,programming, x Editing\PortableApps\vscode-portable\vscode-portable.exe'
[Environment]::SetEnvironmentVariable("code", $newpath)

#sqlite dll
$workpath = "C:\Users\crbk01\AppData\Local\GMap.NET\DllCache\SQLite_v103_NET4_x64\System.Data.SQLite.DLL"
$homepath = (everything 'System.Data.SQLite.DLL' | select -first 1)
Add-Type -Path if(check-path $workpath){$workpath} else {$homepath}

### global variables
$whatPulseQuery = "select rightstr(path,instr(reverse(path),'/')-1) exe,path from (select max(path) path,max(cast(replace(version,'.','') as integer)) version from applications group by case when online_app_id = 0 then name else online_app_id end)"
$whatPulseDbPath = (Search-Everything -filter 'whatpulse.db' -global | select -first 1)
$datagripPath = 'D:\Users\crbk01\AppData\Roaming\JetBrains\DataGrip2021.1'
$datagripProjectPaths = "$datagripPath\projects"
$bComparePath = 'D:\PortableApps\2. fileOrganization\PortableApps\Beyond Compare 4'

echo "paths set"