# Active Directory Termination Script

## Overview

This PowerShell script is designed to streamline the termination process for user accounts in a hybrid Active Directory (AD) and Exchange Online environment. It performs several key tasks:

- Validates the existence of the user in AD.
- Resets the user’s password.
- Converts the mailbox to a shared mailbox and hides it from address lists.
- Clears calendar events organized by the user.
- Removes the user from all AD groups (except the primary group).
- Updates the user’s AD description field with termination details.
- Disables the user’s AD account.
- Moves the account to a designated “Disabled” Organizational Unit (OU).
- Prompts for and validates a ticket number (e.g., `REQ1234567`) to document the action.

**Note:** The domain and paths (like `skystar.com`, `Disabled Sync` OU) are placeholders and should be replaced with the correct values for your organization.

## Prerequisites

- **Active Directory Module:**  
  Ensure the Active Directory module is installed and imported:
  ```powershell
  Import-Module ActiveDirectory
  ```

- **Exchange Online Connectivity:**  
  You must have the Exchange Online PowerShell module installed and be connected:
  ```powershell
  Connect-ExchangeOnline
  ```

  Running this script in an Exchange-enabled PowerShell session ensures mailbox-related commands work properly.

- **Permissions:**  
  You will need appropriate administrative permissions in both AD and Exchange Online environments to modify user accounts, convert mailboxes, and remove group memberships.

## Usage

1. **Open a PowerShell Session:**  
   Ideally, use the Exchange Management Shell or a PowerShell session with the Exchange Online module loaded and connected.

2. **Navigate to the Script Location:**
   ```powershell
   cd C:\Path\To\Your\Script\
   ```

3. **Execution Policy (if needed):**
   ```powershell
   Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
   ```

4. **Run the Script:**
   ```powershell
   .\AD-O365Hybrid-Termination.ps1
   ```

5. **Follow the Prompts:**
   - Enter the username (LAN ID) of the user being terminated.
   - Enter a valid ticket number (e.g., `REQ1234567`).
   - The script will perform the termination actions and prompt you at the end to confirm if you have taken all necessary screenshots.

## Notes

- **Ticket Number Format:**
  The script requires a `REQ` prefix followed by 7 digits (total length = 10 characters). Example: `REQ1234567`.

- **Username Validation:**
  The script ensures the provided username exists in AD and does not contain invalid characters.

- **Hidden Shared Mailbox:**
  After termination, the user’s mailbox is converted to a shared mailbox and hidden from the address lists to prevent accidental use.

- **Removing Groups:**
  The script removes all group memberships (except the primary group), ensuring the terminated user no longer has access to resources.

- **Error Handling:**
  If invalid input is provided (e.g., username not found, incorrect ticket format), the script will prompt you to re-enter until valid input is provided.

## Disclaimer

This script is provided as-is. Test it thoroughly in a non-production environment before using it in production. Always ensure you have the necessary backups and understand the implications of modifying user accounts and mailboxes in your domain and Exchange Online environment.

## License
This project is licensed under the [MIT License](https://github.com/Abyloon/Powershell-Scripts/blob/main/LICENSE.md).