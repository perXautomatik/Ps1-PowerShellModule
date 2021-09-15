' iMacros Scripting-Interface-Sample script
' (c) 2008-2013 iOpus Software 

Option Explicit
Dim iim1, iret

'****
' find current folder
Dim myname, mypath
myname = WScript.ScriptFullName
mypath = Left(myname, InstrRev(myname, "\"))

Dim message
message = "Welcome to iMacros Scripting Interface!" + vbNewline
message = message + "In this example you see how easy it is to ""remote control"" a browser using a simple script"
MsgBox(message)

set iim1= CreateObject ("imacros")
iret = iim1.iimOpen ("")


iret = iim1.iimDisplay("Interface version = " & iim1.iimGetInterfaceVersion())
  
'Run a macro
iret = iim1.iimPlay(mypath & "Macros\Wsh-Start.iim", 30)
if iret < 0 Then
   MsgBox "Error code: "+cstr(iret) + VbCrLf + "Error Text: "+iim1. iimGetErrorText()
End If

iret = iim1.iimDisplay("Script completed.")

MsgBox "Do you want to close the browser window?"

iim1.iimClose(30)
WScript.Quit(iret)
