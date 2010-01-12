/**
 * Add a path to the registry if it's not already present
 */

WshShell = WScript.CreateObject("WScript.Shell");
WshEnv = WshShell.Environment("SYSTEM");

function updateEnvironment()
{
    runDLL = "rundll32 user32.dll,UpdatePerUserSystemParameters";
    cmdLine = WshEnv("windir") + '\\system32\\' + runDLL;
    WshShell.Run(cmdLine);
}

/**
 * Return the absolute version of a path, expanding any environment
 * variables
 */
function absPath(path)
{
    expandedPath = WshShell.ExpandEnvironmentStrings(path);
    fso = WScript.CreateObject("Scripting.FileSystemObject");
    return fso.GetAbsolutePathName(expandedPath);
}

/**
 * Return current working directory
 */
function getCWD()
{
    return absPath('.');
}


function addPath(newPath)
{
    existingPath = WshEnv("Path");
    if (existingPath.charAt(existingPath.length - 1) != ';')
    {
        existingPath += ';';
    }
    newPathStr = newPath + ";";
    if (existingPath.toUpperCase().indexOf(newPathStr.toUpperCase()) == -1)
    {
        objFSO = WScript.CreateObject("Scripting.FileSystemObject");
        if (objFSO.FolderExists(newPath))
        {
            WScript.Echo('Adding [' + newPath + '] to path.');
            WshEnv("Path") = existingPath + newPath;
            WScript.Echo('Wait while the environment is updated...');
            updateEnvironment();
            WScript.Echo('Done');
            return 0;
        }
        else
        {
            WScript.Echo('path does not exist ' + newPath);
            return 2;
        }
    }
    else
    {
        WScript.Echo(newPath + ' already in path');
        return 1;
    }
}

function main()
{
    if (WScript.Arguments.length == 0)
    {
        WScript.Echo("Usage addpath.js path")
    }
    else if (WScript.Arguments.length == 1)
    {
        path = WScript.Arguments.Item(0);
        if (path == '.')
        {
            path = getCWD();
        }
        exitCode = addPath(path);
        WScript.Quit(exitCode);
    }
    else
    {
        WScript.Echo("paths with spaces must be quoted");
        WScript.Quit(3);
    }
}

main()