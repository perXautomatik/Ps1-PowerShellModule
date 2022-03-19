<#
 * FileName: Microsoft.PowerShell_profile.ps1
 * Author: perXautomatik
 * Email: christoffer.broback@gmail.com
 * Date: 08/03/2022
 * Copyright: No copyright. You can use this code for anything with no warranty.
#>

# Increase history
$MaximumHistoryCount = 10000

#------------------------------- Import Modules BEGIN -------------------------------
# 引入 posh-git
Import-Module posh-git

# 引入 oh-my-posh
#Import-Module oh-my-posh

# 引入 ps-read-line
Import-Module PSReadLine

# 设置 PowerShell 主题
# Set-PoshPrompt ys
#Set-PoshPrompt paradox
#ps ecoArgs;
Import-Module echoargs ;
#pscx history;
Install-Module -Name Pscx
Import-Module -name pscx
#------------------------------- Import Modules END   -------------------------------


# Produce UTF-8 by default
$PSDefaultParameterValues["Out-File:Encoding"]="utf8"

# Show selection menu for tab
Set-PSReadlineKeyHandler -Chord Tab -Function MenuComplete

#ps ExecutionPolicy;
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned

#https://stackoverflow.com/questions/47356782/powershell-capture-git-output
#Then stderr should be redirected to stdout.
set GIT_REDIRECT_STDERR=2>&1

#------------------------------- Set Paths           -------------------------------

#ps setHistorySavePath
set-PSReadlineOption -HistorySavePath "D:\AppData\Roaming\Microsoft\Windows\PowerShell\PSReadline\ConsoleHost_history.txt"

#------------------------------- Set Paths  end       -------------------------------

#------------------------------- SystemMigration      -------------------------------

#choco check if installed
#path to list of aps to install
#choco ask to install if not present

#list of portable apps,download source
#path
#download and extract if not present, ask to confirm

#path to portable apps
#path to standard download location


#git Repos paths and origions,
#git systemwide profile folder
#git global path

#everything data folder
#autohotkey script to run on startup

#startup programs

#reg to add if not present

#------------------------------- SystemMigration end  -------------------------------



#-------------------------------  Set Hot-keys BEGIN  -------------------------------
# 设置预测文本来源为历史记录
#Set-PSReadLineOption -PredictionSource History

# 每次回溯输入历史，光标定位于输入内容末尾
Set-PSReadLineOption -HistorySearchCursorMovesToEnd

# 设置 Tab 为菜单补全和 Intellisense
Set-PSReadLineKeyHandler -Key "Tab" -Function MenuComplete

# 设置 Ctrl+d 为退出 PowerShell
Set-PSReadlineKeyHandler -Key "Ctrl+d" -Function ViExit

# 设置 Ctrl+z 为撤销
Set-PSReadLineKeyHandler -Key "Ctrl+z" -Function Undo

# 设置向上键为后向搜索历史记录
Set-PSReadLineKeyHandler -Key UpArrow -Function HistorySearchBackward

# 设置向下键为前向搜索历史纪录
Set-PSReadLineKeyHandler -Key DownArrow -Function HistorySearchForward
#-------------------------------  Set Hot-keys END    -------------------------------

# Helper Functions
#######################################################

function uptime {
	Get-WmiObject win32_operatingsystem | select csname, @{LABEL='LastBootUpTime';
	EXPRESSION={$_.ConverttoDateTime($_.lastbootuptime)}}
}

function reload-profile {
	& $profile
}

function find-file($name) {
	ls -recurse -filter "*${name}*" -ErrorAction SilentlyContinue | foreach {
		$place_path = $_.directory
		echo "${place_path}\${_}"
	}
}

function print-path {
	($Env:Path).Split(";")
}

function unzip ($file) {
	$dirname = (Get-Item $file).Basename
	echo("Extracting", $file, "to", $dirname)
	New-Item -Force -ItemType directory -Path $dirname
	expand-archive $file -OutputPath $dirname -ShowProgress
}


