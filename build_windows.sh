#!/usr/bin/env bash
set -euo pipefail

# Windows build for OTCv8 using MSVC v145
# Requires: Git Bash / MSYS2 + Visual Studio 2026 Build Tools installed

INTDIR="C:\\Users\\%USERNAME%\\Documents\\_build\\otcv8\\OpenGL\\"
VSDEV="C:\\Program Files\\Microsoft Visual Studio\\18\\Community\\Common7\\Tools\\VsDevCmd.bat"
REPO="C:\\Users\\%USERNAME%\\Documents\\TibiaX\\otcv8-dev"

cmd /s /c "\"%VSDEV%\" -arch=x86 -host_arch=x64 && set VCToolsVersion=14.50.35717 && cd /d %REPO% && msbuild vc16\\otclient.sln /p:Configuration=OpenGL /p:Platform=Win32 /p:PlatformToolset=v145 /p:VCToolsVersion=14.50.35717 /p:VcpkgRoot=C:\\vcpkg /p:VcpkgTriplet=x86-windows-static-md /p:VcpkgUseStatic=false /p:VcpkgAppLocalDeps=false /p:IntDir=%INTDIR%"

echo "Built: %REPO%\\otclient_gl.exe"

