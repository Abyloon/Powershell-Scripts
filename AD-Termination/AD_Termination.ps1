<#
Creation by Helen Najar
#>

# Active Directory
Import-Module ActiveDirectory
Add-Type -Assembly 'System.Web'

# Arrays for the script
write-host " "
Write-Host "========================================================"  -ForegroundColor Yellow
Write-Host "    Welcome to the Termination  in Active Directory     "  -ForegroundColor Green 
Write-Host "========================================================"  -ForegroundColor Yellow
write-host "            SkyStar Environment Script Launched             "  -ForegroundColor Green 
Write-Host "========================================================"  -ForegroundColor Yellow
write-host " "

#Gather LAN ID
$username = Read-Host  "Enter User's username "
#Test for invalid characters or an empty field in the $username variable
while($username -match '[$!~#%&*{}\\:<>?/|+"@_]' -or $username.Length -eq '0' -or $username -eq ' '){
  #Retest Condition
  $username = Read-Host -Prompt "You have entered an invalid character. Please enter a valid LAN ID"  
}
$udoesExist = Get-ADUser -Filter { SamAccountName -eq $username } -properties SamAccountName | Select-Object SamAccountName
$udoesExist1 = $udoesExist.samaccountname
while (!$udoesExist1) {
	Write-Host "The Username account provided was not found. Please Enter the User Username" -ForegroundColor Red -NoNewline
	$username = read-host -prompt " "
	$udoesExist =  Get-ADUser -Filter { SamAccountName -eq $username } -properties SamAccountName | Select-Object SamAccountName
	$udoesExist1 = $udoesExist.samaccountname
}
$date = Get-Date -DisplayHint Date
do {
    $ticketnumber = Read-Host "Enter Ticket Number"
    $ticketnumber = $ticketnumber.ToUpper()
    $isValid = $false

    if ($ticketnumber.Length -eq 10) {
        $startsWithSREQ = $ticketnumber.Substring(0,3) -match "^(SRQ|SRQ)$"
        $isNumeric = $ticketnumber.Substring(3) -match "^[0-9]{7}$"

        if ($startsWithSREQ -and $isNumeric) {
            $isValid = $true
        }
    }

    if (-not $isValid) {
        Write-Host "Invalid input. The input must be exactly 11 characters long, start with 'SREQ' or 'sreq', and the remaining 7 characters must be numbers."
    }
} while (-not $isValid)
$StaticDesc = "Disabled on "
$FullDesc = $($StaticDesc) + $($date) + " per $ticketnumber"

##Generate a randomized Password 
function Generate-Password([int32]$PasswordLength = 22){
        #Using ASCII Hexadecimal codes for A to Z, a to z and Numbers (0, 9)
        #then iterate(for-each) and randomly pick characters(ASCII to Char conversion)
        $_local_str = -join( (0x30..0x39) + (0x41..0x5A ) +(0x61..0x7A) | Get-Random  -Count $PasswordLength | % {[Char]$_} )
        return ConvertTo-SecureString $_local_str -AsPlainText -Force
}
Write-Host " "
Get-ADPrincipalGroupMembership  $username | Select name
Write-Host "Gathering MemberOf..."
Write-Host "Gathered MemberOf, it will show off once the script is completed"
Write-Host " "
Write-Host "Ensuring Domain User is the Primary AD Group..."
$group = get-adgroup "Domain Users" -properties @("primaryGroupToken")
Get-ADUser $username | Set-ADUser -replace @{primaryGroupID=$group.primaryGroupToken}
Write-Host "Ensured Domain User is the Primary AD Group - COMPLETED"

$passW = Generate-Password
## New Password
Write-Host " "
Write-Host "Setting New Password..."
Set-ADAccountPassword -Identity $username -Reset -NewPassword (ConvertTo-SecureString -AsPlainText $passW -Force)
Write-Host "Setting New Password - COMPLETED"

<#Write-Host "Removing manager..."
Get-ADUser -Identity $username -Properties * | Set-ADUser -Clear manager
Write-Host "Removing manager - COMPLETED"#>
Write-Host " "
Write-Host "Converting to Shared Mailbox on Hybrid..."
Set-RemoteMailbox $username@unitedroad.com -Type Shared
Write-Host "Converted to Shared Mailbox on Hybrid - COMPLETED"
Write-Host " "
Write-Host "Selecting Hide From Address Lists..."
Set-RemoteMailbox -Identity $username@unitedroad.com -HiddenFromAddressListsEnabled $true
Write-Host "Selecting Hide From Address Lists - COMPLETED"
Write-Host " "
Write-Host "Syncing to O365..."
Connect-ExchangeOnline
Set-Mailbox $username@unitedroad.com -Type Shared
Write-Host "Syncing to O365 - COMPLETED"
#To Clear the Calendar Events the User Organized/Host
Write-Host " "
Write-Host "Clearing CalendarEvents ...."
$Email = $username + '@unitedroad.com'
Remove-CalendarEvents -Identity $Email -CancelOrganizedMeetings -QueryWindowInDays 120
Write-Host "Clearing CalendarEvents for $Email - COMPLETED" -ForegroundColor Cyan


## Remove From all GroupMembership 
Write-Host " "
Write-Host "Removing Group Memberships..."
Get-ADUser -Identity $username -Properties MemberOf | ForEach-Object {$_.MemberOf | Remove-ADGroupMember -Members $_.DistinguishedName -Confirm:$false}
Write-Host "Removing Group Memberships - COMPLETED - Ignore Primary Group Error"

## Marking Account Disabled
Write-Host " "
Write-Host "Updating Description Field..."
Write-Host "Updating Description Field - COMPLETE"
$CurrentDesc = Get-ADUser -Identity $username -Properties * | select Description
$OldDesc = $CurrentDesc.Description
$UpdatedDesc = $FullDesc +" - "+ $OldDesc
Set-ADUser -Identity $username -Description $UpdatedDesc
Write-Host " "
Write-Host "Marking Account Disabled..."
Set-ADUser -Identity $username -Enabled $false
Write-Host "Marking Account Disabled - COMPLETE"

## Move User to Disabled OU
Write-Host " "
Write-Host "Moving account to Disabled Mailbox Sync OU..."
Get-ADUser $username | Move-ADobject -TargetPath 'OU=Disabled Mailbox Sync,OU=Disabled Objects,DC=urs,DC=local'
Write-Host "Moving account to Disabled Mailbox Sync OU - COMPLETE"
Write-Host " "

## Check $answer to see if the user would look to perform another action
Write-Output "Please take the proper screenshot or copy the entire process in TicketWork"
$answer = Read-Host -Prompt "Press 'y' for Yes or 'n' for No"
Write-Output ' '
while($answer -notmatch '[YyNn]'){
    Write-Output "Your selection is not valid, please choose from the valid options"
    $answer = Read-Host -Prompt "Press 'y' for Yes or 'n' for No"
}
## Do the needful
if($answer -match '[nN]'){
    $answer = 'n'
    break;
}