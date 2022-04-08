	# https://gist.github.com/aroben/5542538
		$ProcessesById = @{}
		foreach ($Process in (Get-WMIObject -Class Win32_Process)) {
			$ProcessesById[$Process.ProcessId] = $Process
		}
		
		$ProcessesWithoutParents = @()
		$ProcessesByParent = @{}
		foreach ($Pair in $ProcessesById.GetEnumerator()) 
		{
			$Process = $Pair.Value
		
			if (($Process.ParentProcessId -eq 0) -or !$ProcessesById.ContainsKey($Process.ParentProcessId)) {
				$ProcessesWithoutParents += $Process
				continue
			}
		
			if (!$ProcessesByParent.ContainsKey($Process.ParentProcessId)) {
				$ProcessesByParent[$Process.ParentProcessId] = @()
			}
			$Siblings = $ProcessesByParent[$Process.ParentProcessId]
			$Siblings += $Process
			$ProcessesByParent[$Process.ParentProcessId] = $Siblings
		}