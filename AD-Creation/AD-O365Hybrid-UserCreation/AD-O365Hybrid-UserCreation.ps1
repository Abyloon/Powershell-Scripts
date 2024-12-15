<#
Creation by Helen Najar
#>

# Active Directory
Import-Module ActiveDirectory

Write-Host " "
Write-Host "========================================================"  -ForegroundColor Yellow
Write-Host "    Welcome to AD & Exchange OnPrem Account Creation    "  -ForegroundColor Green 
Write-Host "========================================================"  -ForegroundColor Yellow
Write-Host "            SkyStar Environment Script Launched         "  -ForegroundColor Green 
Write-Host "========================================================"  -ForegroundColor Yellow
Write-Host " "

# Functions

function ValidateInput {
    param (
        [string]$prompt
    )
    Write-Host $prompt -ForegroundColor Magenta -NoNewline
    $inputValue = Read-Host -Prompt " "
    $inputValue = $inputValue.Trim()
    while ($inputValue -match '[.$!~#%&*{}\\:<>?/|+"@_()0-9]' -or $inputValue -eq '' -or $inputValue.Length -eq 0) {
        Write-Host 'Invalid characters detected or empty input. Please enter a valid value:' -ForegroundColor Red -NoNewline
        $inputValue = Read-Host -Prompt " "
        $inputValue = $inputValue.Trim()
    }
    return $inputValue
}

function ValidateAllowNumberInput {
    param (
        [string]$prompt
    )
    Write-Host $prompt -ForegroundColor Magenta -NoNewline
    $inputValue = Read-Host -Prompt " "
    $inputValue = $inputValue.Trim()
    while ($inputValue -match '[.$!~#%&*{}\\:<>?/|+"@_()]' -or $inputValue -eq '' -or $inputValue.Length -eq 0) {
        Write-Host 'Invalid characters detected or empty input. Please enter a valid number:' -ForegroundColor Red -NoNewline
        $inputValue = Read-Host -Prompt " "
        $inputValue = $inputValue.Trim()
    }
    return $inputValue
}

function ValidateUserExistence {
    param (
        [string]$username
    )
    $userExists = Get-ADUser -Filter { SamAccountName -eq $username } -Properties SamAccountName | Select-Object SamAccountName
    return $userExists.SamAccountName -ne $null
}

function CopySTAREMMemberOf {
    $mirror = "!STAR_Employee"
    $mirrorSAN = Get-ADUser -Filter { SamAccountName -eq $mirror } -Properties * | Select-Object SamAccountName
    $mirrorSAN1 = $mirrorSAN.samaccountname
    $newUserDN = Get-ADUser -Identity $Username -Properties DistinguishedName | Select-Object DistinguishedName
    Get-ADUser -Identity $mirrorSAN1 -Properties memberof | ForEach-Object { $_.MemberOf | Add-ADGroupMember -Members $newUserDN -Confirm:$false }
}

function CopyContractorMemberOf {
    $mirror = "!STAR_Contractor"
    $mirrorSAN = Get-ADUser -Filter { SamAccountName -eq $mirror } -Properties * | Select-Object SamAccountName
    $mirrorSAN1 = $mirrorSAN.samaccountname
    $newUserDN = Get-ADUser -Identity $Username -Properties DistinguishedName | Select-Object DistinguishedName
    Get-ADUser -Identity $mirrorSAN1 -Properties memberof | ForEach-Object { $_.MemberOf | Add-ADGroupMember -Members $newUserDN -Confirm:$false }
}

function EnableMailboxToO365 {
    $onmmicrosftdomain = "star365.mail.onmicrosoft.com"
    Enable-RemoteMailbox -Identity $Username -RemoteRoutingAddress $Username@$onmmicrosftdomain
    Write-Host "Existing user remote mailbox enabled" -ForegroundColor Green
}

