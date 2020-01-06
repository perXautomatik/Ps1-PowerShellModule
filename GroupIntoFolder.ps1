#https://stackoverflow.com/questions/41467996/powershell-create-a-folder-from-a-file-name-then-place-that-file-in-the-folde

Get-ChildItem -File |  # Get files
  Group-Object { $_.Name -replace '[.][^.]*$' } |  #[(]?\d*[)]?$ folders by nameExceptDigit
  ForEach-Object {
    # Create directory
    $dir = New-Item -Type Directory -Name $_.Name
    # Move files there
    $_.Group | Move-Item -Destination $dir
  }