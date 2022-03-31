#-------------------------------    Functions BEGIN   -------------------------------

#######################################################


	
	#todo: breakout
	function sudo {

	}
	
	#todo: breakout
	function pstree {

	}
	
	#todo: breakout
	function Update-Packages {

	
}

Function aliasEFunc {
}  ;

#todo: breakout
function Show-ProcessTree{

}

function unzip{

}

	
# todo: breake out to file
function sed-recursive{

}


#del alias:gc -Force
#del alias:gp -Force


function aliasbc($REMOTE,$LOCAL,$BASE,$MERGED) { cmd /c "C:\Users\crbk01\Desktop\WhenOffline\BeondCompare4\BComp.exe" "$REMOTE" "$LOCAL" "$BASE" "$MERGED" } #todo: replace hardcode with global variable pointing to path

function aliasChangeDirectory { param ( $Path = '%USERPROFILE%\Desktop\' ) Set-Location $Path }; #if no param, navigate to desktop # 5. 更改工作目录 # 输入要切换到的路径 # 用法示例：cd C:/ # 默认路径：D 盘的桌面

Function aliasEFuncGT([string]$leaf,[string]$remote,[string]$branch) { git submodule add -f --name $leaf -- $remote $branch ; git commit -am $leaf+$remote+$branch } ; #todo: move to git aliases #Git Ad $leaf as submodule from $remote and branch $branch

Function aliasEGLp($path,$message) { cd $path ; git add .; git commit -m $message ; git push } ; #todo: move to git aliases

Function aliasEGSfunc {cd $_; Out-File -FilePath .\lazy.log -inputObject (git lazy 'AutoCommit' 2>&1 )} ; #todo: parameterize #todo: rename to more descriptive #todo: breakout

function aliasExecuteThis($searchstring) { menu @(everything "ext:exe $searchString") | %{& $_ } } #use whatpulse db first, then everything #todo: sort by rescent use #use everything to find executable for fast execution

function aliasfilesInFolAsStream { get-childitem | out-string -stream } # filesInFolAsStream ;

function aliasFunctionEverything([string]$filter) {Search-Everything -filter $filter -global}

function aliasListDirectory { (Get-ChildItem).Name ; Write-Host("") }; # 3. 查看目录 ls & ll

function aliasMakeThings { nmake.exe $args -nologo }; # 1. 编译函数 make

function aliasMyAliases { Get-Alias -Definition alias* | select name }

function aliasopenasadminf { Start-Process powershell -Verb runAs } #new ps OpenAsADmin

function aliasOpenCurrentFolderF { param ( $Path = '.' ) Invoke-Item $Path }; # 4. 打开当前工作目录 # 输入要打开的路径 # 用法示例：open C:\ # 默认路径：当前工作文件夹

function aliasPastDo($searchstring) { $path = aliasPshellHistoryPath; menu @( get-content $path | where{ $_ -match $searchstring }) | %{Invoke-Expression $_ } } #search history of past expressions and invokes it, doesn't register the expression itself in history, but the pastDo expression.

function aliasPastDoEdit($searchstring) { $path = aliasPshellHistoryPath; menu @( get-content $path | where{ $_ -match $searchstring }) | %{ Set-Clipboard -Value $_ }} #search history of past expressions and adds to clipboard

function aliasPshellHistoryPath { (Get-PSReadlineOption).HistorySavePath }

function aliasrb { shutdown /r } #reboot

function aliasreloadprofile { & $profile } #reload-profile is an unapproved verb.

function aliasviv { vivaldi "vivaldi://flags" } #todo: use standard browser instead of hardcoded

function checkout () { & git checkout $args }

function df { get-volume }

function export($name, $value) { set-item -force -path "env:$name" -value $value; }

function Get-AllNic { Get-NetAdapter | Sort-Object -Property MacAddress } # 1. 获取所有 Network Interface

function Get-IPv4Routes { Get-NetRoute -AddressFamily IPv4 | Where-Object -FilterScript {$_.NextHop -ne '0.0.0.0'} } # 2. 获取 IPv4 关键路由

function Get-IPv6Routes { Get-NetRoute -AddressFamily IPv6 | Where-Object -FilterScript {$_.NextHop -ne '::'} } # 3. 获取 IPv6 关键路由

function grep($regex, $dir) { if ( $dir ) { ls $dir | select-string $regex return } $input | select-string $regex }

function grepv($regex) { $input | ? { !$_.Contains($regex) } }

function pgrep($name) { Get-Process $name }

function pkill($name) { Get-Process $name -ErrorAction SilentlyContinue | kill }

function print-path { ($Env:Path).Split(";") }

function pull () { & get pull $args }

function sed($file, $find, $replace){ (Get-Content $file).replace("$find", $replace) | Set-Content $file }

function touch($file) { "" | Out-File $file -Encoding ASCII }

function uptimef { Get-WmiObject win32_operatingsystem | select csname, @{LABEL='LastBootUpTime'; EXPRESSION={$_.ConverttoDateTime($_.lastbootuptime)}} } #doesn't psreadline module implement this already?

function which($name) { Get-Command $name | Select-Object -ExpandProperty Definition } #should use more

function aliasCode { & $env:code }

function aliasfifs { get-childitem | out-string -stream }

#-------------------------------    Functions END     -------------------------------


#-------------------------------   Set alias BEGIN    -------------------------------

#set-alias -Name cd -Value aliasChangeDirectory -Option AllScope
#set-alias -Name gc -Value checkout
#set-alias -Name gp -Value pull
set-alias -Name lsx -Value aliasListDirectory

set-alias -name code -value aliasCode
set-alias -Name filesinfolasstream -Value aliasfifs
set-alias -Name bcompare -Value aliasbc

set-alias -name EveryGitRepo -Value aliasEFunc

set-alias -name GitAdEPathAsSNB -value aliasEFuncGT
set-alias -name GitUp -value aliasEGLp
set-alias -name gitSilently -Value aliasEGSfunc
set-alias -name gitSingleRemote -Value aliasEGSRfunc

set-alias -name executeThis -value aliasExecuteThis
set-alias -Name filesinfolasstream -Value aliasfilesInFolAsStream
set-alias -name everything -value aliasFunctionEverything
set-alias -Name make -Value aliasMakeThings
set-alias -name MyAliases -value aliasMyAliases
set-alias -Name OpenAsADmin -Value aliasopenasadminf
set-alias -Name open-current-folder -Value aliasOpenCurrentFolderF
set-alias -name pastDo -value aliasPastDo
set-alias -name pastDoEdit -value aliasPastDoEdit
set-alias -name pshelHistorypath -value (Get-PSReadlineOption).HistorySavePath
set-alias -Name reboot -Value aliasrb
set-alias -Name browserflags -Value aliasviv
set-alias -Name df -Value get-volume
set-alias -name ppath -value printpath
set-alias -name reload -value reloadProfile
set-alias -name unzip -value unzipf    
set-alias -name uptime -value uptimef

set-alias -Name getnic -Value Get-NetAdapter | Sort-Object -Property MacAddress # 1. 获取所有 Network Interface
set-alias -Name ll -Value Get-ChildItem            
set-alias -Name getip -Value Get-IPv4Routes
set-alias -Name getip6 -Value Get-IPv6Routes      
set-alias -Name os-update -Value Update-Packages


echo "Alias set"
#-------------------------------    Set alias END     -------------------------------


