<# Second draft Script
Author Helen Najar #>

# Active Directory
Import-Module ActiveDirectory

# Arrays for the script
write-host " "
Write-Host "=============================================================="  -ForegroundColor Yellow
Write-Host " Welcome to the Creating New Users in Active Directory script "  -ForegroundColor Green 
Write-Host "=============================================================="  -ForegroundColor Yellow
write-host "                 Environment Script Launched                  "  -ForegroundColor Green 
Write-Host "=============================================================="  -ForegroundColor Yellow
write-host " "
Write-Host "Enter New Hire First Name" -ForegroundColor Magenta -NoNewline;
$firstname = Read-Host -prompt " "
## Verify no special characters have been entered, and the field isn't blank.
while ($firstname -match '[.$!~#%&*{}\\:<>?/|+"@_()]' -or $firstname.Length -eq '0' -or $firstname -eq ' ') {
    ## Retest condition
    Write-Host 'Invalid characters detected. Please Enter the FirstName of this user.'-ForegroundColor Red -NoNewline;
    $firstname = read-host -prompt ' '
    }
Write-Host "Enter New Hire Last Name" -ForegroundColor Magenta -NoNewline
$lastname = Read-Host -prompt " "
## Verify no special characters have been entered and the field isn't blank
while ($lastname -match '[.$!~#%&*{}\\:<>?/|+"@_()]' -or $lastname.Length -eq '0' -or $lastname -eq ' ' -or $lastname -match '[1234567890]') {
    ## Retest condition
    Write-Host 'Invalid characters detected. Please Enter the Last Name of this user'-ForegroundColor Red -NoNewline
    $lastname = read-host -prompt ' '
    }
write-host "Gathered New Hire Name" -ForegroundColor Cyan      
write-host "Gathering Job Title..." -ForegroundColor Green
Write-Host "Enter the user Job Title of the user" -ForegroundColor Magenta -NoNewline
$Description = Read-Host -prompt ' '
while ($Description -match '[$!~#%&*{}\\:<>?/|+"@_()]' -or $Description.Length -eq '0' -or $Description -eq ' ') {
    ## Retest condition
    write-host 'Invalid characters detected. Please Enter the Job Title of this user ' -ForegroundColor Red -NoNewline
    $Description = read-host -prompt ' '
    }
write-host "Gathered Jobe Title." -ForegroundColor Cyan
write-host "Generated Description" -ForegroundColor Cyan
write-host "Gathering Department info..." -ForegroundColor Green
write-host "Enter the Department" -ForegroundColor Magenta -NoNewline
$department = read-host -prompt " "
while ($department -match '[$!~#%&*{}\\:<>?/|+"@_()]' -or $department.Length -eq '0' -or $department -eq ' ') {
    ## Retest condition
    write-host 'Invalid characters detected. Please Enter the Department of this user.' -ForegroundColor Red -NoNewline
    $department = read-host -prompt ' '
    }

##Gather manager and generate
write-host "Gathered Department info" -ForegroundColor Cyan
write-host "Gathering Manager info..."  -ForegroundColor Green
write-host "Enter the Manager Firstname Lastname"  -ForegroundColor Magenta -NoNewline
$manager = read-host -prompt " "
while ($manager -match '[$!~#%&*{}\\:<>?/|+"@_()]' -or $manager.Length -eq '0' -or $manager -eq ' ') {
    ## Retest condition
    write-host "Invalid characters detected. Please enter the Manager's Firstname Lastname based on the form." -ForegroundColor Red -NoNewline
    $manager = read-host -prompt ' '
    }

#check to accept only the person name in AD.
$mgrexist = Get-Aduser -filter { Name -like $manager } -Properties * | Select-Object samaccountname
$mgrexist1 = $mgrexist.samaccountname

while (!$mgrexist1) {
    Write-Host "The manager account provided was not found. Please Enter the Full Name of a valid account to continue" -ForegroundColor Red -NoNewline
    $manager = read-host -prompt " "
    $mgrexist = Get-Aduser -filter { Name -like $manager } -Properties * | Select-Object samaccountname
    $mgrexist1 = $mgrexist.samaccountname
}

write-host "Gathered Manager info." -ForegroundColor Cyan
write-host "Generating Password..." -ForegroundColor Green

