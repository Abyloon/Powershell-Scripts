# Microsoft Exchange Online PowerShell Script

## Overview

This PowerShell script streamlines common Exchange Online mailbox management tasks in a hybrid environment. It allows you to:

- Grant Full Access, SendAs, and SendOnBehalf permissions.
- Configure Out of Office (automatic replies) for users.
- Set up email forwarding rules (both internal and external).

**Note:** The domain and environment references (e.g., `@skystar.com` and any mention of "STAR") are examples only and should be replaced with your actual organizational domain and environment details.

## Prerequisites

- **Exchange Management Shell**:  
  You must run this script from the **Exchange Management Shell** or a PowerShell session with the Exchange Online PowerShell module installed and connected to Exchange Online.  
  - For example, use `Connect-ExchangeOnline` before running this script.
  
- **Active Directory Module**:  
  The Active Directory module should be installed and available. Typically:
  ```powershell
  Import-Module ActiveDirectory
  ```
  
- **Administrative Permissions**:  
  Ensure that you have the necessary permissions to modify mailbox settings, grant permissions, and manage forwarding rules in both Active Directory and Exchange Online.

## Running the Script

1. **Open the Exchange Management Shell** (or a PowerShell session with the Exchange Online module connected).
   
2. **Navigate to the Script Location**:
   ```powershell
   cd C:\Path\To\Script\
   ```

3. **Set Execution Policy** (if needed):
   ```powershell
   Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
   ```

4. **Run the Script**:
   ```powershell
   .\Exchange-Script.ps1
   ```

5. **Follow the On-Screen Prompts**:
   - Choose an action from the menu (1-6).
   - Provide the requested usernames and information as prompted.

## Common Tasks

- **Grant Full Access**: Enter a user and a shared mailbox username to grant the user Full Access to the mailbox.
- **SendAs Permissions**: Assign SendAs rights to allow a user to send emails as another mailbox.
- **SendOnBehalf Permissions**: Give a user the ability to send on behalf of another mailbox.
- **Configure Out of Office**: Easily set up auto-reply messages for a user’s mailbox.
- **Forwarding**: Set mail forwarding to another internal user or an external email address.

## Notes

- **Username Validation**:  
  The script checks the validity of usernames and verifies that they exist in Active Directory before proceeding.

- **Tenant and Domain Configuration**:  
  Update the script with your actual domain and tenant information. The placeholders used in the code are for demonstration only.

- **Confirmation and Screenshots**:  
  After completing tasks, the script may prompt you to review or take screenshots before exiting.

## Disclaimer

This script is provided as-is. Test it in a non-production environment before using it in production. Always ensure you have proper backups and understand the implications of modifying user mailboxes and permissions in your Exchange Online and Active Directory environment.

## License
This project is licensed under the [MIT License](https://github.com/Abyloon/Powershell-Scripts/blob/main/LICENSE.md).
```