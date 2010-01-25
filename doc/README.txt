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



Scripts Summary

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



Detailed documentation for scripts:


[Registry path utilities]

AddPath

Add a directory to the the registry path

Add current directory to the system path:
[c:\batch-flow] addpath .

Add a specific directory to the system path:
[c:\batch-flow] addpath "c:\Program Files\gimp\bin"


Regpath

Test and manipulate the registry path.

/L             Set Local path to system path

If you've changed the windows path in the gui, use this to make sync
up the path in the commandline.


/Q             Quiet - Don't output path

For Use in batch files, output nothing to the console


/M             Output in Multiline format [default]
/Ma            Output in Multiline format (absolute paths)
/M#            Output in Multiline format with numbers

Use /M to get a multiline listing of the system paths.
The 'a' suffix expands all paths to absolute paths.
The '#' suffix displays a number by each line.


/P             Output in PATH format

Output the system path in the format PATH=path1;path2

This can be useful for the generation of batch files


/P:name        Output in PATH format with [name] prefix

Output the path in the format name=path1;path2

This can be useful for the generation of batch files


/D             Check for current directory in system path


/D:directory   Check for directory in system path

Check if a directory appears in the system path


/F:file        Look for file in system path

Search the directories in a system path for a file
(note wildcards are not supported).


/V             Validate directories in system path exist

Checks if directories in the system path exist.


[Explorer Clipboard Integration with Commandline]

CPath

Copy the current 'PATH' environment variable to the clipboard


CCD

Copy Current Directory to clipboard

Instead of manually copying the folder from the prompt with the mouse, use this script.


PCD

Go to current directory in clipboard

With the address bar enabled in explorer:
- click on it and use Ctrl-C to copy.
- Go to the commandline and enter PCD to go to that folder instantly.


PFiles

Paste files into the current directory.

Works in the same way as using 'paste' in windows explorer to a folder


[Directory Bookmarking with dirsave and dirload]

dirsave

Saves directory bookmarks

Save a bookmark 'devstuff'
[c:\dev\my stuff] dirsave devstuff
Saved directory to devstuff

Clear a bookmark named 'test'
dirsave /c test

Clear a bookmark named 'test1' and 'test2'
dirsave /c test1 test2


dirload

List saved folders

[c:\] dirload /l
Bookmark        Directory
devstuff        C:\dev\my stuff
work		C:\dev\work
games		F:\games

Go to saved bookmark 'devstuff'
[c:\] dirload devstuff
[c:\dev\my stuff]

List specific bookmarks
[c:\dev\my stuff] dirload /l devstuff work
Bookmark        Directory
devstuff        C:\dev\my stuff
work		C:\dev\work

This is used to have directories bound to Fkeys in TCC/LE or 4nt.

When pressing Alt-F12 only the bookmarks attached to Fkeys are shown,
to see all the saved bookmarks dirload /l can be used as normal.



Show a single bookmark with no title (useful for scripting)
[c:\] dirload /s devstuff
devstuff        C:\dev\my stuff
[c:\]



For Developers

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
  