'''List of users on local host:'''
quser
'''List of users on remote host:'''
quser /SERVER:hostname

'''Logoff a user remotely'''
#1) grab the session id from: quser /SERVER:hostname
#2) Execute the command below, replace Session ID with the one you want to logoff.
Logoff SESSIONID /SERVER:hostname

'''Installation:'''
#Install office or any other installations
Cd /tmp #the temp folder or any other path if preferred
Cd to the file of the installation [ cd XXXXXX]
Setup /configure configuration-Office365-x64 #example of O365

'''Credential Store: (Delete any username and password stored on the PC)'''
# 
Navigate to Start > Run > 
rundll32.exe keymgr.dll,KRShowKeyMgr
To Reset your own password
explorer shell:::{2559a1f2-21d7-11d4-bdaf-00c04f60b9f0}
