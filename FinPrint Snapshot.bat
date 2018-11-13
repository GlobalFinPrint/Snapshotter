echo off
setlocal enabledelayedexpansion

set /p src="Enter path that contains the videos to snapshot: "
set /p subfldr_flg="Does this path have subfolders with more videos to snapshot? (y/n) "
set /p dst="Enter path to hold the snapshots: "
set /p snpsht_time="Enter a time to take the snapshot: (HH:MM:SS) "

set recursion=0
if "%subfldr_flg%"=="Y" set recursion=1
if "%subfldr_flg%"=="y" set recursion=1

if %recursion%==1 (
   for /R %src% %%i in (*.mp4, *.avi, *.mts) do (
        set name=%%~ni
        echo !name!
        ffmpeg -ss !snpsht_time! -i "%%i" -vframes 1 -q:v 2 "%dst%/!name!.jpg"
   )
) else (
    for %%i in (%src%\*.mp4, %src%\*.avi, %src%\*.mts) do (
        set name=%%~ni
        echo !name!
        ffmpeg -ss !snpsht_time! -i "%%i" -vframes 1 -q:v 2 "%dst%/!name!.jpg"
    )
)

echo Process completed successfully.
echo on
PAUSE