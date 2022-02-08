;use what changed to install irfanviewer. then uninstall and just take the file asigning.
;install everything
;bcompare.
;steam.

;all images linked to one hdd

;all sounds ans music to one hdd

;do so for all extensions, question being, would it be extreamly heavy for the storage?
;we copy the full path to the new drive to 

;it would be easier to overview batchprocesses, easier to find duplicates and possible to identify filesm whoere actually the same but due to some minor detale consideed to be different.

;wonder if one could guess file extension while processing the files, like files without filename, the link can be renamed with actual filename after all.
Imports PdfSharp.Drawing
Imports PdfSharp.Pdf
Imports System.Text.RegularExpressions
imports System
imports System.Collections.Generic

param($drive1, $drive2, $drive3)
$diskdata = get-PSdrive $drive1 | Select-Object Used,Free
write-host "$($drive1) has  $($diskdata.Used) Used and $($diskdata.Free) free"
if ($drive2 -ne $null) {
$diskdata = get-PSdrive $drive2 | Select-Object Used,Free
write-host "$($drive2) has  $($diskdata.Used) Used and $($diskdata.Free) free"
    if ($drive3 -ne $null) {
    $diskdata = get-PSdrive $drive3 | Select-Object Used,Free
    write-host "$($drive3) has  $($diskdata.Used) Used and $($diskdata.Free) free"
    }
    else
    { return}
}
else
{return} # don't bother testing for drive3 since we didn't even have 

    function MyFunction(ByVal cmdArgs As String)
		@document = PdfSharp.Pdf.IO.PdfReader.Open(cmdArgs, PdfSharp.Pdf.IO.PdfDocumentOpenMode.Import)
        Console.WriteLine(System.Environment.GetFolderPath(System.Environment.SpecialFolder.ApplicationData))
        @rgx Regex("^[0-9]{16}$")
        @docs PdfDocument) = New List(Of PdfDocument)
        @i = 0
        @p = System.Environment.GetFolderPath(System.Environment.SpecialFolder.ApplicationData) +  "\part{0}.pdf"
   
        For Each rootb In document.Outlines
            
            If rgx.IsMatch(rootb.Title) Then
                @newdoc = New PdfDocument
                @rp = newdoc.AddPage(rootb.DestinationPage)
                @outline = newdoc.Outlines.Add(rootb.Elements.GetString("/Title"), rp, True, PdfOutlineStyle.Bold, XColors.Red)
                @child = rootb.Elements.GetDictionary("/First")
                While child IsNot Nothing
                    @item = child
                    @cp = newdoc.AddPage(item.DestinationPage)
                    outline.Outlines.Add(item.Elements.GetString("/Title"), cp, True)
                    child = child.Elements.GetDictionary("/Next")
                End While
            
                newdoc.Save(String.Format(p, i))
                i += 1
            End if
        Next
	
        End function

