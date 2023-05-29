'''List of users on local host:'''
quser
'''List of users on remote host:'''
quser /SERVER:hostname

'''Logoff a user remotely'''
#1) grab the session id from: quser /SERVER:hostname
#2) Execute the command below, replace Session ID with the one you want to logoff.
Logoff SESSIONID /SERVER:hostname

'''Installation:'''
# Install office or any other installations
Cd /tmp #the temp folder or any other path if preferred
Cd to the file of the installation [ cd XXXXXX]
Setup /configure configuration-Office365-x64 #example of O365

'''Credential Store: (Delete any username and password stored on the PC)'''
# Navigate to Start > Run > 
rundll32.exe keymgr.dll,KRShowKeyMgr
'''To Reset your own password'''
explorer shell:::{2559a1f2-21d7-11d4-bdaf-00c04f60b9f0}

'''Permissions:'''
'''Show permissions on a folder:'''
get-acl "C:\Users\username" | FL  ("folder path")
Get DFS path
Get-DfsnFolderTarget -Path "\\google.com\users\Home" 

'''Show owner of folder::'''
GET-ACL "\\path\" | Select Path, Owner -expand access

'''AD Basic Commands'''
# Unlock AD account
Unlock-ADAccount -Identity <username>
# Identify Lockouts
Get-ADUser XXXX -Properties * | Select-Object LockedOut
# Account Information
net user XXXXX /Domain
# Show AD Groups of a user:
Get-ADPrincipalGroupMembership -Identity (AD Name) | Format-Table -Property name
# Get List of AD groups members names:
Get-ADGroupMember -Identity "Security Group" | Select-Object Name | Sort-Object Name

''' AD Advanced '''
$DSACL_GRP_1 = {dsacls "OU=REPLACEWITH OU PATH OF OKTA GROUPS" /I:T /G 'REPLACEWITH Company Deligation AD Client Security Group Admin:CCDC;group'}
$DSACL_GRP_2 = {dsacls "OU=REPLACEWITH OU PATH OF OKTA GROUPS" /I:S /G 'REPLACEWITH Deligation AD Client Security Group Admin:GA;;group'}
Invoke-Command -ScriptBlock $DSACL_GRP_1
Invoke-Command -ScriptBlock $DSACL_GRP_2

#Script to gather LastLogon in AD  
Get-ADUser -Filter * -Properties “LastLogonDate” | select SAMAccountName, LastLogonDate, GivenName, Surname | Export-Csv -Path .\LastLogon3.csv 
# REPLACE AD VALUE FROM CSV 
#Replace 'namecolumn' ; 'phonecolumn' ; @{'ipPhone'} with required variables 
$csv = '\\path\to\CSV\file' 
foreach($item in $csv) {%u 
    Set-ADUser -Identity $($item.'namecolumn') -Replace @{'ipPhone'= 'phonecolumn'}} 

''' Computer objects in servers OU '''
/I:T  # This object and subobjects.
/I:S # Subobjects only.
/G # Grants specified permissions to the user or group.
CC # Create child object. this applies to all types of child objects; otherwise, it applies to the specified child-object type.
DC # Delete a child object.
;computer # specifies Computer Objects
;user # specifies User objects
:GA  # Generic All, Read Write Execute

 
''' DIRECTORY PERMISSIONS '''
$path = "\\server\path\" #define path to the shared folder 
$reportpath ="C:\Users\$env:UserName\Desktop\ACL.csv" #define path to export permissions report 
#script scans for directories under shared folder and gets acl(permissions) for all of them 
dir -Recurse $path | where { $_.PsIsContainer } | % { $path1 = $_.fullname; Get-Acl $_.Fullname | % { $_.access | Add-Member -MemberType NoteProperty '.\Application Data' -Value $path1 -passthru }} | Export-Csv $reportpath 

#Translate an SID to a user name or group
Get-ADUser -Filter * | Select-Object -Property SID,Name | Where-Object -Property SID -like "*-INSERTLASTFOUROFSIDHERE"

