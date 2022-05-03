	out-null -InputObject( git remote -v | Tee-Object -Variable proc ) ;
	%{$proc -split '\n'} |
	 %{ $properties = $_ -split '[\t\s]';
	$remote = try{ 
		New-Object PSObject -Property @{ 
			name = $properties[0].Trim();
			url = $properties[1].Trim();  
			type = $properties[2].Trim() }
		 } catch {'noRemote'} ;	
	$remote | select-object -first 1 | select url}
