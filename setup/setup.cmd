@echo off
: TODO - Detect 4NT or TCC/LE and run in CMD instead (or fix python loop problem)

setlocal
cd ..
echo ....................................................................
echo .. These folders will be added to the system path:                ..
echo ....................................................................
echo .. %CD%\dev        - Put your development related shortcuts here  ..
echo .. %CD%\launchers  - ff [firefox], np [notepad] etc               ..
echo .. %CD%\scripts    - Batch, WSH and Python scripts                ..
echo ....................................................................
echo Continue?
rem choice

SET PRIMARY_PYTHON=NOT_FOUND
for /F "tokens=1* delims= " %%a in ('"python --version 2>&1"') DO SET PRIMARY_PYTHON=%%b

IF "%PRIMARY_PYTHON%"=="program or batch file." goto no_python

:has_python
goto python_end

:no_python

: Maybe check if in registry, if so offer to add it to the path ?

echo Python was not found in the path, these commands will not be available:
:dir /b scripts\*.py

for %%p in (scripts\*.py) do echo %%~np


goto python_end

:python_end

endlocal