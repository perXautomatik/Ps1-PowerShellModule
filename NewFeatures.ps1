# Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
# src: https://gist.github.com/apfelchips/62a71500a0f044477698da71634ab87b
# New-Item $(Split-Path "$($PROFILE.CurrentUserCurrentHost)") -ItemType Directory -ea 0; Invoke-WebRequest -Uri "https://git.io/JYZTu" -OutFile "$($PROFILE.CurrentUserCurrentHost)"

# ref: https://devblogs.microsoft.com/powershell/optimizing-your-profile/#measure-script
# ref: Powershell $? https://stackoverflow.com/a/55362991

# ref: Write-* https://stackoverflow.com/a/38527767
# Write-Host wrapper for Write-Information -InformationAction Continue
# define these environment variables if not set already and also provide them as PSVariables
#src: https://stackoverflow.com/a/34098997/7595318


#### Package Management: Chocolatey
#Chocolatey is a powerful package manager for Windows, working sort of like apt-get or homebrew. Let's get that first. Fire up CMD.exe as Administrator and run:
#@powershell -NoProfile -ExecutionPolicy Bypass -Command "iex ((new-object net.webclient).DownloadString('https://chocolatey.org/install.ps1'))" && SET PATH=%PATH%;%ALLUSERSPROFILE%\chocolatey\bin
# Once done, you can install packages by running `cinst` (short for `choco install`). Most packages below will be installed with Chocolatey.
###### Bonus: Use Windows 10 & OneGet
#Windows 10 comes with [OneGet](https://github.com/OneGet/oneget), a universal package manager that can use Chocolatey to find and install packages. To install, run:
Get-PackageProvider -name chocolatey
#Once done, you can look for all Chrome packages by typing `Find-Package -Name Chrome` or install it by typing `Install-Package -Name GoogleChrome`.

# Runs all .ps1 files in this module's directory
Get-ChildItem -Path $PSScriptRoot\*.ps1 | ? name -NotMatch 'Microsoft.PowerShell_profile' | Foreach-Object { . $_.FullName }
$env:path = @(
    $env:path
    'C:\Program Files (x86)\Notepad++\'
    'C:\Users\admin\AppData\Local\GitHub\PortableGit_c7e0cbde92ba565cb218a521411d0e854079a28c\cmd'
    'C:\Users\admin\AppData\Local\GitHub\PortableGit_c7e0cbde92ba565cb218a521411d0e854079a28c\usr\bin'
    'C:\Users\admin\AppData\Local\GitHub\PortableGit_c7e0cbde92ba565cb218a521411d0e854079a28c\usr\share\git-tfs'
    'C:\Users\admin\AppData\Local\Apps\2.0\C31EKMVW.15A\TWAQ6XY3.BAX\gith..tion_317444273a93ac29_0003.0000_328216539257acd4'
    'C:\Users\admin\AppData\Local\GitHub\lfs-amd64_1.1.0;C:\WINDOWS\Microsoft.NET\Framework\v4.0.30319'
) -join ';'                 

# http://blogs.msdn.com/b/powershell/archive/2006/06/24/644987.aspx
Update-TypeData "$PSScriptRoot\My.Types.Ps1xml"
# http://get-powershell.com/post/2008/06/25/Stuffing-the-output-of-the-last-command-into-an-automatic-variable.aspx
function Out-Default {
    if ($input.GetType().ToString() -ne 'System.Management.Automation.ErrorRecord') {
	try {
	    $input | Tee-Object -Variable global:lastobject | Microsoft.PowerShell.Core\Out-Default
	} catch {
	    $input | Microsoft.PowerShell.Core\Out-Default
	}
    } else {
	$input | Microsoft.PowerShell.Core\Out-Default
    }
}
function getjob { Get-Job | select id, name, state | ft -a }
function stopjob ($id = '*') { Get-Job $id | Stop-Job; gj }
function rmjob { Get-Job | ? state -match 'comp' | Remove-Job }
# https://community.spiceworks.com/topic/1570654-what-s-in-your-powershell-profile?page=1#entry-5746422
function Test-Administrator {
    $user = [Security.Principal.WindowsIdentity]::GetCurrent()
    (New-Object Security.Principal.WindowsPrincipal $user).IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)
}
function Start-PsElevatedSession {
    # Open a new elevated powershell window
    if (!(Test-Administrator)) {
	if ($host.Name -match 'ISE') {
	    start PowerShell_ISE.exe -Verb runas
	} else {
	    start powershell -Verb runas -ArgumentList $('-noexit ' + ($args | Out-String))
	}
    } else {
	Write-Warning 'Session is already elevated'
    }
}
Set-Alias -Name su -Value Start-PsElevatedSession

