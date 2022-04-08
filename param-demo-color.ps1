
#demo-color.ps1

# Jeffery Hicks
# http://jdhitsolutions.com/blog
# follow on Twitter: http://twitter.com/JeffHicks
# 
# "Those who forget to script are doomed to repeat their work."

Param(
[switch]$ListOnly,
[switch]$combo)

#enumerate color options for the current console
$colors=[System.Enum]::GetNames([System.ConsoleColor])

if ($ListOnly) {
    #display a sorted list of colors
    $colors | Sort
}
Else {
    #Demo color samples
    Clear-Host

    if ($combo) { #cycle through all background and foreground combinations
     for ($i=0;$i -lt $colors.count;$i++) { 
         for ($j=0;$j -lt $colors.count;$j++) {
            if ($colors[$i] -ne $colors[$j]) {
                $msg="{0} on {1}" -f $colors[$i],$colors[$j]
                Write-Host $msg -foregroundcolor $colors[$i] -backgroundcolor $colors[$j]
            } #if
        } #for $j
     } #for $i
    } #if $combo
    else {
        #show the list of colors
        for ($i=0;$i -lt $colors.count;$i++) { 
            Write-Host " $($colors[$i])   " -BackgroundColor $colors[$i]
        } #for
    } #else
} #else no $ListOnly

#EOF