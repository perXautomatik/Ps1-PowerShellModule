# Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
# src: https://gist.github.com/apfelchips/62a71500a0f044477698da71634ab87b
# Invoke-WebRequest -Uri "https://git.io/JYZTu" -OutFile "$PROFILE.CurrentUserAllHosts"

Set-Alias open       Invoke-Item -Option AllScope
Set-Alias g          git -Option AllScope

# bash-like
Set-Alias cat        Get-Content -Option AllScope
Set-Alias cd         Set-Location -Option AllScope
Set-Alias clear      Clear-Host -Option AllScope
Set-Alias cp         Copy-Item -Option AllScope
Set-Alias history    Get-History -Option AllScope
Set-Alias kill       Stop-Process -Option AllScope
Set-Alias lp         Out-Printer -Option AllScope
Set-Alias ll         Get-Childitem -Option AllScope
Set-Alias mv         Move-Item -Option AllScope
Set-Alias ps         Get-Process -Option AllScope
Set-Alias pwd        Get-Location -Option AllScope
Set-Alias which      Get-Command -Option AllScope
Set-Alias env        Get-Environment -Option AllScope

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


if ( $isWindows ){
    $PATH = $(ConvertFrom-String -Delimiter ";" ${env:PATH})
} else {
    $PATH = $(ConvertFrom-String -Delimiter ":" ${env:PATH})
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

function ls {
    Get-Childitem
}

function Get-Environment {  # Get-Variable to show all Powershell Variables accessible via $
    if($args.Count -eq 0){
        Get-Childitem env:
    }
    elseif($args.Count -eq 1) {
        Start-Process (Get-Command $args[0]).Source
    }
    else {
        Start-Process (Get-Command $args[0]).Source -ArgumentList $args[1..($args.Count-1)]
    }
}

# function Set-EnvironmentAndPSVariable{
#     if (([Environment]::GetEnvironmentVariable($args[0]))){
#         Set-Variable -Name "$args[0]" -Value ([Environment]::GetEnvironmentVariable("$args[0]"))
#     }
#     else {
#         [Environment]::SetEnvironmentVariable($args[0], $args[1], 'User')
#         Set-Variable -Name $args[0] -Value $args[1]
#     }
# }

# defin these environment variables if not set already and also provide them as PSVariables
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
function cdports { Set-Location "$PORTS_DIR" }

function cf {
    if ($null -ne (Get-Module PSFzf)) {
        Get-ChildItem . -Recurse -Attributes Directory | Invoke-Fzf | Set-Location
    }
    else {
        Write-Host "please install PSFzf"
    }
}

function .. { Set-Location ".." }
function .... { Set-Location (Join-Path -Path ".." -ChildPath "..") }

if ( Test-CommandExists 'git') {

    function git-root {
        $gitrootdir = (git rev-parse --show-toplevel)
        if ($gitrootdir) {
            Set-Location $gitrootdir
        }
    }
    
    if ( $isWindows ){
        function git-bash {
            if ($args.Count -eq 0){
                . $(Join-Path -Path $(Split-Path -Path $(Get-Command git).Source) -ChildPath "..\bin\bash") -l
            } else {
                . $(Join-Path -Path $(Split-Path -Path $(Get-Command git).Source) -ChildPath "..\bin\bash") $args
            }
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
        If($Property){
            # Create Property a set which includes the 'DefaultPropertySet' and Property for the respective 'Value' matched
            $DefaultPropertySet = $PSItem.PSStandardMembers.DefaultDisplayPropertySet.ReferencedPropertyNames
            $TypeName = ($PSItem.PSTypenames)[0]
            Get-TypeData $TypeName |Remove-TypeData
            Update-TypeData -TypeName $TypeName -DefaultDisplayPropertySet ($DefaultPropertySet+$Property |Select-Object -Unique)

            $PSItem | Where-Object {$_.properties.Value -like "$Value"}
        }
    }
}

# https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_functions?view=powershell-7#piping-objects-to-functions
function all {
    process { $_ | Select-Object * }
}

function list {
    process { $_ | Format-List * }
}

function string {
    process { $_ | Out-String -Stream }
}

function grep {
    process { $_ | Select-String -Pattern $args }
}

function help {
    get-help $args[0] | out-host -paging
}

function man {
    get-help $args[0] | out-host -paging
}

function mkdir {
    new-item -type directory -path (Join-Path "$args" -ChildPath "")
}

function md {
    new-item -type directory -path (Join-Path "$args" -ChildPath "")
}

function pause($message="Press any key to continue . . . ") {
    Write-Host -NoNewline $message
    $i=16,17,18,20,91,92,93,144,145,166,167,168,169,170,171,172,173,174,175,176,177,178,179,180,181,182,183
    while ($k.VirtualKeyCode -Eq $Null -Or $i -Contains $k.VirtualKeyCode){
        $k = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
    }
    Write-Host
}

function Install-Chocolatey {
    if (Get-Command choco -errorAction SilentlyContinue)
    {
        write-output "chocolatey already installed!";
    }
    else {
        start-process (Get-HostExecutable) -ArgumentList "-Command Set-ExecutionPolicy Bypass -Scope Process -Force; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'); pause"
    }
}

function choco {
    start-process (Get-HostExecutable) -ArgumentList "-Command choco.exe ${args}; pause"-Verb runAs
}

if (Test-Path("${env:ChocolateyInstall}\helpers\chocolateyProfile.psm1")) {
    Import-Module "${env:ChocolateyInstall}\helpers\chocolateyProfile.psm1"
}

function Reload-Profile {
    . $PROFILE.CurrentUserAllHosts
}

function Download-Latest-Profile {
    Invoke-WebRequest -Uri "https://gist.githubusercontent.com/apfelchips/62a71500a0f044477698da71634ab87b/raw/Profile.ps1" -OutFile "$PROFILE.CurrentUserAllHosts"
    Reload-Profile
}

If ($IsWindows) {
    function isAdmin {
        $user = [Security.Principal.WindowsIdentity]::GetCurrent();
        (New-Object Security.Principal.WindowsPrincipal $user).IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator);
    }

    function subl {
        start-process "${Env:ProgramFiles}\Sublime Text 3\subl.exe" -ArgumentList $args -WindowStyle Hidden # hide subl shim script
    }

    function stree($directory = $pwd) {
        $gitrootdir = (Invoke-Command{Set-Location $args[0]; git rev-parse --show-toplevel 2>&1;} -ArgumentList $directory)

        if ( Test-Path -Path "$gitrootdir\.git" -PathType Container){
            $newestExe = Get-Item "${env:ProgramFiles(x86)}\Atlassian\SourceTree\SourceTree.exe" | select -Last 1
            # Write-Host "Opening $gitrootdir with $newestExe"
            start-process -filepath $newestExe -ArgumentList "-f `"$gitrootdir`" log"
        }
        else {
            Write-Host "git directory not found"
        }
    }
}

function Get-HostExecutable {
    if ($PSVersionTable.PSEdition = "Core") {
        $ConsoleHostExecutable = (get-command pwsh).Source
    }
    else {
        $ConsoleHostExecutable = (get-command powershell).Source
    }
    return $ConsoleHostExecutable
}


# function sudo() # use chocolatey sudo instead
# {
#     if ($args.Length -eq 0)
#     {
#         start-process (get-hostexecutable) -verb "runAs"
#     }
#     if ($args.Length -eq 1)
#     {
#         start-process $args[0] -verb "runAs"
#     }
#     if ($args.Length -gt 1)
#     {
#         start-process $args[0] -ArgumentList $args[1..$args.Length] -verb "runAs"
#     }
# }

# src: http://serverfault.com/questions/95431
function Test-Administrator {
    $user = [Security.Principal.WindowsIdentity]::GetCurrent();
    (New-Object Security.Principal.WindowsPrincipal $user).IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)
}

# src: https://devblogs.microsoft.com/scripting/use-a-powershell-function-to-see-if-a-command-exists/
function Test-CommandExists {
    Param ($command)
    $oldPreference = $ErrorActionPreference
    $ErrorActionPreference = ‘stop’
    try {
        if( Get-Command $command ){
            return $true
        }
    }
    Catch {
        return $false
    }
    Finally {$ErrorActionPreference=$oldPreference}
}

function Clear-SavedHistory { # src: https://stackoverflow.com/a/38807689
  [CmdletBinding(ConfirmImpact='High', SupportsShouldProcess)]
  param()
  $havePSReadline = ($null -ne (Get-Module -EA SilentlyContinue PSReadline))
  $target = if ($havePSReadline) { "entire command history, including from previous sessions" } else { "command history" }
  if (-not $pscmdlet.ShouldProcess($target)){ return }
  if ($havePSReadline) {
        Clear-Host
        # Remove PSReadline's saved-history file.
        if (Test-Path (Get-PSReadlineOption).HistorySavePath) {
            # Abort, if the file for some reason cannot be removed.
            Remove-Item -EA Stop (Get-PSReadlineOption).HistorySavePath
            # To be safe, we recreate the file (empty).
            $null = New-Item -Type File -Path (Get-PSReadlineOption).HistorySavePath
        }
        # Clear PowerShell's own history
        Clear-History
        [Microsoft.PowerShell.PSConsoleReadLine]::ClearHistory()
    }
    else { # Without PSReadline, we only have a *session* history.
        Clear-Host
        Clear-History
    }
}

function Install-PowershellGet {
    start-process (Get-HostExecutable) -ArgumentList "-Command Install-Module -Name PowerShellGet -Repository PSGallery -Force -AllowClobber -SkipPublisherCheck; pause" -verb runAs
}

function Install-MyModules {
    Install-Module PSReadLine -Scope CurrentUser -Repository 'PSGallery' -AllowPrerelease -Force
    Install-Module posh-git -Scope CurrentUser -Repository 'PSGallery' -AllowPrerelease -Force
    Install-Module PSFzf -Scope CurrentUser -Repository 'PSGallery' -Force
}

# if (($host.Name -eq 'ConsoleHost') -and ($null -ne (Get-Module -ListAvailable -Name PowershellGet))) {
#     Import-Module PowershellGet
# }

if (($host.Name -eq 'ConsoleHost') -and ($null -ne (Get-Module -ListAvailable -Name PSReadLine))) {
    # example: https://github.com/PowerShell/PSReadLine/blob/master/PSReadLine/SamplePSReadLineProfile.ps1
    Import-Module PSReadLine

    # Set-PSReadLineOption -EditMode Emac
    Set-PSReadLineKeyHandler -Key Tab -Function MenuComplete

    Set-PSReadLineOption -HistorySearchCursorMovesToEnd
    Set-PSReadLineKeyHandler -Key UpArrow -Function HistorySearchBackward
    Set-PSReadLineKeyHandler -Key DownArrow -Function HistorySearchForward
    Set-PSReadlineKeyHandler -Chord 'Shift+Tab' -Function Complete

    Set-PSReadLineOption -predictionsource history
    if ($null -ne (Get-Module PSFzf)) {
        #Set-PSReadLineKeyHandler -Key Tab -ScriptBlock { Invoke-FzfTabCompletion }
        #$FZF_COMPLETION_TRIGGER='...'
        Set-PsFzfOption -PSReadlineChordProvider 'Ctrl+t' -PSReadlineChordReverseHistory 'Ctrl+r'
    }
}

if (($host.Name -eq 'ConsoleHost') -and ($null -ne (Get-Module -ListAvailable -Name posh-git))) {
    Import-Module posh-git
}

if (Test-CommandExists 'thefuck') {
    function fuck {
        $PYTHONIOENCODING_BKP=$env:PYTHONIOENCODING
        $env:PYTHONIOENCODING="utf-8"
        $history = (Get-History -Count 1).CommandLine;

        if (-not [string]::IsNullOrWhiteSpace($history)) {
            $fuck = $(thefuck $args $history);
            if (-not [string]::IsNullOrWhiteSpace($fuck)) {
                if ($fuck.StartsWith("echo")) { $fuck = $fuck.Substring(5); }
                else { iex "$fuck"; }
            }
        }
        [Console]::ResetColor()
        $env:PYTHONIOENCODING=$PYTHONIOENCODING_BKP
    }
    Set-Alias f fuck -Option AllScope
}

# hacks for old powerhsell versions
if ($PSVersionTable.PSVERSION.Major -lt 7) {
    $PSDefaultParameterValues['Out-File:Encoding'] = 'utf8' # Fix Encoding for PS 5.1 -> 6.0 https://stackoverflow.com/a/40098904

    function Get-ExitBoolean($command) { # fixed: https://github.com/PowerShell/PowerShell/pull/9849
        & $command | Out-Null; $?
    }
    Set-Alias geb   Get-ExitBoolean

    function Use-Default # $var = d $Value : "DefaultValue"  eg ternary # fixed: https://toastit.dev/2019/09/25/ternary-operator-powershell-7/
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
        }
        else {
            $toReturn = $args[$coord -1]
        }
        return $toReturn
    }
    Set-Alias d    Use-Default
}

Write-Host "`$PSVersion: $($PSVersionTable.PSVersion.Major).$($PSVersionTable.PSVersion.Minor).$($PSVersionTable.PSVersion.Patch)"
Write-Host "`$PSEdition: $($PSVersionTable.PSEdition | Out-String -NoNewline)"
Write-Host "`$Profile:   $PSCommandPath"
