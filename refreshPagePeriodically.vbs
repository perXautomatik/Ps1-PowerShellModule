On Error Resume Next

Set objExplorer = CreateObject("InternetExplorer.Application")


objExplorer.Navigate "https://portalen1.gotland.se/Asp/W3D3.asp"

objExplorer.Visible = 1


Wscript.Sleep 5000


Set objDoc = objExplorer.Document


do while true

    Wscript.Sleep 30000

    objDoc.Location.Reload(True)

    If Err <> 0 Then

        Wscript.Quit

    End If

loop