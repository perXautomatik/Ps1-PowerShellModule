# Grab the current background and pick the new one
$BGPath = "C:\Users\crbk01\Desktop"
$CurrentBG = Get-Item (Join-Path $BGPath -ChildPath 'DittoDatabase.db')
$NewBG     = Get-ChildItem $BGPath -Filter *.db -Exclude $CurrentBG.Name |Get-Random
# Store the current name of the new background in a variable
$NewBGName = $NewBG.Name


# Now comes the swap operation
# 1. Rename old file to something completely random, but keep a reference to it with -PassThru
$OldBG = $CurrentBG |Rename-Item -NewName $([System.IO.Path]::GetRandomFileName()) -PassThru

# 2. Rename new file to proper name
$NewBG |Rename-Item -NewName 'backgrounddefault.jpg'

# 3. And finally rename the old background back to the name previously used by the new background
$OldBG |Rename-Item -NewName $NewBGName