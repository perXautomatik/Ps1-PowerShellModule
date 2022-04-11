function Update-Packages {
	# Python 直接执行
	#$env:PATHEXT += ";.py"
	# 更新系统组件
	# update pip
	# Write-Host "Step 1: 更新 pip" -ForegroundColor Magenta -BackgroundColor Cyan
	# $a = pip list --outdated
	# $num_package = $a.Length - 2
	# for ($i = 0; $i -lt $num_package; $i++) {
	# 	$tmp = ($a[2 + $i].Split(" "))[0]
	# 	pip install -U $tmp
	# }

	# update conda
	Write-Host "Step 1: 更新 Anaconda base 虚拟环境" -ForegroundColor Magenta -BackgroundColor Cyan
	conda activate base
	conda upgrade python

	# update TeX Live
	$CurrentYear = Get-Date -Format yyyy
	Write-Host "Step 2: 更新 TeX Live" $CurrentYear -ForegroundColor Magenta -BackgroundColor Cyan
	tlmgr update --self
	tlmgr update --all

	# update Chocolotey
	# Write-Host "Step 3: 更新 Chocolatey" -ForegroundColor Magenta -BackgroundColor Cyan
	# choco outdated

	# update Apps using winget
	Write-Host "Step 3: 通过 winget 更新 Windows 应用程序" -ForegroundColor Magenta -BackgroundColor Cyan
	winget upgrade
	winget upgrade --all

}
