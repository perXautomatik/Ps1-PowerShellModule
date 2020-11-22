' iMacros Extract-2-File Script
' (c) 2008-2013 iOpus Software 

Option Explicit

Dim objFileSystem, objOutputFile
Dim strOutputFile

Const OPEN_FILE_FOR_APPENDING = 8

Dim message
message = "This script demonstrates how to extract data from a web site and store this information in a text file "
message = message + "(CSV Format, CSV = Comma separated values). It uses the macro <wsh-extract-jobs.iim>." + vbCrLf + VbCrLf 
message = message + "Tip: This script has the same function as <extract-2-database.vbs> but stores the data in a test file instead of a database."

MsgBox (message)

' find current folder
Dim myname, mypath
myname = WScript.ScriptFullName
mypath = Left(myname, InstrRev(myname, "\"))

' generate a filename based on the script name
strOutputFile = "./extracted-data.txt"

Set objFileSystem = CreateObject("Scripting.fileSystemObject")

Set objOutputFile = objFileSystem.CreateTextFile(strOutputFile, TRUE)
'Note: Use ....CreateTextFile(strOutputFile, FALSE) to append data to the file

Dim iim1, iret, iplay
set iim1= CreateObject ("imacros")
iret = iim1.iimOpen("")

Dim num, pos, str, s
For num = 1 To 3 
   str = cstr(num)  'Convert integer to string
   iret = iim1.iimDisplay("Listing No: " + str)

   pos = num   '+ 4'start at 5: Offset for POS= statement
   str = cstr(pos)  'Convert integer to string
   iret = iim1.iimSet("myvar", str) 'Select a new link for each run

   iplay = iim1.iimPlay(mypath & "Macros\wsh-extract-jobs.iim")

   If iplay = 1 Then
       s =  """" +  iim1.iimGetExtract(1)+ """,""" + iim1.iimGetExtract(2) + """,""" + iim1.iimGetExtract(3) + """,""" + iim1.iimGetExtract(4)  + """"
       objOutputFile.WriteLine(s)
   End If

   If iplay < 0 Then
      MsgBox "Error code: "+cstr(iplay) + VbCrLf + "Error Text: " + iim1. iimGetErrorText()  
   End If
Next

iret = iim1.iimClose
objOutputFile.Close
Set objFileSystem = Nothing

MsgBox "The data is stored in the file <extracted-data.txt>. The script is completed."

WScript.Quit(iret)









