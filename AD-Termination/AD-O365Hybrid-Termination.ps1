<#
Creation by Helen Najar
#>

# Import Active Directory Module
Import-Module ActiveDirectory
Add-Type -Assembly 'System.Web'

Write-Host " "
Write-Host "========================================================"  -ForegroundColor Yellow
Write-Host "    Welcome to the Termination in Active Directory     "  -ForegroundColor Green
Write-Host "========================================================"  -ForegroundColor Yellow
Write-Host "            SkyStar Environment Script Launched        "  -ForegroundColor Green
Write-Host "========================================================"  -ForegroundColor Yellow
Write-Host " "

# Gather LAN ID
$username = Read-Host "Enter User's username"

# Validate username input
while ($username -match '[$!~#%&*{}\\:<>?/|+"@_]' -or $username.Length -eq 0 -or $username -eq ' ') {
    $username = Read-Host -Prompt "Invalid characters detected. Please enter a valid LAN ID"
}

$udoesExist = Get-ADUser -Filter { SamAccountName -eq $username } -Properties SamAccountName | Select-Object SamAccountName
$udoesExist1 = $udoesExist.SamAccountName

while (-not $udoesExist1) {
    Write-Host "The username provided was not found. Please enter a valid username:" -ForegroundColor Red -NoNewline
    $username = Read-Host -Prompt " "
    $udoesExist = Get-ADUser -Filter { SamAccountName -eq $username } -Properties SamAccountName | Select-Object SamAccountName
    $udoesExist1 = $udoesExist.SamAccountName
}

$date = Get-Date -DisplayHint Date

# Validate ticket number format
# Pattern: 'REQ' followed by 7 digits (total length = 10 chars, e.g. REQ1234567)
do {
    $ticketnumber = Read-Host "Enter Ticket Number"
    $ticketnumber = $ticketnumber.ToUpper()
    $isValid = $false

    if ($ticketnumber.Length -eq 10) {
        # Check prefix 'REQ' and 7 digits
        $startsWithREQ = $ticketnumber.Substring(0,3) -match "^(REQ)$"
        $isNumeric = $ticketnumber.Substring(3) -match "^[0-9]{7}$"

        if ($startsWithREQ -and $isNumeric) {
            $isValid = $true
        }
    }

    if (-not $isValid) {
        Write-Host "Invalid input. The input must be exactly 10 characters long, start with 'REQ', and the remaining 7 characters must be numbers."
    }
} while (-not $isValid)

$StaticDesc = "Disabled on "
$FullDesc = "$StaticDesc$date per $ticketnumber"

# Generate a randomized Password
function Generate-Password([int32]$PasswordLength = 22) {
    # Using ASCII codes for 0-9, A-Z, a-z
    $_local_str = -join ((0x30..0x39)+(0x41..0x5A)+(0x61..0x7A) | Get-Random -Count $PasswordLength | ForEach-Object {[Char]$_})
    return ConvertTo-SecureString $_local_str -AsPlainText -Force
}

Write-Host " "
Get-ADPrincipalGroupMembership $username | Select Name
Write-Host "Gathering MemberOf..."
Write-Host "MemberOf will display again once the script is completed."
Write-Host " "
Write-Host "Ensuring 'Domain Users' is the Primary AD Group..."
$group = Get-ADGroup "Domain Users" -Properties @("primaryGroupToken")
Get-ADUser $username | Set-ADUser -replace @{primaryGroupID=$group.primaryGroupToken}
Write-Host "'Domain Users' set as the Primary Group - COMPLETED"

$passW = Generate-Password
Write-Host " "
Write-Host "Setting New Password..."
Set-ADAccountPassword -Identity $username -Reset -NewPassword (ConvertTo-SecureString -AsPlainText $passW -Force)
Write-Host "New Password Set - COMPLETED"

Write-Host " "
Write-Host "Converting to Shared Mailbox on Hybrid..."
Set-RemoteMailbox "$username@skystar.com" -Type Shared
Write-Host "Converted to Shared Mailbox on Hybrid - COMPLETED"

Write-Host " "
Write-Host "Hiding From Address Lists..."
Set-RemoteMailbox -Identity "$username@skystar.com" -HiddenFromAddressListsEnabled $true
Write-Host "Hidden from Address Lists - COMPLETED"

Write-Host " "
Write-Host "Syncing to O365..."
Connect-ExchangeOnline
Set-Mailbox "$username@skystar.com" -Type Shared
Write-Host "Syncing to O365 - COMPLETED"

Write-Host " "
Write-Host "Clearing Calendar Events..."
$Email = "$username@skystar.com"
Remove-CalendarEvents -Identity $Email -CancelOrganizedMeetings -QueryWindowInDays 120
Write-Host "Calendar Events Cleared for $Email - COMPLETED" -ForegroundColor Cyan

Write-Host " "
Write-Host "Removing Group Memberships..."
Get-ADUser -Identity $username -Properties MemberOf | ForEach-Object { $_.MemberOf | Remove-ADGroupMember -Members $_ -Confirm:$false }
Write-Host "Group Memberships Removed - COMPLETED (Ignore any primary group error)"

Write-Host " "
Write-Host "Updating Description Field..."
$CurrentDesc = (Get-ADUser -Identity $username -Properties Description).Description
$UpdatedDesc = "$FullDesc - $CurrentDesc"
Set-ADUser -Identity $username -Description $UpdatedDesc
Write-Host "Description Field Updated - COMPLETED"

Write-Host " "
Write-Host "Disabling Account..."
Set-ADUser -Identity $username -Enabled $false
Write-Host "Account Disabled - COMPLETED"

Write-Host " "
Write-Host "Moving account to Disabled Mailbox Sync OU..."
Get-ADUser $username | Move-ADObject -TargetPath 'OU=Disabled Sync,OU=Disabled Objects,DC=skystar,DC=com'
Write-Host "Moved to Disabled Mailbox Sync OU - COMPLETED"
Write-Host " "

Write-Host "Please take the proper screenshot or copy the entire process into the ticket."
$answer = Read-Host -Prompt "Press 'y' for Yes or 'n' for No"
Write-Output ' '
while ($answer -notmatch '^[YyNn]$') {
    Write-Host "Your selection is not valid. Please press 'y' for Yes or 'n' for No."
    $answer = Read-Host -Prompt " "
}

if ($answer -match '^[Nn]$') {
    Write-Host "Exiting script..." -ForegroundColor Cyan
}