function Display {
    Clear-Host
    Write-Host -BackgroundColor DarkGreen "Reminder: Active Directory user account setup complete!"
    Write-Host -BackgroundColor DarkGreen "Provide the default password listed to the user's Manager."
    Write-Host " "
    Write-Host "========================================================"
    Write-Host '                   General Information'
    Write-Host "========================================================"
    Write-Host "Firstname:              $propFirstName"
    Write-Host "Lastname:               $propLastName"
    Write-Host "Display name:           $fullName"
    Write-Host "Email Address:          $Email"
    Write-Host ''
    Write-Host "========================================================"
    Write-Host '                   Account Information'
    Write-Host "========================================================"
    Write-Host "LAN ID:                 $Username"
    Write-Host "UserPrincipalName:      $upn "
    Write-Host "OU:                     $OU"
    Write-Host "Domain:                 $domain"
    Write-Host ''
    Write-Host "========================================================"
    Write-Host '                   Organization Information'
    Write-Host "========================================================"
    Write-Host "Department:             $dpt"
    Write-Host "Job Title:              $title"
    Write-Host "Company:                $company"
    Write-Host "Manager (Input):        $Manager"
    Write-Host "Manager Username:       $mgrexist1"
    Write-Host ''
    Write-Host "========================================================"
    Write-Host '                Active Directory Group Membership'
    Write-Host "========================================================"
    $ADGroupMembership = Get-ADUser $Username | Get-ADPrincipalGroupMembership
    $ADGroupMembership | ForEach-Object {
        Write-Host "Group:                  $_.Name"
    }
    Write-Host ''
    Write-Host 'Please take a screenshot of any changes made and attach them to the ticket. Press X to Exit' -ForegroundColor DarkGreen -NoNewline
    $exitKey = Read-Host " "
    while ($exitKey -ne 'x') {
        Write-Host 'Press X to Exit' -ForegroundColor DarkGreen -NoNewline
        $exitKey = Read-Host " "
    }
}

function CreateSharedMailbox {
    $sname = ValidateInput "Enter the username of the Shared Mailbox"
    Write-Host "Gathering Ticket Number" -ForegroundColor Green
    do {
        Write-Host "Enter the Ticket Number" -ForegroundColor Magenta -NoNewline
        $ticketnumber = Read-Host -prompt ' '
        $ticketnumber = $ticketnumber.ToUpper()
        $isValid = $ticketnumber -match "^(REQ)[0-9]{7}$"
        if (-not $isValid) {
            Write-Host "Invalid input. The input must start with 'REQ' followed by 7 digits." -ForegroundColor Red
        }
    } while (-not $isValid)

    $Description = "RESOURCE MAILBOX per $ticketnumber"
    $Email = "$sname@skystar.com"
    $OU = "OU=Users,DC=skystar,DC=com"

    New-RemoteMailbox -UserPrincipalName $Email -Alias $sname -Name $sname -OnPremisesOrganizationalUnit $OU -Shared -ResetPasswordOnNextLogon $true
    Set-ADUser $sname -Description $Description
    Write-Host "Shared Mailbox created successfully: $sname" -ForegroundColor Green
}

function CreateDistributionGroup {
    $groupName = ValidateInput "Enter the name of the Distribution Group"
    $managedBy = ValidateInput "Enter the username of the group manager"
    $member = ValidateInput "Enter the username of an end user (to be added as a member)"

    # Validate member existence
    while (!(ValidateUserExistence $member)) {
        Write-Host "The provided username '$member' was not found. Please enter a valid username." -ForegroundColor Red -NoNewline
        $member = ValidateInput "Enter the username of an end user (to be added as a member)"
    }

    Write-Host "Gathering Ticket Number" -ForegroundColor Green
    do {
        Write-Host "Enter the Ticket Number" -ForegroundColor Magenta -NoNewline
        $ticketnumber = Read-Host -prompt ' '
        $ticketnumber = $ticketnumber.ToUpper()
        $isValid = $ticketnumber -match "^(REQ)[0-9]{7}$"
        if (-not $isValid) {
            Write-Host "Invalid input. The input must start with 'REQ' followed by 7 digits." -ForegroundColor Red
        }
    } while (-not $isValid)

    $newNote = "Created per $ticketnumber"
    $groupName = "$groupName@skystar.com"
    $alias = $groupName
    $organizationalUnit = "OU=Users,DC=skystar,DC=com"
    New-DistributionGroup -Name $groupName -Alias $alias -Type "Distribution" -OrganizationalUnit $organizationalUnit -ManagedBy "$managedBy@skystar.com" -Members $member -MemberDepartRestriction Closed -MemberJoinRestriction Closed
    Set-DistributionGroup -Identity $groupName -Notes $newNote
    Write-Host "Distribution Group created successfully: $groupName" -ForegroundColor Green
}

