
# this is just a trimmed-down, robocopy-only version of this:
# https://github.com/gangstanthony/PowerShell/blob/master/Get-Files.ps1

# a note about: $dir = '"' + $dir + ' "'
# https://stackoverflow.com/a/30244061/4589490

function Get-Files
{
    [cmdletbinding()]
    param
    (
        [parameter(ValueFromPipeline=$true)]
        [string[]]$Path = $PWD,
        [string[]]$Include,
        [string[]]$ExcludeDirs,
        [string[]]$ExcludeFiles,
        [switch]$Recurse,
        [switch]$FullName,
        [switch]$Directory,
        [switch]$File
    )
    
    if ($Directory -and $File)
    {
        throw 'Cannot use both -Directory and -File at the same time.'
    }

    $Path = (Resolve-Path $Path).ProviderPath

    function CreateFolderObject
    {
        $name = ''
        $name += $(Split-Path $matches.FullName -Leaf)
        Write-Output $(New-Object psobject -Property @{
            FullName = $matches.FullName
            DirectoryName = $($matches.FullName.substring(0, $matches.fullname.lastindexof('\')))
            Name = $name.ToString()
            Size = $null
            Extension = '[Directory]'
            DateModified = $null
        })
    }

    $params = '/L', '/NJH', '/BYTES', '/FP', '/NC', '/TS', '/R:0', '/W:0'
    if ($Recurse) {$params += '/E'}
    if ($Include) {$params += $Include}
    if ($ExcludeDirs) {$params += '/XD', ('"' + ($ExcludeDirs -join '" "') + '"')}
    if ($ExcludeFiles) {$params += '/XF', ('"' + ($ExcludeFiles -join '" "') + '"')}

    foreach ($dir in $Path)
    {
        if ($dir.contains(' '))
        {
            $dir = '"' + $dir + ' "'
        }

        foreach ($line in $(robocopy $dir 'c:\tmep' $params))
        {
            # folder
            if (!$File -and $line -match '\s+\d+\s+(?<FullName>.*\\)$')
            {
                if ($Include)
                {
                    if ($matches.FullName -like "*$($include.replace('*',''))*")
                    {
                        if ($FullName)
                        {
                            Write-Output $( $matches.FullName )
                        }
                        else
                        {
                            Write-Output $( CreateFolderObject )
                        }
                    }
                }
                else
                {
                    if ($FullName)
                    {
                        Write-Output $( $matches.FullName )
                    }
                    else
                    {
                        Write-Output $( CreateFolderObject )
                    }
                }
            }
            # file
            elseif (!$Directory -and $line -match '(?<Size>\d+)\s(?<Date>\S+\s\S+)\s+(?<FullName>.*[^\\])$')
            {
                if ($FullName)
                {
                    Write-Output $( $matches.FullName )
                }
                else
                {
                    $name = Split-Path $matches.FullName -Leaf
                    Write-Output $(New-Object psobject -Property @{
                        FullName = $matches.FullName
                        DirectoryName = Split-Path $matches.FullName
                        Name = $name
                        Size = [int64]$matches.Size
                        Extension = $(if ($name.IndexOf('.') -ne -1) {'.' + $name.split('.')[-1]} else {'[None]'})
                        DateModified = $matches.Date
                    })
                }
            }
        }
    }
}
