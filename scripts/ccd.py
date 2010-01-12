from win32clipboard import OpenClipboard, EmptyClipboard, SetClipboardText, CloseClipboard
from os import getcwd

def main():
    """
    Copy current working directory to clipboard
    """
    OpenClipboard()
    EmptyClipboard()
    SetClipboardText(getcwd())
    CloseClipboard()
    print 'Copied CWD'

if __name__ == "__main__":
    main()

