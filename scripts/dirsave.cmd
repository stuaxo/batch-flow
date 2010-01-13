@echo off
:
: Example aliases file for TCC/4NT to use this from hotkeys
: Remove ":" at the beginning of each line to use
:
:@@ctrl-f5=dirsave f5
:@@ctrl-f6=dirsave f6
:@@ctrl-f7=dirsave f7
:@@ctrl-f8=dirsave f8
:@@ctrl-f9=dirsave /c f5 f6 f7 f8
:
:@@alt-f5=dirload f5
:@@alt-f6=dirload f6
:@@alt-f7=dirload f7
:@@alt-f8=dirload f8
:@@alt-f9=dirload /l f5 f6 f7 f8
:
if "%1"=="" goto usage
if "%1"=="/?" goto usage
if "%1"=="/H" goto usage
if "%1"=="/h" goto usage
if "%1"=="/C" goto cleardirs
if "%1"=="/c" goto cleardirs

if not exist "%APPDATA%\CMD\SaveDirs" mkdir "%APPDATA%\CMD\SaveDirs"
goto dirsave


:dirsave
if not "%1"=="%~n1" goto usage
CD > "%APPDATA%\CMD\SaveDirs\%1.scd"
echo Saved directory to %1

goto end


:cleardirs
if not exist %APPDATA%\CMD\SaveDirs\*.scd goto nonesaved
if ""=="%2" goto cleardirs_clearall
echo Deleting specified bookmarks:

if not ""=="%3" goto cleardirs_clearspecific_confirm

shift
goto cleardirs_clearspecific

:cleardirs_clearspecific_confirm
shift
set /p dirload_choice=Clear bookmarks %* ?  [y/N]
if ""=="%dirload_choice%" goto cancelled
if "Y"=="%dirload_choice%" goto cleardirs_clearspecific
if "y"=="%dirload_choice%" goto cleardirs_clearspecific
set dirload_choice=
goto cancelled

:cleardirs_clearspecific
if ""=="%1" goto end
if not exist %APPDATA%\CMD\SaveDirs\%1.scd goto cleardirs_clearspecific_nofile
del %APPDATA%\CMD\SaveDirs\%1.scd > NUL
echo %%~n1 Cleared
shift
goto cleardirs_clearspecific

:cleardirs_clearspecific_nofile
echo %%~n1 Empty
shift
goto cleardirs_clearspecific

:cleardirs_clearall
set /p dirload_choice=Clear ALL saved folders?  [y/N]
if ""=="%dirload_choice%" goto cancelled
if "Y"=="%dirload_choice%" goto cleardirs_procede
if "y"=="%dirload_choice%" goto cleardirs_procede
set dirload_choice=
goto cancelled

:cleardirs_procede
set dirload_choice=
echo Deleting saved directories:
for /f %%A IN ('dir /b %APPDATA%\CMD\SaveDirs\*.scd') do (
    del %APPDATA%\CMD\SaveDirs\%%A > NUL
    echo Cleared %%~nA
)
goto end


:cancelled
echo Cancelled
goto end


:nonesaved
echo No directories saved yet
goto end


:usage
echo Usage:
echo    dirsave name            Save current directory to bookmark 'name'
echo    dirsave /C name1 name2  Clear directory bookmarks name1 and name2
echo    dirsave /C              Clear ALL directory bookmarks
echo See also dirload
:end

