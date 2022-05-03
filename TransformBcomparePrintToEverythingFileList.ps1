#
#  1 - read in columns of
#
# Read in data


#  2 - remove top 12 rows  

$inputx = ( Get-Content -ReadCount 10000 -path 'X:\ToDatabase\Files\''L D B S E T T''files.txt'  ) | Select-Object -Skip 12 | Select-Object -first 10 | ConvertTo-Csv -Delimiter `t

#  - "" arround first column
#Left Orphan Files (1315753) Size          Modified            Attr
#  -
$inputx

$outputx = $inputx | 
    Select-Object @{@($_.PSObject.Properties)[1]={[string]$_."Filename"}},
        @{@($_.PSObject.Properties)[2]={[string]$_."Size"}},
        @{@($_.PSObject.Properties)[3]={[string]$_."Date Modified"}},
        @{@($_.PSObject.Properties)[4]={[string]$_."Date Created"}},
        @{@($_.PSObject.Properties)[5]={[string]$_."Attributes"}};



#  3 - append \\19.. before path column
$outputx | Format-Table @{Label="Filename"; Expression={'"\\192.168.0.30\' + $_.Filename + '"'}} | Export-Csv -NoTypeInformation -Path "X:\ToDatabase\Files\BcompareFileList.efu" -Delimiter ','

# Save as csv file

