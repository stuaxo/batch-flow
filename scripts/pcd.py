import os
import sys
import tempfile

from win32con import CF_TEXT, CF_HDROP
from win32clipboard import IsClipboardFormatAvailable, OpenClipboard, GetClipboardData, CloseClipboard

def _gen_script(script, clipboard):
    """
    Generate script to change directory
    """
    with open(script, 'wb') as f:
        f.write('CD /D %s\n' % clipboard)
    

def main():
    """
    Copy current working directory to clipboard
    """
    if sys.argv[-1] != '/BATCHLAUNCH':
        print 'Needs to be launched from batch file.'
        sys.exit(1)
    
    OpenClipboard()
    if (IsClipboardFormatAvailable(CF_TEXT)):
        clipboard = GetClipboardData(CF_TEXT)
    elif (IsClipboardFormatAvailable(CF_HDROP)):
        clipboard = os.path.basename(GetClipboardData(CF_HDROP)[0])
    else:
        print 'Sorry no clipboard data I can use.'
        clipboard = None
    CloseClipboard()
    
    if not clipboard:
        sys.exit(1)
    
    cwd = os.getcwd()
    if cwd == clipboard:
        print 'Already at [' + clipboard + ']'
        sys.exit(1)
    
    try:
        os.chdir(clipboard)
        _gen_script('%s\\go_pcd.cmd' % tempfile.gettempdir(), clipboard)
    except:
        location, sep, extra = clipboard.partition('\n')
        if extra:
            print 'Too many lines in clipboard.'
        else:
            print 'Could not change to clipboard location [%s]' % location
        sys.exit(1)
    os.chdir(cwd)
    

if __name__ == "__main__":
    main()

