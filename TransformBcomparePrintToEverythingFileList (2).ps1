#
#  1 - read in columns of
#
# Read in data
#  2 - remove top 12 rows  

#(Measure-Command ).TotalSeconds
$inputx = [System.IO.File]::ReadLines('X:\ToDatabase\Files\''L D B S E T T''files.txt') | Select-Object -Skip 12 # | Select-Object -first 10 
  
$outputx  = $inputx | ForEach-Object {
    $hash  = @{
        Filename= '\\192.168.0.30\' + ($_ -split "[ ]{1,}")[0] 
        Size=($_ -split "[ ]{1,}")[1]
        'Date Modified'= ($_ -split "[ ]{1,}")[2]
        'Date Created'= ($_ -split "[ ]{1,}")[3]
        Attributes= ($_ -split "[ ]{1,}")[4]
        }
        New-Object PSObject -Property $hash
}

$outputx | Select-Object -property Filename, Size, 'Date Modified', 'Date Created', Attributes | Export-Csv  -Delimiter ',' -Path "X:\ToDatabase\Files\BcompareFileList.efu" -NoTypeInformation 
# Save as csv file # need powershell vers 7.x -QuoteFields "Filename"

