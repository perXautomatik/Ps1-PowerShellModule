	param([UInt32]$ProcessId, $IndentLevel) 
	$Process = $ProcessesById[$ProcessId]
	$Indent = " " * $IndentLevel
	if ($Process.CommandLine) {
		$Description = $Process.CommandLine
	} else {
		$Description = $Process.Caption
	}

	Write-Output ("{0,6}{1} {2}" -f $Process.ProcessId, $Indent, $Description)

	foreach ($Child in ($ProcessesByParent[$ProcessId] | Sort-Object CreationDate)) {
		Show-ProcessTree $Child.ProcessId ($IndentLevel + 4) }
	
	Write-Output ("{0,6} {1}" -f "PID", "Command Line")
	Write-Output ("{0,6} {1}" -f "---", "------------")

	foreach ($Process in ($ProcessesWithoutParents | Sort-Object CreationDate)) {
		Show-ProcessTree $Process.ProcessId 0
	}