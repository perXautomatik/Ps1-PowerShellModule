' iMacros Connect-To-IE Script
' (c) 2008-2013 iOpus Software 

Option Explicit
Dim iim1, iret

'****
' find current folder
Dim myname, mypath
myname = WScript.ScriptFullName
mypath = Left(myname, InstrRev(myname, "\"))

Dim message
message = "This example script controls Internet Explorer 10 via the iMacros Sidebar." + vbNewLine
message = message + "It works also with IE8 and IE9."
MsgBox(message)

set iim1= CreateObject ("imacros")
'You can also add other command line parameters, like -tray, -key, and even -kioskmode (try it!)
iret = iim1.iimOpen ("-ie_ext", true)

if iret < 0 Then
   MsgBox "Error code: "+cstr(iret) + VbCrLf + "Error Text: "+iim1. iimGetErrorText()
End If

iret = iim1.iimDisplay("Start demo")
  
'Run first macro
iret = iim1.iimPlay(mypath & "Macros\Wsh-Start.iim", 30)
if iret < 0 Then
   MsgBox "Error code: "+cstr(iret) + VbCrLf + "Error Text: "+iim1. iimGetErrorText()
End If

'Run second macro
iret = iim1.iimPlay(mypath & "Macros\Wsh-Lunch.iim", 30)
if iret < 0 Then
   MsgBox "Error code: "+cstr(iret) + VbCrLf + "Error Text: "+iim1. iimGetErrorText()
End If

'Run third macro
iret = iim1.iimPlay(mypath & "Macros\Wsh-Submit-BUtton.iim", 30)
if iret < 0 Then
   MsgBox "Error code: "+cstr(iret) + VbCrLf + "Error Text: "+iim1. iimGetErrorText()
End If

iret = iim1.iimDisplay("Script completed.")

MsgBox "Close iMacros and Internet Explorer"

iim1.iimClose(30)
WScript.Quit(iret)
