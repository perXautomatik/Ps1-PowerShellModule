$regKey ="HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\advanced"
$user = $env:username
$domain = $env:userdomain
Set-ItemProperty -Path $regKey -Name SeparateProcess -Value 1
net use \\$args\c$ /user:$domain\$user
explorer.exe \\$args\c$