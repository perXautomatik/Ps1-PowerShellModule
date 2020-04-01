chcp 1252
cd /D "G:\sbf"
cd "\Livsmiljö\Miljö- och hälsoskydd\Vatten\Avlopp\Klart Vatten\Fastigheter\GIS"
xcopy "Fastigheter_Sweref.*" "Arbetsskikt\Annat\backup\FlaggbackupFastigheterSweref\batchBackup" /c /r /d /y /i > "Arbetsskikt\Annat\backup\FlaggbackupFastigheterSweref\batchBackup\xcopy.log"

pause

