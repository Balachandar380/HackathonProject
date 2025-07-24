@echo off

SETLOCAL EnableDelayedExpansion

set arg1=%1
set arg2=%2
set arg3=%3
set arg4=%4
set arg5=%5

if "%~5" neq "" (
  "%~dp0fred.exe" %arg1% %arg2% %arg3% %arg4% %arg5% -nosplash
) else if "%~3" neq "" (
  "%~dp0fred.exe" %arg1% %arg2% %arg3% -nosplash
)