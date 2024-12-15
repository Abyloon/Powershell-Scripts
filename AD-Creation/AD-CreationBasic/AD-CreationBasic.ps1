<# Author: Helen Najar
   Script: Create New Users in Active Directory basic format
#>
# Import the Active Directory module
Import-Module ActiveDirectory

# Prompt for user input
$FirstName = Read-Host "Enter First Name"
$Surname = Read-Host "Enter Last Name"
$Username = Read-Host "Enter Username (e.g., FirstinitialLastName)"
$ADgroups = Read-Host "Enter AD group to copy memberships from (leave blank if none)"
$Password = Read-Host "Enter a Password" | ConvertTo-SecureString -AsPlainText -Force

# Construct the full name and username
$DisplayName = "$FirstName $Surname"
$UserPrincipalName = "$Username@domain.com"
$EmailAddress = "$Username@domain.com"
$ADPath = "CN=Users,DC=domain,DC=com"

# Create the new AD user account
New-ADUser -Name $DisplayName `
           -GivenName $FirstName `
           -Surname $Surname `
           -SamAccountName $Username `
           -UserPrincipalName $UserPrincipalName `
           -DisplayName $DisplayName `
           -Path $ADPath `
           -AccountPassword $Password `
           -Enabled $True `
           -EmailAddress $EmailAddress `
           -ChangePasswordAtLogon $False

# Add the new user to the specified AD groups
if ($ADgroups) {
    Write-Host "Adding user to groups..."
    Get-ADPrincipalGroupMembership -Identity $ADgroups | Select-Object SamAccountName | ForEach-Object {
        Add-ADGroupMember -Identity $_.SamAccountName -Members $Username
    }
} else {
    Write-Host "No AD group specified. Skipping group membership assignment."
}

Write-Host -BackgroundColor DarkGreen "Active Directory user account setup complete!"
