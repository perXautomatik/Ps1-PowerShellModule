function getChildrenRecursive ($object) {
   $children = @($object.children)
   $children
   if ($children.count -gt 0) {
        foreach ($child in $children) {
            getChildrenRecursive $child
            }
        }
    }