param ( 
	$path = "C:\Users\crbk01\Desktop\Ny mapp\Södra"
	$cpdfExecutable = "C:\Users\crbk01\Desktop\cpdf"
)
$result = @()

	dir $path\*.pdf | foreach-object{
		 $NumberOfPages = & $cpdfExecutable -pages $_.FullName
		 $details = @{
		 NumberOfPages = $NumberOfPages 
		 Name = $_.Name
		 }
		 $result += New-Object PSObject -Property $details 
	}
	$result
	$result | export-csv -Path $path\pdf.csv

echo "saved @ $path\pdf.csv file"