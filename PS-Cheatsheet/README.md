# PowerShell Cheatsheets

This folder contains a collection of PowerShell scripts (cheatsheets) for various system administration tasks, including network troubleshooting, general administration, and Exchange management.

## Scripts

### 1. `Network-Cheatsheet.ps1`
Contains common PowerShell commands and scripts for managing network-related tasks, including checking ports, running ping tests, troubleshooting network/VPN issues, and firewall management.

### 2. `General-Cheatsheet.ps1`
A general cheatsheet for common administrative tasks in Windows environments, such as user management, Active Directory management, permissions, system cleanup, and service management.

### 3. `Exchange-Cheatsheet.ps1`
Contains PowerShell commands and scripts specifically for managing Exchange environments, including user management, mailbox configurations, and troubleshooting.

## Usage

To use any of the scripts, simply download the `.ps1` file and execute it in PowerShell. Ensure your execution policy allows the running of scripts:

```powershell
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
```

## Requirements

- PowerShell (v5.0 or later recommended).
- Proper permissions to execute the commands in your environment.

## License

This project is licensed under the MIT License - see the [LICENSE](https://github.com/Abyloon/Powershell-Scripts/blob/main/LICENSE.md) file for details.
```
