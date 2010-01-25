import os
import sys
import tempfile

from win32con import CF_TEXT, CF_HDROP
from win32clipboard import IsClipboardFormatAvailable, OpenClipboard, GetClipboardData, CloseClipboard

def _gen_script(script, directory):
    """
    Generate script to change directory
    """
    with open(script, 'wb') as f:
        f.write('CD /D %s\n' % directory)
    


def goto_directory(directory):
    """
    Generate batch script and then change to directory
    """
    _gen_script('%s\\go_pcd.cmd' % tempfile.gettempdir(), directory)
    os.chdir(directory)

def main():
    """
    Copy current working directory to clipboard
    """
    if len(sys.argv) == 1 or sys.argv[1] != '/BATCHLAUNCH':
        print 'Needs to be launched from batch file.'
        sys.exit(1)
    
    OpenClipboard()
    if (IsClipboardFormatAvailable(CF_TEXT)):
        # Copying from clipboard seems to add a 10 and a 0
        path = GetClipboardData(CF_TEXT).rstrip(chr(10) + chr(0))
    elif (IsClipboardFormatAvailable(CF_HDROP)):
        path = os.path.basename(GetClipboardData(CF_HDROP)[0])
    else:
        print 'Sorry no clipboard data I can use.'
        path = None
    CloseClipboard()
    
    if not clipboard:
    if not path:
        sys.exit(1)
    
    cwd = os.getcwd()
    if cwd == path:
        print 'Already at [' + path + ']'
        sys.exit(1)
    
    try:
        if os.path.isfile(path):
            parent = os.path.normpath(os.path.join(path, '..'))
            print '[%s] is a file, changing to parent directory.' % path
            goto_directory(parent)
        else:
            goto_directory(path)
    except:
        location, sep, extra = path.partition('\n')
        if extra:
            print 'Too many lines in clipboard.'
        else:
            print 'Could not change to clipboard location [%s]' % location
        sys.exit(1)
    os.chdir(cwd)
    

if __name__ == "__main__":
    main()

