function getChildrenRecursive {   
    param(
        [Parameter(Mandatory=$true,ValueFromPipeline=$true)][PSCustomObject] $object,       
        [Parameter(Mandatory=$true,ValueFromPipeline=$true)][string] $pMethodPath,
        [Parameter(Mandatory=$false)][int32] $depth
      )

        
      
        'presenting' 
        $json = [ordered]@{}
        
        ($object).PSObject.Properties |
            ForEach-Object { $json[$_.Name] = $_.Value }
        
        $json.SyncRoot

      if($depth -eq $null) {$depth = 0}
      
      $str = '-' * $depth
      
    foreach ($item in $object.PSObject.Properties) {
            if ($item.TypeNameOfValue -eq 'System.Object') {    
                if($item.Value.children) {
                $depth = 1+$depth                                                                                    
                getChildrenRecursive $item.Value.children $pMethodPath $depth   
                }
            }
            else {
                $json
            }           
        }
        

 
}