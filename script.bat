for %%i in (*mp4) do (
ffprobe.exe -v error -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 "%%~nxi" > tempfile
set /p duration=<tempfile
del tempfile
set /a duration= %duration%-14
ffmpeg.exe -i "%%~nxi" -ss 8 -t %duration% -vcodec copy -acodec copy "output\%%~nxi"
)