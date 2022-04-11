function Clear-SavedHistory { # src: https://stackoverflow.com/a/38807689
    [CmdletBinding(ConfirmImpact='High', SupportsShouldProcess)]
    param()
        $havePSReadline = ( $null -ne   $(Get-Module PSReadline -ea SilentlyContinue) )
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
