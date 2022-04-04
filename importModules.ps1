


#------------------------------- Credit to : apfelchips -------------------------------

    # https://docs.microsoft.com/en-us/powershell/scripting/gallery/installing-psget
    if ( $PSVersionTable.PSVersion.Major -lt 7 ) {
    function Install-PowerShellGet { Start-Process "$(Get-HostExecutable)" -ArgumentList "-noProfile -noLogo -Command Install-PackageProvider -Name NuGet -Force; Install-Module -Name PowerShellGet -Repository PSGallery -Force -AllowClobber -SkipPublisherCheck; pause" -verb "RunAs"}
    }
       
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

    PowerShellGet\Install-Module -Name Pscx  -Scope CurrentUser -Force -AllowClobber
    PowerShellGet\Install-Module -Name SqlServer -Scope CurrentUser -Force -AllowClobber

    if ( $IsWindows ){
        # Windows Update CLI tool http://woshub.com/pswindowsupdate-module/#h2_2
        # Install-WindowsUpdate -MicrosoftUpdate -AcceptAll -AutoReboot
        # native alternative: WindowsUpdateProvider\Install-WUUpdates >= Windows Server 2019
        PowerShellGet\Install-Module -Name PSWindowsUpdate -Scope CurrentUser -Force -AllowClobber
    }
}

if (!( ""-eq "${env:ChocolateyInstall}"  ))  {     
      TryImport-Module "${env:ChocolateyInstall}\helpers\chocolateyProfile.psm1" 
    }




function Import-MyModules {
    TryImport-Module PSProfiler
    TryImport-Module hashdata
    TryImport-Module WFTools
    TryImport-Module AzureAD
    TryImport-Module SqlServer
    TryImport-Module PSWindowsUpdate    
    TryImport-Module echoargs ;    #ps ecoArgs;
    TryImport-Module pscx   #pscx history;
    
    # 设置 PowerShell 主题
   # 引入 ps-read-line # useful history related actions      
   # example: https://github.com/PowerShell/PSReadLine/blob/master/PSReadLine/SamplePSReadLineProfile.ps1
   if ( ($host.Name -eq 'ConsoleHost') -and ($null -ne (Get-Module -ListAvailable -Name PSReadLine)) ) {
 	    TryImport-Module PSReadLine

	    #-------------------------------  Set Hot-keys BEGIN  -------------------------------
    
	    # Set-PSReadLineOption -EditMode Emac
    
	    # 每次回溯输入历史，光标定位于输入内容末尾
	    Set-PSReadLineOption -HistorySearchCursorMovesToEnd

	    # 设置 Tab 为菜单补全和 Intellisense
	    
	    Set-PSReadLineKeyHandler -Key "Tab" -Function MenuComplete
    	    Set-PSReadlineKeyHandler -Chord 'Shift+Tab' -Function Complete       
   	    # 设置 Ctrl+d 为退出 PowerShell
	    Set-PSReadlineKeyHandler -Key "Ctrl+d" -Function ViExit

	    # 设置 Ctrl+z 为撤销
	    Set-PSReadLineKeyHandler -Key "Ctrl+z" -Function Undo

	    # 设置向上键为后向搜索历史记录 # Autocompletion for arrow keys @ https://dev.to/ofhouse/add-a-bash-like-autocomplete-to-your-powershell-4257
	    Set-PSReadLineKeyHandler -Key UpArrow -Function HistorySearchBackward
	    Set-PSReadLineKeyHandler -Key DownArrow -Function HistorySearchForward

	    #-------------------------------  Set Hot-keys END    -------------------------------

	    if ( $(Get-Module PSReadline).Version -ge 2.2 ) {
	        # 设置预测文本来源为历史记录
	        Set-PSReadLineOption -predictionsource history -ea SilentlyContinue
	    }

	    if ( $(Get-Module PSFzf) -ne $null ) {
	        #Set-PSReadLineKeyHandler -Key Tab -ScriptBlock { Invoke-FzfTabCompletion }
	        #$FZF_COMPLETION_TRIGGER='...'
	        Set-PsFzfOption -PSReadlineChordProvider 'Ctrl+t' -PSReadlineChordReverseHistory 'Ctrl+r'
	    }
}
	# 引入 posh-git
	if ( ($host.Name -eq 'ConsoleHost') -and ($null -ne (Get-Module -ListAvailable -Name posh-git)) ) { TryImport-Module posh-git }      
	# 引入 oh-my-posh
	TryImport-Module oh-my-posh
}

# Set-PoshPrompt ys
#Set-PoshPrompt paradox
Add-Type -Path "C:\Users\crbk01\AppData\Local\GMap.NET\DllCache\SQLite_v103_NET4_x64\System.Data.SQLite.DLL"
echo "modules imported"