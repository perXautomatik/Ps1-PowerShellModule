' iMacros Random-Numbers Script
' (c) 2008-2013 iOpus Software 

Option Explicit
Dim iim1, iret
Dim rn, i, keyword

MsgBox ("This example script submits random information to a website")

' find current folder
Dim myname, mypath
myname = WScript.ScriptFullName
mypath = Left(myname, InstrRev(myname, "\"))

set iim1= CreateObject ("imacros")
iret = iim1.iimOpen

'Run 3 times
for i = 1 to 3

iret = iim1.iimDisplay("Generating number")

'Create random number between 1 and 5
Randomize
rn = cint (rnd()*5 + 1)

iret = iim1.iimDisplay("Number=" + cstr(rn))

select case rn
  case 1:
   keyword = "Sunshine"
  case 2:
   keyword = "Snow"
  case 3:
   keyword = "Rain"
  case 4:
   keyword = "Wind"
  case 5:
   keyword = "clouds" 
 case else:
   keyword = "This should not happen"
end select

 'Set the variables
   iret = iim1.iimSet("mynumber", cstr(rn))
   iret = iim1.iimSet("mytext", keyword)
  
 'Run the macro
   iret = iim1.iimPlay(mypath & "Macros\wsh-random.iim")
   If iret < 0 Then
      MsgBox "Error Code: "+cstr(iret) + VbCrLf + "Error Text: "+iim1. iimGetErrorText()
   End If

next

iret = iim1.iimDisplay("The script and macro are completed. Click OK to close the IIM browser and this script.")
iret = iim1.iimClose
WScript.Quit(iret)
