
Function Get-Something {[CmdletBinding()] param([Parameter(ValueFromPipeline)][pscustomobject]$Thing)
process{

$hash = $null

$hash = @{}

$proc = ((Get-Content -Path $Thing | ConvertFrom-Json | select state).state | Convertfrom-Json).tabGroups

 $ressult = @()

foreach ($p in $proc)

{

 $hash.add($p.createDate,$p.tabsmeta)

}

foreach ($p in $hash.GetEnumerator())
{
$creationDate = $p.key
foreach ($v in $p.value)
{
 $ressult += [pscustomobject] @{ creationDate = $creationDate; title = $v.title ; url = $v.url}
}

}


;
$ressult
}}

get-something 'E:\Google Drive\Downloads\thot kute.json'





#to add adress column
Function Get-Something 
{
         [CmdletBinding()] param([Parameter(ValueFromPipeline)][pscustomobject]$Thing)
process{ ((Get-Content -Path $Thing | ConvertFrom-Json | select state).state | Convertfrom-Json).tabGroups | %{[pscustomobject] @{ creationDate = $_.creationDate; tabsmeta = $_.tabsmeta}} | forEach-object($_.tabmeta) {%{[pscustomobject] @{title = $_.title; creationDate = $_.createDate; url = $_.url}}}

        }
 } 



 get-something 'E:\Google Drive\Downloads\thot kute.json' 
#to add adress column



#to add adress column
Function Get-Something 
{
         [CmdletBinding()] param([Parameter(ValueFromPipeline)][pscustomobject]$Thing)
process{ $tabgroups=((Get-Content -Path $Thing | ConvertFrom-Json | select state).state | Convertfrom-Json).tabGroups ;
            $result = @();
         $set = @(foreach($creationDate in $tabgroups.createDate){[pscustomobject] @{ creationDate = $creationDate; tabsmeta = $tabgroups.tabsmeta}}) 

         $result = @(foreach($element in $set.tabsmeta){[pscustomobject] @{ title = $element.title; creationDate = $set.createDate; url = $element.url}}) ; $result 
        }
 } 



 get-something 'E:\Google Drive\Downloads\thot kute.json' 
#to add adress column


Invoke-Command -ScriptBlock 
{@{title=Extensions - OneTab; url=chrome://extensions/?id=chphlpgkkbolifaimnlloiipkdnihall; id=6YLMW5NfJhHgi2gNhqNSh1}}
  -ArgumentList *

Invoke-Command $i

$q ={@{r=r d;t=f}}

$q 


($q).GetEnumerator() | ForEach-Object{
    Write-Output "Key = $($_.key)"
    Write-Output "Value = $($_.value)"
    }


$q | ConvertFrom-Json

$q | ConvertFrom-StringData


$q | convertfrom-json


$hash = ($q)[0]

$hash | convertto-json

$hash | convertfrom-string



$hash | %{$_.r}

Import-LocalizedData $hash


ConvertFrom-StringData $hash

$hash.count

$ressult 
# https://powersnippets.com/union-object/

for-each json in path
{
    $temp = get-something(json)

    -join $temp, $ressult  
}


$ressult | Export-Csv -Path $item + 'csv' -Delimiter ';' -NoTypeInformation



Function Union-Object ([String[]]$Property = @()) {             # https://powersnippets.com/union-object/
    
    $Objects = $Input | ForEach {$_}                            # Version 02.00.01, by iRon
    
    If (!$Property) {ForEach ($Object in $Objects) {$Property += $Object.PSObject.Properties | Select -Expand Name}}
    $Objects | Select ([String[]]($Property | Select -Unique))
} Set-Alias Union Union-Object


<Object[]> | Union-Object [[-Property] <String[]>]