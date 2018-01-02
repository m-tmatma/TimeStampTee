cd /d %~dp0

if "%APPVEYOR%" == "True" (
	set NUGET_EXE=nuget.exe
	set EXTRA_CMD=/verbosity:minimal /logger:"C:\Program Files\AppVeyor\BuildAgent\Appveyor.MSBuildLogger.dll"
) else (
	set NUGET_EXE="C:\Program Files (x86)\NuGet\nuget.exe"
	set EXTRA_CMD=
)
set MSBUILD_EXE="C:\Program Files (x86)\Microsoft Visual Studio\2017\Community\MSBuild\15.0\Bin\MSBuild.exe"

del /Q *.nupkg || echo OK

echo %MSBUILD_EXE% TimeStampTee.sln /p:Configuration=Release  %EXTRA_CMD% 
     %MSBUILD_EXE% TimeStampTee.sln /p:Configuration=Release  %EXTRA_CMD% || (echo error && exit /b 1)
echo %MSBUILD_EXE% TimeStampTee.sln /p:Configuration=Debug    %EXTRA_CMD% || (echo error && exit /b 1)
     %MSBUILD_EXE% TimeStampTee.sln /p:Configuration=Debug    %EXTRA_CMD% || (echo error && exit /b 1)

%NUGET_EXE% pack TimeStampTee.nuspec -Prop Configuration=Release
