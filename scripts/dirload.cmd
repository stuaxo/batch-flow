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
if "%1"=="" goto listdirs
if "%1"=="/?" goto usage
if "%1"=="/H" goto usage
if "%1"=="/h" goto usage

if not exist "%APPDATA%\CMD\SaveDirs\*.scd" goto nonesaved

if "%1"=="/L" goto listdirs
if "%1"=="/l" goto listdirs
if "%1"=="/s" goto showdir
if "%1"=="/S" goto showdir
if "%1"=="/-" goto batchflowdir
if "%1"=="/--" goto showscds

goto dirload


:dirload
if not exist "%APPDATA%\CMD\SaveDirs\%1.scd" goto noslot

for /f "delims=/" %%A in ('type "%APPDATA%\CMD\SaveDirs\%1.scd"') do (
call :check_in_dir "%%A" %1
CD /D %%A 2>NUL
if ERRORLEVEL 1 echo [%%A] Not accessible
goto end
)

goto end

:check_in_dir
:: %1 == directory (quoted)
:: %2 == bookmark name
if %1=="%CD%" echo This is bookmark %2
shift
exit /b 1
goto:eof

:listdirs
echo Bookmark	Directory
if not "%2"=="" goto listdirs_specific
for /f %%A IN ('dir /b "%APPDATA%\CMD\SaveDirs\*.scd"') do (
    call dirload /S %%~nA
)
goto end

:listdirs_specific
shift
if "%1"=="" goto end
if not exist "%APPDATA%\CMD\SaveDirs\%1.scd" goto listdirs_specific
call dirload /S %1
goto listdirs_specific

:showdir
if ""=="%2" goto showdir_usage
for /f "delims=/" %%A in ('type "%APPDATA%\CMD\SaveDirs\%2.scd"') do (
    echo %2		%%A
    goto end
)

shift
goto noslot

:showdir_usage
echo Must specify directory slot
goto end

:batchflowdir
:: Undocumented function for developers
echo Going to directory containing dirload
cd /d %~d0%~p0
goto end

:showscds
:: Undocumented feature for developers
:: Show location of bookmarks
echo Bookmark save folder is [%%APPDATA%%\CMD\SaveDirs]
dir "%APPDATA%\CMD\SaveDirs"
goto end

:noslot
echo No directory saved at %1
goto end


:nonesaved
echo No directories saved yet
goto end


:usage
echo dirload usage:
echo    dirload                 Equivilent to /L
echo    dirload name            Change to directory at bookmark 'name'
echo    dirload /L              List all bookmarked directories
echo    dirload /L name1 name2  List bookmarks name1 and name2
echo    dirload /S name         Show directory bookmark called 'name'
echo See also dirsave

:end

