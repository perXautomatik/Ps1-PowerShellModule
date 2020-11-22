' iMacros Get-Response-Times Script
' (c) 2008-2013 iOpus Software 

'Note: Technically this script is simliar to the "Get-Exchange-Rate.vbs" script

Option Explicit

Msgbox ("This example will retrieve the response time measured with the same macro as Demo\Stopwatch.iim.")

Dim macro
macro = "VERSION BUILD=8031994" + vbNewLine 
macro = macro + "TAB T=1     " + vbNewLine 
macro = macro + "TAB CLOSEALLOTHERS " + vbNewLine 
macro = macro + "SET !FOLDER_STOPWATCH NO" + vbNewLine 
macro = macro + "STOPWATCH ID=Total" + vbNewLine 
macro = macro + "STOPWATCH ID=Firstpage" + vbNewLine 
macro = macro + "URL GOTO=http://demo.imacros.net/Automate/StopWatchDemo" + vbNewLine 
macro = macro + "STOPWATCH ID=Firstpage" + vbNewLine 
macro = macro + "TAG POS=1 TYPE=A ATTR=HREF:http://demo.imacros.net/Automate/AutoDataEntry" + vbNewLine 
macro = macro + "TAG POS=1 TYPE=INPUT:TEXT FORM=ID:demo ATTR=NAME:fname CONTENT=Tom " + vbNewLine 
macro = macro + "TAG POS=1 TYPE=INPUT:TEXT FORM=ID:demo ATTR=NAME:lname CONTENT=Tester " + vbNewLine 
macro = macro + "STOPWATCH ID=SubmitData" + vbNewLine 
macro = macro + "TAG POS=1 TYPE=BUTTON:SUBMIT FORM=ID:demo ATTR=TXT:Submit " + vbNewLine 
macro = macro + "STOPWATCH ID=SubmitData " + vbNewLine 
macro = macro + "STOPWATCH ID=Store1" + vbNewLine 
macro = macro + "URL GOTO=http://www.iopus.com/imacros/" + vbNewLine 
macro = macro + "TAG POS=1 TYPE=A ATTR=TXT:*Buy*" + vbNewLine 
macro = macro + "TAG POS=1 TYPE=IMG ATTR=ALT:Buy<SP>Now" + vbNewLine 
macro = macro + "STOPWATCH ID=Store1 " + vbNewLine 
macro = macro + "STOPWATCH ID=Total"

Dim iim1, iret, iplay
Dim s

set iim1= CreateObject ("imacros")

iret = iim1.iimOpen ("")
iret = iim1.iimDisplay("Get Response Times Example")
iplay = iim1.iimPlayCode(macro)

Dim errortext
errortext  = iim1. iimGetErrorText()

If iplay < 0 Then
    s = "The following error occurred: " +  vbCrLf + vbCrLf + errortext
    MsgBox s
    MsgBox "Now trying to analyze extracted values...."
End If

'Get extracted values
Dim idName
Dim Firstpage, SubmitData, Store1, Total

iret = iim1.iimGetStopwatch(3,idName,Firstpage)
s =s + "Intial page load time: "  + Firstpage + " Seconds (ID " & idName & ")" +vbcrlf +vbcrlf

iret = iim1.iimGetStopwatch(4,idName,SubmitData)
s =s + "Form 1 submit time: "  + SubmitData + " Seconds (ID " & idName & ")" +vbcrlf +vbcrlf

iret = iim1.iimGetStopwatch(5,idName,Store1)
s =s + "Online store form load time: "  + Store1 + " Seconds (ID " & idName & ")" +vbcrlf +vbcrlf

iret = iim1.iimGetStopwatch(2,idName,Total)
s =s + "Overall macro run time: "  + Total + " Seconds (ID " & idName & ")"  

MsgBox s

iret = iim1.iimClose
WScript.Quit(iret)
