## Q:\Test\2018\06\09\SO_50777494.ps1
## the following RegEx usees a positive lookbehind and a
## capture group for the filename.

[RegEx]$Search = '(?<=#include ).*\/([^>]+)>'
$Replace = '"$1"'

ForEach ($File in (Get-ChildItem -Path '.\File*.cpp' -Recurse -File)) {
    (Get-Content $File) -Replace $Search,$Replace |
        Set-Content $File
}