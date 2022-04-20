          # https://powersnippets.com/union-object/

$List = @(
    New-Object PSObject -Property @{Id = 2; Name = $Null}
    New-Object PSObject -Property @{Id = 1}
    New-Object PSObject -Property @{Id = 3; Name = "Test"}
)


Function Union-Object ([String[]]$Property = @()) {             # https://powersnippets.com/union-object/
    $Objects = $Input | ForEach {$_}                            # Version 02.00.01, by iRon
    If (!$Property) {ForEach ($Object in $Objects) {$Property += $Object.PSObject.Properties | Select -Expand Name}}
    $Objects | Select ([String[]]($Property | Select -Unique))
} Set-Alias Union Union-Object


<Object[]> | Union-Object [[-Property] <String[]>]