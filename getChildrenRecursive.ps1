function getChildrenRecursive {   
    param(
        [Parameter(Mandatory=$true,ValueFromPipeline=$true)][PSCustomObject] $object,       
        [Parameter(Mandatory=$true,ValueFromPipeline=$true)][string] $pMethodPath,
        [Parameter(Mandatory=$false)][int32] $depth
      )
    
    if($depth -eq $null) {$depth = 0}
    
    $json = [ordered]@{}
    $object
    ($object).PSObject.Properties |
        ForEach-Object { $json[$_.Name] = $_.Value }
        
        $json.SyncRoot
    $children = $json.SyncRoot
    

   if ($children.count -gt 0) {
    $depth = 1+$depth
        foreach ($child in $children) {   
            $child
            if ($child) {  
                $s = '-' * $depth + $child                         
                $s.substring(0, [System.Math]::Min(20, $s.Length))
                getChildrenRecursive $child $pMethodPath $depth
            }
        }

    }


}