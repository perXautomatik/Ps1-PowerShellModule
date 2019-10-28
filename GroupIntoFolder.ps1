#https://stackoverflow.com/questions/41467996/powershell-create-a-folder-from-a-file-name-then-place-that-file-in-the-folde

$path = 'C:\Users\crbk01\OneDrive - Region Gotland\Till Github\PowerShell and bash'

 dir $path\*.* | Group-Object -Property extension -AsHashTable 

   # Get files
 # Group-Object {$_.fullname} |  # Group by part before first underscore