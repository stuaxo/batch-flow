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
: extra 'if' is for tccle/4nt
:
FOR /F "tokens=3* delims=	" %%A IN ('reg query "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders" /v Personal') DO if not "%%A"=="" CD /D %%A
