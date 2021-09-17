function getChildrenRecursive {   
    param(
        [Parameter(Mandatory=$true,ValueFromPipeline=$true)][PSCustomObject] $object,       
        [Parameter(Mandatory=$true,ValueFromPipeline=$true)][string] $pMethodPath
      )
    
    Invoke-Command -FilePath $pMethodPath -InputObject $object 

    $children = @($object.children)
   if ($children.count -gt 0) {
        foreach ($child in $children) {        
            getChildrenRecursive $child $pMethodPath
            }
        }

    }