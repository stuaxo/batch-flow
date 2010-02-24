@echo on

:: detect 4nt or tcc/le
if "%@eval[2 + 2]%" == "4" goto 4nt_tcc
goto start

:4nt_tcc
:: Not compatible with 4nt or tcc/le, so run with cmd
cmd /C %0 %*
exit /b %E%

:start

setlocal
cd ..

:: Create the dev directory
IF NOT EXIST dev\NUL mkdir dev

:query_do_setup
echo ....................................................................
echo .. These folders will be added to the system path:                ..
echo ....................................................................
echo .. %CD%\dev        - Put your development related shortcuts here  ..
echo .. %CD%\launchers  - ff [firefox], np [notepad] etc               ..
echo .. %CD%\scripts    - Batch, WSH and Python scripts                ..
echo ....................................................................
SET /P CHOICE=Continue [Y/N]

if "%CHOICE%"=="Y" goto do_setup
if "%CHOICE%"=="y" goto do_setup
if "%CHOICE%"=="N" goto end
if "%CHOICE%"=="n" goto end
goto query_do_setup

:do_setup
echo.
echo TIP: To update other open command prompts to the new path use the command
echo regpath /L
echo.
call scripts\addpath.cmd dev > NUL
call scripts\addpath.cmd launchers > NUL
call scripts\addpath.cmd scripts > NUL

SET PYTHON_VERSION=NOT_FOUND
for /F "tokens=1* delims= " %%a in ('"python --version 2>&1"') DO SET PYTHON_VERSION=%%b

IF "%PYTHON_VERSION%"=="program or batch file." goto no_python

:has_python
:: TODO - check correct python modules installed


::   Find python

set PYTHON_PATH=
:: Get path to primary python
for %%P in (%PATH%) do if exist %%P\python.exe if "%PYTHON_PATH%"=="" set PYTHON_PATH=%%P\
if not "%PYTHON_PATH%"=="" goto has_python__install_modules

:: Check for python 2.6
set PYTHON_VERSION=2.6

:: search registry
set QUERY="HKLM\SOFTWARE\Python\PythonCore\%PYTHON_VERSION%\InstallPath"

for /F "tokens=3* skip=4 delims=	 " %%a in ('reg.exe query "%QUERY%" /ve') DO (
    if exist "%%b\python.exe" (
        SET PYTHON_PATH=%%b
    )
)

if "%PYTHON_PATH%"=="" goto no_python

SET /P CHOICE=Install pywin32 and winshell [Y/n]

if "%CHOICE%"=="N" goto end
if "%CHOICE%"=="n" goto end

:has_python__install_modules

%PYTHON_PATH%\scripts\easy_install pywin32
%PYTHON_PATH%\scripts\easy_install winshell

goto python_end


:no_python

: Maybe check if in registry, if so offer to add it to the path ?

echo Python was not found in the path, these commands will not be available:
:dir /b scripts\*.py

for %%p in (scripts\*.py) do echo %%~np


echo To Fix this:  Install Python and these modules:
echo.
echo pywin32   http://sourceforge.net/projects/pywin32/
echo winshell  http://timgolden.me.uk/python/winshell.html
echo.



goto python_end

:python_end

:end
endlocal