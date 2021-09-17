function getChildrenRecursive ($object,$presentationMethod) {   
   & $presentationMethod $object
    $children = @($object.children)
   if ($children.count -gt 0) {
        foreach ($child in $children) {
            getChildrenRecursive $child $presentationMethod
            }
        }
    }