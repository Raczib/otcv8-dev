# OTCv8 (Windows) ? Build Guide for Friends

This guide is based on a working build on **Windows** using **Visual Studio 2026 Build Tools**.

## TL;DR
- **MSVC toolset:** v145
- **MSVC build tools version:** 14.50.35717
- **Windows SDK:** 10.0 (latest)
- **vcpkg root:** `C:\vcpkg`
- **Triplet:** `x86-windows-static-md`
- **Repo location:** avoid OneDrive (use a normal folder like `C:\Users\<you>\Documents\TibiaX\\otclient`)

---

## 1) Install Visual Studio Build Tools (Required)
Install **Visual Studio 2026 Build Tools** with:
- MSVC v145 toolset
- Windows 10/11 SDK (10.0.x, ?latest?)

Verify that **MSVC Build Tools Version** is **14.50.35717**.

---

## 2) Install vcpkg
Use a fixed path (this guide assumes `C:\vcpkg`).

```powershell
cd C:\
git clone https://github.com/microsoft/vcpkg.git
C:\vcpkg\bootstrap-vcpkg.bat
```

Update ports:
```powershell
cd C:\vcpkg
git pull
C:\vcpkg\vcpkg.exe update
```

---

## 3) Install dependencies with vcpkg
Always use the **x86-windows-static-md** triplet.

```powershell
C:\vcpkg\vcpkg.exe install ^
  boost-system:x86-windows-static-md ^
  boost-filesystem:x86-windows-static-md ^
  boost-headers:x86-windows-static-md ^
  boost-cmake:x86-windows-static-md ^
  zlib:x86-windows-static-md ^
  bzip2:x86-windows-static-md ^
  glew:x86-windows-static-md ^
  openssl:x86-windows-static-md ^
  physfs:x86-windows-static-md ^
  openal-soft:x86-windows-static-md ^
  libogg:x86-windows-static-md ^
  libvorbis:x86-windows-static-md ^
  luajit:x86-windows-static-md ^
  fmt:x86-windows-static-md
```

If you see headers missing after install, force rebuild without binary cache:
```powershell
C:\vcpkg\vcpkg.exe install <package>:x86-windows-static-md --no-binarycaching --host-triplet=x64-windows
```

---

## 4) Build (PowerShell)

**Important:** Do not build from a OneDrive folder. OneDrive/AV can lock MSBuild tlog files.

From PowerShell:

```powershell
$intDir='C:\Users\<you>\Documents\_build\otcv8\OpenGL\'
New-Item -ItemType Directory -Force -Path $intDir | Out-Null

cmd /s /c '"C:\Program Files\Microsoft Visual Studio\18\Community\Common7\Tools\VsDevCmd.bat" -arch=x86 -host_arch=x64 && set VCToolsVersion=14.50.35717 && cd /d C:\Users\<you>\Documents\TibiaX\\otclient && msbuild vc16\otclient.sln /p:Configuration=OpenGL /p:Platform=Win32 /p:PlatformToolset=v145 /p:VCToolsVersion=14.50.35717 /p:VcpkgRoot=C:\vcpkg /p:VcpkgTriplet=x86-windows-static-md /p:VcpkgUseStatic=false /p:VcpkgAppLocalDeps=false /p:IntDir=C:\Users\<you>\Documents\_build\otcv8\OpenGL\'
```

Output:
```
C:\Users\<you>\Documents\TibiaX\\otclient\otclient_gl.exe
```

---

## 5) Common Problems & Fixes

### A) `boost/config.hpp` or `boost/system/config.hpp` missing
Reinstall boost headers + cmake:
```powershell
C:\vcpkg\vcpkg.exe install boost-cmake:x86-windows-static-md boost-headers:x86-windows-static-md --no-binarycaching --host-triplet=x64-windows
```

### B) `openssl/conf.h` missing
Reinstall OpenSSL:
```powershell
C:\vcpkg\vcpkg.exe install openssl:x86-windows-static-md --no-binarycaching --host-triplet=x64-windows
```

### C) `physfs.h` / `AL/al.h` missing
Reinstall OpenAL + PhysFS:
```powershell
C:\vcpkg\vcpkg.exe install openal-soft:x86-windows-static-md physfs:x86-windows-static-md --no-binarycaching --host-triplet=x64-windows
```

### D) `luajit/lua.h` missing
Reinstall LuaJIT:
```powershell
C:\vcpkg\vcpkg.exe install luajit:x86-windows-static-md --no-binarycaching --host-triplet=x64-windows
```

### E) `MSB3061 unable to delete ... unsuccessfulbuild`
This is usually OneDrive/AV locking the tlog file. Fix:
- Move the repo out of OneDrive.
- Build with a custom `IntDir` on a normal local path (as shown above).

---

## 6) Build script (optional)
If you want a 1?click build, use `build_windows.sh` (requires Git Bash or MSYS2).

---

## Notes
- This build uses **Win32** (x86) + OpenGL configuration.
- Triplet must match: **x86-windows-static-md**.
- Do not mix different vcpkg roots.

---

If something fails, share the exact error output and we?ll add it to this guide.