## Generate password and convert to secure string 
$pWord = $fInitial + $lInitial + '.password'
$securepWord = ConvertTo-SecureString $pWord -AsPlainText -Force
write-host "Generated Password of firstname Initial + Lastname Initial + .password. Eg: FL.password" -ForegroundColor Cyan
# Company selection generate
## Choose Company loop
Write-Host ' '
Write-Host "Gathering Company tab information..." -ForegroundColor Green
Write-Host ' '
Write-Host "Please Choose a company"  -ForegroundColor Magenta
Write-Host 'C. ' -ForegroundColor  Yellow -NoNewline; Write-host 'Contractors' -ForegroundColor Magenta
Write-Host 'S. '-ForegroundColor  Yellow -NoNewline; Write-host 'Stars' -ForegroundColor Magenta
write-host "Press " -ForegroundColor Magenta -NoNewline
Write-Host 'C ' -ForegroundColor  Yellow -NoNewline
Write-Host 'or ' -ForegroundColor Magenta -NoNewline
Write-Host 'S ' -ForegroundColor  Yellow -NoNewline
$company = Read-Host -Prompt " "
Write-Output ' '
while($company -notmatch '[SsCc]' -or $company.Length -ge '2' -or $company -match '[.$!~#%&*{}\\:<>?/|+"@_()]' -or $company.Length -eq '0' -or $company -eq ' ' -or $company -match '[1234567890]'){
    Write-Host "Your selection is not valid. Please choose from the valid options."  -ForegroundColor Red
    Write-Host "Press 'S' for Stars or 'C' for Contractor" -ForegroundColor Red -NoNewline
    $company = Read-Host -Prompt " "
}
write-host "Updating Company tab based on the selection." -ForegroundColor Green
#Fill out address for Star and company
If ($company -match '[Ss]'){
   $company = 'Stars'
}
elseif ($company -match '[Cc]'){
   $company = 'Contractor'
}
write-host "Updated Company tab information." -ForegroundColor Cyan
#Office section
Write-Host "Gathering Office tab information..." -ForegroundColor Green
Write-Host ' '
Write-Host "Please Choose an Office" -ForegroundColor Magenta
Write-Host 'O. ' -ForegroundColor  Yellow -NoNewline; Write-Host 'Office Location for Local based Users'  -ForegroundColor Magenta
Write-Host 'F. ' -ForegroundColor  Yellow -NoNewline; Write-Host 'Field for remote users' -ForegroundColor Magenta
Write-Host "Press " -ForegroundColor Magenta -NoNewline
Write-Host "O " -ForegroundColor Yellow -NoNewline
Write-Host "Or " -ForegroundColor Magenta -NoNewline
Write-Host "F " -ForegroundColor Yellow -NoNewline

$Office = Read-Host -Prompt " "
Write-Output ' '
while($Office -notmatch '[FfOo]' -or $Office.Length -ge '2' -or $Office -match '[.$!~#%&*{}\\:<>?/|+"@_()]' -or $Office.Length -eq '0' -or $Office -eq ' ' -or $Office -match '[1234567890]'){
    Write-Host "Your selection is not valid, please choose from the valid options." -ForegroundColor Red
    Write-Host "Press 'O' for Office Location or 'F' for Field" -ForegroundColor Red -NoNewline
    $office = Read-Host -Prompt " "
    ##add only one letter
}
Write-Host "Updating Office Tab information" -ForegroundColor Green

#Fill out address for Star and company
If ($office -match '[Oo]'){
    Write-Host "Updating office and address tab ..." -ForegroundColor Green
    $office = 'Office Location'
    $street = '8977 Richardson Street'
    $city = 'Lansdowne'
    $state = 'PA'
    $zipcode = '19050'
    $country = 'US'
    Write-Host "updated office tab and address tab completed." -ForegroundColor Cyan
}
elseif ($office -match '[Ff]'){
   Write-Host "Updating office tab ..." -ForegroundColor Green
   $office = 'Field'
   $street = $Null
   $city = $Null
   $state = $Null
   $zipcode = $Null
   $country = $Null
   Write-Host "update to office tab completed." -ForegroundColor Cyan
}

## Generate full name from user input and replace the first initials with the upper case in case they weren't entered initially as such
Write-Host "Generating Proper Firstname, Lastname, and Fullname..." -ForegroundColor Green
$fInitial = $firstname.Substring(0, 1).ToUpper()
$lInitial = $lastname.Substring(0, 1).ToUpper()
$pFirstName = $firstname.ToLower()
$propFirstName = $fInitial + $pFirstName.Remove(0, 1)
$pLastName = $lastname.ToLower()
$propLastName = $lInitial + $pLastName.Remove(0, 1)
$fullName = $propFirstName + ' ' + $propLastName
Write-Host "Generated Proper Firstname, Lastname, and Fullname" -ForegroundColor Cyan



