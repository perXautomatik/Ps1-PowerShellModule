function presentJson ($object){
$json = [ordered]@{}

().PSObject.Properties |
    ForEach-Object { $json[$_.Name] = $_.Value }

$json.SyncRoot
}