function CreateSTAREmp {
    $firstname = ValidateInput "Enter New Hire First Name"
    $lastname = ValidateInput "Enter New Hire Last Name"
    Write-Host "Gathered New Hire Name" -ForegroundColor Cyan

    Write-Host "Gathering Office tab information..." -ForegroundColor Green
    $Office = ValidateInput "Enter Office Location"
    write-host "Gathering Job Title..." -ForegroundColor Green
    $jtitle = ValidateInput "Enter the user Job Title of the user"
    write-host "Gathered Job Title." -ForegroundColor Cyan
    write-host "Gathering Department info..." -ForegroundColor Green
    $department = ValidateInput "Enter the Department"
    write-host "Gathered Department info" -ForegroundColor Cyan
    write-host "Gathering Manager info..."  -ForegroundColor Green
    Write-Host "Enter the Manager's Username" -ForegroundColor Magenta -NoNewline
    $manager = ValidateInput " "
    while (!(ValidateUserExistence $manager)) {
        Write-Host "The manager account provided was not found. Please enter a valid username." -ForegroundColor Red -NoNewline
        $manager = ValidateInput "Enter the Manager's Username"
    }

    $mgrexist = Get-ADUser -Filter { SamAccountName -eq $manager } -Properties SamAccountName | Select-Object SamAccountName
    $mgrexist1 = $mgrexist.SamAccountName
    write-host "Gathered Manager info." -ForegroundColor Cyan

    $company = "SkyStar"
    $fInitial = $firstname.Substring(0, 1).ToUpper()
    $lInitial = $lastname.Substring(0, 1).ToUpper()
    $init = $fInitial + $lInitial
    $pWord = $init + ".password"
    $securepWord = ConvertTo-SecureString $pWord -AsPlainText -Force
    $propFirstName = $fInitial + $firstname.Remove(0, 1)
    $propLastName = $lInitial + $lastname.Remove(0, 1)
    $fullName = $propFirstName + ' ' + $propLastName
    Write-Host "Generating Username" -ForegroundColor Cyan
    $Username = ($fInitial.ToLower() + $lastname.ToLower())
    Write-Host "Generated Username" -ForegroundColor Cyan
    Write-Host "Generating email and UserPrincipalName..." -ForegroundColor Green
    $upn = $Username + '@skystar.com'
    $Email = $Username + '@skystar.com'
    $OU = "OU=Users,DC=skystar,DC=com"
    $domain = $env:userdnsdomain
    $titleInitial = $jtitle.Substring(0, 1).ToUpper()
    $title = $titleInitial + $jtitle.Remove(0, 1)
    $dptInitial = $department.Substring(0, 1).ToUpper()
    $dpt = $dptInitial + $department.Remove(0, 1)
    Write-Host "All information has been gathered and generated" -ForegroundColor Cyan

    Write-Host "Checking if the username '$Username' already exists in AD..." -ForegroundColor Green
    $doesExist = Get-ADUser -Filter { SamAccountName -eq $Username } -Properties SamAccountName | Select-Object SamAccountName

    if ($doesExist -eq $null) {
        Write-Host "Verified Username is not in AD." -ForegroundColor Cyan
        Write-Host "Creating User Account in AD..." -ForegroundColor Green
        New-ADUser `
        -Name $fullName `
        -GivenName $propFirstName `
        -Surname $propLastName `
        -SamAccountName $Username `
        -UserPrincipalName $upn `
        -DisplayName $fullName `
        -Path $OU `
        -Description $NULL `
        -Office $Office `
        -AccountPassword $securepWord -PassThru

        Set-ADUser $Username -Enabled $True
        Set-ADUser $Username -ChangePasswordAtLogon $True 
        Set-ADUser $Username -EmailAddress $Email
        Set-ADUser $Username -Department $dpt
        Set-ADUser $Username -Title $title
        Set-ADUser $Username -Company $company
        Set-ADUser $Username -Manager $mgrexist1
        Set-ADUser $Username -City $Office

        CopySTAREMMemberOf
        EnableMailboxToO365
        Add-ADGroupMember –Identity "O365 E3 Group" –Members $Username
    } else {
        Write-Warning "Username $Username already exists in AD!"
        Write-Host "The username '$Username' already exists. Please enter a number (0-9) to append:" -ForegroundColor Magenta
        $digit = ValidateAllowNumberInput "Enter a number (0-9): "
        $Username = $Username + $digit
        Write-Host "We have generated the following username: $Username" -ForegroundColor Green
        Write-Host "Would you like us to proceed? (Y/N)" -ForegroundColor Magenta -NoNewline
        $answer = Read-Host -Prompt ' '
        while($answer -notmatch '^[YyNn]$') {
            Write-host "Your selection is not valid. Press Y for yes; N for no:" -ForegroundColor Red -NoNewline
            $answer = Read-Host -Prompt ' '
        }
        $upn = $Username + '@skystar.com'
        $Email = $Username + '@skystar.com'
        $altfullname = $propFirstName + ' ' + $propLastName
        try {
            If ($answer -match '[yY]') {
                Write-Host "Creating User account in AD..." -ForegroundColor Green
                New-ADUser `
                -Name $altfullname `
                -GivenName $propFirstName `
                -Surname $propLastName `
                -SamAccountName $Username `
                -UserPrincipalName $upn `
                -DisplayName $fullName `
                -Path $OU `
                -Description $NULL `
                -Office $Office `
                -AccountPassword $securepWord -PassThru

                Set-ADUser $Username -Enabled $True
                Set-ADUser $Username -ChangePasswordAtLogon $True
                Set-ADUser $Username -EmailAddress $Email
                Set-ADUser $Username -Department $dpt
                Set-ADUser $Username -Title $title
                Set-ADUser $Username -Company $company
                Set-ADUser $Username -Manager $mgrexist1
                Set-ADUser $Username -City $Office

                CopySTAREMMemberOf
                EnableMailboxToO365
                Add-ADGroupMember –Identity "O365 E3 Group" –Members $Username

                Write-Host -BackgroundColor DarkGreen "Active Directory user account setup complete!"
                Write-Host 'Press any key to continue' -ForegroundColor DarkGreen -NoNewline
                $end = Read-Host -Prompt " "
            } else {
                Write-Host 'You have chosen not to proceed. Please reopen the script or consult an ABC analyst.' -ForegroundColor Red
                Write-Host "Press any Key to Exit" -ForegroundColor Red -NoNewline
                $end = Read-Host -Prompt " "
                return
            }
        }
        catch {
            Write-Host "User not created. Verify username uniqueness and try again." -ForegroundColor Red
            Write-Host "Press any Key to Exit" -ForegroundColor Red -NoNewline
            $end = Read-Host -Prompt " "
            return
        }
    }
    Display
}

