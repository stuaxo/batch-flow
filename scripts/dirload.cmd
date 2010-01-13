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

if not exist "%APPDATA%\CMD\SaveDirs\*.scd" goto nonesaved

if "%1"=="/L" goto listdirs
if "%1"=="/l" goto listdirs
if "%1"=="/s" goto showdir
if "%1"=="/S" goto showdir

goto dirload


:dirload
if not exist "%APPDATA%\CMD\SaveDirs\%1.scd" goto noslot

:: need to cd into dir for XP compatibility
:: pushd, popd in case CD to SaveDirs fails
pushd
cd "%APPDATA%\CMD\SaveDirs"
for /f "delims=/" %%A in (%1.scd) do (
popd
cd %%A
goto end
)
popd
echo No directory bookmark %1
goto end


:listdirs
echo Bookmark	Directory
for /f %%A IN ('dir /b "%APPDATA%\CMD\SaveDirs\*.scd"') do (
    call dirload /S %%~nA
)
goto end


:showdir
if ""=="%2" goto showdir_usage
pushd
cd "%APPDATA%\CMD\SaveDirs"
for /f "delims=/" %%A in (%2.scd) do (
    echo %2		%%A
    popd
    goto end
)

shift
goto noslot
popd
:showdir_usage
echo Must specify directory slot
echo See dirload /? for usage
goto end


:noslot
echo No directory saved at %1
goto end


:nonesaved
echo No directories saved yet
goto end


:usage
echo dirload usage:
echo    dirload name            Change to directory at bookmark 'name'
echo    dirload /L              List bookmarked directories
echo    dirload /L name1 name2  List bookmarks name1 and name2
echo    dirload /S name         Show directory bookmark called 'name'
echo See also dirsave

:end

