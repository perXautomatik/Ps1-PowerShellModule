cd "E:\OneDrive - Region Gotland\PortableApps\5. image\PortableApps\geosetter\tools\"


$set1 = .\exiftool.exe -a -u -g1  "E:\Pictures\Badges & Signs & Shablon Art\00 - soulcripple front (2).jpg"

$set2 = .\exiftool.exe -a -u -g1  "E:\Pictures\Badges & Signs & Shablon Art\00 - soulcripple front.jpg"

Compare-Object $set1 $set2 | select -ExpandProperty inputobject