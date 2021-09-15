' iMacros Connect-To-Firefox Script
' (c) 2008-2013 iOpus Software 

Option Explicit
MsgBox ("This example script opens an instance of Firefox. For this script to work you need to have iMacros for *Firefox* 7.1 or later installed.")

Dim iim1, i, s
set iim1= CreateObject ("iMacros")

'i = iim1.iimOpen ("-fx", false) 'Use open Firefox instance if available
i = iim1.iimOpen ("-fx", true) 'Always open new instance

if i<0 then
	msgbox "Could not connect to a FIREFOX web browser."
end if


i = iim1.iimPlay("Demo-Firefox\Fillform.iim", 60)

if i<0 then
	s = iim1. iimGetErrorText()
	msgbox "The Scripting Interface returned error code: "+cstr(i)
end if

msgbox "Press OK to close Firefox"

i = iim1.iimClose

WScript.Quit(i)