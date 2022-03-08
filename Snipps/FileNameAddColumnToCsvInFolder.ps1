Set-PSDebug -Trace 2
get-childItem | foreach {

$fileName = $_
$input = Import-Csv -Delimiter ';' $fileName

ForEach ($line in $input) {
    Add-Member -InputObject $line -NotePropertyName "FileName" -NotePropertyValue $fileName
}

$input # here I get the information

$input | Export-Csv -Delimiter ';' $fileName -NoTypeInformation -Encoding Unicode 
}