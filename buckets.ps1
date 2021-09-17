#todo; sort ressult first, right now, doesn't seem to be any specific order in which buckets is inserted or created.
#todo: currently indiscrimatingly distributing every post evenly over number of buckets, rather specifiy a filter for each bucket.
#todo: currenly accepts any form of set. numerical or not, discriminate when quantity param is specified.
#todo: fill buckets denepding on specified quantity param.
#todo; case of both number and size of buckets is set, case of bucket owerflow, consolidate buckets until the largest objects have bin fit into avaible buckets. discard rest.

cd (Split-Path -Path $MyInvocation.MyCommand.Definition -Parent)
. .\SplitIntoBuckets.ps1
 
# Example 2 - Split into buckets of size 15
$buc = (get-process | Group-Object -Property ProcessName | select Name, @{n='Mem';e={[int] ([math]::Round(($_.Group|Measure-Object WorkingSet64 -Sum).Sum / 1MB))}}) | ConvertTo-Buckets -numberOfbuckets 16
$buc 