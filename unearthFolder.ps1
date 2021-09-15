param(
[string]$InputPath
)

$src = $inputPath
$dest = $src | split-path
$num=1


Get-ChildItem -Path $src -Recurse | ForEach-Object {
    
    $item = $_
    $nextName = Join-Path -Path $dest -ChildPath $item.name

    while(Test-Path -Path $nextName)
    {
       $nextName = Join-Path $dest ($item.BaseName + "_$num" + $item.Extension)    
       $num+=1   
    }

$fullName = $item.FullName

if (!([system.io.directory]::Exists($dest))){
   [system.io.directory]::CreateDirectory($dest)
}
    Move-Item -path $fullName -Destination $nextName
}