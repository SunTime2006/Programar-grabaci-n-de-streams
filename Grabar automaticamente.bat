@echo off
setlocal EnableDelayedExpansion

echo ================================
echo   PROGRAMAR GRABACION M3U8
echo ================================

set /p M3U8_URL=Introduce la URL del stream m3u8: 
set /p START_TIME=Introduce la hora de inicio (HH:MM, 24h): 
set /p DURATION_MIN=Duracion de la grabacion (en minutos): 
set /p OUTPUT_NAME=Nombre del archivo de salida (sin extension): 

set OUTPUT_DIR=%cd%
set OUTPUT_FILE=%OUTPUT_DIR%\%OUTPUT_NAME%.mp4
set /a DURATION_SEC=%DURATION_MIN%*60

set RECORD_SCRIPT=%OUTPUT_DIR%\_record_temp.bat

echo @echo off > "%RECORD_SCRIPT%"
echo ffmpeg -y -i "%M3U8_URL%" -map 0 -t %DURATION_SEC% -c:v copy -c:a aac -b:a 128k "%OUTPUT_FILE%" >> "%RECORD_SCRIPT%"

set TASK_NAME=Grabacion_M3U8_%OUTPUT_NAME%

schtasks /create ^
 /sc once ^
 /st %START_TIME% ^
 /tn "%TASK_NAME%" ^
 /tr "\"%RECORD_SCRIPT%\"" ^
 /f

echo.
echo ================================
echo Grabacion programada correctamente
echo Archivo: %OUTPUT_FILE%
echo Hora de inicio: %START_TIME%
echo Duracion: %DURATION_MIN% minutos
echo ================================
echo.

pause
