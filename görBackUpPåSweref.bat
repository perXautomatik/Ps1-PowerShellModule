cd /D "G:\sbf\Livsmilj”\Milj”- och h„lsoskydd\Vatten\Avlopp\Klart Vatten\Fastigheter\GIS"
mkdir "Arbetsskikt\Annat\backup\FlaggbackupFastigheterSweref\batchBackup\%date:~%"
xcopy "Fastigheter_Sweref.*" "Arbetsskikt\Annat\backup\FlaggbackupFastigheterSweref\batchBackup\%date:~%" /c /r /v /y > "Arbetsskikt\Annat\backup\FlaggbackupFastigheterSweref\batchBackup\%date:~%\xcopy.log" 

cd /D "C:\Program Files\MapInfo\Professional"

start MapInfoPro.exe

exit