function CreateSTARCont {
    $firstname = ValidateInput "Enter New Hire First Name"
    $lastname = ValidateInput "Enter New Hire Last Name"
    Write-Host "Gathered New Hire Name" -ForegroundColor Cyan

    Write-Host "Gathering Office tab information..." -ForegroundColor Green
    $Office = ValidateInput "Enter Office Location"
    write-host "Gathering Job Title..." -ForegroundColor Green
    $jtitle = ValidateInput "Enter the user Job Title of the user"
    write-host "Gathered Job Title." -ForegroundColor Cyan
    write-host "Gathering Department info..." -ForegroundColor Green
    $department = ValidateInput "Enter the Department"
    write-host "Gathered Department info" -ForegroundColor Cyan
    write-host "Gathering Manager info..."  -ForegroundColor Green
    Write-Host "Enter the Manager's Username"  -ForegroundColor Magenta -NoNewline
    $manager = ValidateInput " "
    while (!(ValidateUserExistence $manager)) {
        Write-Host "The manager account provided was not found. Please enter a valid username." -ForegroundColor Red -NoNewline
        $manager = ValidateInput "Enter the Manager's Username"
    }
    $mgrexist = Get-ADUser -Filter { SamAccountName -eq $manager } -Properties SamAccountName | Select-Object SamAccountName
    $mgrexist1 = $mgrexist.SamAccountName
    write-host "Gathered Manager info." -ForegroundColor Cyan

    $company = "SkyStar"
    $fInitial = $firstname.Substring(0, 1).ToUpper()
    $lInitial = $lastname.Substring(0, 1).ToUpper()
    $init = $fInitial + $lInitial
    $pWord =  $init + ".password"
    $securepWord = ConvertTo-SecureString $pWord -AsPlainText -Force
    $propFirstName = $fInitial + $firstname.Remove(0, 1)
    $propLastName = $lInitial + $lastname.Remove(0, 1)
    $fullName = $propFirstName + ' ' + $propLastName
    Write-Host "Generating Username" -ForegroundColor Cyan
    $Username = $fInitial.ToLower() + $lastname.ToLower()
    Write-Host "Generated Username" -ForegroundColor Cyan
    Write-Host "Generating email and UserPrincipalName..." -ForegroundColor Green
    $upn = $Username + '@skystar.com'
    $Email = $Username + '@skystar.com'
    $OU = "OU=Users,DC=skystar,DC=com"
    $domain = $env:userdnsdomain
    $titleInitial = $jtitle.Substring(0, 1).ToUpper()
    $title = $titleInitial + $jtitle.Remove(0, 1)
    $dptInitial = $department.Substring(0, 1).ToUpper()
    $dpt = $dptInitial + $department.Remove(0, 1)

    Write-Host "All information has been gathered and generated" -ForegroundColor Cyan
    Write-Host "Checking if the username '$Username' already exists in AD..." -ForegroundColor Green
    $doesExist = Get-ADUser -Filter { SamAccountName -eq $Username } -Properties SamAccountName | Select-Object SamAccountName

    if ($doesExist -eq $null) {
        Write-Host "Verified Username is not in AD." -ForegroundColor Cyan
        Write-Host "Creating User Account in AD..." -ForegroundColor Green
        New-ADUser `
        -Name $fullName `
        -GivenName $propFirstName `
        -Surname $propLastName `
        -SamAccountName $Username `
        -UserPrincipalName $upn `
        -DisplayName $fullName `
        -Path $OU `
        -Description $NULL `
        -Office $Office `
        -AccountPassword $securepWord -PassThru

        Set-ADUser $Username -Enabled $True
        Set-ADUser $Username -ChangePasswordAtLogon $True 
        Set-ADUser $Username -EmailAddress $Email
        Set-ADUser $Username -Department $dpt
        Set-ADUser $Username -Title $title
        Set-ADUser $Username -Company $company
        Set-ADUser $Username -Manager $mgrexist1
        Set-ADUser $Username -City $Office

        CopyContractorMemberOf
        EnableMailboxToO365
        Add-ADGroupMember –Identity "O365 E3 Group" –Members $Username
    } else {
        Write-Warning "Username $Username already exists in AD!"
        Write-Host "The username '$Username' already exists, please enter a number (0-9) to add:" -ForegroundColor Magenta
        $digit = ValidateAllowNumberInput "Enter a number (0-9): "
        $Username = $Username + $digit
        Write-Host "We have generated the following username: $Username" -ForegroundColor Green
        Write-Host "Would you like us to proceed? (Y/N)" -ForegroundColor Magenta -NoNewline
        $answer = Read-Host -Prompt ' '
        while($answer -notmatch '^[YyNn]$') {
            Write-host "Your selection is not valid. Press Y for yes; N for no:" -ForegroundColor Red -NoNewline
            $answer = Read-Host -Prompt ' '
        }
        $upn = $Username + '@skystar.com'
        $Email = $Username + '@skystar.com'
        $altfullname = $propFirstName + ' ' + $propLastName
        try {
            If ($answer -match '[yY]'){
                Write-Host "Creating User account in AD..." -ForegroundColor Green
                New-ADUser `
                -Name $altfullname `
                -GivenName $propFirstName `
                -Surname $propLastName `
                -SamAccountName $Username `
                -UserPrincipalName $upn `
                -DisplayName $fullName `
                -Path $OU `
                -Description $NULL `
                -Office $Office `
                -AccountPassword $securepWord -PassThru

                Set-ADUser $Username -Enabled $True
                Set-ADUser $Username -ChangePasswordAtLogon $True
                Set-ADUser $Username -EmailAddress $Email
                Set-ADUser $Username -Department $dpt
                Set-ADUser $Username -Title $title
                Set-ADUser $Username -Company $company
                Set-ADUser $Username -Manager $mgrexist1
                Set-ADUser $Username -City $Office

                CopyContractorMemberOf
                EnableMailboxToO365
                Add-ADGroupMember –Identity "O365 E3 Group" –Members $Username

                Write-Host -BackgroundColor DarkGreen "Active Directory user account setup complete!"
                Write-Host 'Press any key to continue' -ForegroundColor DarkGreen -NoNewline
                $end = Read-Host -Prompt " "
            } else {
                Write-Host 'You have chosen not to proceed. Please reopen the script or consult an ABC analyst.' -ForegroundColor Red
                Write-Host "Press any Key to Exit" -ForegroundColor Red -NoNewline
                $end = Read-Host -Prompt " "
                return
            }
        }
        catch {
            Write-Host "User not created. Verify username uniqueness and try again." -ForegroundColor Red
            Write-Host "Press any Key to Exit" -ForegroundColor Red -NoNewline
            $end = Read-Host -Prompt " "
            return
        }
    }
    Display
}

