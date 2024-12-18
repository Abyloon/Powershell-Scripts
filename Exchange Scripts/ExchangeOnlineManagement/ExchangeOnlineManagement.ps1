<#
Creation by Helen Najar
#>

# Import the Active Directory module
Import-Module ActiveDirectory

Write-Host " "
Write-Host "=============================================================="  -ForegroundColor Yellow
Write-Host "       Welcome to the Microsoft Exchange Online Script        "  -ForegroundColor Green
Write-Host "=============================================================="  -ForegroundColor Yellow
Write-Host "           Exchange Environment Script Launched               "  -ForegroundColor Green
Write-Host "=============================================================="  -ForegroundColor Yellow
Write-Host " "

Connect-ExchangeOnline

# Domain suffix
$domainSuffix = "@skystar.com"

# Function to validate a username (general user)
function ValidateUsername {
    param(
        [string]$Username
    )

    # Validate input characters
    while ($Username -match '[.$!~#%&*{}\\:<>?/|+"_()]' -or $Username.Length -eq 0 -or $Username -eq ' ' -or $Username -match '[0-9]') {
        Write-Host 'Invalid characters detected. Please enter a valid username:' -ForegroundColor Red -NoNewline
        $Username = Read-Host -Prompt ' '
    }

    # Check if user exists in AD
    $userExists = Get-ADUser -Filter { SamAccountName -eq $Username } -Properties SamAccountName | Select-Object SamAccountName
    $userExistsName = $userExists.SamAccountName

    while (-not $userExistsName) {
        Write-Host "The provided username was not found. Please enter a valid username:" -ForegroundColor Red -NoNewline
        $Username = Read-Host -Prompt " "
        $userExists = Get-ADUser -Filter { SamAccountName -eq $Username } -Properties SamAccountName | Select-Object SamAccountName
        $userExistsName = $userExists.SamAccountName
    }

    return $Username
}

# Function to validate a shared mailbox username
function ValidateSharedUsername {
    param(
        [string]$SharedUsername
    )

    while ($SharedUsername -match '[.$!~#%&*{}\\:<>?/|+"_()]' -or $SharedUsername.Length -eq 0 -or $SharedUsername -eq ' ' -or $SharedUsername -match '[0-9]') {
        Write-Host 'Invalid characters detected. Please enter a valid shared mailbox username:' -ForegroundColor Red -NoNewline
        $SharedUsername = Read-Host -Prompt ' '
    }

    $sharedExists = Get-ADUser -Filter { SamAccountName -eq $SharedUsername } -Properties SamAccountName | Select-Object SamAccountName
    $sharedExistsName = $sharedExists.SamAccountName

    while (-not $sharedExistsName) {
        Write-Host "The provided shared mailbox username was not found. Please enter a valid shared mailbox username:" -ForegroundColor Red -NoNewline
        $SharedUsername = Read-Host -Prompt " "
        $sharedExists = Get-ADUser -Filter { SamAccountName -eq $SharedUsername } -Properties SamAccountName | Select-Object SamAccountName
        $sharedExistsName = $sharedExists.SamAccountName
    }

    return $SharedUsername
}

