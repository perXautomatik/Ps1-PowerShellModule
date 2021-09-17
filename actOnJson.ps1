$jsonx = "D:\OneDrive\TabSessionManager - Backup\BookmarkCommanderExport.txt"

$json = [ordered]@{}

(Get-Content $jsonx -Raw | ConvertFrom-Json).PSObject.Properties |
    ForEach-Object { $json[$_.Name] = $_.Value }

$json.SyncRoot
$json.SyncRoot.children

