function getChildrenRecursive {   
    param(
        [Parameter(Mandatory=$true,ValueFromPipeline=$true)][PSCustomObject] $object,       
        [Parameter(Mandatory=$true,ValueFromPipeline=$true)][string] $pMethodPath,
        [Parameter(Mandatory=$false)][int32] $depth
      )

      if($depth -eq $null) {$depth = 0}
      $str = '-' * $depth;        

      $q = $object.Value

      foreach ($item in $q)
      {
          $item
      }

}