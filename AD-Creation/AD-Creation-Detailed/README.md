# Active Directory User Creation Script

## Overview

This PowerShell script automates the process of creating new users in Active Directory (AD). It ensures consistent user data entry, validates inputs, and assigns user attributes such as job title, department, and manager. The script also dynamically handles office location and company assignment, making it an efficient tool for IT administrators.

---

## Features

- **Interactive Input:** Prompts the user to enter details like first name, last name, job title, and department with validation for accurate data entry.
- **Dynamic Company and Location Assignment:** Allows selection between `Stars` and `Contractors` for company and `Office` or `Field` for location.
- **Manager Validation:** Confirms the existence of the specified manager in AD.
- **Unique Username Generation:** Automatically resolves username conflicts by appending numeric suffixes if needed.
- **Secure Password Generation:** Creates a default secure password for the user.
- **Comprehensive User Attributes:** Populates fields such as:
  - Name
  - Email
  - Office Address
  - Job Title
  - Department
  - Manager
- **Error Handling:** Provides feedback for any issues encountered during the user creation process.

---

## Requirements

- **System:** Windows Server with Active Directory Domain Services (AD DS).
- **Modules:** Active Directory module for Windows PowerShell.
- **Permissions:** User running the script must have permissions to create users in AD.

---

## Installation

1. Clone or download this repository.
2. Save the `AD-Creation.ps1` script to a secure location accessible to your administrative account.
3. Ensure you have the necessary permissions to execute PowerShell scripts on your system.

---

## Usage

1. Open PowerShell as an administrator.
2. Navigate to the directory containing the script.
3. Run the script using the following command:

   ```powershell
   .\AD-Creation.ps1
   ```

4. Follow the prompts to input user details:
   - First Name
   - Last Name
   - Job Title
   - Department
   - Manager
   - Company (`Stars` or `Contractors`)
   - Office Location (`Office` or `Field`)

5. The script will validate inputs and create the new user in Active Directory.

---

## Example Output

When successfully executed, the script will display messages like:

```plaintext
===============================================================
 Welcome to the Creating New Users in Active Directory script
===============================================================
                 Environment Script Launched
===============================================================

Enter New Hire First Name: John
Enter New Hire Last Name: Doe
Enter Job Title: Software Engineer
Enter Department: IT
Enter Manager's Full Name: Jane Smith
Choose Company (C for Contractors, S for Stars): S
Choose Office Location (O for Office, F for Field): O
Creating user in Active Directory...
User 'John Doe' created successfully!
```

If an error occurs, the script will display details for troubleshooting.

---

## Script Details

- **Default Password:** A default password is generated in the format `FL.password`, where `F` is the first initial and `L` is the last initial.
- **Logon Requirement:** Users are required to change their password upon first logon.
- **AD Organizational Unit (OU):** Users are created in the `OU=Users,DC=skystar,DC=com` path. Modify this path in the script if needed.

---

## Limitations

- Assumes the AD domain is `skystar.com`. Adjust the domain and OU path in the script if your environment differs.
- Note: The domain 'skystar.com' is used for example purposes only.
- Password policies in AD must permit the default password format.

---

## Contributing

Feel free to open issues or submit pull requests for enhancements or bug fixes.

---

## License

This project is licensed under the [MIT License](https://github.com/Abyloon/Powershell-Scripts/blob/main/LICENSE.md).
