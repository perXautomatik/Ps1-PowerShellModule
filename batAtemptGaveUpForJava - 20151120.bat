set tempfolder = %1 %I+temp
mkdir tempfolder


set folderCnt=0
set fileCnt=0

for %%A in (%*) do 
(
    FOR %%i IN (%%A) DO 
	(
		
		IF EXIST %%~si\NUL
		(
			 set /a folderCnt+=1
 			 set "folder!folderCnt!=%%A"
		)
		ELSE
		(
			 set /a fileCnt+=1
 			 set "file!fileCnt!=%%A"
		)		
	)			
)

set "folder!folderCnt+1!=tempfolder"

for /l %%N in (1 1 %fileCnt%) do
	mv %%N - !file%%N! tempfolder

for /l %%N in (1 1 %folderCnt%) do
	mv %%N - !file%%N! tempfolder

