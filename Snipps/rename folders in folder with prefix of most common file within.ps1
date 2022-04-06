param ( $from = "E:\Programming(projects)\programming and lessons\schoolProjects" )

    $dir = dir $from | ?{$_.PSISContainer}

foreach ($oldName in $dir){
    $oldName = $oldName.FullName
    $prefix = (Get-Childitem $oldName -Recurse -File  | where { -not $_.PSIsContainer } | group Extension -NoElement | sort count -desc | select name -First 1 ).Name
    
    Write-Host $prefix

    $newName = ($oldName | Split-Path -Leaf )
    $newName = "$prefix $newName"
    
    Rename-Item -Path $oldName -NewName $newName
}