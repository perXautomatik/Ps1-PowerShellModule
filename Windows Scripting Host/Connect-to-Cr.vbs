Option Explicit
Dim iim1, iret

Dim id
id = 1

' find current folder
Dim myname, mypath
myname = WScript.ScriptFullName
mypath = Left(myname, InstrRev(myname, "\"))

Dim fso
Set fso = CreateObject("Scripting.FileSystemObject")
Dim SSLog
Const ForAppending = 8
Set SSLog = fso.OpenTextFile(mypath & "TestCrInterface_id"&CStr(id)&".log", ForAppending, True)
set iim1= CreateObject ("imacros")
SSLog.WriteLine("Started " & Now & " with interface version " & iim1.iimGetInterfaceVersion())


Dim i, macro
for i = 1 to 1

iret = iim1.iimOpen(" -cr",true)
SSLog.WriteLine( cstr(i) & " " & Now & " iimInit iret = " & iret & " " & iim1. iimGetErrorText)
' Fill the form
iret = iim1.iimSet("name","Number " & CStr(i))
iret = iim1.iimPlay(mypath & "Macros\Wsh-FillFormXPath.iim",180)
SSLog.WriteLine( cstr(i) & " " & Now & " iimPlay macro iret = " & iret & " " & iim1. iimGetErrorText)
' Submit the form
macro = "TAG XPATH=""id('TestForm')/descendant::input[@value='Yes']"" CONTENT=YES" + vbNewLine
macro = macro + "TAG XPATH=""/descendant::input[@type='submit']""" + vbNewLine
macro = macro + "WAIT SECONDS=5"
iret = iim1.iimPlayCode(macro,180)
SSLog.WriteLine( cstr(i) & " " & Now & " iimPlay code iret = " & iret & " " & iim1. iimGetErrorText)

iret = iim1.iimClose
Next

WScript.Quit(iret)
