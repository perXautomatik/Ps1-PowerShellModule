# – Keith Jun 29 '11 at 20:59 
#JNK
#answered Jun 29 '11 at 20:34 @ https://stackoverflow.com/questions/6526441/comparing-folders-and-content-with-powershell


$Folder1 = $param[0]
$Folder2 = $param[1]
$Folder1 = $Folder1 | Get-ChildItem -Recurse 
$Folder2 = $Folder2 | Get-ChildItem -Recurse
Compare-Object  $Folder1 $Folder2 -verbos

| % {$_.psobject.properties}




 | Where-Object {$_.SideIndicator -eq "<="} 


ForEach-Object {
        Copy-Item "C:\Folder1\$($_.name)" -Destination "C:\Folder3" -Force
        }




Compare-Object $Folder1 $Folder2 -Property Name, Length | Where-Object {$_.SideIndicator -eq "=>"} | ForEach-Object {
        Copy-Item "$Folder2Path\$($_.name)" -Destination $Folder3 -Force
        }
