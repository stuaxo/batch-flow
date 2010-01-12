"""
Paste files in the current directory, in the same way as explorer does.

(If they were 'cut' they will be moved, otherwise copied)
"""
import os
import sys
import struct

import win32api
import pythoncom

from win32con import CF_HDROP
from win32com.shell import shellcon
import win32clipboard

DROPEFFECT_COPY, DROPEFFECT_MOVE = 5, 2

def get_dropeffect():
    """
    Return drop effect of file
    """
    CF_PREFERREDDROPEFFECT = win32clipboard.RegisterClipboardFormat(
        shellcon.CFSTR_PREFERREDDROPEFFECT)
    effect_str = win32clipboard.GetClipboardData(CF_PREFERREDDROPEFFECT)
    return struct.unpack("i", effect_str[:4])[0]

def main():
    targetdir = os.path.abspath(sys.argv[1] if len(sys.argv) > 1 else os.getcwd())
    
    ## Note - Need DropEffect to work out if it's copy or cut
    win32clipboard.OpenClipboard()
    if (win32clipboard.IsClipboardFormatAvailable(CF_HDROP)):
        files = win32clipboard.GetClipboardData(CF_HDROP)
        drop_effect = get_dropeffect()
    else:
        files = []
        drop_effect = None
    win32clipboard.CloseClipboard()
    
    if os.path.abspath(os.path.commonprefix(files)) == targetdir:
        print 'Files already in folder [' + targetdir + ']'
    
    ## TODO - Check for overwriting
    
    if drop_effect == DROPEFFECT_COPY:
        for filename in files:
            print filename
            win32api.MoveFile(filename, os.path.join(targetdir, os.path.basename(filename)))
    elif drop_effect == DROPEFFECT_MOVE:
        for filename in files:
            print filename
            win32api.CopyFile(filename, os.path.join(targetdir, os.path.basename(filename)))
        


if __name__ == "__main__":
    main()

