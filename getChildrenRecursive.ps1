function getChildrenRecursive {   
    param(
        [Parameter(Mandatory=$true,ValueFromPipeline=$true)][PSCustomObject] $object,       
        [Parameter(Mandatory=$true,ValueFromPipeline=$true)][string] $pMethodPath,
        [Parameter(Mandatory=$false)][int] $depth
      )
   
     & $pMethodPath $cmd
if($depth -eq $null)
    {$depth = 0}
$depth
   $depth = 1+$depth
 
   $children = @($object.children)

   if ($children.count -gt 0) {
        foreach ($child in $children) {   
            if ($child) {                
            getChildrenRecursive $child $pMethodPath $depth
        }
            }
        }

    }