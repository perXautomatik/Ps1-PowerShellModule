    function exec-script ($file, $func, $parm) {
       
       . $file    
       
       $x = (& $func $parm)
       
       $x
        
       }
    
    exec-script -file ".\Hello" -func "Hello" -parm "World"