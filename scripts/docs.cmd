@echo off
:
: Go to the Documents location specified in the registry at:
:
: HKEY_CURRENT_USER
:  + Software
:  |  + Microsoft
:  |  |  + Windows
:  |  |  |  + CurrentVersion
:  |  |  |  |  + Explorer
:  |  |  |  |  |  + Shell Folders  [Personal]
:  '  '  '  '  '
:
for /F "tokens=3,skip=2" %%a in ('reg query "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders" /v Personal') DO cd /D %%a

