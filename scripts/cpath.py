from win32clipboard import OpenClipboard, EmptyClipboard, SetClipboardText, CloseClipboard
from os import environ

def main():
    """
    Copy current working directory to clipboard
    """
    OpenClipboard()
    EmptyClipboard()
    SetClipboardText(environ['PATH'])
    CloseClipboard()
    print 'Copied Path'
    
if __name__ == "__main__":
    main()