#Generate proper email and UserPrincipalName[upn]
Write-Host "Generating email, and  UserPrincipalName..." -ForegroundColor Green
$email = $firstName.ToLower() + "." + $lastname.ToLower()
$fInitial = $firstName.Substring(0, 1).ToUpper()
$lInitial = $lastname.Substring(0, 1).ToUpper()
$upn = $email + '@skystar.com'
$Email = "$email@skystar.com"

Write-Host "Generated email, and  UserPrincipalName" -ForegroundColor Cyan

#Setting the Path for the OU.
Write-Host "creating based on the $OU..."  -ForegroundColor Green
$OU = "OU=Star,OU=Users,OU=Users_And_Groups,OU=Stars,DC=skystar,DC=com"
#Setting the variable for the domain.
$domain = $env:userdnsdomain

#Generate Job title, department, and company
Write-Host "Generating Proper Job Title, Description, Department..." -ForegroundColor Green
$titleInitial = $Description.Substring(0, 1).ToUpper()
$title = $titleInitial + $Description.Remove(0, 1)
$propdescription = $titleInitial + $Description.Remove(0, 1)
$dptInitial = $department.Substring(0, 1).ToUpper()
$dpt = $dptInitial + $department.Remove(0, 1)
Write-Host "Generated Proper Job Title, Description and Department." -ForegroundColor Cyan

##IF the lastname longer then 6 characters, username be made as such. Else create with the fulllastname+firstinitial
Write-Host "Generating Username..." -ForegroundColor Green
If ($lastname.length -ge 6){
    $lowerLastName = $lastname.substring(0,6)
    $Username = $lowerLastName.ToLower() + $fInitial.ToLower()
    }
else {
    $Username = $lastname.ToLower() + $fInitial.ToLower()
    }
Write-Host "Generated Username" -ForegroundColor Cyan
Write-Host "All information has been gathered and generated" -ForegroundColor Cyan
## Check for existing SamAccountName
Write-Host "Checking if the username '$username' already exists in AD..." -ForegroundColor Green
$doesExist = Get-ADUser -Filter { SamAccountName -eq $Username } -properties SamAccountName | Select-Object SamAccountName

# Creating Displayname, First name, surname, samaccountname, UPN, etc., and entering a password for the user.

if ($doesExist -eq $null) {
    Write-Host "Verified Username is not in AD." -ForegroundColor Cyan
    Write-Host "Creating User Account in AD..." -ForegroundColor Green
     New-ADUser `
    -Name $fullName `
    -GivenName $propFirstName `
    -Surname $propLastName `
    -SamAccountName $Username `
    -UserPrincipalName $upn `
    -Displayname $fullName `
    -Path $OU `
    -Description $propdescription `
    -Office $Office `
    -AccountPassword $securepWord -passThru
    # Set required details
    Set-ADUser $Username -Enabled $True
    Set-ADUser $Username -ChangePasswordAtLogon $False 
    Set-ADUser $Username -EmailAddress "$Email"

    # Set Organization Section
    Set-ADUser $Username -Department $dpt
    Set-ADUser $Username -Title $title
    Set-ADUser $Username -Company $company
    Set-ADUser $Username -Manager $mgrexist1

    #Set Address
    Set-ADUser $Username -StreetAddress $street
    Set-ADUser $Username -City $city
    Set-ADUser $Username -State $state
    Set-ADUser $Username -PostalCode $zipcode
    Set-ADUser $Username -Country $country
  }
