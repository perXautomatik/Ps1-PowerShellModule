' iMacros Get-Exchange-Rate Script
' (c) 2008-2013 iOpus Software 

Option Explicit

Msgbox ("This example will retrieve the current exchange rate for US$, EURO and GBP. This macro will run in the system tray.")

' find current folder
Dim myname, mypath
myname = WScript.ScriptFullName
mypath = Left(myname, InstrRev(myname, "\"))

Dim iim1, iret, iplay
set iim1= CreateObject ("imacros")

iret = iim1.iimOpen ("")
iret = iim1.iimDisplay("Extract Example")
iplay = iim1.iimPlay(mypath & "Macros\wsh-extract-rate.iim")

Dim s

If iplay = 1 Then
     s = "One US$ costs " + iim1.iimGetExtract(1) + " EURO or " + iim1.iimGetExtract(2) + " British Pounds (GBP)"
 else
     s = "The following error occurred: " + iim1.iimGetErrorText()
End If

MsgBox s

iret = iim1.iimClose
WScript.Quit(iret)