# Unixlike commands
#######################################################

function df {
	get-volume
}

function sed($file, $find, $replace){
	(Get-Content $file).replace("$find", $replace) | Set-Content $file
}

function sed-recursive($filePattern, $find, $replace) {
	$files = ls . "$filePattern" -rec
	foreach ($file in $files) {
		(Get-Content $file.PSPath) |
		Foreach-Object { $_ -replace "$find", "$replace" } |
		Set-Content $file.PSPath
	}
}

function grep($regex, $dir) {
	if ( $dir ) {
		ls $dir | select-string $regex
		return
	}
	$input | select-string $regex
}

function grepv($regex) {
	$input | ? { !$_.Contains($regex) }
}

function which($name) {
	Get-Command $name | Select-Object -ExpandProperty Definition
}

function export($name, $value) {
	set-item -force -path "env:$name" -value $value;
}

function pkill($name) {
	ps $name -ErrorAction SilentlyContinue | kill
}

function pgrep($name) {
	ps $name
}

function touch($file) {
	"" | Out-File $file -Encoding ASCII
}

function sudo {
	$file, [string]$arguments = $args;
	$psi = new-object System.Diagnostics.ProcessStartInfo $file;
	$psi.Arguments = $arguments;
	$psi.Verb = "runas";
	$psi.WorkingDirectory = get-location;
	[System.Diagnostics.Process]::Start($psi) >> $null
}

# https://gist.github.com/aroben/5542538
function pstree {
	$ProcessesById = @{}
	foreach ($Process in (Get-WMIObject -Class Win32_Process)) {
		$ProcessesById[$Process.ProcessId] = $Process
	}

	$ProcessesWithoutParents = @()
	$ProcessesByParent = @{}
	foreach ($Pair in $ProcessesById.GetEnumerator()) {
		$Process = $Pair.Value

		if (($Process.ParentProcessId -eq 0) -or !$ProcessesById.ContainsKey($Process.ParentProcessId)) {
			$ProcessesWithoutParents += $Process
			continue
		}

		if (!$ProcessesByParent.ContainsKey($Process.ParentProcessId)) {
			$ProcessesByParent[$Process.ParentProcessId] = @()
		}
		$Siblings = $ProcessesByParent[$Process.ParentProcessId]
		$Siblings += $Process
		$ProcessesByParent[$Process.ParentProcessId] = $Siblings
	}

	function Show-ProcessTree([UInt32]$ProcessId, $IndentLevel) {
		$Process = $ProcessesById[$ProcessId]
		$Indent = " " * $IndentLevel
		if ($Process.CommandLine) {
			$Description = $Process.CommandLine
		} else {
			$Description = $Process.Caption
		}

		Write-Output ("{0,6}{1} {2}" -f $Process.ProcessId, $Indent, $Description)
		foreach ($Child in ($ProcessesByParent[$ProcessId] | Sort-Object CreationDate)) {
			Show-ProcessTree $Child.ProcessId ($IndentLevel + 4)
		}
	}

	Write-Output ("{0,6} {1}" -f "PID", "Command Line")
	Write-Output ("{0,6} {1}" -f "---", "------------")

	foreach ($Process in ($ProcessesWithoutParents | Sort-Object CreationDate)) {
		Show-ProcessTree $Process.ProcessId 0
	}
}


#-------------------------------    Functions BEGIN   -------------------------------
# Python 直接执行
$env:PATHEXT += ";.py"

