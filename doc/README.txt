A set of scripts for the windows commandline.

Help with:
  System 'PATH' environment variable:
     Add the current or another directory to it    [addpath]
     Check if a file or directory is already in it [regpath]
     Validate the system path                      [regpath]

  Clipboard and folders
     Go to a directory in the clipboard            [pcd]
     Copy the current directory to the clipboard   [ccd]
     Copy the local path to the clipboard          [cpath]
     Paste files into the current directory        [pfiles]
     Save a directory to a named bookmark          [dirsave]
     Load a directory from a named bookmark        [dirload]
     Create windows shortcuts (lnk files)          [lnk]

  Shortcuts to common locations and programs and operations
     Desktop                                       [dt]
     My Documents                                  [docs]
     Program Files                                 [pf]
     Open explorer in current directory            [e]
     Notepad                                       [np]
     Firefox                                       [ff]

Activate these from hotkeys by using TCC/LE or 4NT as your shell with
the supplied aliases.ini




Scripts

addpath.............Add a path to the system path
ccd.................Copy Current Directory to clipboard
cpath...............Copy the local path to clipboard
dirload.............Go to an bookmarked directory
dirsave.............Bookmark a directory
lnk.................Create a shortcut
pcd.................Go to directory in the clipboard
pfiles..............Paste files in this directory from explorer
regpath.............Manipulate and view the system path
updateenvironment...Update environment (often saves logging out)



Script types
  addpath       (WSH)
  regpath       (WSH)
  dirload
  dirsave
  ccd           (Python and PyWin32)
  cpath         (Python and PyWin32)
  lnk           (Python and PyWin32)
  pcd           (Python and PyWin32)
  lnk           (Python and PyWin32, winshell)

 (WSH = Uses Windows Scripting Host)


Python Dependencies

Python 2.6 [As of Dec 2009] 
pywin32   http://sourceforge.net/projects/pywin32/
winshell  http://timgolden.me.uk/python/winshell.html
  