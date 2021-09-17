cd (Split-Path -Path $MyInvocation.MyCommand.Definition -Parent)
. .\getChildrenRecursive.ps1
. .\presentJson.ps1

$jsonx = "D:\OneDrive\TabSessionManager - Backup\tablerone_backup_with_thumbs_2021-04-19-09-33-16.txt"
$jsonx = Get-Content $jsonx -Raw | ConvertFrom-Json

$presentationMethodPath = (Join-Path -Path (Split-Path -Path $MyInvocation.MyCommand.Definition -Parent) -ChildPath "presentJson.ps1" )


getChildrenRecursive $jsonx $presentationMethodPath