'''Check user in another Domain via powershell'''
Get-ADUser -Server "example.domain.local" -identity $username -properties passwordlastset, passordexpired, whenchanged, LastBadPasswordAttempt, LastLogonDate, canonicalname, emailaddress
#Script for gathering a list of users that haven't logged into a domain account in X amount of days and are still active - Will output CSV file to the root folder for the current user
$domain = "<enter domain here>"  # Quotes need to be present when running
$DaysInactive = <place amount of days inactive to check here>
$time = (Get-Date).Adddays(-($DaysInactive))
Get-ADUser -Filter {LastLogonTimeStamp -lt $time -and enabled -eq $true } -Properties LastLogonTimeStamp,enabled | select-object Name,@{Name="Stamp"; Expression={[DateTime]::FromFileTime($_.lastLogonTimestamp).ToString('yyyy-MM-dd')}} | export-csv C:\Users\$env:username\Inactive_Users.csv -notypeinformation

'''Windows Management Instrumentation (WMI) classes or information about the available classes.'''
Get-Wmiobject Win32_Service | Where-Object {$_.PathName -like '*[EXECUTABLE NAME GOES HERE]*'} | Select Name, DisplayName, State, Description, PathName; Get-Date | Select DateTime 

'''GET LIST OF COMPUTERS IN Add-Member and export to csv'''
# GENERIC 
Get-ADComputer -Filter * -Property * | Select-Object Name, Userprincipalname | Export-Csv C:\Users\$env:UserName\Desktop\computers.csv -NoTypeInformation -Encoding UTF8 
#SPECIFIC 
GET-ADComputer -Properties Description -Filter * -SearchBase "ou=PCs,dc=star,dc=ad,dc=us,dc=StarLightning,dc=com" | Select-Object Name,Description 

'''Script to gather Access Control List'''
# Replace [Words under these] with actual Values 
# Example: $SharedPathArray = 'C:\Windows', 'C:\Users' 
# Delimited by Pipe Symbol "|" 
$SharedPathArray = '[ABSOLUTE PATH]', '[ABSOLUTE PATH]', '[ABSOLUTE PATH]', '[ABSOLUTE PATH]', '[ABSOLUTE PATH]', '[ABSOLUTE PATH]' 
(Get-ChildItem -Directory -literalPath $SharedPathArray -recurse | ForEach-Object {Get-Acl $_.FullName} | Select PSChildName, Owner, Group -expand Access | Export-Csv "[PATH TO DESTINATION.csv]" 
Import-Csv -path "[PATH TO NON CSV FILE WITH DIMITERS.txt]" -Delimiter "|" | Export-Csv "[PATH TO DESTINATION.csv]


'''Drive Space Clearing:'''
<# Use the drive script
ONLY if the script is encountering errors use this command before attempting to run the script again: #>
set-executionpolicy undefined -scope currentuser
#To empty recycle bin
rd /s c:\$recycle.bin # command prompt admin
#To empty MSOcache
rd /s c:\MSOcache   # command prompt admin

'''Services'''
#Basic restart service
restart nsclientpp service

#Remotely start service:
Get-Service -Name [service] -ComputerName [ComputerName] | Start-service
#Displays service status: 
sc queryex [Service Name] 
# Shows friendly name:
Get-display name [service name]
# Start a service:
Start-services *name*
# Restart a service
Restart-services *name*
# Stop a service
Stop-services *name*
# Kill service: 
taskkill /f /pid 772
# To Review all Services commands and what can be done:
get-help Get-Service
 
# Other services command and Exaple:
cd C:\windows\system32
lodctr /R
cd C:\windows\syswow64
lodctr /R
winmgmt /resyncperf
restart-service winmgmt -Force
restart-service SNMP -Force
restart-service nsclientpp -Force
 
#SERVICE LOCATOR 
IF ($OSProcess = Get-WmiObject win32_service | ?{$_.pathname -like '*lmgrd*'} | select Name, DisplayName, State, PathName) {$OSProcess} Else {Write-Host 'No service found matching your keyword in the executable path of the service'} 
