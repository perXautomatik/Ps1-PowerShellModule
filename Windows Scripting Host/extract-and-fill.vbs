' iMacros Extract-and-Fill Script
' (c) 2008-2013 iOpus Software 

Option Explicit

Dim value1, value2, s

Msgbox ("This example shows how to use a data EXTRACTION and then fill the extracted data into a new form. It uses two macros for this purpose.")

' find current folder
Dim myname, mypath
myname = WScript.ScriptFullName
mypath = Left(myname, InstrRev(myname, "\"))

Dim iim1, iret, iplay

set iim1 = CreateObject ("imacros")

iret = iim1.iimOpen ("")

'--- Extraction starts ---
iret = iim1.iimDisplay("Extract Data")
iplay = iim1.iimPlay(mypath & "Macros\wsh-extract-rate.iim")

If iplay < 0 Then
    s = "The following error occurred: " +  vbCrLf + vbCrLf + iim1. iimGetErrorText()
    MsgBox s
    WScript.Quit(iplay)
End If

'--- Extraction done ---

value1 = iim1.iimGetExtract(1)
value2 = iim1.iimGetExtract(2)

s = "Hello Jim,"  +vbCrLf + vbCrLf
s = s + "Did you know? One US$ costs " + value1 + " EURO or " + value2 + " British Pounds (GBP)."

'--- Submission starts ---
iret = iim1.iimDisplay("Submit extracted data")
iret = iim1.iimSet ("currency", s)
iplay = iim1.iimPlay(mypath & "Macros\wsh-extract-and-fill-part2.iim")

If iplay < 0 Then
    MsgBox "Error code: "+cstr(iplay) + VbCrLf + "Error Text: "+iim1. iimGetErrorText()
End If

iret = iim1.iimClose

WScript.Quit(iret)
