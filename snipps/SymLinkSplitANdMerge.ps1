mkdir C:\Users\Dator\AppData\LocalLow\ArchBears

Start-Process -FilePath "$env:comspec" -ArgumentList "/k", "mklink", "/j", "C:\Users\Dator\AppData\LocalLow\ArchBears", "E:\Users\Dator\AppData\LocalLow\ArchBears"

dir "C:\Program Files (x86)\Wizards of the Coast\*" -include *.log,*.htm -rec | gc | out-file "E:\ToDatabase\log\Mtga.txt"

$upperBound = 50MB # calculated by Powershell
$ext = "log"
$rootName = "log_"

$reader = new-object System.IO.StreamReader("C:\Exceptions.log")
$count = 1
$fileName = "{0}{1}.{2}" -f ($rootName, $count, $ext)
while(($line = $reader.ReadLine()) -ne $null)
{
    Add-Content -path $fileName -value $line
    if((Get-ChildItem -path $fileName).Length -ge $upperBound)
    {
        ++$count
        $fileName = "{0}{1}.{2}" -f ($rootName, $count, $ext)
    }
}

$reader.Close()