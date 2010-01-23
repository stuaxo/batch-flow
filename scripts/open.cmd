@echo off
:: Open a file (uses explorer to do this really)

if "%1"=="" goto nofile

explorer %*
goto end

:nofile
echo Must specify a file or directory to open.

:end
