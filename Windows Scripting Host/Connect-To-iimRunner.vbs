' iMacros Connect-To-iimRunner Script
' (c) 2008-2013 iOpus Software 

Option Explicit

Dim iim1, i
set iim1 = CreateObject ("imacros")

'****
' find current folder
Dim myname, mypath
myname = WScript.ScriptFullName
mypath = Left(myname, InstrRev(myname, "\"))

Dim message
message = "This script connects to iimRunner to start the iMacros Browser."
message = message + " Use this technology for example to control the iMacros Browser from ASP, ASP.NET or PHP accounts."
MsgBox(message)

i = iim1.iimOpen("-runner ")

if i = -6 or i = - 1 then
  msgbox ("iimRunner ist not running. Please start iimRunner.exe first. You find this file in the iMacros program directory.")
  WScript.Quit(i)
end if

if i = -7 then
  msgbox ("The max. number of allowed iMacros instances is reached. You can change this limit in the simple.xml file in the iMacros directory.")
  WScript.Quit(i)
end if


i = iim1.iimPlay(mypath & "Macros\Wsh-Start.iim")
msgbox ("Demo completed. Result: " & iim1. iimGetErrorText & VBNewLine &"Press OK to close the iMacros browser.")

iim1.iimClose
WScript.Quit(i)
