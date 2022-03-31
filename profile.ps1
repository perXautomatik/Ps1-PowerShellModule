#-------------------------------    Functions BEGIN   -------------------------------

#######################################################


# 1. 编译函数 make
function aliasMakeThings {
	nmake.exe $args -nologo
};


# 2. 更新系统 os-update

# 3. 查看目录 ls & ll
function aliasListDirectory {
	(Get-ChildItem).Name
	Write-Host("")
};


# 4. 打开当前工作目录
function aliasOpenCurrentFolderF {
	param
	(
		# 输入要打开的路径
		# 用法示例：open C:\
		# 默认路径：当前工作文件夹
		$Path = '.'
	)
	Invoke-Item $Path
};


# 5. 更改工作目录
function aliasChangeDirectory {
	param (
		# 输入要切换到的路径
		# 用法示例：cd C:/
		# 默认路径：D 盘的桌面
		$Path = 'D:\Users\newton\Desktop\'
	)
	Set-Location $Path
};

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


# filesInFolAsStream ;
function aliasfilesInFolAsStream {
	get-childitem | out-string -stream
}


#new ps OpenAsADmin
function aliasopenasadminf {
	Start-Process powershell -Verb runAs
}


Function aliasEFunc {Search-Everything -PathExclude 'C:\users\Crbk01\AppData\Local\Temp'-Filter '<wholefilename:child:.git file:>|<wholefilename:child:.git folder:>' -global | Where{ $_ -notmatch 'C..9dfe73ef|OneDrive|GitHubDesktop.app|Microsoft VS Code._.resources.app|Installer.resources.app.node_modules|Microsoft.E dge.User Data.*.Extensions|Program Files.*.(Esri|MapInfo|ArcGIS)|Recycle.Bin' }}  ;



Function aliasEGSfunc {cd $_; Out-File -FilePath .\lazy.log -inputObject (git lazy 'AutoCommit' 2>&1 )} ;



Function aliasEGSRfunc
{
	out-null -InputObject( git remote -v | Tee-Object -Variable proc ) ;
	 %{$proc -split '\n'} | %{ $properties = $_ -split '[\t\s]';
	  $remote = try{ New-Object PSObject -Property @{ name = $properties[0].Trim();
	    url = $properties[1].Trim();  type = $properties[2].Trim() } } catch {'noRemote'} ;
	     $remote | select-object -first 1 | select url}
	  } ;



function aliasFunctionEverything([string]$filter)
	{Search-Everything -filter $filter -global}

function aliasPshellHistoryPath {
	(Get-PSReadlineOption).HistorySavePath
}

function aliasPastDo($searchstring) {
$path = aliasPshellHistoryPath; menu @( get-content $path | where{ $_ -match $searchstring }) | %{Invoke-Expression $_ }
}

function aliasPastDoEdit($searchstring) {
$path = aliasPshellHistoryPath; menu @( get-content $path | where{ $_ -match $searchstring }) | %{ Set-Clipboard -Value $_ }
}


function aliasExecuteThis($searchstring) {
menu @(everything "ext:exe $searchString") | %{& $_ }
}


function aliasMyAliases {
Get-Alias -Definition alias* | select name
}




#Git Ad $leaf as submodule from $remote and branch $branch
Function aliasEFuncGT([string]$leaf,[string]$remote,[string]$branch)
{
 git submodule add -f --name $leaf -- $remote $branch ; git commit -am $leaf+$remote+$branch
 } ;


Function aliasEGLp($path,$message) { cd $path ; git add .; git commit -m $message ; git push } ;


function pull () { & get pull $args }
function checkout () { & git checkout $args }

#del alias:gc -Force
#del alias:gp -Force

function aliasbc($REMOTE,$LOCAL,$BASE,$MERGED) {
cmd /c "C:\Users\crbk01\Desktop\WhenOffline\BeondCompare4\BComp.exe" "$REMOTE" "$LOCAL" "$BASE" "$MERGED"
}

function aliasviv {
vivaldi "vivaldi://flags"
}


function aliasrb {
shutdown /r
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


function pstree {
	# https://gist.github.com/aroben/5542538
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

# Python 直接执行
#$env:PATHEXT += ";.py"

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


#-------------------------------   Set Network BEGIN    -------------------------------
# 1. 获取所有 Network Interface
function Get-AllNic {
	Get-NetAdapter | Sort-Object -Property MacAddress
}


# 2. 获取 IPv4 关键路由
function Get-IPv4Routes {
	Get-NetRoute -AddressFamily IPv4 | Where-Object -FilterScript {$_.NextHop -ne '0.0.0.0'}
}


# 3. 获取 IPv6 关键路由
function Get-IPv6Routes {
	Get-NetRoute -AddressFamily IPv6 | Where-Object -FilterScript {$_.NextHop -ne '::'}
}

#-------------------------------    Set Network END     -------------------------------

#-------------------------------    Functions END     -------------------------------


#-------------------------------   Set alias BEGIN    -------------------------------
set-alias -name reload-profile -value reloadProfile
set-alias -name uptime -value uptimef
set-alias -name print-path -value printpath

set-alias -name unzip -value unzipf    

set-alias -Name getip6 -Value Get-IPv6Routes      
set-alias -Name getip -Value Get-IPv4Routes
set-alias -Name getnic -Value Get-AllNic
set-alias -Name reboot -Value aliasrb
set-alias -Name browserflags -Value aliasviv
set-alias -Name bcompare -Value aliasbc

#set-alias -Name gc -Value checkout
#set-alias -Name gp -Value pull
set-alias -name GitUp -value aliasEGLp
set-alias -name GitAdEPathAsSNB -value aliasEFuncGT

set-alias -name MyAliases -value aliasMyAliases

set-alias -name executeThis -value aliasExecuteThis

set-alias -name pastDoEdit -value aliasPastDoEdit

set-alias -name pastDo -value aliasPastDo
set-alias -name pshelHistorypath -value aliasPshellHistoryPath

set-alias -name code -value '& $env:code'
set-alias -name gitSingleRemote -Value aliasEGSRfunc
set-alias -name gitSilently -Value aliasEGSfunc
set-alias -name EveryGitRepo -Value aliasEFunc

set-alias -Name OpenAsADmin -Value aliasopenasadminf
set-alias -Name filesinfolasstream -Value aliasfilesInFolAsStream
#set-alias -Name cd -Value aliasChangeDirectory -Option AllScope

set-alias -Name open-current-folder -Value aliasOpenCurrentFolderF
#set-alias -Name ls -Value aliasListDirectory
set-alias -Name ll -Value Get-ChildItem            
set-alias -Name make -Value aliasMakeThings
set-alias -Name os-update -Value Update-Packages

set-alias -name everything -value aliasFunctionEverything

echo "Alias set"
#-------------------------------    Set alias END     -------------------------------


