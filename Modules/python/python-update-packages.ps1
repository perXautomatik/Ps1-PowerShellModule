		# Python ????
		#$env:PATHEXT += ";.py"
		# ??????
		# update pip
		# Write-Host "Step 1: ?? pip" -ForegroundColor Magenta -BackgroundColor Cyan
		# $a = pip list --outdated
		# $num_package = $a.Length - 2
		# for ($i = 0; $i -lt $num_package; $i++) {
			# 	$tmp = ($a[2 + $i].Split(" "))[0]
			# 	pip install -U $tmp
	# }
	
	# update conda
	Write-Host "Step 1: ?? Anaconda base ????" -ForegroundColor Magenta -BackgroundColor Cyan
	conda activate base
	conda upgrade python
	
	# update TeX Live
	$CurrentYear = Get-Date -Format yyyy
	Write-Host "Step 2: ?? TeX Live" $CurrentYear -ForegroundColor Magenta -BackgroundColor Cyan
	tlmgr update --self
	tlmgr update --all
	
	# update Chocolotey
	# Write-Host "Step 3: ?? Chocolatey" -ForegroundColor Magenta -BackgroundColor Cyan
	# choco outdated
	
	# update Apps using winget
	Write-Host "Step 3: ?? winget ?? Windows ????" -ForegroundColor Magenta -BackgroundColor Cyan
	winget upgrade
	winget upgrade --all