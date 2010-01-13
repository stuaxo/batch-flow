/**
 * A quickly put together script (pretty dirty in fact... however it seems
 * to work enough).
 * 
 * (C) Stuart Axon 2009, 2010
 * 
 * Licensed under MIT license
 */

function showUsage()
{
    u = new Array(); 
    u.push("System Path Utility");
    u.push('');
    u.push('Usage:');
    u.push('regpath [/Q][/M[a][#]][/P[:name]][/D[:directory]][/R[#n]|path][/F:file]');
    u.push('');
    if (canSetPath)
    {
        u.push("/L             Set Local path to system path");
    }
    u.push("/Q             Quiet - Don't output path");
    u.push("/M             Output in Multiline format [default]");
    u.push("/Ma            Output in Multiline format (absolute paths)");
    u.push("/M#            Output in Multiline format with numbers");
    u.push("/P             Output in PATH format\n");
    u.push("/P:name        Output in PATH format with [name] prefix");
    u.push("/D             Check for current directory in system path");
    u.push("/D:directory   Check for directory in system path");
    u.push("/F:file        Look for file in system path");
    u.push('');
    //u.push("/R#n           Remove numbered entry n"); // TODO
    //u.push("/R path        Remove path");             // TODO
    u.push('');
    u.push('/V             Validate directories in system path exist');
    u.push('');
    u.push("ErrorLevels:");
    u.push("1: Directory not in registry found");
    u.push("2: File not found in registry path");
    u.push('');
    for (var i = 0; i < u.length; i++)
    {
        WScript.Echo(u[i])
    }
}

canSetPath = false; // Only an external batch file can do this
findPath = "";
prefix = "";
envName = "";
exitVal = 0;
showHelp = false;
displaySummary = true;

displayPath = true;
multiLine = true;
showNumbers = false;
absPaths = false;

validate = false;

WshShell = WScript.CreateObject("WScript.Shell");
systemEnv = WshShell.Environment("SYSTEM");
userEnv = WshShell.Environment("User");
registryPath = userEnv("Path");
if (registryPath != "")
{
	registryPath += ";";
}
registryPath += systemEnv("Path");


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


/**
 * Delete path by index
 *
 * Relys on an implementation detail of the indexing
 * 
 * Indexing shows user paths first, and then system paths
 */
function deleteIndexPath(pathIndex)
{
    WScript.Echo('TODO... Possibly this all needs rewriting before manipulating any paths');
}


/**
 * Find folders in registry path
 *
 * Checking is case insensitive
 *
 * TODO 
 *  - Check short filenames
 *  - Ignore trailing slashes
 */
function folderInRegPath(folder)
{
    checkFolder = absPath(folder);
    
    folders = registryPath.split(';');
    for(j = 0; j < folders.length; j++)
    {
        if (absPath(folders[j]) == checkFolder)
        {
            return folders[j];
        }
    }
    return false;
}

 
/**
 * Return true if the file is in the path
 *
 * This is a bit dumb: ';' between quotes
 * might confuse it.
 */
function fileInRegPath(filename)
{
    fso = WScript.CreateObject("Scripting.FileSystemObject");
    folders = registryPath.split(';');
    found = false;
    for(j = 0; j < folders.length; j++)
    {
        folder = folders[j];
        if (fso.FileExists(absPath(folder + '\\' + filename)))
        {
            found = true;
            WScript.Echo('@ ' + absPath(folder));
        }
    }
    return found;
}


/**
 * Depending on status output pass or fail message
 */
function statusMessage(status, okMessage, failMessage)
{
    if (status)
    {
        WScript.Echo(okMessage);
    }
    else
    {
        WScript.Echo(failMessage);
    }
    return status;
}

function validatePath()
{
    fso = WScript.CreateObject("Scripting.FileSystemObject");
    folders = registryPath.split(';');
    
    WScript.StdErr.Writeline('[Exists]  Folder');
    for(j = 0; j < folders.length; j++)
    {
        folder = folders[j];
        if (absPaths)  // Hack for output
        {
            folder = absPath(folder);
        }

        if (showNumbers)
        {
            message = '#' + (j +1) + '\t';
        }
        else
        {
            message = '';
        }
        if (fso.FolderExists(absPath(folder)))
        {
            message += ' [OK]  ' + folder;
        }
        else
        {
            message += '[FAIL] ' + folder;
        }
        WScript.Echo(message);
    }
}

function showMultilineRegPath(absPaths)
{
    folders = registryPath.split(';');
    for(j = 0; j < folders.length; j++)
    {
        folder = folders[j];
        if (showNumbers)
        {
            message = '#' + (j +1) + '\t';
        }
        else
        {
            message = '';
        }
        if (absPaths)
        {
            message += absPath(folder);
        }
        else
        {
            message += folder;
        }
        WScript.Echo(message);
    }
}


