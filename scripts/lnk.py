import os
import sys

import winshell

def create_shortcut(target, shortcut):
    if target.rpartition('.')[2] in ('cmd', 'bat', 'exe', 'lnk', 'pif', 'com', 'url'):
        processed_shortcut = shortcut.rpartition('.')[0] + '.lnk'
    else:
        processed_shortcut = shortcut + '.lnk'
    
    print 'create: ' + processed_shortcut
    print 'target: ' + target
    
    winshell.CreateShortcut (
          Path=processed_shortcut,
          Target=target,
          #Description=""
        )


def main():
    if len(sys.argv) == 1:
        print 'Usage:'
        print 'lnk target [shortcut]'
    else:
        target = os.path.abspath(sys.argv[1] if len(sys.argv) > 1 else os.getcwd())
        shortcut = sys.argv[2] if len(sys.argv) > 2 else os.path.basename(target)
        create_shortcut(target, shortcut)



if __name__=='__main__':
    main()
