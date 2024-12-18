# Migration Logs Directory

## **Purpose**
The `migration-logs` folder is used to store log files generated during the execution of the **Hybrid Exchange to Office 365 Migration** process. These logs serve as a record of the migration status, errors, warnings, and other important messages that are useful for troubleshooting and auditing purposes.

---

## **What Gets Logged?**
The logs typically contain:
- **Batch Progress**: The percentage of completion for each migration batch.
- **Error Messages**: Any errors that occur during the connection, migration, or completion phases.
- **Status Reports**: Details on the success, failure, or pending state of mailbox migrations.
- **Timing Information**: Timestamps for when migration events occurred.

---

## **File Naming Convention**
Log files follow a naming pattern similar to:
```
log_YYYYMMDD_HHMMSS.txt
```
Where:
- **YYYYMMDD** = Year, Month, and Day (e.g., `20241218` for December 18, 2024)
- **HHMMSS** = Hour, Minute, and Second when the log was created

Example log file:
```
log_20241218_154532.txt
```

---

## **How to Use These Logs**
1. **Review Errors**: If any part of the migration fails, check the log files for error messages or warning prompts.
2. **Monitor Progress**: Review the percentage completion of the migration batch.
3. **Audit Trail**: Use logs as a permanent record of which mailboxes were migrated and when the process was completed.

---

## **Important Notes**
- **Sensitive Data**: Logs should **not contain any user credentials** or personal information. The script should be designed to avoid exposing any sensitive information in log files.
- **Retention Policy**: Decide how long you want to keep these logs. If disk space is a concern, you may want to set up a cleanup script to delete older logs after a certain period.
- **Git Ignore**: This folder is excluded from version control via `.gitignore` to prevent log files from being uploaded to GitHub. However, a `.gitkeep` file is included to ensure the folder is tracked in the repo.

---

## **Security Considerations**
1. **Exclude Logs from Git**: Log files are excluded using a `.gitignore` entry to avoid leaking internal details to the GitHub repo.
2. **Access Control**: Ensure that access to log files is limited to authorized users only, especially in production environments.

---

## **Example Log Entries**
```
[2024-12-18 15:45:12] INFO: Migration batch 'Batch_01' started successfully.
[2024-12-18 15:46:15] WARN: User 'user1@domain.com' migration is taking longer than expected.
[2024-12-18 15:50:43] ERROR: Failed to complete migration for 'user2@domain.com' - Reason: Connection timeout.
[2024-12-18 16:00:21] INFO: Migration batch 'Batch_01' completed with 5 successes, 1 failure.
```

---

## **How to View Logs**
- **PowerShell**: Use the `Get-Content` cmdlet to view logs directly in PowerShell.
  ```powershell
  Get-Content .\migration-logs\log_20241218_154532.txt
  ```
- **Text Editor**: Open the log file with any text editor (like VS Code, Notepad++, etc.).