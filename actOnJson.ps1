cd (Split-Path -Path $MyInvocation.MyCommand.Definition -Parent)
. .\getChildrenRecursive.ps1
. .\presentJson.ps1

$jsonx = "D:\OneDrive\TabSessionManager - Backup\BookmarkCommanderExport.txt"
$jsonx = Get-Content $jsonx -Raw | ConvertFrom-Json

$presentationMethodPath = (Join-Path -Path (Split-Path -Path $MyInvocation.MyCommand.Definition -Parent) -ChildPath "presentJson.ps1" )


getChildrenRecursive $jsonx $presentationMethodPath


