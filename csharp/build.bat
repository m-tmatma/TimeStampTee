@echo off

set SLN_FILE=%~dp0TimeStampTee.sln
set SPC_FILE=%~dp0TimeStampTee.nuspec

if "%APPVEYOR%" == "True" (
	set NUGET_EXE=nuget.exe
	set EXTRA_CMD=/verbosity:minimal /logger:"C:\Program Files\AppVeyor\BuildAgent\Appveyor.MSBuildLogger.dll"
) else (
	set NUGET_EXE="C:\Program Files (x86)\NuGet\nuget.exe"
	set EXTRA_CMD=
)
set MSBUILD_EXE="C:\Program Files (x86)\Microsoft Visual Studio\2017\Community\MSBuild\15.0\Bin\MSBuild.exe"

for /r %%i in (*.nupkg) do (
	if exist %%i (
		echo removing %%i
		del %%i
	)
)

setlocal ENABLEDELAYEDEXPANSION
set FRAMEWORK_VERSION1=3.5
set FRAMEWORK_VERSION2=4.0
set FRAMEWORK_VERSION3=4.5.2
set FRAMEWORK_VERSION4=4.6

set i=1
:BEGIN
call set FRAMEWORK_VERSION=%%FRAMEWORK_VERSION!i!%%
if defined FRAMEWORK_VERSION (
	echo %MSBUILD_EXE% %SLN_FILE% /p:Configuration=Release  /p:TargetFrameworkVersion="v!FRAMEWORK_VERSION!" /t:"Clean","Rebuild"  %EXTRA_CMD%
	     %MSBUILD_EXE% %SLN_FILE% /p:Configuration=Release  /p:TargetFrameworkVersion="v!FRAMEWORK_VERSION!" /t:"Clean","Rebuild"  %EXTRA_CMD% || GOTO :ERROR_END

	echo %MSBUILD_EXE% %SLN_FILE% /p:Configuration=Debug    /p:TargetFrameworkVersion="v!FRAMEWORK_VERSION!" /t:"Clean","Rebuild"  %EXTRA_CMD%
	     %MSBUILD_EXE% %SLN_FILE% /p:Configuration=Debug    /p:TargetFrameworkVersion="v!FRAMEWORK_VERSION!" /t:"Clean","Rebuild"  %EXTRA_CMD% || GOTO :ERROR_END

	set /A i+=1
	goto :BEGIN
)

echo %NUGET_EXE% pack %SPC_FILE% -Prop Configuration=Release -OutputDirectory %~dp0
     %NUGET_EXE% pack %SPC_FILE% -Prop Configuration=Release -OutputDirectory %~dp0 || GOTO :ERROR_END
exit /b 0

:ERROR_END
echo error
exit /b 1