do {
    Write-Host " "
    Write-Host "Please Choose from the Options below" -ForegroundColor Magenta
    Write-Host '1. ' -ForegroundColor Yellow -NoNewline; Write-Host 'Full Access Request' -ForegroundColor Magenta
    Write-Host '2. ' -ForegroundColor Yellow -NoNewline; Write-Host 'SendAs Requests' -ForegroundColor Magenta
    Write-Host '3. ' -ForegroundColor Yellow -NoNewline; Write-Host 'SendOnBehalf Requests' -ForegroundColor Magenta
    Write-Host '4. ' -ForegroundColor Yellow -NoNewline; Write-Host 'Configure Out of Office Requests' -ForegroundColor Magenta
    Write-Host '5. ' -ForegroundColor Yellow -NoNewline; Write-Host 'Forward Requests' -ForegroundColor Magenta
    Write-Host '6. ' -ForegroundColor Yellow -NoNewline; Write-Host 'Exit' -ForegroundColor Magenta
    Write-Host "Press an Option:" -ForegroundColor Magenta -NoNewline
    $Option = Read-Host -Prompt " "

    Write-Output ' '
    while ($Option -notmatch '^[1-6]$') {
        Write-Host "Your selection is not valid, please choose from 1-6." -ForegroundColor Red
        $Option = Read-Host -Prompt "Press a number (1-6): "
    }

    switch ($Option) {
        # Full Access
        '1' {
            Write-Host "Enter End-User Username" -ForegroundColor Magenta -NoNewline
            $Username = ValidateUsername (Read-Host -Prompt " ")
            Write-Host "Enter SharedMailbox Username" -ForegroundColor Magenta -NoNewline
            $Sharedusername = ValidateSharedUsername (Read-Host -Prompt " ")
            Write-Host "Granting Full Access..." -ForegroundColor Green
            $sharedmailbox = $Sharedusername + $domainSuffix
            $Email = $Username + $domainSuffix
            Add-MailboxPermission -Identity $sharedmailbox -User $Email -AccessRights FullAccess -InheritanceType All
            Write-Host "Full Access granted for $Email" -ForegroundColor Cyan
            Get-MailboxPermission -Identity $sharedmailbox
        }

        # SendAs
        '2' {
            Write-Host "Enter End-User Username" -ForegroundColor Magenta -NoNewline
            $Username = ValidateUsername (Read-Host -Prompt " ")
            Write-Host "Enter SharedMailbox Username" -ForegroundColor Magenta -NoNewline
            $Sharedusername = ValidateSharedUsername (Read-Host -Prompt " ")
            Write-Host "Granting SendAs Access..." -ForegroundColor Green
            $sharedmailbox = $Sharedusername + $domainSuffix
            $Email = $Username + $domainSuffix
            Add-RecipientPermission $sharedmailbox -AccessRights SendAs -Trustee $Email
            Write-Host "SendAs granted for $Email" -ForegroundColor Cyan
            Get-RecipientPermission $sharedmailbox | Select-Object Trustee, AccessControlType, AccessRights
        }

        # SendOnBehalf
        '3' {
            Write-Host "Enter End-User Username" -ForegroundColor Magenta -NoNewline
            $Username = ValidateUsername (Read-Host -Prompt " ")
            Write-Host "Enter SharedMailbox Username" -ForegroundColor Magenta -NoNewline
            $Sharedusername = ValidateSharedUsername (Read-Host -Prompt " ")
            Write-Host "Granting SendOnBehalf..." -ForegroundColor Green
            $sharedmailbox = $Sharedusername + $domainSuffix
            $Email = $Username + $domainSuffix
            Set-Mailbox $sharedmailbox -GrantSendOnBehalfTo @{Add="$Email"}
            Write-Host "SendOnBehalf granted for $Email" -ForegroundColor Cyan
            Get-Mailbox $sharedmailbox | Select-Object Name,Alias,UserPrincipalName,PrimarySmtpAddress,@{l='SendOnBehalfOf';e={$_.GrantSendOnBehalfTo -join ";"}}
        }

        # Configure Out of Office
        '4' {
            Write-Host "Enter End-User Username" -ForegroundColor Magenta -NoNewline
            $Username = ValidateUsername (Read-Host -Prompt " ")
            Write-Host "Configuring OutOfOffice..." -ForegroundColor Green
            Write-Host "Enter the Out of Office Message" -ForegroundColor Magenta -NoNewline
            $Message = Read-Host -Prompt " "
            while ($Message.Length -eq 0 -or $Message -eq ' ') {
                Write-Host 'Invalid input. Please enter the Out of Office Message:' -ForegroundColor Red -NoNewline
                $Message = Read-Host -Prompt " "
            }
            $Email = $Username + $domainSuffix
            Set-MailboxAutoReplyConfiguration -Identity $Email -AutoReplyState Enabled -InternalMessage $Message -ExternalMessage $Message
            Write-Host "Configured Out of Office for $Email" -ForegroundColor Cyan
        }

        # Forward Requests
        '5' {
            Write-Host "Enter End-User Username" -ForegroundColor Magenta -NoNewline
            $Username = ValidateUsername (Read-Host -Prompt " ")
            $Email = $Username + $domainSuffix

            Write-Host "Please Choose from the Options below" -ForegroundColor Magenta
            Write-Host '1. ' -ForegroundColor Yellow -NoNewline; Write-Host 'Forward Request Internal' -ForegroundColor Magenta
            Write-Host '2. ' -ForegroundColor Yellow -NoNewline; Write-Host 'Forward Request External' -ForegroundColor Magenta
            $Optionforward = Read-Host -Prompt "Press an Option (1 or 2): "

            while ($Optionforward -notmatch '^[12]$') {
                Write-Host "Invalid selection. Please choose 1 or 2." -ForegroundColor Red
                Write-Host '1. ' -ForegroundColor Yellow -NoNewline; Write-Host 'Forward Request Internal' -ForegroundColor Magenta
                Write-Host '2. ' -ForegroundColor Yellow -NoNewline; Write-Host 'Forward Request External' -ForegroundColor Magenta
                $Optionforward = Read-Host -Prompt " "
            }

            if ($Optionforward -eq '1') {
                Write-Host "Enter Forward To Username" -ForegroundColor Magenta -NoNewline
                $ForwardUser = ValidateUsername (Read-Host -Prompt " ")
                $forwardMailbox = $ForwardUser + $domainSuffix
                Set-Mailbox $Email -ForwardingAddress $forwardMailbox -DeliverToMailboxAndForward $true
                Write-Host "Forwarding set for $Email to $forwardMailbox" -ForegroundColor Cyan
            } elseif ($Optionforward -eq '2') {
                Write-Host "Enter Forward To External Email" -ForegroundColor Magenta -NoNewline
                $external = Read-Host -Prompt " "
                while ($external.Length -eq 0 -or $external -eq ' ' -or $external -notmatch '@') {
                    Write-Host 'Invalid input. Please enter a valid external email address:' -ForegroundColor Red -NoNewline
                    $external = Read-Host -Prompt " "
                }
                Set-Mailbox $Email -ForwardingSMTPAddress $external -DeliverToMailboxAndForward $True
                Write-Host "External forwarding set for $Email to $external" -ForegroundColor Cyan
            }
        }

        # Exit
        '6' {
            Write-Host "This is a reminder. Take all necessary screenshots before pressing Y to exit." -ForegroundColor Magenta -NoNewline
            $Question = Read-Host -Prompt " "
            While ($Question -notmatch '[Yy]') {
                Write-Host "Are you all set now? Press 'Y'"
                $Question = Read-Host -Prompt " "
            }
            Write-Host "Exiting Script..."; Start-Sleep 3; Clear-Host
        }
    }
} until ($Option -eq '6')