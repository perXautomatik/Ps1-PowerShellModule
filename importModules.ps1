Install-Module -Name PowerShellGet -Scope CurrentUser -AllowClobber -AllowPrerelease   -AcceptLicense -force -SkipPublisherCheck
$profileFolder = (split-path $profile -Parent)
$pos = join-path -Path $profileFolder -ChildPath 'sqlite.ps1'
 Import-Module $pos

# 引入 posh-git
find-module -name posh-git | install-module -Force ; Import-Module posh-git

# 引入 oh-my-posh
find-module -name oh-my-posh | install-module -Force ; Import-Module oh-my-posh
# 设置 PowerShell 主题
# Set-PoshPrompt ys
Set-PoshPrompt paradox


# 引入 ps-read-line
Import-Module PSReadLine


#Import-Module echoargs ; ps ecoArgs;

find-module -name Pscx | install-module ; Import-Module -name pscx
pscx history;

echo "modules imported"