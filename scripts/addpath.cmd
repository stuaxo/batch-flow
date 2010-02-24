: Helper script to launch addpath.js 
: Addpath should always be launched from here when on the commandline otherwise 
: it will not be possible to change the local path.
:
@echo off
:: Call WSH script to add to path, then output
:: new path

if "%1"=="/?" goto usage
if "%1"=="/l" goto add_to_local_path_option
if "%1"=="/L" goto add_to_local_path_option

cscript //nologo %~d0%~p0\addpath.js %~f1
if ERRORLEVEL 1 goto already_in_path
if ERRORLEVEL 2 goto does_not_exist

goto add_to_local_path

:add_to_local_path_option
shift

:add_to_local_path
if "%1"=="." PATH=%PATH%;%CD%
if not "%1"=="." PATH=%PATH%;%1
goto end

:already_in_path
exit /B 2
goto end

:does_not_exist
exit /B 1

:usage
echo Usage:
echo   addpath path		Add path to the system path
echo   addpath /l path	Add path to this prompts path
echo.
echo Example:
echo   Add current path to registry:
echo     addpath .
echo.
echo   This works as paths are converted to absolute paths.
echo.

:end
