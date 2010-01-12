: Wrapper script for pcd.py (Paste Change Directory)
:
: It must be run from here otherwise the directory change
: will not work.
:
@echo off
python %~d0%~p0\%~n0.py /BATCHLAUNCH %*
if errorlevel 1 exit /b 1
call %TEMP%\go_pcd.cmd
del %TEMP%\go_pcd.cmd > NUL

:end