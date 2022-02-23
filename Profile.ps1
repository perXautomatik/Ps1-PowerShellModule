# Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
# src: https://gist.github.com/apfelchips/62a71500a0f044477698da71634ab87b
# New-Item $(Split-Path "$($PROFILE.CurrentUserCurrentHost)") -ItemType Directory -ea 0; Invoke-WebRequest -Uri "https://git.io/JYZTu" -OutFile "$($PROFILE.CurrentUserCurrentHost)"

# ref: https://devblogs.microsoft.com/powershell/optimizing-your-profile/#measure-script
# ref: Powershell $? https://stackoverflow.com/a/55362991

# ref: Write-* https://stackoverflow.com/a/38527767
# Write-Host wrapper for Write-Information -InformationAction Continue

#src: https://stackoverflow.com/a/34098997/7595318
function Test-IsInteractive {
    # Test each Arg for match of abbreviated '-NonInteractive' command.
    $NonInteractiveFlag = [Environment]::GetCommandLineArgs() | Where-Object{ $_ -like '-NonInteractive' }
    if ( (-not [Environment]::UserInteractive) -or ( $NonInteractiveFlag -ne $null ) ) {
        return $false
    }
    return $true
}

if ( Test-IsInteractive ) {
# Clear-Host # remove advertisements (preferably use -noLogo)

# custom aliases
Set-Alias flush-dns  Clear-DnsClientCache -Option AllScope

# bash-like
Set-Alias cat        Get-Content -Option AllScope
Set-Alias cd         Set-Location -Option AllScope
Set-Alias clear      Clear-Host -Option AllScope
Set-Alias cp         Copy-Item -Option AllScope
Set-Alias history    Get-History -Option AllScope
Set-Alias kill       Stop-Process -Option AllScope
Set-Alias lp         Out-Printer -Option AllScope
#Set-Alias ls         Get-Childitem -Option AllScope
Set-Alias ll         Get-Childitem -Option AllScope
Set-Alias mv         Move-Item -Option AllScope
Set-Alias ps         Get-Process -Option AllScope
Set-Alias pwd        Get-Location -Option AllScope
Set-Alias which      Get-Command -Option AllScope

Set-Alias open       Invoke-Item -Option AllScope
Set-Alias basename   Split-Path -Option AllScope
Set-Alias realpath   Resolve-Path -Option AllScope

# cmd-like
Set-Alias rm         Remove-Item -Option AllScope
Set-Alias rmdir      Remove-Item -Option AllScope
Set-Alias echo       Write-Output -Option AllScope
Set-Alias cls        Clear-Host -Option AllScope

Set-Alias chdir      Set-Location -Option AllScope
Set-Alias copy       Copy-Item -Option AllScope
Set-Alias del        Remove-Item -Option AllScope
Set-Alias dir        Get-Childitem -Option AllScope
Set-Alias erase      Remove-Item -Option AllScope
Set-Alias move       Move-Item -Option AllScope
Set-Alias rd         Remove-Item -Option AllScope
Set-Alias ren        Rename-Item -Option AllScope
Set-Alias set        Set-Variable -Option AllScope
Set-Alias type       Get-Content -Option AllScope

#src: https://devblogs.microsoft.com/scripting/use-a-powershell-function-to-see-if-a-command-exists/
function Test-CommandExists {
    Param ($command)
    $oldErrorActionPreference = $ErrorActionPreference
    $ErrorActionPreference = 'stop'
    try { Get-Command $command; return $true }
    catch {return $false}
    finally { $ErrorActionPreference=$oldErrorActionPreference }
}

function Get-ModulesAvailable {
    if ( $args.Count -eq 0 ) {
        Get-Module -ListAvailable
    } else {
        Get-Module -ListAvailable $args
    }
}

function Get-ModulesLoaded {
    if ( $args.Count -eq 0 ) {
        Get-Module -All
    } else {
        Get-Module -All $args
    }
}

function TryImport-Module {
    $oldErrorActionPreference = $ErrorActionPreference
    $ErrorActionPreference = 'stop'
    try { Import-Module $args}
    catch { }
    finally { $ErrorActionPreference=$oldErrorActionPreference }
}

function Clean-Object {
    process {
        $_.PSObject.Properties.Remove('PSComputerName')
        $_.PSObject.Properties.Remove('RunspaceId')
        $_.PSObject.Properties.Remove('PSShowComputerName')
    }
    #Where-Object { $_.PSObject.Properties.Value -ne $null}
}

function Get-DefaultAliases {
    Get-Alias | Where-Object { $_.Options -match "ReadOnly" }
}

function Remove-CustomAliases { # https://stackoverflow.com/a/2816523
    Get-Alias | Where-Object { ! $_.Options -match "ReadOnly" } | % { Remove-Item alias:$_ }
}


function set-x {
    Set-PSDebug -trace 2
}

function set+x {
    Set-PSDebug -trace 0
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
Set-Alias env        Get-Environment -Option AllScope

# TODO:
# function Set-EnvironmentAndPSVariable{
#     if (([Environment]::GetEnvironmentVariable($args[0]))){
#         Set-Variable -Name "$args[0]" -Value ([Environment]::GetEnvironmentVariable("$args[0]"))
#     } else {
#         [Environment]::SetEnvironmentVariable($args[0], $args[1], 'User')
#         Set-Variable -Name $args[0] -Value $args[1]
#     }
# }

# define these environment variables if not set already and also provide them as PSVariables
if (-not $env:XDG_CONFIG_HOME) { $env:XDG_CONFIG_HOME = Join-Path -Path "$HOME" -ChildPath ".config" }; $XDG_CONFIG_HOME = $env:XDG_CONFIG_HOME
if (-not $env:XDG_DATA_HOME) { $env:XDG_DATA_HOME = Join-Path -Path "$HOME" -ChildPath ".local/share" }; $XDG_DATA_HOME = $env:XDG_DATA_HOME
if (-not $env:XDG_CACHE_HOME) { $env:XDG_CACHE_HOME = Join-Path -Path "$HOME" -ChildPath ".cache" }; $XDG_CACHE_HOME = $env:XDG_CACHE_HOME

if (-not $env:DESKTOP_DIR) { $env:DESKTOP_DIR = Join-Path -Path "$HOME" -ChildPath "desktop" }; $DESKTOP_DIR = $env:DESKTOP_DIR

if (-not $env:NOTES_DIR) { $env:NOTES_DIR = Join-Path -Path "$HOME" -ChildPath "notes" }; $NOTES_DIR = $env:NOTES_DIR
if (-not $env:CHEATS_DIR) { $env:CHEATS_DIR = Join-Path -Path "$env:NOTES_DIR" -ChildPath "cheatsheets" }; $CHEATS_DIR = $env:CHEATS_DIR
if (-not $env:TODO_DIR) { $env:TODO_DIR = Join-Path -Path "$env:NOTES_DIR" -ChildPath "_ToDo" }; $TODO_DIR = $env:TODO_DIR

if (-not $env:DEVEL_DIR) { $env:DEVEL_DIR = Join-Path -Path "$HOME" -ChildPath "devel" }; $DEVEL_DIR = $env:DEVEL_DIR
if (-not $env:PORTS_DIR) { $env:PORTS_DIR = Join-Path -Path "$HOME" -ChildPath "ports" }; $PORTS_DIR = $env:PORTS_DIR

function cdc { Set-Location "$XDG_CONFIG_HOME" }
function cdd { Set-Location "$DESKTOP_DIR" }
function cdn { Set-Location "$NOTES_DIR" }
function cdcheat { Set-Location "$CHEATS_DIR" }
function cdt { Set-Location "$TODO_DIR" }
function cddev { Set-Location "$DEVEL_DIR" }
function cddd { Set-Location "$DEVEL_DIR" }
function cdports { Set-Location "$PORTS_DIR" }

function cf {
    if ( $(Get-Module PSFzf) -ne $null ) {
        Get-ChildItem . -Recurse -Attributes Directory | Invoke-Fzf | Set-Location
    } else {
        Write-Error "please install PSFzf"
    }
}

function .. { Set-Location ".." }
function .... { Set-Location (Join-Path -Path ".." -ChildPath "..") }

if ( $(Test-CommandExists 'git') ) {
    Set-Alias g    git -Option AllScope

    function git-root {
        $gitrootdir = (git rev-parse --show-toplevel)
        if ( $gitrootdir ) {
            Set-Location $gitrootdir
        }
    }

    if ( $IsWindows ) {
        function git-sh {
            if ( $args.Count -eq 0 ) {
                . $(Join-Path -Path $(Split-Path -Path $(Get-Command git).Source) -ChildPath "..\bin\sh") -l
            } else {
                . $(Join-Path -Path $(Split-Path -Path $(Get-Command git).Source) -ChildPath "..\bin\sh") $args
            }
        }

        function git-bash {
            if ( $args.Count -eq 0 ) {
                . $(Join-Path -Path $(Split-Path -Path $(Get-Command git).Source) -ChildPath "..\bin\bash") -l
            } else {
                . $(Join-Path -Path $(Split-Path -Path $(Get-Command git).Source) -ChildPath "..\bin\bash") $args
            }
        }

        function git-vim {
           . $(Join-Path -Path $(Split-Path -Path $(Get-Command git).Source) -ChildPath "..\bin\bash") -l -c `'vim $args`'
        }

        if ( -Not (Test-CommandExists 'sh') ){
            Set-Alias sh   git-sh -Option AllScope
        }

        if ( -Not (Test-CommandExists 'bash') ){
            Set-Alias bash   git-bash -Option AllScope
        }

        if ( -Not (Test-CommandExists 'vi') ){
            Set-Alias vi   git-vim -Option AllScope
        }

        if ( -Not (Test-CommandExists 'vim') ){
            Set-Alias vim   git-vim -Option AllScope
        }
    }
}

function Select-Value { # src: https://geekeefy.wordpress.com/2017/06/26/selecting-objects-by-value-in-powershell/
    [Cmdletbinding()]
    param(
        [parameter(Mandatory=$true)] [String] $Value,
        [parameter(ValueFromPipeline=$true)] $InputObject
    )
    process {
        # Identify the PropertyName for respective matching Value, in order to populate it Default Properties
        $Property = ($PSItem.properties.Where({$_.Value -Like "$Value"})).Name
        If ( $Property ) {
            # Create Property a set which includes the 'DefaultPropertySet' and Property for the respective 'Value' matched
            $DefaultPropertySet = $PSItem.PSStandardMembers.DefaultDisplayPropertySet.ReferencedPropertyNames
            $TypeName = ($PSItem.PSTypenames)[0]
            Get-TypeData $TypeName | Remove-TypeData
            Update-TypeData -TypeName $TypeName -DefaultDisplayPropertySet ($DefaultPropertySet+$Property |Select-Object -Unique)

            $PSItem | Where-Object {$_.properties.Value -like "$Value"}
        }
    }
}

Remove-Item alias:ls -ea SilentlyContinue
function ls { # ls -al is musclememory by now so ignore all args for this "alias"
    Get-Childitem
}

# https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_functions?view=powershell-7#piping-objects-to-functions

function all {
    process { $_ | Select-Object * }
}

function list { # fl is there by default
    process { $_ | Format-List * }
}

function string {
    process { $_ | Out-String -Stream }
}

function grep {
    process { $_ | Select-String -Pattern $args }
}

function man {
    Get-Help $args[0] | out-host -paging
}

function mkdir {
    New-Item -type directory -path (Join-Path "$args" -ChildPath "")
}

function md {
    New-Item -type directory -path (Join-Path "$args" -ChildPath "")
}

function pause($message="Press any key to continue . . . ") {
    Write-Host -NoNewline $message
    $i=16,17,18,20,91,92,93,144,145,166,167,168,169,170,171,172,173,174,175,176,177,178,179,180,181,182,183
    while ($k.VirtualKeyCode -eq $null -or $i -Contains $k.VirtualKeyCode){
        $k = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
    }
    Write-Host ""
}

# native touch implementation
# src: https://ss64.com/ps/syntax-touch.html
function Set-FileTime {
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
Set-Alias touch Set-FileTime -Option AllScope

function Reload-Profile {
    . $PROFILE.CurrentUserCurrentHost
}

function Download-Latest-Profile {
    New-Item $( Split-Path $($PROFILE.CurrentUserCurrentHost) ) -ItemType Directory -ea 0
    if ( $(Get-Content "$($PROFILE.CurrentUserCurrentHost)" | Select-String "62a71500a0f044477698da71634ab87b" | Out-String) -eq "" ) {
        Move-Item -Path "$($PROFILE.CurrentUserCurrentHost)" -Destination "$($PROFILE.CurrentUserCurrentHost).bak"
    }
    Invoke-WebRequest -Uri "https://gist.githubusercontent.com/apfelchips/62a71500a0f044477698da71634ab87b/raw/Profile.ps1" -OutFile "$($PROFILE.CurrentUserCurrentHost)"
    Reload-Profile
}

if ( ($PSVersionTable.PSEdition -eq $null) -or ($PSVersionTable.PSEdition -eq "Desktop") ) {
    $PSVersionTable.PSEdition = "Desktop"
    $IsWindows = $true
}

if ( -not $IsWindows ) {
    function Test-IsAdmin {
        if ( (id -u) -eq 0 ) {
            return $true
        }
        return $false
    }
}

if ( $IsWindows ) {
    # src: http://serverfault.com/questions/95431
    function Test-IsAdmin {
        $user = [Security.Principal.WindowsIdentity]::GetCurrent();
        return $(New-Object Security.Principal.WindowsPrincipal $user).IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator);
    }

    function Restart-Explorer {
        Get-Process explorer | Stop-Process
        Start-Process "$(Get-HostExecutable)" -ArgumentList "-noProfile -noLogo -Command 'Get-Process explorer | Stop-Process'" -verb "runAs"
    }

    function Reset-Spooler {
        Start-Process "$(Get-HostExecutable)" -ArgumentList "-noProfile -noLogo -Command 'Stop-Service -Name Spooler -Force; Get-Item ${env:SystemRoot}\System32\spool\PRINTERS\* | Remove-Item -Force -Recurse; Start-Service -Name Spooler'" -verb "runAs"
    }

    function subl {
        Start-Process "${Env:ProgramFiles}\Sublime Text\subl.exe" -ArgumentList $args -WindowStyle Hidden # hide subl shim script
    }

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
    } else {
        function choco {
            Start-Process (Get-HostExecutable) -ArgumentList "-noProfile -noLogo -Command choco.exe ${args}; pause" -verb runAs
        }
    }

    TryImport-Module "${env:ChocolateyInstall}\helpers\chocolateyProfile.psm1"
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

function Clear-SavedHistory { # src: https://stackoverflow.com/a/38807689
  [CmdletBinding(ConfirmImpact='High', SupportsShouldProcess)]
  param()
  $havePSReadline = ( $(Get-Module PSReadline -ea SilentlyContinue) -ne $null )
  $target = if ( $havePSReadline ) { "entire command history, including from previous sessions" } else { "command history" }
  if ( -not $pscmdlet.ShouldProcess($target) ) { return }
  if ( $havePSReadline ) {
        Clear-Host
        # Remove PSReadline's saved-history file.
        if ( Test-Path (Get-PSReadlineOption).HistorySavePath ) {
            # Abort, if the file for some reason cannot be removed.
            Remove-Item -ea Stop (Get-PSReadlineOption).HistorySavePath
            # To be safe, we recreate the file (empty).
            $null = New-Item -Type File -Path (Get-PSReadlineOption).HistorySavePath
        }
        # Clear PowerShell's own history
        Clear-History
        [Microsoft.PowerShell.PSConsoleReadLine]::ClearHistory()
    } else { # Without PSReadline, we only have a *session* history.
        Clear-Host
        Clear-History
    }
}

function Install-MyModules {
    PowerShellGet\Install-Module -Name PSReadLine -Scope CurrentUser -AllowPrerelease -Force -AllowClobber
    PowerShellGet\Install-Module -Name posh-git -Scope CurrentUser -Force -AllowClobber
    PowerShellGet\Install-Module -Name PSFzf -Scope CurrentUser -Force -AllowClobber

    PowerShellGet\Install-Module -Name PSProfiler -Scope CurrentUser -Force -AllowClobber # --> Measure-Script

    # serialization tools: eg. ConvertTo-HashString / ConvertTo-HashTable https://github.com/torgro/HashData
    PowerShellGet\Install-Module -Name hashdata -Scope CurrentUser -Force - AllowClobber

    # useful Tools eg. ConvertTo-FlatObject, Join-Object... https://github.com/RamblingCookieMonster/PowerShell
    PowerShellGet\Install-Module -Name WFTools -Scope CurrentUser -Force -AllowClobber

    # https://old.reddit.com/r/AZURE/comments/fh0ycv/azuread_vs_azurerm_vs_az/
    # https://docs.microsoft.com/en-us/microsoft-365/enterprise/connect-to-microsoft-365-powershell
    PowerShellGet\Install-Module -Name AzureAD -Scope CurrentUser -Force -AllowClobber

    PowerShellGet\Install-Module -Name SqlServer -Scope CurrentUser -Force -AllowClobber

    if ( $IsWindows ){
        # Windows Update CLI tool http://woshub.com/pswindowsupdate-module/#h2_2
        # Install-WindowsUpdate -MicrosoftUpdate -AcceptAll -AutoReboot
        # native alternative: WindowsUpdateProvider\Install-WUUpdates >= Windows Server 2019
        PowerShellGet\Install-Module -Name PSWindowsUpdate -Scope CurrentUser -Force -AllowClobber
    }
}

function Import-MyModules {
    TryImport-Module PSProfiler
    TryImport-Module hashdata
    TryImport-Module WFTools
    TryImport-Module AzureAD
    TryImport-Module SqlServer
    TryImport-Module PSWindowsUpdate
}

if ( ($host.Name -eq 'ConsoleHost') -and ($null -ne (Get-Module -ListAvailable -Name PSReadLine)) ) {
    # example: https://github.com/PowerShell/PSReadLine/blob/master/PSReadLine/SamplePSReadLineProfile.ps1
    TryImport-Module PSReadLine

    # Set-PSReadLineOption -EditMode Emac
    Set-PSReadLineKeyHandler -Key Tab -Function MenuComplete

    Set-PSReadLineOption -HistorySearchCursorMovesToEnd
    Set-PSReadLineKeyHandler -Key UpArrow -Function HistorySearchBackward
    Set-PSReadLineKeyHandler -Key DownArrow -Function HistorySearchForward
    Set-PSReadlineKeyHandler -Chord 'Shift+Tab' -Function Complete

    if ( $(Get-Module PSReadline).Version -ge 2.2 ) {
        Set-PSReadLineOption -predictionsource history -ea SilentlyContinue
    }

    if ( $(Get-Module PSFzf) -ne $null ) {
        #Set-PSReadLineKeyHandler -Key Tab -ScriptBlock { Invoke-FzfTabCompletion }
        #$FZF_COMPLETION_TRIGGER='...'
        Set-PsFzfOption -PSReadlineChordProvider 'Ctrl+t' -PSReadlineChordReverseHistory 'Ctrl+r'
    }
}

if ( ($host.Name -eq 'ConsoleHost') -and ($null -ne (Get-Module -ListAvailable -Name posh-git)) ) {
        TryImport-Module posh-git
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

# hacks for old powerhsell versions
if ( $PSVersionTable.PSVersion.Major -lt 7 ) {
    # https://docs.microsoft.com/en-us/powershell/scripting/gallery/installing-psget
    function Install-PowerShellGet {
        Start-Process "$(Get-HostExecutable)" -ArgumentList "-noProfile -noLogo -Command Install-PackageProvider -Name NuGet -Force; Install-Module -Name PowerShellGet -Repository PSGallery -Force -AllowClobber -SkipPublisherCheck; pause" -verb "RunAs"
    }

    $PSDefaultParameterValues['Out-File:Encoding'] = 'utf8' # Fix Encoding for PS 5.1 https://stackoverflow.com/a/40098904

    function Get-ExitBoolean($command) { # fixed: https://github.com/PowerShell/PowerShell/pull/9849
        & $command | Out-Null; $?
    }
    Set-Alias geb   Get-ExitBoolean

    function Use-Default # $var = d $Value : "DefaultValue" eg. ternary # fixed: https://toastit.dev/2019/09/25/ternary-operator-powershell-7/
    {
        for ($i = 1; $i -lt $args.Count; $i++){
            if ($args[$i] -eq ":"){
                $coord = $i; break
            }
        }
        if ($coord -eq 0) {
            throw new System.Exception "No operator!"
        }
        if ($args[$coord - 1] -eq ""){
            $toReturn = $args[$coord + 1]
        } else {
            $toReturn = $args[$coord -1]
        }
        return $toReturn
    }
    Set-Alias d    Use-Default
}

Write-Host "PSVersion: $($PSVersionTable.PSVersion.Major).$($PSVersionTable.PSVersion.Minor).$($PSVersionTable.PSVersion.Patch)"
Write-Host "PSEdition: $($PSVersionTable.PSEdition)"
Write-Host "Profile:   $PSCommandPath"

} # interactive test close
