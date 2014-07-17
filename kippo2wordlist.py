#!/usr/bin/python

import re, os

print '''
 _   ___                    _____  _    _               _ _ _     _   
| | / (_)                  / __  \| |  | |             | | (_)   | |  
| |/ / _ _ __  _ __   ___  `' / /'| |  | | ___  _ __ __| | |_ ___| |_ 
|    \| | '_ \| '_ \ / _ \   / /  | |/\| |/ _ \| '__/ _` | | / __| __|
| |\  \ | |_) | |_) | (_) |./ /___\  /\  / (_) | | | (_| | | \__ \ |_ 
\_| \_/_| .__/| .__/ \___/ \_____/ \/  \/ \___/|_|  \__,_|_|_|___/\__|
        | |   | |                                                     
        |_|   |_|                                                     
Author: Ian Ahl, 1aN0rmus@TekDefense.com
Created: 01/13/2013
'''


# variables for the kippo logs, if your path is not the default from honeydrive, modify logPath. 
# if your log files are not named kippo.log or kippor.log.x please modify logPre.
logPre = 'kippo.log'
logPath = '/opt/kippo/log/'
outputFile = '/opt/kippo/log/wordlist.txt'
reSearch = 'login\sattempt\s\[(.+)\/(.+)\]\s'
passwordList = []

# open up the directory found in the logPath variable to find any files that start with the prefix from variable logPre.
# Opens each of those logfiles and uses regex to find to find the passwords and add them to a list.
for r, d, f in os.walk(logPath):
    for files in f:
        if files.startswith(logPre):
            #print files
            logFile = logPath + files
            #print logFile
            lines = open(logFile,'r').readlines()
            for i in lines:
                searchPass = re.search(reSearch,i)
                if searchPass is not None:
                    passwordList.append(searchPass.group(2))
# Removing duplicate entries with the set function.
passwordList = list(set(passwordList))                   
# outputting results to the file defined in the outputFile variable.
output = open(outputFile, 'w')
for i in passwordList:
    output.write(i + '\n')
print 'Wordlist has been archived to ' + outputFile
