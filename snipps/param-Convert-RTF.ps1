$Comments = @' 
Script name: Convert-RTF.ps1 
Created on: 2007-02-14 
Author: Kent Finkle 
Purpose: How Can I Use Windows PowerShell to Convert 1,000 .RTF Files to Word Documents? 
'@ 
 
$wdFormatDocument = 0 
 
$objWord = New-Object -comobject Word.Application  
$objWord.Visible = $True  
$objDoc = $objWord.Documents.Add() 
 
$colFiles = gci($param[0]) 
 
foreach ($objFile in $colFiles) 
{ 
    $strFile = $objFile.FullName
    $strNewFile = $objFile.DirectoryName + "\" 
        + $objFile.Name.Split(".")[0] + ".doc" 
    $objDoc = $objWord.Documents.Open($strFile, $False) 
    $a = $objDoc.SaveAs([ref] $strNewFile, [ref] $wdFormatDocument) 
    $objDoc.Close() 
} 
 
$a = $objWord.Quit() 