# http://www.lavinski.me/my-powershell-profile/
function Elevate-Process {
    $file, [string]$arguments = $args
    $psi = new-object System.Diagnostics.ProcessStartInfo $file
    $psi.Arguments = $arguments
    $psi.Verb = 'runas'

    $psi.WorkingDirectory = Get-Location
    [System.Diagnostics.Process]::Start($psi)
}
Set-Alias sudo Elevate-Process
# https://www.reddit.com/r/PowerShell/comments/49ahc1/what_are_your_cool_powershell_profile_scripts/
# http://kevinmarquette.blogspot.com/2015/11/here-is-my-custom-powershell-prompt.html
# https://www.reddit.com/r/PowerShell/comments/46hetc/powershell_profile_config/
$PSLogPath = ("{0}\Documents\WindowsPowerShell\log\{1:yyyyMMdd}-{2}.log" -f $env:USERPROFILE, (Get-Date), $PID)
if (!(Test-Path $(Split-Path $PSLogPath))) { md $(Split-Path $PSLogPath) }
Add-Content -Value "# $(Get-Date) $env:username $env:computername" -Path $PSLogPath
Add-Content -Value "# $(Get-Location)" -Path $PSLogPath
function prompt {
    # KevMar logging
    $LastCmd = Get-History -Count 1
    if ($LastCmd) {
	$lastId = $LastCmd.Id
	Add-Content -Value "# $($LastCmd.StartExecutionTime)" -Path $PSLogPath
	Add-Content -Value "$($LastCmd.CommandLine)" -Path $PSLogPath
	Add-Content -Value '' -Path $PSLogPath
	$howlongwasthat = $LastCmd.EndExecutionTime.Subtract($LastCmd.StartExecutionTime).TotalSeconds
    }
    # Kerazy_POSH propmt
    # Get Powershell version information
    $MajorVersion = $PSVersionTable.PSVersion.Major
    $MinorVersion = $PSVersionTable.PSVersion.Minor
    # Detect if the Shell is 32- or 64-bit host
    if ([System.IntPtr]::Size -eq 8) {
	$ShellBits = 'x64 (64-bit)'
    } elseif ([System.IntPtr]::Size -eq 4) {
	$ShellBits = 'x86 (32-bit)'
    }
    # Set Window Title to display Powershell version info, Shell bits, username and computername
    $host.UI.RawUI.WindowTitle = "PowerShell v$MajorVersion.$MinorVersion $ShellBits | $env:USERNAME@$env:USERDNSDOMAIN | $env:COMPUTERNAME | $env:LOGONSERVER"
    # Set Prompt Line 1 - include Date, file path location
    Write-Host(Get-Date -UFormat "%Y/%m/%d %H:%M:%S ($howlongwasthat) | ") -NoNewline -ForegroundColor DarkGreen
    Write-Host(Get-Location) -ForegroundColor DarkGreen
    # Set Prompt Line 2
    # Check for Administrator elevation
    if (Test-Administrator) {
	Write-Host '# ADMIN # ' -NoNewline -ForegroundColor Cyan
    } else {
	Write-Host '# User # ' -NoNewline -ForegroundColor DarkCyan
    }
    Write-Host '»' -NoNewLine -ForeGroundColor Green
    ' ' # need this space to avoid the default white PS>
}
# http://stackoverflow.com/questions/3097589/getting-my-public-ip-via-api
# https://www.reddit.com/r/PowerShell/comments/4parze/formattable_help/
function wimi {
    ((iwr http://www.realip.info/api/p/realip.php).content | ConvertFrom-Json).IP
}
<#
((iwr http://www.realip.info/api/p/realip.php).content | ConvertFrom-Json).IP
((iwr https://api.ipify.org/?format=json).content | ConvertFrom-Json).IP
(iwr http://ipv4bot.whatismyipaddress.com/).content
(iwr http://icanhazip.com/).content.trim()
(iwr http://ifconfig.me/ip).content.trim() # takes a long time
(iwr http://checkip.dyndns.org/).content -replace '[^\d.]+' # takes a long time
#>
#function Format-List {$input | Tee-Object -Variable global:lastformat | Microsoft.PowerShell.Utility\Format-List}
#function Format-Table {$input | Tee-Object -Variable global:lastformat | Microsoft.PowerShell.Utility\Format-Table}
#if ($LastFormat) {$global:lastobject=$LastFormat; $LastFormat=$Null}

<#
# sal stop stop-process
sal ss select-string
sal wh write-host
sal no New-Object
sal add Add-Member
#>

function Clean-Object {
    process {
        $_.PSObject.Properties.Remove('PSComputerName')
        $_.PSObject.Properties.Remove('RunspaceId')
        $_.PSObject.Properties.Remove('PSShowComputerName')
    }
    #Where-Object { $_.PSObject.Properties.Value -ne $null}
}

function Get-Environment {  # Get-Variable to show all Powershell Variables accessible via $
    if ( $args.Count -eq 0 ) {
        Get-Childitem env:
    } elseif( $args.Count -eq 1 ) {
        Start-Process (Get-Command $args[0]).Source
    } else {
        Start-Process (Get-Command $args[0]).Source -ArgumentList $args[1..($args.Count-1)]
    }
}


function cf {
    if ( $null -ne $(Get-Module PSFzf) ) {
        Get-ChildItem . -Recurse -Attributes Directory | Invoke-Fzf | Set-Location
    } else {
        Write-Error "please install PSFzf"
    }
}

function pause($message="Press any key to continue . . . ") {
    Write-Host -NoNewline $message
    $i=16,17,18,20,91,92,93,144,145,166,167,168,169,170,171,172,173,174,175,176,177,178,179,180,181,182,183
    while ($null -eq $k.VirtualKeyCode -or $i -Contains $k.VirtualKeyCode){
        $k = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
    }
    Write-Host ""
}


function Set-FileTime {  
# native touch implementation
# src: https://ss64.com/ps/syntax-touch.html
    param(
        [string[]]$paths,
        [bool]$only_modification = $false,
        [bool]$only_access = $false
    )

    begin {
        function updateFileSystemInfo([System.IO.FileSystemInfo]$fsInfo) {
            $datetime = Get-Date
            if ( $only_access ) {
                $fsInfo.LastAccessTime = $datetime
            } elseif ( $only_modification ) {
                $fsInfo.LastWriteTime = $datetime
            } else {
                $fsInfo.CreationTime = $datetime
                $fsInfo.LastWriteTime = $datetime
                $fsInfo.LastAccessTime = $datetime
            }
        }

        function touchExistingFile($arg) {
            if ( $arg -is [System.IO.FileSystemInfo] ) {
                    updateFileSystemInfo($arg)
                } else {
                $resolvedPaths = Resolve-Path $arg
                foreach ($rpath in $resolvedPaths) {
                    if ( Test-Path -type Container $rpath ) {
                        $fsInfo = New-Object System.IO.DirectoryInfo($rpath)
                    } else {
                        $fsInfo = New-Object System.IO.FileInfo($rpath)
                    }
                    updateFileSystemInfo($fsInfo)
                }
            }
        }

        function touchNewFile([string]$path) {
            #$null > $path
            Set-Content -Path $path -value $null;
        }
    }

    process {
        if ( $_ ) {
            if ( Test-Path $_ ) {
                touchExistingFile($_)
            } else {
                touchNewFile($_)
            }
        }
    }

    end {
        if ( $paths ) {
            foreach ( $path in $paths ) {
                if ( Test-Path $path ) {
                    touchExistingFile($path)
                } else {
                    touchNewFile($path)
                }
            }
        }
    }
}

if ( $IsWindows ) {

    function stree($directory = $pwd) {
        $gitrootdir = (Invoke-Command{Set-Location $args[0]; git rev-parse --show-toplevel 2>&1;} -ArgumentList $directory)

            if ( Test-Path -Path "$gitrootdir\.git" -PathType Container) {
                $newestExe = Get-Item "${env:ProgramFiles(x86)}\Atlassian\SourceTree\SourceTree.exe" | select -Last 1
                Write-Debug "Opening $gitrootdir with $newestExe"
                Start-Process -filepath $newestExe -ArgumentList "-f `"$gitrootdir`" log"
            } else {
                Write-Error "git directory not found"
            }
    }

if ( "${env:ChocolateyInstall}" -eq "" ) {
        function Install-Chocolatey {
            if (Get-Command choco -ErrorAction SilentlyContinue) {
                Write-Error "chocolatey already installed!"
            } else {
                Start-Process (Get-HostExecutable) -ArgumentList "-Command Set-ExecutionPolicy Bypass -Scope Process -Force; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1') -verb RunAs"
            }
        }
        else {
            function choco { Start-Process (Get-HostExecutable) -ArgumentList "-noProfile -noLogo -Command choco.exe ${args}; pause" -verb runAs } 
        }
    }
}

function Get-HostExecutable {
if ( $PSVersionTable.PSEdition -eq "Core" ) {
    $ConsoleHostExecutable = (get-command pwsh).Source
} else {
    $ConsoleHostExecutable = (get-command powershell).Source
}
return $ConsoleHostExecutable
}

# don't override chocolatey sudo or unix sudo
if ( -not $(Test-CommandExists 'sudo') ) {
function sudo() {
    if ( $args.Length -eq 0 ) {
        Start-Process $(Get-HostExecutable) -verb "runAs"
    } elseif ( $args.Length -eq 1 ) {
        Start-Process $args[0] -verb "runAs"
    } else {
        Start-Process $args[0] -ArgumentList $args[1..$args.Length] -verb "runAs"
    }
}
}


# Helper Functions
#######################################################

if ( -Not (Test-CommandExists 'sh') ){ Set-Alias sh   git-sh -Option AllScope }
function uptimef {
	Get-WmiObject win32_operatingsystem | select csname, @{LABEL='LastBootUpTime';
	EXPRESSION={$_.ConverttoDateTime($_.lastbootuptime)}}
}

function find-file($name) {
	ls -recurse -filter "*${name}*" -ErrorAction SilentlyContinue | foreach {
		$place_path = $_.directory
		echo "${place_path}\${_}"
	}
}
function unzipf ($file) {
	$dirname = (Get-Item $file).Basename
	echo("Extracting", $file, "to", $dirname)
	New-Item -Force -ItemType directory -Path $dirname
	expand-archive $file -OutputPath $dirname -ShowProgress
}


# already expanded to save time https://github.com/nvbn/thefuck/wiki/Shell-aliases#powershell
if ( $(Test-CommandExists 'thefuck') ) {
    function fuck {
        $PYTHONIOENCODING_BKP=$env:PYTHONIOENCODING
        $env:PYTHONIOENCODING="utf-8"
        $history = (Get-History -Count 1).CommandLine

        if (-not [string]::IsNullOrWhiteSpace($history)) {
            $fuck = $(thefuck $args $history)
            if ( -not [string]::IsNullOrWhiteSpace($fuck) ) {
                if ( $fuck.StartsWith("echo") ) { $fuck = $fuck.Substring(5) } else { iex "$fuck" }
            }
        }
        [Console]::ResetColor()
        $env:PYTHONIOENCODING=$PYTHONIOENCODING_BKP
    }
    Set-Alias f fuck -Option AllScope
}

if ( $(Test-CommandExists 'git') ) {
    Set-Alias g    git -Option AllScope
    function git-root { $gitrootdir = (git rev-parse --show-toplevel) ; if ( $gitrootdir ) { Set-Location $gitrootdir } }

    if ( $IsWindows ) {
        function git-sh {
            if ( $args.Count -eq 0 ) { . $(Join-Path -Path $(Split-Path -Path $(Get-Command git).Source) -ChildPath "..\bin\sh") -l
            } else { . $(Join-Path -Path $(Split-Path -Path $(Get-Command git).Source) -ChildPath "..\bin\sh") $args }
        }

        function git-bash {
            if ( $args.Count -eq 0 ) {
                . $(Join-Path -Path $(Split-Path -Path $(Get-Command git).Source) -ChildPath "..\bin\bash") -l
            } else {
                . $(Join-Path -Path $(Split-Path -Path $(Get-Command git).Source) -ChildPath "..\bin\bash") $args
            }
        }

        function git-vim { . $(Join-Path -Path $(Split-Path -Path $(Get-Command git).Source) -ChildPath "..\bin\bash") -l -c `'vim $args`' }

        if ( -Not (Test-CommandExists 'sh') ){ Set-Alias sh   git-sh -Option AllScope }

        if ( -Not (Test-CommandExists 'bash') ){ Set-Alias bash   git-bash -Option AllScope }

        if ( -Not (Test-CommandExists 'vi') ){ Set-Alias vi   git-vim -Option AllScope }

        if ( -Not (Test-CommandExists 'vim') ){ Set-Alias vim   git-vim -Option AllScope }
    }
}

#function aliasCode { & $env:code }
function .. { Set-Location ".." }
function .... { Set-Location (Join-Path -Path ".." -ChildPath "..") }
function all { process { $_ | Select-Object * } }  # https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_functions?view=powershell-7#piping-objects-to-functions
function cdc { Set-Location "$XDG_CONFIG_HOME" }
function cdcheat { Set-Location "$CHEATS_DIR" }
function cdd { Set-Location "$DESKTOP_DIR" }
function cddd { Set-Location "$DEVEL_DIR" }
function cddev { Set-Location "$DEVEL_DIR" }
function cdn { Set-Location "$NOTES_DIR" }
function cdports { Set-Location "$PORTS_DIR" }
function cdt { Set-Location "$TODO_DIR" }

function df { get-volume }
function enter-dir { param ( $Path = '%USERPROFILE%\Desktop\' ) Set-Location $Path }; #if no param, navigate to desktop # 5. 更改工作目录 # 输入要切换到的路径 # 用法示例：cd C:/ # 默认路径：D 盘的桌面

function export($name, $value) { set-item -force -path "env:$name" -value $value; }
function Get-AllNic { Get-NetAdapter | Sort-Object -Property MacAddress } # 1. 获取所有 Network Interface
function get-Childnames { param ($path = $pwd) (Get-ChildItem -path $path).Name ; Write-Host("") }; # 3. 查看目录 ls & ll
function Get-DefaultAliases {Get-Alias | Where-Object { $_.Options -match "ReadOnly" }}
function get-historyPath { (Get-PSReadlineOption).HistorySavePath }
function Get-IPv4Routes { Get-NetRoute -AddressFamily IPv4 | Where-Object -FilterScript {$_.NextHop -ne '0.0.0.0'} } # 2. 获取 IPv4 关键路由
function Get-IPv6Routes { Get-NetRoute -AddressFamily IPv6 | Where-Object -FilterScript {$_.NextHop -ne '::'} } # 3. 获取 IPv6 关键路由
function grep { process { $_ | Select-String -Pattern $args } } # function grep($regex, $dir) { if ( $dir ) { ls $dir | select-string $regex return } $input | select-string $regex }
function grepv($regex) { $input | ? { !$_.Contains($regex) } }

function invoke-Nmake { nmake.exe $args -nologo }; # 1. 编译函数 make

function list { process { $_ | Format-List * } } # fl is there by default
function man { Get-Help $args[0] | out-host -paging }
function md { New-Item -type directory -path (Join-Path "$args" -ChildPath "") }

function mkdir { New-Item -type directory -path (Join-Path "$args" -ChildPath "") }
function open-here { param ( $Path = $pwd ) Invoke-Item $Path }; # 4. 打开当前工作目录 # 输入要打开的路径 # 用法示例：open C:\ # 默认路径：当前工作文件夹
function pgrep($name) { Get-Process $name }
function pkill($name) { Get-Process $name -ErrorAction SilentlyContinue | kill }
function printpath { ($Env:Path).Split(";") }
function pull () { & get pull $args }

function read-uptime { Get-WmiObject win32_operatingsystem | select csname, @{LABEL='LastBootUpTime'; EXPRESSION={$_.ConverttoDateTime($_.lastbootuptime)}} } #doesn't psreadline module implement this already?
function Remove-CustomAliases { Get-Alias | Where-Object { ! $_.Options -match "ReadOnly" } | % { Remove-Item alias:$_ }} # https://stackoverflow.com/a/2816523
function remove-TempfilesNfolders { foreach ($folder in get-tempfilesNfolders) {Remove-Item $folder -force -recurse} }
function sed($file, $find, $replace) { if (!$file -or !(Test-Path $file)) { throw "file not found: '$file'" }  (Get-Content $file).replace("$find", $replace) | Set-Content $file }

function start-BrowserFlags { vivaldi "vivaldi://flags" } #todo: use standard browser instead of hardcoded

function touch($file) { "" | Out-File $file -Encoding ASCII }
function which($name) { Get-Command $name | Select-Object -ExpandProperty Definition } #should use more
function get-mac { Get-NetAdapter | Sort-Object -Property MacAddress }
Remove-Item alias:ls -ea SilentlyContinue ; function ls { Get-Childitem} # ls -al is musclememory by now so ignore all args for this "alias"
function clear-Days_Back { param ( $path = "C:\Support\SQLBac\" ,$Daysback = "0" ) $CurrentDate = Get-Date $DatetoDelete = $CurrentDate.AddDays($Daysback) Get-ChildItem $path | Where-Object { $_.LastWriteTime -lt $DatetoDelete } | Remove-Item }
Set-Alias flush-dns                                  Clear-DnsClientCache -Option AllScope
set-alias lsx						 	             get-Childnames  -Option AllScope
set-alias filesinfolasstream		            	 read-pathsAsStream  -Option AllScope
set-alias make						             	 invoke-Nmake  -Option AllScope
set-alias browserflags				            	 start-BrowserFlags  -Option AllScope
set-alias getnic					            	 get-mac -Option AllScope # 1. 获取所有 Network Interface  
set-alias ll						             	 Get-ChildItem              -Option AllScope
set-alias getip						                 Get-IPv4Routes  -Option AllScope
set-alias getip6					            	 Get-IPv6Routes        -Option AllScope
set-alias os-update					                 Update-Packages  -Option AllScope
