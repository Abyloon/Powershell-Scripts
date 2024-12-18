# AD-Creation
## Overview

The **AD-Creation** folder contains a collection of PowerShell scripts designed to streamline the process of creating and configuring Active Directory (AD) user accounts. These scripts cater to a variety of scenarios, from simple account setups to more complex hybrid configurations integrating with Office 365.

## Contents

### 1. `AD-Creation-Basic/`
This folder contains a **basic AD user creation script** that focuses on core functionality:

- **Key Features:**
  - Prompts for first and last name, username, and password.
  - Creates a user account in AD.
  - Optionally copies group memberships from a specified template user.
  
- **Ideal For:**  
  Administrators who need a quick and straightforward way to create standard AD user accounts with minimal complexity.

### 2. `AD-Creation-Detailed/`
This folder includes a **detailed AD user creation script** that provides more customization and automation:

- **Key Features:**
  - More extensive attribute configuration (department, job title, company, etc.).
  - Enhanced validation and error handling.
  - Automated group memberships, email setup, and possibly additional attributes depending on your environment’s needs.
  
- **Ideal For:**  
  Environments where new accounts require more detailed attributes and standardized group memberships, making onboarding more efficient and consistent.

### 3. `AD-O365Hybrid-UserCreation`
This folder contains a **hybrid-focused AD user creation script** that integrates with Office 365 (Exchange Online):

- **Key Features:**
  - Creates the user in AD and prepares them for Office 365 (hybrid) environments.
  - Enables or configures remote mailboxes for Exchange Online.
  - Sets attributes required for a smooth hybrid experience, such as ensuring users appear in the global address list and properly syncing to Office 365.
  
- **Ideal For:**  
  Organizations using a hybrid AD/Exchange Online environment, ensuring that new accounts are cloud-ready and properly configured from the start.

## Prerequisites

- **Active Directory Module:**  
  Each script typically requires the Active Directory PowerShell module:
  ```powershell
  Import-Module ActiveDirectory
  ```

- **Permissions:**  
  Ensure you have the necessary administrative privileges in AD (and Exchange Online if using the hybrid script) to create and modify accounts.

- **Adaptation & Configuration:**  
  Update paths, OUs, domain names, and template accounts as required for your specific environment. The provided scripts and folders are structured as examples and may contain placeholder values.

## Usage

1. **Open PowerShell as Administrator:**  
   Right-click on PowerShell and select **Run as Administrator**.

2. **Navigate to the Desired Script Folder:**  
   ```powershell
   cd C:\Path\To\AD-Creation\ad-creation-basic\
   ```
   *(or `ad-creation-detailed`, or `ad-o365hybridcreation` depending on your needs)*

3. **Set Execution Policy (if necessary):**  
   ```powershell
   Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
   ```

4. **Run the Script:**
   ```powershell
   .\YourScriptName.ps1
   ```

5. **Follow On-Screen Prompts:**  
   The script will ask for user details, ticket numbers (if applicable), and other attributes, then automatically create the user account with the specified configuration.

## Notes

- **Customization:**  
  Each script can be tailored to match your exact onboarding processes, attribute requirements, and compliance needs.

- **Error Handling:**  
  Scripts typically include validations for usernames, email addresses, and required attributes. If a required piece of information is missing or invalid, the script will prompt you to re-enter the information.

## Disclaimer

These scripts are provided as-is. Test them thoroughly in a non-production environment before using them in your live AD. Always ensure proper backups and understand the implications of creating and configuring user accounts in your environment.
```