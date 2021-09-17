function getChildrenRecursive {   
    param(
        [Parameter(Mandatory=$true,ValueFromPipeline=$true)][PSCustomObject] $object,       
        [Parameter(Mandatory=$true,ValueFromPipeline=$true)][string] $pMethodPath,
        [Parameter(Mandatory=$false)][int32] $depth
      )
      if($depth -eq $null) {$depth = 0}
      
      $str = '-' * $depth
      $s

    foreach ($item in $object.PSObject.Properties) {
            if($item.Value.children) {
                if ($item.TypeNameOfValue -eq 'System.Object') {

                $depth = 1+$depth                            
                                                        
                getChildrenRecursive $item.Value.children $pMethodPath $depth   
                }
            }
            $item
        }

 
}