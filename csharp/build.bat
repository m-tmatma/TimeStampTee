cd /d %~dp0
@echo off

if "%APPVEYOR%" == "True" (
	set NUGET_EXE=nuget.exe
	set EXTRA_CMD=/verbosity:minimal /logger:"C:\Program Files\AppVeyor\BuildAgent\Appveyor.MSBuildLogger.dll"
) else (
	set NUGET_EXE="C:\Program Files (x86)\NuGet\nuget.exe"
	set EXTRA_CMD=
)
set MSBUILD_EXE="C:\Program Files (x86)\Microsoft Visual Studio\2017\Community\MSBuild\15.0\Bin\MSBuild.exe"

del /Q *.nupkg || echo OK

setlocal ENABLEDELAYEDEXPANSION
set FRAMEWORK_VERSION1=3.5
set FRAMEWORK_VERSION2=4.0
set FRAMEWORK_VERSION3=4.5.2
set FRAMEWORK_VERSION4=4.6

set i=1
:BEGIN
call set FRAMEWORK_VERSION=%%FRAMEWORK_VERSION!i!%%
if defined FRAMEWORK_VERSION (
	echo %MSBUILD_EXE% TimeStampTee.sln /p:Configuration=Release  /p:TargetFrameworkVersion="v!FRAMEWORK_VERSION!" /t:"Clean","Rebuild"  %EXTRA_CMD%
	     %MSBUILD_EXE% TimeStampTee.sln /p:Configuration=Release  /p:TargetFrameworkVersion="v!FRAMEWORK_VERSION!" /t:"Clean","Rebuild"  %EXTRA_CMD% || (echo error && exit /b 1)

	set /A i+=1
	goto :BEGIN
)

echo %NUGET_EXE% pack TimeStampTee.nuspec -Prop Configuration=Release
     %NUGET_EXE% pack TimeStampTee.nuspec -Prop Configuration=Release
