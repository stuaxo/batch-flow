import os
import sys

from win32clipboard import OpenClipboard, EmptyClipboard, SetClipboardText, CloseClipboard

def copy_file_location(file_path):
    """
    Copy current working directory to clipboard
    """
    OpenClipboard()
    EmptyClipboard()
    SetClipboardText(file_path)
    CloseClipboard()
    print '[%s] Copied to clipboard.' % file_path

if __name__ == "__main__":
    if len(sys.argv) > 1:
        if sys.argv[1].lower() in ('/?', '-h', '--help'):
            print 'ccd [file]'
            print ''
            print "If file is specified, it's absolute path is copied to the clipboard"
            print "otherwise the current working directory is copied to the clipboard"
        else:
            if os.path.isfile(sys.argv[1]) or os.path.isdir(sys.argv[1]):
                copy_file_location(os.path.abspath(sys.argv[1]))
            else:
                print '[%s] cannot be accessed. ' % sys.argv[1]

    else:
        copy_file_location(os.getcwd())


