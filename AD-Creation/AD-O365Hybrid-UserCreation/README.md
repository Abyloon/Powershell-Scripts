# AD-ExchangeHybrid-UserCreation.ps1

## Overview

`AD-ExchangeHybrid-UserCreation.ps1` is a PowerShell script designed for environments that integrate on-premises Active Directory (AD) with a hybrid Exchange/Office 365 setup. It allows administrators to create new AD user accounts (employees or contractors), enable their remote mailboxes in Office 365, and manage shared mailboxes and distribution groups.

**Note:** The domain and environment references (e.g., "skystar.com" and "STAR") are examples only and should be replaced or adjusted to fit your actual infrastructure and naming conventions.

## Key Features

- **AD User Creation**:  
  Create new Active Directory user accounts for full-time employees or contractors.
  
- **Hybrid Exchange Integration**:  
  Automatically enable remote mailboxes, integrating with Office 365.

- **Automated Group Membership**:  
  Copy group memberships from template accounts, ensuring correct permissions by default.

- **Shared Mailbox Creation**:  
  Easily create new shared mailboxes.

- **Distribution Group Management**:  
  Create and configure distribution groups, including adding members and setting ownership.

## Prerequisites

- **Environment**:  
  The script must be run from the **Exchange Management Shell** in your hybrid environment to ensure all required cmdlets and permissions are available.
  
- **PowerShell & Modules**:  
  Windows PowerShell 5.1 or later recommended.  
  Active Directory module and Exchange management tools must be available in the Exchange Management Shell.

- **Permissions**:  
  Appropriate administrative permissions in Active Directory and Exchange are required for user, mailbox, and group creation.

- **Domain Configuration**:  
  Update the script to reflect your actual domain, OU paths, and template accounts. The provided "STAR" and "skystar.com" domain values are placeholders.

## Usage

1. **Open the Exchange Management Shell as Administrator**:  
   Run the Exchange Management Shell with elevated privileges.

2. **Navigate to the Script Location**:  
   Use `cd` to navigate to the directory where you downloaded `AD-ExchangeHybrid-UserCreation.ps1`. For example:  
   ```powershell
   cd C:\Scripts\
   ```

3. **Set Execution Policy** (if not already):  
   ```powershell
   Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
   ```

4. **Run the Script**:  
   ```powershell
   .\AD-ExchangeHybrid-UserCreation.ps1
   ```

5. **Follow On-Screen Prompts**:  
   Choose the option you need (e.g., create a Star Employee, Contractor, Shared Mailbox, or Distribution Group) and provide the requested details (First Name, Last Name, Manager’s Username, Department, etc.).

6. **Confirmation and Screenshots**:  
   The script will display user and mailbox details at the end. Take any required screenshots before exiting.

## Example Workflows

- **Create a Star Employee**:  
  Select option `1` and enter the requested information. The script will create the AD user, assign group memberships, enable the remote mailbox, and place the user in the correct O365 group.

- **Create a Shared Mailbox**:  
  Select option `3` and enter the requested information, including a **REQ** ticket number (e.g., `REQ1234567`) for documentation. The script will create the shared mailbox and update AD attributes accordingly.

## Notes

- **Ticket Numbers**:  
  The script uses `REQ` followed by 7 digits (e.g., `REQ1234567`) to validate ticket numbers for certain tasks (like shared mailbox creation or distribution groups).

- **Username Conflicts**:  
  If the generated username already exists, you’ll be prompted to append a number (0-9) to create a unique username, and asked whether to proceed.

- **Template Accounts & Groups**:  
  The script references template accounts (like `!STAR_Employee`, `!STAR_Contractor`) and groups (like `O365 E3 Group`). Ensure these accounts and groups exist and match your organizational standards.

## Disclaimer

This script is provided as-is. Test it in a non-production environment first. Always ensure you have proper backups and understand the implications of creating users and mailboxes in your domain and Exchange organization.

## License
This project is licensed under the [MIT License](https://github.com/Abyloon/Powershell-Scripts/blob/main/LICENSE.md).
```