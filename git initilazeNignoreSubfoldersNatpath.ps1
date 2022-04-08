#. .\filesystem\DirectoriesAtDepthN.ps1
#. .\git\InitializeNewReposInEachSubfolder.ps1
#. .\git\folderContToignored.ps1

every-load 'DirectoriesAtDepthN.ps1'
every-load 'InitializeNewReposInEachSubfolder.ps1'
every-load 'folderContToignored.ps1'

ListDirectoriesAtDepth 'D:\PortableApps\' 2  |
    NewRepo $_.fullname 'portableapps.com'   |
    addToIgnored 