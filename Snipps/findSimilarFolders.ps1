powershell breake down folder tree untill 
doughterfolder does not contain parrent file names, that is, unearth untill there would be name conflicts

get all folders children of path
go from tip leaf towards root
compare x/y with x

Get-ChildItem -Path $rootPath -Directory | ForEach-Object {
    # $_ now contains the folder with the date like '01-04-2018'
    # this is the folder where the .pdf files should go
 
    $targetFolder = $_.FullName
 
    Resolve-Path "$targetFolder\*" | ForEach-Object {
 
        # $_ here contains the fullname of the subfolder(s) within '01-04-2018'
 
        Move-Item -Path "$_\*.*" -Destination $targetFolder -Force
 
        # delete the now empty 'dayreports' folder
 
        Remove-Item -Path $_
    }
}



cd E: ; cd 'E:\SteamLibrary\steamapps\common\My Games\Blizzards\backup\ATMA_CONFIG\atma\10 08 30 ATMA_CONFIG\ATMA_CONFIG'
$files = Get-ChildItem -Directory
Get-ChildItem $files | Move-Item -Destination { $_.Directory.Parent.FullName }  -Verbose
