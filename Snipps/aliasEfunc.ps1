	Search-Everything -PathExclude 'C:\users\Crbk01\AppData\Local\Temp'-Filter '<wholefilename:child:.git file:>|<wholefilename:child:.git folder:>' -global | #todo: rename #todo: breakout
Where{ $_ -notmatch 
'C..9dfe73ef|OneDrive|GitHubDesktop.app|Microsoft VS Code._.resources.app|Installer.resources.app.node_modules|Microsoft.E dge.User Data.*.Extensions|Program Files.*.(Esri|MapInfo|ArcGIS)|Recycle.Bin' 
}
