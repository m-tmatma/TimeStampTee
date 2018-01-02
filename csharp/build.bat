cd /d %~dp0

set NUGET_EXE="C:\Program Files (x86)\NuGet\nuget.exe"
set MSBUILD_EXE="C:\Program Files (x86)\Microsoft Visual Studio\2017\Community\MSBuild\15.0\Bin\MSBuild.exe"

del /Q *.nupkg

%MSBUILD_EXE% TimeStampTee.sln /p:Configuration=Release  || (echo error && exit /b 1)
%MSBUILD_EXE% TimeStampTee.sln /p:Configuration=Debug    || (echo error && exit /b 1)

%NUGET_EXE% pack TimeStampTee.nuspec
