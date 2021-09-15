// iMacros Connect-To-Firefox JScript
// (c) 2013 iOpus Software 

var WshShell = WScript.CreateObject("WScript.Shell");
var iim1 = WScript.CreateObject("iMacros");
var iret;

alert("This example script opens an instance of Firefox. For this script to work you need to have iMacros for *Firefox* 7.1 or later installed.");

//iret = iim1.iimOpen("-fx", false); //Use open Firefox instance if available
iret = iim1.iimOpen("-fx", true); //Always open new instance

if (iret < 0)
{
	alert("Could not connect to a FIREFOX web browser.");
}

iret = iim1.iimPlay("Demo-Firefox\\Fillform.iim", 60);

if (iret < 0)
{
	var s = iim1.iimGetErrorText();
	alert("The Scripting Interface returned error code: " + iret + "\n" + s);
}

alert("Press OK to close Firefox");

iret = iim1.iimClose();

WScript.Quit(iret)

function alert(msg)
{
	WshShell.Popup(msg);
}