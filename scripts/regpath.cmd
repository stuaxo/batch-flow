: Helper script to launch regpath javascript part.
: 
: Regpath should be launched from here if running from the commandline, otherwise
: setting the local path will not be possible.
:
@echo off
if "%1"=="/L" goto setlocaltosys
if "%1"=="/l" goto setlocaltosys
cscript //NoLogo %~d0%~p0\regpath.js %* /BATCHLAUNCH
if errorlevel 1 exit /b 1

goto end

:setlocaltosys
FOR /F "delims=/" %%A IN ('cscript //NoLogo %~d0%~p0\regpath.js %* /P') DO (
    %%A
    goto end
)


:end
