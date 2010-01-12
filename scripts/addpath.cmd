: Helper script to launch addpath.js 
: Addpath should always be launched from here when on the commandline otherwise 
: it will not be possible to change the local path.
:
@echo off
:: Call WSH script to add to path, then output
:: new path

cscript //nologo %~d0%~p0\addpath.js %*
if ERRORLEVEL 1 goto already_in_path
if ERRORLEVEL 2 goto does_not_exist

if "%*"=="." PATH=%PATH%;%CD%
if not "%*"=="." PATH=%PATH%;%*
goto end

:already_in_path
exit /B 2
goto end

:does_not_exist
exit /B 1

:end
