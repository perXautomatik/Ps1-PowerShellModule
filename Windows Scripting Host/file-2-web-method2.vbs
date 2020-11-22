' iMacros File-2-Web-Method2 Script
' (c) 2008-2013 iOpus Software 

Option Explicit

Dim message
message = "This script demonstrates how to read data from a simple text file and submit this information to a website."
message = message + " It reads from the file <IIM-TEST-SUBMIT.CSV>  and uses the macro <wsh-submit-2-web.iim>." + vbCrLf + VbCrLf 
message = message + "Tip: This script has the same function as <database-2-web.vbs> but uses a text file instead of a database as input." + vbCrLf + VbCrLf 
message = message + "Note: If you change the file name of the input text file, you also need to change it in the <schema.ini> file."


'Tip: For more information on the method used here
'search for "Text File Driver" and "Schema.ini" in any search engine

'Note: On some language versions of Windows (e.g. German (Deutsch)) CSV data is separated by semicolons (;)
'and not a comma (,). This this case you need to replace all "," by ";" in the input file ("iimsubmit.csv")


Dim rs, sDir, strConnect
Dim iim1, iret

set rs = createobject("ador.recordset")

'Note for x64 users: You must start the VBS script in 32bit mode (C:\Windows\SysWOW64\wscript.exe) for the Microsoft ODBC Driver to work
'Please see the note about VBS scripts on http://wiki.imacros.net/x64 for more details 

sDir =  Replace(WScript.ScriptFullName, WScript.ScriptName, "") 'Get current directory
strConnect = _
   "Driver={Microsoft Text Driver (*.txt; *.csv)};" & _
   "DefaultDir=" & sDir & ";"

Const adOpenStatic = 3
rs.open "select * from iimsubmit.csv", strConnect, adOpenStatic

MsgBox "Input file information:" & vbCrLf &  vbCrLf & _
"Recordcount: " & rs.recordcount & vbCrLf &  vbCrLf & _
"Fields per record: " & rs.fields.count


set iim1= CreateObject ("imacros")
iret = iim1.iimOpen
iret = iim1.iimDisplay("Submitting Data")

do until rs.eof
   'Set the variables

   iret = iim1.iimSet("FNAME", rs.fields(0))
   iret = iim1.iimSet("LNAME", rs.fields(1))
   iret = iim1.iimSet("ADDRESS", rs.fields(2))
   iret = iim1.iimSet("CITY", rs.fields(3))
   iret = iim1.iimSet("ZIP", rs.fields(4))
   iret = iim1.iimSet("STATE-ID", rs.fields(5))
   iret = iim1.iimSet("COUNTRY-ID", rs.fields(6))
   iret = iim1.iimSet("EMAIL", rs.fields(7))
   'Run the macro
   'Same macro as in database-2-web.vbs example!!!
   iret = iim1.iimPlay(sDir & "Macros\wsh-submit-2-web.iim")
   If iret < 0 Then
       MsgBox "Error code: "+cstr(iret) + VbCrLf + "Error Text: "+iim1. iimGetErrorText()
   End If
  rs.movenext
loop

iret = iim1.iimDisplay("Done!")
iret = iim1.iimClose
WScript.Quit(iret)
