' iMacros Self-Test Script
' (c) 2008-2013 iOpus Software 

Option Explicit

Dim objFileSystem, objOutputFile
Dim strOutputFile
Dim Header
Const OPEN_FILE_FOR_APPENDING = 8

Dim iim1, iret
set iim1= CreateObject ("imacros")

Dim lVersion
lVersion = iim1.iimGetInterfaceVersion ()
Msgbox "iMacros Self Test Script" + vbCrlf+vbCrlf + "Scripting Interface Version: " + Cstr (lVersion)

'****
Dim Browser
Browser = inputbox("Type in what browser you want to test"+vbCrLf+vbCrLf+"1 = iMacros Browser, 2 = IE, 3 = Firefox, 4 = iMacros.Sidebar","",CStr(1))
select case Browser
case 1:
	strOutputFile = "./self-test-imacros.txt" 
case 2:
	strOutputFile = "./self-test-ie.txt" 
case 3:
	strOutputFile = "./self-test-fx.txt"
case 4:
	strOutputFile = "./self-test-iMacros.Sidebar.txt"
case else:
   Msgbox "Wrong Selection. Please start script again and enter only 1, 2, 3 or 4"
   WScript.Quit(0)
end select

Set objFileSystem = CreateObject("Scripting.fileSystemObject")
Set objOutputFile = objFileSystem.CreateTextFile(strOutputFile, TRUE)

objOutputFile.WriteLine("*** Test Report for iMacros Self Test Script ***"+vbcrlf)
objOutputFile.WriteLine("*** Scripting Interface Version: "+cstr (lversion)+" ***"+vbcrlf+vbcrlf)

' find demo macros folder
Dim myname, mypath, demo
myname = WScript.ScriptFullName
mypath = Left(myname, InstrRev(myname, "\"))
demo = objFileSystem.GetParentFolderName(objFileSystem.GetParentFolderName(mypath)) & "\Macros\Demo\"

dim m(100)
dim max
dim i
i=1

'Standard macros 
m(i) = "Buy iMacros Now":i=i+1
m(i) = "FillForm":i=i+1
m(i) = "Frames":i=i+1
m(i) = "Stopwatch":i=i+1
m(i) = "Extract":i=i+1
m(i) = "ExtractAndFill":i=i+1
m(i) = "ExtractRelative":i=i+1
m(i) = "ExtractTable":i=i+1
m(i) = "Download":i=i+1
m(i) = "SaveAs":i=i+1
m(i) = "JavascriptDialog":i=i+1
m(i) = "Screenshot":i=i+1

if browser = 1 or browser = 2 or browser = 4 then
m(i) = "Upload":i=i+1
m(i) = "WebPageDialog":i=i+1
m(i) = "Search":i=i+1
m(i) = "TagPosition":i=i+1

'DirectScreen and Image Recognition Macros
m(i) = "Drag-and-Drop":i=i+1
m(i) = "Flash":i=i+1
m(i) = "ImageRecognition":i=i+1
m(i) = "Keyword-Assert":i=i+1
m(i) = "Silverlight":i=i+1
end if

'Macros with Java applets
if browser = 1 or browser = 4 then
m(i) = "Directscreen-Click":i=i+1
m(i) = "Draw":i=i+1
end if

'TAB support
m(i) = "Open6Tabs":i=i+1
m(i) = "Tabs":i=i+1

max = i-1

Msgbox ("Click OK to start test run."+vbcrlf+vbcrlf+cstr(max) + " Test Macros") 

'Start Browser
select case Browser
case 1:
	i=  iim1.iimOpen
case 2:
	i=  iim1.iimOpen ("-ie")
case 3:
	i= iim1.iimOpen ("-fx")
case 4:
	i=  iim1.iimOpen ("-ie_ext")
end select
if i < 0 then objOutputFile.WriteLine("INIT: Error-No: " + cstr(i) + " => Description: " + iim1. iimGetErrorText())

Dim fullName
for i = 1 to max
fullName = demo & m(i)& ".iim" 
iret = iim1.iimPlay(fullName)
objOutputFile.WriteLine(cstr(i) + " ; " +cstr(time) + " ; " +m(i) + " ; "+cstr(iret) + " ; " + iim1. iimGetErrorText() )

'check  if user stopped the test
if iret = -101 or iret = -102 then exit for
next


objOutputFile.Close
Set objFileSystem = Nothing
MsgBox ("Test completed"+vbcrlf+vbcrlf+"Report Name: "+strOutputFile+vbcrlf+vbcrlf+ "OK will close the browser")
iret = iim1.iimClose ()
WScript.Quit(iret)



