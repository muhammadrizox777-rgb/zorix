@echo off
cd /d "%~dp0"
title ZORIX CLIENT - Build
echo ==========================================
echo    ZORIX CLIENT - yigish (build) boshlandi
echo ==========================================
echo.

where java >nul 2>nul
if errorlevel 1 goto nojava
java -version 2>&1 | findstr /C:"version \"21" >nul
if errorlevel 1 goto wrongjava

if exist ".gradle-local\gradle-8.12\bin\gradle.bat" goto havegradle
echo [1/3] Gradle yuklab olinmoqda (bir marta, ~130 MB)...
powershell -NoProfile -ExecutionPolicy Bypass -Command "[Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12; New-Item -ItemType Directory -Force .gradle-local | Out-Null; Invoke-WebRequest -UseBasicParsing https://services.gradle.org/distributions/gradle-8.12-bin.zip -OutFile .gradle-local\gradle.zip; Expand-Archive -Force .gradle-local\gradle.zip .gradle-local"
if errorlevel 1 goto fail
:havegradle

echo [2/3] ZORIX CLIENT yigilmoqda. Birinchi marta 5-10 daqiqa ketishi mumkin. Kuting...
call ".gradle-local\gradle-8.12\bin\gradle.bat" build --no-daemon
if errorlevel 1 goto fail

echo [3/3] Tayyor fayl nusxalanmoqda...
if not exist "TAYYOR-MOD" mkdir "TAYYOR-MOD"
copy /Y "build\libs\zorix-client-1.0.0.jar" "TAYYOR-MOD\" >nul
echo.
echo ==========================================
echo  TAYYOR!  Fayl: TAYYOR-MOD\zorix-client-1.0.0.jar
echo  Uni .minecraft\mods papkasiga tashlang.
echo ==========================================
explorer "TAYYOR-MOD"
pause
exit /b 0

:nojava
echo [XATO] Java topilmadi. Avval Java 21 ni o'rnating (INSTALL-UZ.txt, 1-qadam).
pause
exit /b 1

:wrongjava
echo [XATO] Java 21 kerak. Sizda boshqa versiya bor. INSTALL-UZ.txt, 1-qadamga qarang.
pause
exit /b 1

:fail
echo.
echo [XATO] Yigish muvaffaqiyatsiz tugadi. Oynadagi xato yozuvini nusxalab menga yuboring.
pause
exit /b 1
