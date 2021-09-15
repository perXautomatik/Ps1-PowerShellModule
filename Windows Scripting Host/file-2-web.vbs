' iMacros File-2-Web Script
' (c) 2008-2013 iOpus Software 

Option Explicit

Dim message
message = "This script demonstrates how to read data from the <address.csv> text file in the /datasource directory using"
message = message + " iMacros DATASOURCE features. In other words, the macro reads the data directly,"
message = message + " this script is only responsible for the loop over the data. This is similar to pressing the LOOP button,"
message = message + "but offers more flexibility e. g. when the number of records is unknown. The script uses the macro <wsh-file-2-web.iim>." + vbCrLf + VbCrLf 
message = message + "Tip: This script has the same function as <file-2-web-method2.vbs> but uses a different method."

' find current folder
Dim myname, mypath
myname = WScript.ScriptFullName
mypath = Left(myname, InstrRev(myname, "\"))

Dim iim1, i, iret

set iim1= CreateObject ("imacros")

iret = iim1.iimOpen("")
if iret < 0 then MsgBox "Error during Initialization. Error code: "+cstr (iret)

iret = iim1.iimDisplay("Submitting Data")
if iret < 0 then MsgBox "Error iimDisplay. Error code: "+cstr (iret)

'Note: The input file name is specified in the macro
'You can also specify it inside the script with "iimSet"

'Loop through the input file until end
'We start at "2" to skip the first header line in the file
i = 2
while iret <> -1240                  ' at end of input file, iMacros stops with error -1240
   'Set the current read position
   iret = iim1.iimSet("line", cstr(i))

   'Run the macro
   iret = iim1.iimPlay(mypath & "Macros\wsh-file-2-web.iim")

'Check if user wants to stop
if (iret = - 102) Or (iret = -101) Then
    MsgBox "Stopped by user"
    WScript.Quit(iret)
End If 
  i = i + 1
wend

iret = iim1.iimDisplay("Done!")
iret = iim1.iimClose
WScript.Quit(iret)
