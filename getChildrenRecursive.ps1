function getChildrenRecursive {   
    param(
        [Parameter(Mandatory=$true,ValueFromPipeline=$true)][PSCustomObject] $object,       
        [Parameter(Mandatory=$true,ValueFromPipeline=$true)][string] $pMethodPath,
        [Parameter(Mandatory=$false)][int32] $depth
      )
    
    if($depth -eq $null) {$depth = 0}
    $s = '-' * $depth + $object      
    $s.substring(0, [System.Math]::Min(15, $s.Length))
    $children = @($object.children)

    $object
    $children.count

   if ($children.count -gt 0) {
    $depth = 1+$depth
        foreach ($child in $children) {   
            if ($child) {  
                $s = '-' * $depth + $child                         
                $s.substring(0, [System.Math]::Min(15, $s.Length))
                getChildrenRecursive $child $pMethodPath $depth
            }
        }

    }
}