<#
 .SYNOPSIS
    PowerShell Cheatsheet for System Administration.
 .DESCRIPTION
    This script provides a collection of commands for user management, 
    Active Directory operations, permissions handling, and service monitoring. 
    Designed to streamline system administration tasks.
 .AUTHOR
    Your Name
 .NOTES
    Replace placeholders (e.g., `<username>`, `<hostname>`) with actual values for your environment.
#>

# -----------------------
# User Management
# -----------------------

# List all users on the local machine
Write-Host "Listing users on the local host..."
quser

# List all users on a remote host
Write-Host "Listing users on a remote host..."
quser /SERVER:<hostname> # Replace <hostname> with the target server name.

# Log off a user on a remote host
Write-Host "Logging off a remote user. Retrieve Session ID from the command below:"
quser /SERVER:<hostname> # Step 1: Find the session ID.
Logoff <SESSIONID> /SERVER:<hostname> # Step 2: Log off the specific session ID.

# -----------------------
# Credential Management
# -----------------------

# Open Credential Manager to delete stored usernames and passwords
Write-Host "Opening Credential Manager..."
rundll32.exe keymgr.dll,KRShowKeyMgr

# Shortcut to reset your Windows password
Write-Host "Shortcut to reset your password..."
explorer shell:::{2559a1f2-21d7-11d4-bdaf-00c04f60b9f0}

# -----------------------
# Active Directory Commands
# -----------------------

# Unlock an Active Directory account
Unlock-ADAccount -Identity <username> # Replace <username> with the locked user account.

# Check if a user account is locked
Get-ADUser <username> -Properties LockedOut | Select-Object LockedOut

# Display group memberships of an AD user
Get-ADPrincipalGroupMembership -Identity <username> | Format-Table -Property Name

# Export group membership details for an AD group
Get-ADGroupMember -Identity "<Group Name>" | Select-Object Name | Sort-Object Name | Export-Csv -Path .\ADGroupMembers.csv -NoTypeInformation

# Gather last logon dates for all users in AD
Get-ADUser -Filter * -Properties LastLogonDate | Select-Object SAMAccountName, LastLogonDate | Export-Csv -Path .\LastLogonReport.csv

# -----------------------
# Permissions and ACLs
# -----------------------

# Display permissions for a specific folder
Get-Acl "C:\Path\To\Folder" | Format-List

# Export permissions for all directories under a shared folder to a CSV file
$SharedFolderPath = "\\server\path\"
$ExportPath = "C:\Users\$env:UserName\Desktop\PermissionsReport.csv"
Write-Host "Exporting permissions for $SharedFolderPath to $ExportPath..."
Get-ChildItem -Recurse $SharedFolderPath | Where-Object { $_.PsIsContainer } | ForEach-Object {
    $Permissions = Get-Acl $_.FullName
    $Permissions.Access | Add-Member -NoteProperty 'FolderPath' -Value $_.FullName -PassThru
} | Export-Csv -Path $ExportPath -NoTypeInformation

# Retrieve the owner of a folder
Write-Host "Retrieving folder owner..."
Get-Acl "\\path\to\folder" | Select-Object Path, Owner

# -----------------------
# WMI Queries and Services
# -----------------------

# Retrieve information about a specific service by its executable name
Write-Host "Searching for services by executable name..."
Get-WmiObject Win32_Service | Where-Object { $_.PathName -like "*<ExecutableName>*" } | Select-Object Name, DisplayName, State, PathName

# Restart a specific service
Write-Host "Restarting the specified service..."
Restart-Service -Name "<ServiceName>"

# Remotely start a service
Write-Host "Starting a service on a remote host..."
Get-Service -Name "<ServiceName>" -ComputerName "<RemoteHost>" | Start-Service

# Export all running services to a CSV file
Write-Host "Exporting a list of all running services..."
Get-Service | Where-Object { $_.Status -eq "Running" } | Export-Csv -Path .\RunningServices.csv -NoTypeInformation

# -----------------------
# Drive Cleanup
# -----------------------

# Empty the recycle bin
Write-Host "Clearing the recycle bin..."
rd /s /q c:\$recycle.bin

# Remove MSOcache to free up space
Write-Host "Clearing MSOcache..."
rd /s /q c:\MSOcache

# Reset execution policy to allow scripts
Write-Host "Resetting execution policy for the current user..."
Set-ExecutionPolicy Undefined -Scope CurrentUser

# -----------------------
# Additional Utilities
# -----------------------

# Check disk usage and free up space
Write-Host "Analyzing disk space..."
Get-PSDrive -PSProvider FileSystem | Select-Object Name, Used, Free

# Gather a list of inactive users in the domain
$InactiveDays = 90
Write-Host "Gathering a list of inactive users for the past $InactiveDays days..."
$Time = (Get-Date).AddDays(-$InactiveDays)
Get-ADUser -Filter { LastLogonTimeStamp -lt $Time -and Enabled -eq $true } -Properties LastLogonTimeStamp | Select-Object Name, @{Name="LastLogonDate";Expression={[DateTime]::FromFileTime($_.LastLogonTimeStamp)}} | Export-Csv -Path .\InactiveUsers.csv -NoTypeInformation

Write-Host "Script execution complete. Review the exported files for results."