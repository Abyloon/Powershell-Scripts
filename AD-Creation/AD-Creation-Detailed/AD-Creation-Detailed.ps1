<# Author: Helen Najar
   Script: Create New Users in Active Directory
#>

# Import necessary Active Directory module
Import-Module ActiveDirectory

# Script header
Write-Host "`n==============================================================" -ForegroundColor Yellow
Write-Host " Welcome to the Creating New Users in Active Directory script " -ForegroundColor Green
Write-Host "==============================================================" -ForegroundColor Yellow
Write-Host "           SkyStar Environment Script Launched                " -ForegroundColor Green
Write-Host "==============================================================" -ForegroundColor Yellow
Write-Host "`n"

# Function to validate user input
Function ValidateInput($promptMessage, $validationPattern, $errorMessage) {
    do {
        Write-Host $promptMessage -ForegroundColor Magenta -NoNewline
        $uinput = Read-Host
        if ($uinput -match $validationPattern) {
            Write-Host $errorMessage -ForegroundColor Red
        }
    } while ($uinput -match $validationPattern -or $uinput.Length -eq 0)
    return $uinput
}

# Get user details
$firstname = ValidateInput "Enter New Hire First Name:" '[^a-zA-Z]' "Invalid characters detected. Please use only letters."
$lastname = ValidateInput "Enter New Hire Last Name:" '[^a-zA-Z]' "Invalid characters detected. Please use only letters."
$jobTitle = ValidateInput "Enter Job Title:" '[^a-zA-Z\s]' "Invalid characters detected. Please use only letters and spaces."
$department = ValidateInput "Enter Department:" '[^a-zA-Z\s]' "Invalid characters detected. Please use only letters and spaces."

# Get and validate manager
do {
    Write-Host "Enter Manager's Full Name:" -ForegroundColor Magenta -NoNewline
    $managerName = Read-Host
    $manager = Get-ADUser -Filter { Name -like $managerName } -Properties SamAccountName | Select-Object -ExpandProperty SamAccountName
    if (!$manager) {
        Write-Host "Manager not found in AD. Please try again." -ForegroundColor Red
    }
} while (!$manager)

# Choose company
do {
    Write-Host "Choose Company (C for Contractors, S for Stars):" -ForegroundColor Magenta -NoNewline
    $company = Read-Host
    if ($company -notmatch '^[SsCc]$') {
        Write-Host "Invalid choice. Enter 'C' or 'S'." -ForegroundColor Red
    }
} while ($company -notmatch '^[SsCc]$')
$company = if ($company -match '[Ss]') { 'Stars' } else { 'Contractors' }

# Choose office location
do {
    Write-Host "Choose Office Location (O for Office, F for Field):" -ForegroundColor Magenta -NoNewline
    $officeChoice = Read-Host
    if ($officeChoice -notmatch '^[OoFf]$') {
        Write-Host "Invalid choice. Enter 'O' or 'F'." -ForegroundColor Red
    }
} while ($officeChoice -notmatch '^[OoFf]$')

if ($officeChoice -match '[Oo]') {
    $office = 'Office Location'
    $address = @{
        Street  = '8977 Richardson Street'
        City    = 'Lansdowne'
        State   = 'PA'
        ZipCode = '19050'
        Country = 'US'
    }
} else {
    $office = 'Field'
    $address = @{ Street = $null; City = $null; State = $null; ZipCode = $null; Country = $null }
}

# Generate username and validate uniqueness
$fInitial = $firstname.Substring(0, 1).ToUpper()
$lInitial = $lastname.Substring(0, 1).ToUpper()
$usernameBase = if ($lastname.Length -ge 6) { $lastname.Substring(0, 6) } else { $lastname }
$username = "$($usernameBase.ToLower())$($fInitial.ToLower())"

do {
    $existingUser = Get-ADUser -Filter { SamAccountName -eq $username } -Properties SamAccountName
    if ($existingUser) {
        Write-Host "Username '$username' already exists. Appending a numeric suffix." -ForegroundColor Yellow
        $suffix = Read-Host "Enter a number to append to the username"
        $username = "$username$suffix"
    }
} while ($existingUser)

# Generate additional user attributes
$email = "$($firstname.ToLower()).$($lastname.ToLower())@skystar.com"
$upn = "$email"
$password = "$fInitial$lInitial.password" | ConvertTo-SecureString -AsPlainText -Force

# Create user in AD
Write-Host "Creating user in Active Directory..." -ForegroundColor Green
try {
    New-ADUser `
        -Name "$firstname $lastname" `
        -GivenName $firstname `
        -Surname $lastname `
        -SamAccountName $username `
        -UserPrincipalName $upn `
        -DisplayName "$firstname $lastname" `
        -EmailAddress $email `
        -Path "OU=Users,DC=skystar,DC=com" `
        -AccountPassword $password `
        -Office $office `
        -Title $jobTitle `
        -Department $department `
        -Company $company `
        -Manager $manager `
        -StreetAddress $address.Street `
        -City $address.City `
        -State $address.State `
        -PostalCode $address.ZipCode `
        -Country $address.Country `
        -Enabled $true `
        -PassThru | Set-ADUser -ChangePasswordAtLogon $true

    Write-Host "User '$firstname $lastname' created successfully!" -ForegroundColor Cyan
} catch {
    Write-Host "Failed to create user: $_" -ForegroundColor Red
}