/**
 * Return the right parameter (seperated by ':')
 *
 * Used by cronky parameter parsing
 */
function getRParam(argument)
{
    if (argument.charAt(2) == ':')
    {
        return argument.substr(3);
    }
    else
    {
        return '';
    }
}


/**
 * This bit is hacked together and doesn't use the proper api at all,
 * and sets a loads of global flags, ew.       never mind... 
 */
function processArguments()
{
    for(i = 0; i < WScript.Arguments.length; i++)
    {
        argument = WScript.Arguments(i);
        rParam = getRParam(argument);
        if (argument.length > 1 && argument.charAt(0) == '/')
        {
            switch(argument.toUpperCase().charAt(1))
            {
                case 'B':
                    if (argument=='/BATCHLAUNCH')
                    {
                        canSetPath = true;
                    }
                    break
                case 'R':
                    // More dodgy option parsing
                    if (argument.charAt(2) == '#')
                    {
                        deleteIndexPath(argument.substr(3));
                    }
                    else
                    {
                        if (i == WScript.Arguments.length -1)
                        {
                            WScript.Echo('Must specify path or index to remove');
                        }
                        deletePath(WScript.Arguments(i + 1));
                    }
                    break;
                case '?':
                    showHelp = true;
                    break;
                case 'M':
                    multiLine = true;
                    // More option parsing
                    if (argument.charAt(2).toUpperCase() == 'A' || argument.charAt(3).toUpperCase() == 'A')
                        absPaths = true;
                    if (argument.charAt(2) == '#' || argument.charAt(3) == '#')
                        showNumbers = true;
                    break;
                case 'P':
                    multiLine = false;
                    if (rParam != '')
                    {
                        prefix = rParam;
                    }
                    else
                    {
                        prefix = "PATH=";
                    }
                    break;
                case 'D':
                    displayPath = false;
                    if (rParam)
                    {
                        checkPath = argument.substr(3);
                    }
                    else
                    {
                        checkPath = getCWD();
                    }
                    if (!statusMessage(
                            foundFolder = folderInRegPath(checkPath),
                            'Found in Registry Path [' + foundFolder + ']',
                            'Not Found in Registry Path [' + checkPath + ']'))
                        exitVal = 1;
                    break;
                case 'F':
                    if (rParam)
                    {
                        displayPath = false;
                        if (!statusMessage(
                            fileInRegPath(rParam),
                            'File in Registry Path [' + rParam + ']',
                            'File not in Registry Path [' + rParam + ']'))
                            exitVal |= 2;
                    }
                    else
                    {
                        WScript.StdErr.Writeline('Must specify a file.');
                    }
                    break;
                case 'Q':
                    displayPath = false;
                    break;
                case 'V':
                    if (argument.charAt(2).toUpperCase() == 'A' || argument.charAt(3).toUpperCase() == 'A')
                        absPaths = true;
                    if (argument.charAt(2) == '#' || argument.charAt(3) == '#')
                        showNumbers = true;
                    validatePath();
                    validate = false;
                    displayPath = false;
                    break;
            }
        }
        else
        {
            /// Yeah has cut n paste, ew
            displayPath = false;
            // By default check if the folder is in the path
            fso = WScript.CreateObject("Scripting.FileSystemObject");
            if (fso.FolderExists(absPath(argument)))
            {
                // If it's a folder then test it
                if (!statusMessage(
                            foundFolder = folderInRegPath(argument),
                            'Found in Registry Path [' + foundFolder + ']',
                            'Not Found in Registry Path [' + absPath(argument) + ']'))
                        exitVal = 1;
            }
            else
            {
                WScript.StdErr.Writeline(argument + ' is not a folder or valid option');
            }
        }
    }
}

/**
 * Not 100% right as output happens in other places too
 */
function showOutput()
{
    if (showHelp)
    {
        showUsage();
    }
    else if (displayPath)
    {
        pathLine = prefix + registryPath;
        if (! WScript.Arguments.length)
        {
            WScript.StdErr.Writeline('Registry Path:');
        }
        if (multiLine)
        {
            showMultilineRegPath(absPaths);
            if (! WScript.Arguments.length)
            {
                WScript.Echo('');
                statusMessage(folderInRegPath(getCWD()),
                    'Current directory [' + getCWD() + '] found in system path',
                    'Current directory [' + getCWD() + '] not found in system path');
            }
        }
        else
        {
            WScript.Echo(pathLine);
        }
    }
}

function main()
{
    processArguments();
    showOutput();
    WScript.Quit(exitVal);
}

main();