# 更新系统组件
function Update-Packages {
	# update pip
	# Write-Host "Step 1: 更新 pip" -ForegroundColor Magenta -BackgroundColor Cyan
	# $a = pip list --outdated
	# $num_package = $a.Length - 2
	# for ($i = 0; $i -lt $num_package; $i++) {
	# 	$tmp = ($a[2 + $i].Split(" "))[0]
	# 	pip install -U $tmp
	# }

	# update conda
	Write-Host "Step 1: 更新 Anaconda base 虚拟环境" -ForegroundColor Magenta -BackgroundColor Cyan
	conda activate base
	conda upgrade python

	# update TeX Live
	$CurrentYear = Get-Date -Format yyyy
	Write-Host "Step 2: 更新 TeX Live" $CurrentYear -ForegroundColor Magenta -BackgroundColor Cyan
	tlmgr update --self
	tlmgr update --all

	# update Chocolotey
	# Write-Host "Step 3: 更新 Chocolatey" -ForegroundColor Magenta -BackgroundColor Cyan
	# choco outdated

	# update Apps using winget
	Write-Host "Step 3: 通过 winget 更新 Windows 应用程序" -ForegroundColor Magenta -BackgroundColor Cyan
	winget upgrade
	winget upgrade --all

}
#-------------------------------    Functions END     -------------------------------






#-------------------------------   Set Alias BEGIN    -------------------------------
# 1. 编译函数 make
function MakeThings {
	nmake.exe $args -nologo
}
Set-Alias -Name make -Value MakeThings

# 2. 更新系统 os-update
Set-Alias -Name os-update -Value Update-Packages

# 3. 查看目录 ls & ll
function ListDirectory {
	(Get-ChildItem).Name
	Write-Host("")
}
#Set-Alias -Name ls -Value ListDirectory
Set-Alias -Name ll -Value Get-ChildItem

# 4. 打开当前工作目录
function OpenCurrentFolder {
	param
	(
		# 输入要打开的路径
		# 用法示例：open C:\
		# 默认路径：当前工作文件夹
		$Path = '.'
	)
	Invoke-Item $Path
}
Set-Alias -Name open -Value OpenCurrentFolder

# 5. 更改工作目录
function Change-Directory {
	param (
		# 输入要切换到的路径
		# 用法示例：cd C:/
		# 默认路径：D 盘的桌面
		$Path = 'D:\Users\newton\Desktop\'
	)
	Set-Location $Path
}
Set-Alias -Name cd -Value Change-Directory -Option AllScope
#-------------------------------    Set Alias END     -------------------------------



#######################################################

function pull () { & get pull $args }
function checkout () { & git checkout $args }

del alias:gc -Force
del alias:gp -Force

Set-Alias -Name gc -Value checkout
Set-Alias -Name gp -Value pull

del alias:bcompare -Force
Set-Alias -Name bcompare -Value "C:\\Users\\crbk01\\Desktop\\WhenOffline\\BeondCompare4\\BComp.exe\" \"$REMOTE\" \"$LOCAL\" \"$BASE\" \"$MERGED\"
del alias:browserflags -Force
Set-Alias -Name browserflags -Value vivaldi "vivaldi://flags"
del alias:reboot -Force
set-Alias -Name reboot -Value shutdown /r
#-------------------------------   Set Network BEGIN    -------------------------------
# 1. 获取所有 Network Interface
function Get-AllNic {
	Get-NetAdapter | Sort-Object -Property MacAddress
}
Set-Alias -Name getnic -Value Get-AllNic

# 2. 获取 IPv4 关键路由
function Get-IPv4Routes {
	Get-NetRoute -AddressFamily IPv4 | Where-Object -FilterScript {$_.NextHop -ne '0.0.0.0'}
}
Set-Alias -Name getip -Value Get-IPv4Routes

# 3. 获取 IPv6 关键路由
function Get-IPv6Routes {
	Get-NetRoute -AddressFamily IPv6 | Where-Object -FilterScript {$_.NextHop -ne '::'}
}
Set-Alias -Name getip6 -Value Get-IPv6Routes
#-------------------------------    Set Network END     -------------------------------

# Chocolatey profile
$ChocolateyProfile = "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
if (Test-Path($ChocolateyProfile)) {
  Import-Module "$ChocolateyProfile"
}
