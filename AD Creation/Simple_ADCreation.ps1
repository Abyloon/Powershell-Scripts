# Active Directory
Import-Module ActiveDirectory

# Arrays for the script
$FirstName = Read-Host "Enter First Name"
$Surname = Read-Host "Enter Last Name"
$Username = Read-Host "Enter Username (i.e - FirstinitialLastName)"
$ADgroups = Read-Host "Copy AD group membership from which user?"
$Password = Read-Host "Enter a Password" | ConvertTo-SecureString -AsPlainText -Force

# Creating Displayname, First name, surname, samaccountname, UPN, etc and entering and a password for the user.
 New-ADUser `
-Name "$FirstName $Surname" `
-GivenName $FirstName `
-Surname $Surname `
-SamAccountName $Username `
-UserPrincipalName $Username@domain.com `
-Displayname "$FirstName $Surname" `
-Path "CN=Users,DC=domain,DC=com" `
-AccountPassword $Password 

# Set required details
Set-ADUser $Username -Enabled $True
Set-ADUser $Username -ChangePasswordAtLogon $False 
Set-ADUser $Username -EmailAddress "$Username@domain.com"

# Finds all the AD-groups that the "$ADGroups" user you entered is a part of and adds it to the new user automatically.
Get-ADPrincipalGroupMembership -Identity $ADgroups | Select-Object SamAccountName | ForEach-Object {Add-ADGroupMember -Identity $_.SamAccountName -Members  $Username }

Write-Host -BackgroundColor DarkGreen "Active Directory user account setup complete!"