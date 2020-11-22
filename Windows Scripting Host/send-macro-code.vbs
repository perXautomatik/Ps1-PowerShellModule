' iMacros Send-Macro-Code Script
' (c) 2008-2013 iOpus Software 

Option Explicit
Dim iim1, iret

MsgBox ("This example script uses NO macros, but sends the macro code directly.")

set iim1= CreateObject ("imacros")
iret = iim1.iimOpen("")

Dim MyMacroCode

MyMacroCode = "TAB T=1" + vbNewLine    
MyMacroCode = MyMacroCode+"TAB CLOSEALLOTHERS" + vbNewLine  
MyMacroCode = MyMacroCode+"URL GOTO=http://www.iopus.com" + vbNewLine
MyMacroCode = MyMacroCode+"URL GOTO=http://forum.iopus.com"

'Tip: Use the iMacros Editor Code Generator feature
'to convert your iMacros macros into some scripting/programming language code. 

iret = iim1.iimDisplay("Start demo")
  
'Run the first macro
iret = iim1.iimPlayCode(MyMacroCode)
if iret < 0 Then
   MsgBox "Macro#1: Error Code: "+cstr(iret) + VbCrLf + "Error Text: "+iim1. iimGetErrorText()
End If

'Run the second macro (one line only)
iret = iim1.iimPlayCode("URL GOTO=http://www.alertfox.com")
If iret < 0 Then
      MsgBox "Macro#2: Error Code: "+cstr(iret) + VbCrLf + "Error Text: "+iim1. iimGetErrorText()
End If

iret = iim1.iimDisplay("Script completed.")

MsgBox "Close iMacros browser"

iret = iim1.iimClose
WScript.Quit(iret)
