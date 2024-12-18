# Exchange Scripts

This directory contains PowerShell scripts for **managing and migrating Exchange Online and On-Premises Exchange environments**. The scripts are designed to streamline administrative tasks, automate migrations, and improve operational efficiency.

### **1️ ExchangeOnlineManagement Folder**
This folder contains scripts focused on managing Exchange Online, including user permissions, mailbox access, and automated tasks to support daily administrative needs.

**Key Script(s) in this folder:**
- **ExchangeOnlineManagement.ps1**: This script supports tasks such as managing permissions (SendAs, FullAccess, SendOnBehalf), shared mailboxes, distribution groups, and mailbox forwarding.

**Features:**
- **Access & Permissions**: Grant, remove, and review mailbox permissions like FullAccess, SendAs, and SendOnBehalf.
- **Shared Mailboxes**: Create and manage shared mailboxes.
- **Distribution Groups**: Create and manage distribution groups and assign managers.
- **Mailbox Forwarding**: Configure internal and external email forwarding for user accounts.
- **Out of Office Configuration**: Automate the setup of Out of Office responses for Exchange Online users.

**Usage Instructions:**
1. Open PowerShell as Administrator.
2. Navigate to the **ExchangeOnlineManagement** folder.
3. Run the script using the following command:
   ```powershell
   powershell -ExecutionPolicy Bypass -File .\ExchangeOnlineManagement.ps1
   ```
4. Follow the on-screen prompts to perform the desired task (e.g., FullAccess, SendAs, Out of Office, etc.).

---

### **2️ Migration Folder**
This folder contains scripts focused on **hybrid migrations** from On-Prem Exchange to Exchange Online. These scripts automate the migration process, reducing manual steps and providing a clear, repeatable process for mailbox migrations.

**Key Script(s) in this folder:**
- **HybridMigration.ps1**: A full automation script to migrate mailboxes from On-Prem Exchange to Exchange Online.

**Features:**
- **Automated Migration Steps**: Connects to Exchange Online and On-Prem Exchange, creates migration endpoints, migration batches, and tracks progress.
- **Batch Management**: Automatically starts, monitors, and completes migration batches.
- **Status Reporting**: Provides real-time status updates on the migration process.

**Usage Instructions:**
1. Open PowerShell as Administrator.
2. Navigate to the **Migration** folder.
3. Run the script using the following command:
   ```powershell
   powershell -ExecutionPolicy Bypass -File .\HybridMigration.ps1
   ```
4. Follow the on-screen process. The script will:
   - Install necessary PowerShell modules.
   - Connect to Exchange Online and On-Prem Exchange.
   - Create a migration endpoint.
   - Start and track the migration batch.
   - Complete the migration batch.

---

## **Folder Comparison**

| **Folder**               | **Purpose**                     | **Key Script**             | **Core Features**                                   |
|-------------------------|-----------------------------------|----------------------------|---------------------------------------------------|
| **ExchangeOnlineManagement** | Manage Exchange Online tasks  | ExchangeOnlineManagement.ps1 | Permissions, shared mailboxes, forwarding, and out-of-office setup |
| **Migration**             | Hybrid migration from On-Prem to Exchange Online | HybridMigration.ps1       | Automates full hybrid mailbox migration process    |

---

## **Common Issues & Troubleshooting**

| **Issue**                     | **Cause**                                      | **Solution**                                      |
|-------------------------------|-----------------------------------------------|--------------------------------------------------|
| **Connection Failed**         | MFA or incorrect admin credentials             | Ensure admin account is not MFA-protected or use secure token |
| **Mailbox Migration Fails**   | Invalid CSV file or batch name                 | Verify CSV file format and ensure migration batch name is unique |
| **PowerShell Modules Missing**| Modules not installed                         | Run `Install-Module ExchangeOnlineManagement` and `Install-Module MSOnline` |
| **Script Execution Policy**    | Script cannot be run due to policy             | Run `Set-ExecutionPolicy RemoteSigned` to allow script execution |

---

## **Prerequisites**

1. **Install Required PowerShell Modules**
   ```powershell
   Install-Module ExchangeOnlineManagement -Force
   Install-Module MSOnline -Force
   ```
2. **Hybrid Configuration**
   - Run the **Hybrid Configuration Wizard** to establish a connection between Exchange On-Premises and Exchange Online.
   
3. **Account Permissions**
   - Ensure you have **Global Admin permissions** for Office 365.
   - Ensure the **On-Prem Exchange Admin account** has sufficient permissions to connect to the Exchange server.

4. **CSV File for Migration**
   - Prepare a CSV file with a list of mailboxes to migrate.
   - Place the CSV file in the `Migration` folder.

---

## **Security Considerations**
- **Avoid hardcoding passwords**: Use secure prompts or **SecureString** for passwords.
- **Follow least privilege principles**: Run scripts using a service account with the least privileges required to complete the task.
- **Use secure storage**: Do not store sensitive information (like credentials) in the script. Instead, prompt for them when needed.

---

## **Disclaimer**
This script is intended for **educational purposes only**. Use it at your own risk. Ensure all required security protocols are followed and test in a development environment before running in production.

---

## **License**
This project is licensed under the [MIT License](https://github.com/Abyloon/Powershell-Scripts/blob/main/LICENSE.md).