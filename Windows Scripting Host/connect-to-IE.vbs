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
message = "This example script connects to an already open instance of Internet Explorer with an active (open) iMacros Add-On."
message = message + " If it can not find one, it starts Internet Explorer."
MsgBox(message)

set iim1= CreateObject ("imacros")
iret = iim1.iimOpen ("-IE ", false)

if iret < 0 then MsgBox ("For this example to work you must make sure that the iMacros Add-On is **open** (visible) before you close Internet Explorer. Then the iMacros Add-On is started automatically whenever IE starts and the Scripting Interface can connect to it.")

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

MsgBox "Close Internet Explorer"

iim1.iimClose(30)
WScript.Quit(iret)
