## About Me  
I am an IT professional with a strong focus on Microsoft technologies, PowerShell automation, and hybrid cloud administration. My expertise lies in streamlining enterprise tasks, integrating on-premises Active Directory with Exchange Online, and improving overall workflow efficiency. By leveraging scripting, security best practices, and effective resource management, I deliver solutions that enhance productivity and maintain a secure, compliant environment.

## **Technical Skills and Expertise**
- **Microsoft Technologies:** Proficient in managing Microsoft O365, Exchange, and Azure environments, ensuring seamless collaboration and enhanced security.
- **Automation & Scripting:** Advanced experience in PowerShell scripting, including automation for AD user creation, terminations, hybrid migrations, and Exchange management.
- **Active Directory & Exchange:** Extensive knowledge of AD user provisioning, group membership configuration, and hybrid Exchange mailbox migrations.
- **Security & Compliance:** Skilled in security hardening, exploiting operating systems, and leveraging Proofpoint for email security and DLP (Data Loss Prevention).
- **Networking & Cloud Integration:** Expertise in network diagnostics, configuration, and seamless integration of on-prem and cloud environments.

## **GitHub Repository Structure**
I maintain a clean and organized **PowerShell-Scripts** directory, ensuring clear separation and visibility of projects. This structure reflects my commitment to best practices in file organization and modular scripting.

**Directory Overview:**
```
PowerShell-Scripts/
├── Exchange-Scripts/
│   ├── ExchangeOnlineManagement/
│   │   ├── ExchangeOnlineManagement.ps1
│   │   └── README.md
│   └── HybridMigration/
│       ├── migration-logs/ (includes .gitkeep and README.md to explain logs)
│       ├── sample-migration.csv (demonstrates the CSV format for migrations)
│       ├── sample-migration-logs.txt (example log output for reference)
│       ├── HybridMigration.ps1 (automates hybrid migration process)
│       └── README.md (explains migration workflow and usage)
├── AD-Creation/
│   ├── AD-Creation-Basic/
│   │   ├── AD-Creation-Basic.ps1
│   │   └── README.md
│   ├── AD-Creation-Detailed/
│   │   ├── AD-Creation-Detailed.ps1
│   │   └── README.md
│   ├── AD-O365Hybrid-UserCreation/
│   │   ├── AD-O365Hybrid-UserCreation.ps1
│   │   └── README.md
│   └── README.md
├── AD-Termination/
│   ├── AD-Termination.ps1
│   └── README.md
├── PS-Cheatsheet/
│   ├── Exchange-Cheatsheet/
│   │   ├── Exchange-Cheatsheet.ps1
│   │   └── README.md
│   ├── Network-Cheatsheet/
│   │   ├── network-Cheatsheet.ps1
│   │   └── README.md
│   └── General-Cheatsheet/
│       ├── general-cheatsheet.ps1
│       └── README.md
├── .gitignore (includes CSV exclusions, migration logs, and secrets)
├── LICENSE.md
└── README.md
```

## **Featured Projects**

### **AD_User_Creation_Script**
- **Purpose:** Automates the entire user onboarding process in Active Directory, including group memberships, email provisioning, and attribute configuration.
- **Impact:** Ensures quick, consistent, and secure account provisioning while maintaining compliance with security policies.
- **Key Features:**
  - Automates user creation for both basic and hybrid Office 365 environments.
  - Uses dynamic input validation to prevent misconfiguration.
  - Outputs key information about user accounts, including usernames, display names, and assigned groups.

### **Hybrid Exchange Migration Tool**
- **Purpose:** Fully automates the process of migrating mailboxes from on-premises Exchange to Office 365 via hybrid migration.
- **Impact:** Reduces manual effort, tracks migration progress, and outputs logs for auditability.
- **Key Features:**
  - Creates endpoints, batches, and manages the entire migration lifecycle.
  - Logs migration status, progress, and error information to the **migration-logs** folder.
  - Ensures privacy and compliance by excluding **real data** from GitHub using `.gitignore`.

### **Exchange_Management_Tool**
- **Purpose:** Simplifies mailbox creation, configuration, and remote mailbox management in hybrid Exchange Online environments.
- **Impact:** Reduces manual overhead and enhances mailbox lifecycle management.
- **Key Features:**
  - Powers remote mailbox creation and enables hybrid configurations.
  - Handles permissions like **Send As**, **Full Access**, and **Send on Behalf** assignments.
  - Leverages **dynamic prompts** and **error handling** to ensure smooth execution.

### **PowerShell_Cheatsheet**
- **Purpose:** A curated reference of essential PowerShell commands and scripts, helping teams troubleshoot networks, manage systems, and enforce security policies.
- **Impact:** Accelerates incident response, network diagnostics, and automation workflows.
- **Key Features:**
  - Divided into focused cheatsheets for Exchange, Network, and General IT needs.
  - Includes frequently used one-liners, automation snippets, and security commands.

## **Why Choose Me?**
- **Overkill Approach:** I prioritize completeness and thoroughness in every project.
- **Innovative Solutions:** I create efficient, auditable, and reusable scripts.
- **Security-Focused:** Strong emphasis on security best practices, privacy, and compliance.
- **Professional Presentation:** My repos are organized, annotated, and ready for review by employers or collaborators.