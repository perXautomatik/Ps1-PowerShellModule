
#ps setHistorySavePath
set-PSReadlineOption -HistorySavePath "C:\Users\crbk01\AppData\Roaming\Microsoft\Windows\PowerShell\PSReadline\ConsoleHost_history.txt"

# vscode Portable Path
	#$path = [Environment]::GetEnvironmentVariable('PSModulePath', 'Machine')

$newpath = 'D:\portapps\6, Text,programming, x Editing\PortableApps\vscode-portable\vscode-portable.exe'
[Environment]::SetEnvironmentVariable("code", $newpath)

echo "paths set"