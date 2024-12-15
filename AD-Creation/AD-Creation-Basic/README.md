# Basic Active Directory User Creation Script

## Overview

This PowerShell script automates the creation of Active Directory (AD) user accounts. It prompts for necessary user information such as first name, last name, username, and password. Additionally, the script can copy group memberships from an existing user to the newly created account.

## Features

- **User Creation**: Creates a new AD user with specified first name, last name, and username.
- **Password Handling**: Allows for the input of a secure password.
- **Group Membership Copying**: Copies group memberships from an existing AD user to the newly created user (optional).
- **Email & UPN Setup**: Sets the email address and user principal name (UPN) to follow the standard format.

## Prerequisites

- PowerShell with the **Active Directory Module** installed.
- Administrative privileges in the AD environment.

## Usage

1. Open PowerShell as an administrator.
2. Run the script:
   ```powershell
   .\ad-creation-basic.ps1
   ```
3. Follow the prompts to enter the user's first name, last name, username, and password.
4. If desired, enter the username of an existing user from which to copy group memberships.

## Example Execution

```
Enter First Name: John
Enter Last Name: Doe
Enter Username (e.g., FirstinitialLastName): JDoe
Enter AD group to copy memberships from (leave blank if none): JaneDoe
Enter a Password: ********
```

### Notes

- **AD Groups**: If you wish to add the new user to any groups, enter the username of an existing user who is a member of those groups. The script will automatically add the new user to those groups.
- **Password Management**: The script creates the user account with the specified password and disables the "change password at next logon" setting.

## Disclaimer

- Ensure you have the necessary administrative permissions to create user accounts and assign group memberships in Active Directory.
- This script assumes you're working with a typical AD setup. Custom AD paths may need to be adjusted.

## License

This project is licensed under the [MIT License](https://github.com/Abyloon/Powershell-Scripts/blob/main/LICENSE.md)