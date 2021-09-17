function presentJson ($object){
$json = [ordered]@{}

($object).PSObject.Properties |
    ForEach-Object { $json[$_.Name] = $_.Value }

write-Host  $json.SyncRoot
}