elseif ($doesExist.SamAccountName){
    Write-Warning "Username $Username is already exists in AD!!"
    Write-Host "Altering account creation..." -ForegroundColor Green
	Write-Output ' '
	Write-Host 'The username ' -ForegroundColor Magenta -NoNewline; Write-host $Username -ForegroundColor DarkYellow -NoNewline; Write-host " already exists in the Directory, please enter a number 0-9 to add to this username" -ForegroundColor Magenta -NoNewline
    $digit = read-host -prompt ' '
    while($digit -notmatch '[123456789]' -or $digit.Length -eq '0' -or $digit -eq ' ' -or $digit.Length -ge '3' ){
       ## Retest condition
        write-host 'Invalid characters detected. Please enter a number 0-9 to add to this username' -ForegroundColor Red -NoNewline
        $digit = read-host -prompt ' '
        }
	## Retest while condition
    $doesExist = Get-ADUser -Filter { SamAccountName -eq $Username } -properties SamAccountName | Select-Object SamAccountName
    ## Retest while condition
	write-host ' '
    write-host 'We have located' $Username  'amount of users already exists' -ForegroundColor Green
    $username = $username + $digit
    write-host 'We have generated the following username' $username -ForegroundColor Green
    write-host 'Would you like us to proceed? If so, press Y for yes; if no, press n.' -ForegroundColor Magenta -NoNewline
    $answer = read-host -Prompt ' '
    write-host ' '
    while($answer -notmatch '[YyNn]' -or $answer.Length -ge '2' -or $answer -match '[.$!~#%&*{}\\:<>?/|+"@_()]' -or $answer.Length -eq '0' -or $answer -eq ' ' -or $answer -match '[1234567890]'){
        Write-host "Your selection is not valid. Please choose from the valid options." -ForegroundColor Red -NoNewline
        Write-host 'Would you like us to proceed? If so, press Y for yes; if no, press n.' -ForegroundColor Magenta -NoNewline
        $answer = Read-Host -Prompt ' '
    }
    write-host ' '
    $email = $firstName.ToLower() + "." + $lastname.ToLower() + $digit
    $upn = $email + '@skystar.com'
    $Email = "$email@skystar.com"
    $altfullname = $propFirstName + ' ' + $propLastName + $digit
    try {
        If ($answer -match '[yY]'){
            $answer = 'y'
            Write-Host "Creating User account in AD..." -ForegroundColor Green
            New-ADUser `
            -Name $altfullname `
            -GivenName $propFirstName `
            -Surname $propLastName `
            -SamAccountName $Username `
            -UserPrincipalName $upn `
            -Displayname $fullName `
            -Path $OU `
            -Description $propdescription `
            -Office $Office `
            -AccountPassword $securepWord -passThru
            # Set required details
            Set-ADUser $Username -Enabled $True
            Set-ADUser $Username -ChangePasswordAtLogon $False 
            Set-ADUser $Username -EmailAddress $Email

            # Set Organization Section
            Set-ADUser $Username -Department $dpt
            Set-ADUser $Username -Title $title
            Set-ADUser $Username -Company $company
            Set-ADUser $Username -Manager $mgrexist1

            #Set Address
            Set-ADUser $Username -StreetAddress $street
            Set-ADUser $Username -City $city
            Set-ADUser $Username -State $state
            Set-ADUser $Username -PostalCode $zipcode
            Set-ADUser $Username -Country $country
            Write-Host ' '
            Write-Host -BackgroundColor DarkGreen "Active Directory user account setup complete!" 
            Write-Host 'Press any key to Continue' -ForegroundColor DarkGreen -NoNewline
            $end = Read-Host -Prompt " "
            Write-Host ' '
        }
        elseif ($answer -match '[nN]'){
            $answer = 'n'
            Write-Host 'You have chosen not to proceed, please open the script again or reach out to the ABC analyst for assistance.' -ForegroundColor Red
            Write-Host "Press any Key to Exist" -ForegroundColor Red -NoNewline
            $end = Read-Host -Prompt " "
            break;
        }
    }
    Catch {
        Write-Host ' '
        Write-Host "This user was not created. Please make sure the generated username does not exist in the active directory and try again." -ForegroundColor Red
        Write-Host "Press any Key to Exist" -ForegroundColor Red -NoNewline
        $end = Read-Host -Prompt " "
        break
    }
}
Write-Host -BackgroundColor DarkGreen "Active Directory user account setup complete!" 
Write-Host "Take a screenshot of all that have been done. Press any key to Continue" -ForegroundColor DarkGreen -NoNewline
$end = Read-Host -Prompt " "

#sleep 2
Write-Host
 
$ADProperties = Get-ADUser $Username -Properties *
 
cls
Write-Host -BackgroundColor DarkGreen "Reminder Active Directory user account setup complete!" 
Write-Host " "
Write-Host "========================================================"
Write-Host '                   General Information'
Write-Host "========================================================"
Write-Host "Firstname:              $propFirstName"
Write-Host "Lastname:               $propLastName"
Write-Host "Display name:           $fullName"
Write-Host "Email Address:          $Email"
Write-Host "Description:            $propdescription"
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
Write-Host "Manager Name:           $Manager"
Write-Host "Manager Username:       $mgrexist1"
Write-Host ''
Write-Host "========================================================"
Write-Host '                   Address Information'
Write-Host "========================================================"
Write-Host "StreetAddress:          $street"
Write-Host "City:                   $city"
Write-Host "State:                  $state"
Write-Host "ZipCode:                $zipcode"
Write-Host "country:                $country"
Write-Host ''

Write-Host 'Take a screenshot of all that have been done. Press any key to Exit' -ForegroundColor DarkGreen -NoNewline
$end = Read-Host -Prompt " "
