@echo off
set OLDDIR=%CD%
echo %OLDDIR%
START /WAIT PowerShell.exe -Command "& {Start-Process PowerShell.exe -ArgumentList '-ExecutionPolicy Bypass -File "%OLDDIR%\VHDTerminator.ps1"' -Verb RunAs}"
REM pause