do {
    Write-Host "Please Choose from the Options below" -ForegroundColor Magenta
    Write-Host '1. ' -ForegroundColor Yellow -NoNewline; Write-Host 'Star Employee'  -ForegroundColor Magenta
    Write-Host '2. ' -ForegroundColor Yellow -NoNewline; Write-Host 'Star Contractor' -ForegroundColor Magenta
    Write-Host '3. ' -ForegroundColor Yellow -NoNewline; Write-Host 'New Shared Mailbox' -ForegroundColor Magenta
    Write-Host '4. ' -ForegroundColor Yellow -NoNewline; Write-Host 'Create Distribution Group' -ForegroundColor Magenta		
    Write-Host '5. ' -ForegroundColor Yellow -NoNewline; Write-Host 'Exit' -ForegroundColor Magenta
    Write-Host "Press an Option:" -ForegroundColor Magenta -NoNewline
    $Option = Read-Host -Prompt " "

    Write-Output ' '
    while($Option -notmatch '[1-5]') {
        Write-Host "Invalid selection. Please choose 1-5." -ForegroundColor Red
        $Option = Read-Host -Prompt "Press a number (1-5): "
    }

    switch ($Option) {
        '1' {
            CreateSTAREmp
        }
        '2' {
            CreateSTARCont
        }
        '3' {
            CreateSharedMailbox
        }
        '4' {
            CreateDistributionGroup
        }
        '5' {
            Write-Host "Make sure you've taken all screenshots. Press Y to exit." -ForegroundColor Magenta -NoNewline
            $Question = Read-Host -prompt " "
            While ($Question -notmatch '[Yy]') {
                Write-Host "Are you ready now? Press 'Y'"
                $Question = Read-Host -prompt " "
            }
            Write-Host "Exiting Script..."; Start-Sleep 3; Clear-Host
        }
    }
} until ($Option -eq '5')