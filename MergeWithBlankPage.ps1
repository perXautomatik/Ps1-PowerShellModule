         
    $emptyPage = "G:\sbf\Livsmiljö\Gemensamt\mapbasic program projekt\MapBasic-Gis_OrganizeEmails\tomtPdfBlad.pdf"
    $path = "C:\Users\crbk01\Desktop\mellersta"
    $i = 1
    $param1 = "C:\Users\crbk01\OneDrive - Region Gotland\PortableApps\cpdf\cpdf.exe"
    $param2 = "-pages"

    dir $path\*.pdf | Sort-Object -Property CreationTime -Descending | foreach-object{   
       

        $param4 = $param1 + ".exe"
        $param3 = $_.FullName
        $param5 = $path + 'merge.pdf'

        $NumberOfPages = &$param1 $param2 $param3
        
        if($NumberOfPages)
        {
            if($i -eq 1) 
            {
                & $param1 $emptyPage $emptyPage -o $param5
            }
        
            $mergesNumberOfpages = & $param1 -pages $param5
            $temp = $NumberOfPages
            $temp %= 2
            Out-Host -InputObject "n $i iF: $NumberOfPages isU: $temp Merg: $mergesNumberOfpages"
        
            if ($temp -eq 1) 
            {
                & $param1 $param5 $_.FullName $emptyPage -o $param5
           
                $afterWhitePage = & $param1 -pages $param5
                Out-Host -InputObject "$afterWhitePage :afterWhitePage"
            } 
            else
            {
                & $param1 $param5 $_.FullName -o $param5
            }
        }

        else
        {
            $_.FullName
        }

        $i = $i + 1

    }                        
   