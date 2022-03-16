
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






#-------------------------------   Set Alias BEGIN    -------------------------------
set-alias -name reload-profile -value reloadProfile
set-alias -name uptime -value uptimef
New-Alias -name print-path -value printpath

New-Alias -name unzip -value unzipf


# 1. 编译函数 make
function MakeThings {
	nmake.exe $args -nologo
};
New-Alias -Name make -Value MakeThings

# 2. 更新系统 os-update
New-Alias -Name os-update -Value Update-Packages

# 3. 查看目录 ls & ll
function ListDirectory {
	(Get-ChildItem).Name
	Write-Host("")
};
#New-Alias -Name ls -Value ListDirectory
New-Alias -Name ll -Value Get-ChildItem

# 4. 打开当前工作目录
function OpenCurrentFolderF {
	param
	(
		# 输入要打开的路径
		# 用法示例：open C:\
		# 默认路径：当前工作文件夹
		$Path = '.'
	)
	Invoke-Item $Path
};
New-Alias -Name open-current-folder -Value OpenCurrentFolderF

# 5. 更改工作目录
function Change-Directory {
	param (
		# 输入要切换到的路径
		# 用法示例：cd C:/
		# 默认路径：D 盘的桌面
		$Path = 'D:\Users\newton\Desktop\'
	)
	Set-Location $Path
};

#######################################################
#New-Alias -Name cd -Value Change-Directory -Option AllScope

# filesInFolAsStream ;
New-Alias -Name filesinfolasstream -Value get-childitem | out-string -stream

#new ps OpenAsADmin
function openasadminf {
Start-Process powershell -Verb runAs
}
New-Alias -Name OpenAsADmin -Value openasadminf

Function EFunc {Search-Everything -PathExclude 'C:\users\Crbk01\AppData\Local\Temp'-Filter '<wholefilename:child:.git file:>|<wholefilename:child:.git folder:>' -global | Where{ $_ -notmatch 'C..9dfe73ef|OneDrive|GitHubDesktop.app|Microsoft VS Code._.resources.app|Installer.resources.app.node_modules|Microsoft.E dge.User Data.*.Extensions|Program Files.*.(Esri|MapInfo|ArcGIS)|Recycle.Bin' }}  ;
New-Alias -name EveryGitRepo -Value EFunc

Function EGSfunc {cd $_; Out-File -FilePath .\lazy.log -inputObject (git lazy 'AutoCommit' 2>&1 )} ;
New-Alias -name gitSilently -Value EGSfunc

Function EGSRfunc { out-null -InputObject( git remote -v | Tee-Object -Variable proc ) ; %{$proc -split '\n'} | %{ $properties = $_ -split '[\t\s]'; $remote = try{ New-Object PSObject -Property @{ name = $properties[0].Trim();  url = $properties[1].Trim();  type = $properties[2].Trim() } } catch {'noRemote'} ; $remote | select-object -first 1 | select url} } ;
New-Alias -name gitSingleRemote -Value EGSRfunc

#Git Ad $leaf as submodule from $remote and branch $branch
Function EFuncGT([string]$leaf,[string]$remote,[string]$branch){ git submodule add -f --name $leaf -- $remote $branch ; git commit -am $leaf+$remote+$branch } ;
New-Alias -name GitAdEPathAsSNB -value EFuncGT

Function EGLp($path,$message) { cd $path ; git add .; git commit -m $message ; git push } ;
New-Alias -name GitUp -value EGLp


function pull () { & get pull $args }
function checkout () { & git checkout $args }

#del alias:gc -Force
#del alias:gp -Force

#New-Alias -Name gc -Value checkout
#New-Alias -Name gp -Value pull


function bc($REMOTE,$LOCAL,$BASE,$MERGED) {
cmd /c "C:\Users\crbk01\Desktop\WhenOffline\BeondCompare4\BComp.exe" "$REMOTE" "$LOCAL" "$BASE" "$MERGED"
}
New-Alias -Name bcompare -Value bc

function viv {
vivaldi "vivaldi://flags"
}
New-Alias -Name browserflags -Value viv

function rb {
shutdown /r
}
New-Alias -Name reboot -Value rb

#-------------------------------    Set Alias END     -------------------------------



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


#-------------------------------   Set Network BEGIN    -------------------------------
# 1. 获取所有 Network Interface
function Get-AllNic {
	Get-NetAdapter | Sort-Object -Property MacAddress
}
New-Alias -Name getnic -Value Get-AllNic

# 2. 获取 IPv4 关键路由
function Get-IPv4Routes {
	Get-NetRoute -AddressFamily IPv4 | Where-Object -FilterScript {$_.NextHop -ne '0.0.0.0'}
}
New-Alias -Name getip -Value Get-IPv4Routes

# 3. 获取 IPv6 关键路由
function Get-IPv6Routes {
	Get-NetRoute -AddressFamily IPv6 | Where-Object -FilterScript {$_.NextHop -ne '::'}
}
New-Alias -Name getip6 -Value Get-IPv6Routes
#-------------------------------    Set Network END     -------------------------------
