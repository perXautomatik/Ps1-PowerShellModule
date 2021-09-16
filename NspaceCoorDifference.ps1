#The function/method/code above will calculate the distance in n-dimensional space. a and b are arrays of 
#floating point number and have the same length/size or simply the n. Since you want a 4-dimension, you
# simply pass a 4-length array representing the data of your 4-D vector.


#ndistance

Param(
[float]$a,
[float]$b)

    [float] $total = 0
    [float]  $diff = 0;
    
    for ($i = 0; $i -lt $a.length; $i++) {
        $diff = $b[$i] - $a[$i];
        $total += $diff * $diff;
    }
    [float] [Math]::sqrt($total);
