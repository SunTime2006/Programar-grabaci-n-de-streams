@echo off
setlocal EnableDelayedExpansion
title GRABACION RADIO M3U8 A MP4

echo ================================
echo   GRABADOR M3U8 A MP4
echo ================================

set /p M3U8_URL=URL M3U8: 
set /p START_TIME=Hora inicio (HH:MM 24h): 
set /p DURATION_MIN=Duracion (minutos): 
set /p OUTPUT_NAME=Nombre del archivo: 

REM === FFMPEG ===
set FFMPEG=ffmpeg

set BASE_DIR=%~dp0
set OUTPUT_FILE=%BASE_DIR%%OUTPUT_NAME%.mp4
set /a DURATION_SEC=%DURATION_MIN%*60

REM === ESPERA HASTA LA HORA INDICADA ===
echo.
echo Esperando hasta las %START_TIME% ...
:WAIT
for /f "tokens=1-2 delims=:" %%a in ("%time%") do (
    set H=%%a
    set M=%%b
)
if "%H%:%M%" NEQ "%START_TIME%" (
    timeout /t 20 >nul
    goto WAIT
)

echo.
echo ================================
echo INICIANDO GRABACION
echo ================================

REM === GRABACION MP4 (VIDEO + AUDIO) ===
"%FFMPEG%" -stats -i "%M3U8_URL%" ^
-map 0:v:0 -map 0:a:0? ^
-t %DURATION_SEC% ^
-c:v libx264 -preset veryfast -crf 23 ^
-c:a aac -b:a 128k ^
"%OUTPUT_FILE%"

echo.
echo ================================
echo GRABACION FINALIZADA
echo Archivo: %OUTPUT_FILE%
echo ================================

pause

