cd 'C:\Users\crbk01\OneDrive - Region Gotland\Till Github\Mapinfo\MapInfoTabToCsv'
ls *.mb | ForEach-Object{ sc $_ -encoding utf8 -value(gc $_)}