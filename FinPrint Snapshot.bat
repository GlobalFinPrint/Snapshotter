echo off
setlocal enabledelayedexpansion

set /p src="Enter path that contains the videos to snapshot: "
set /p subfldr_flg="Does this path have subfolders with more videos to snapshot? (y/n) "
set /p dst="Enter path to hold the snapshots: "
set /p snpsht_time="Enter a time to take the snapshot (HH:MM:SS): "

set cur_dir = ""
set /A recursion=0
set /A counter=0

if "%subfldr_flg%"=="Y" set recursion=1
if "%subfldr_flg%"=="y" set recursion=1

if %recursion%==1 (
   for /R %src% %%i in (*.mp4, *.avi, *.mts) do (
	rem determines when a new directory is entered
	if NOT !cur_dir!==%%~pi (
		set cur_dir=%%~pi
		set /A counter=0
	)
	
	rem finds the second file in the video set
	if !counter!==1 call :take_snapshot %%i
	
	set /A counter=counter+1
   )
) else (
    for %%i in (%src%\*.mp4, %src%\*.avi, %src%\*.mts) do (
	rem finds the second file in the video set
	if !counter!==1 call :take_snapshot %%i
	
	set /A counter=counter+1
    )
)

echo Process completed successfully.
echo on
PAUSE

:take_snapshot
	rem Gets name of the parent folder for the video file being processed
	for %%j in ("!cur_dir!\.") do (
            set parent_fldr=%%~nxj
	)

        set name=%~n1
        ffmpeg -ss !snpsht_time! -i "%~1" -vframes 1 -q:v 2 "%dst%/!parent_fldr!.jpg"
EXIT /B 0