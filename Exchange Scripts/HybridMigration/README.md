# Hybrid Exchange to Office 365 Migration Script

## **Description**
This PowerShell script automates the migration of on-premises Exchange mailboxes to Office 365 using the hybrid migration approach.

**Note:** The domain (like `skystar.com`), email addresses, and server names (like `SKY-EXCHP01`) are placeholders and should be replaced with the correct values for your organization

## **Features**
- Connects to Exchange Online and On-Prem Exchange.
- Creates a migration endpoint.
- Creates and starts a migration batch.
- Monitors the migration progress.
- Completes the migration automatically.

## **Prerequisites**
1. Install PowerShell modules:
   ```powershell
   Install-Module ExchangeOnlineManagement -Force
   Install-Module MSOnline -Force
   ```
2. Run the **Hybrid Configuration Wizard**.
3. Ensure you have **Global Admin** permissions for Office 365.

## **Security Advice**
- **Do not hardcode credentials**.
- Use `Get-Credential` to collect credentials during runtime.

## **CSV Example**
The CSV file should have an "EmailAddress" column with the list of mailboxes to migrate:
```
EmailAddress
user1@skystar.com
user2@skystar.com
```

## **Usage**
1. Run the script:
   ```powershell
   powershell -ExecutionPolicy Bypass -File .\HybridMigration.ps1
   ```

2. The script will prompt for your admin credentials.

## **License**
This project is licensed under the [MIT License](https://github.com/Abyloon/Powershell-Scripts/blob/main/LICENSE.md).