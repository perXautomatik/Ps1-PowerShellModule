function RecurseX {[CmdletBinding()] param([Parameter(ValueFromPipeline)][pscustomobject]$Thing)
process{
    $size = 0;
     try { $children = Get-ChildItem "$FOLDER" 
           

    $children | Where-Object {$_.Attributes.ToString() -NotLike "*ReparsePoint*"} | ForEach  {        
		$item = $_
        
        try {
            $FULLNAME=$ITEM.FullName         
            If ($test = $FULLNAME -ne $FOLDER) {
                try { 
                    if (!(Test-Path $FULLNAME -PathType Container)){
			            $size += $ITEM.Length
		            } else {   
                        $ress = RecurseX "$FULLNAME"
				        $size = $size + $ress
			        } 
                 }
                catch { Write-Output " $Tab inner1@ $ress $size $FULLNAME : $($PSItem.ToString())" }
                }
        }
        catch { Write-Output " $Tab  second@ $size $FULLNAME : $($PSItem.ToString())" }
                                                                                                }
 }
     catch { Write-Output " $Tab thies@ $size $FULLNAME : $($PSItem.ToString())"
               <#Write-Output ($PSItem.InvocationInfo | Format-List) #>
               
            }
     
 } end {
    $toPrint = $size
    
    Write-Output $size
	Write-Host "$folder$Tab$toPrint"
	return $size }
}