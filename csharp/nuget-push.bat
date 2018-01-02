@echo off
cd /d %~dp0
set NUGET_EXE="C:\Program Files (x86)\NuGet\nuget.exe"
set PKG_FILE=%1

if "%PKG_FILE%" == "" (
	echo "pacakge file needed"
	exit /b 1
)

if not exist "%PKG_FILE%" (
	echo "package: %PKG_FILE% is not found"
	exit /b 1
)

echo %NUGET_EXE% push %PKG_FILE% -Source https://www.nuget.org/api/v2/package
     %NUGET_EXE% push %PKG_FILE% -Source https://www.nuget.org/api/v2/package
