# PowerShell Cheat Sheet for Network and Firewall Management

## Overview

This repository contains a PowerShell script for network and firewall management tasks, designed for IT administrators to efficiently monitor, troubleshoot, and configure network connectivity and firewall settings in Windows environments.

## Features

### **Network Management**
- **Port Checking**: Check if a port is open on a specific IP address.
- **Reverse DNS Lookup**: Perform reverse DNS lookups for IP addresses.
- **Network Troubleshooting**:
  - Ping remote servers or IPs to troubleshoot connectivity and VPN issues.
  - Export active TCP connections.
  - Use Pathping and Tracert for detailed network analysis.

### **Firewall Management**
- **Manage Firewall Profiles**:
  - Enable/Disable all or specific firewall profiles (Domain, Public, Private).
  - Set custom rules for inbound actions (block inbound on Public profile).
  - Disable firewall on specific interfaces.
- **Firewall Settings**: Review current profile settings and disabled interfaces.

## Getting Started

### Prerequisites
- **PowerShell Version**: Ensure that you're using Windows PowerShell 5.0 or later.
- **Execution Policy**: Ensure that script execution is enabled by running:
  ```powershell
  Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
  ```

### Usage
1. Clone or download the repository.
2. Open the PowerShell script in an editor (e.g., Visual Studio Code or PowerShell ISE).
3. Customize the IP addresses and ports as needed for your environment.
4. Execute the commands or scripts based on your requirements.

### Examples

- **Check if a specific port is open** on a remote IP address:
  ```powershell
  New-Object System.Net.Sockets.TcpClient("192.168.1.100", "443")
  ```

- **Perform a reverse DNS lookup** for a given IP address:
  ```powershell
  nslookup
  set q=ptr
  192.168.1.100
  ```

- **Ping a server continuously** to troubleshoot network connectivity:
  ```powershell
  ping 8.8.8.8 -t > C:\withVPN.txt
  ```

- **Enable firewall profiles** for all networks:
  ```powershell
  Set-NetFirewallProfile -All -Enabled True
  ```

- **Disable firewall for a specific interface**:
  ```powershell
  Set-NetFirewallProfile -Name Public -DisabledInterfaceAliases "Ethernet1"
  ```

## Contribution
Feel free to contribute improvements or additional use cases by submitting a pull request. All contributions are welcome!

## Disclaimer
This script is provided as-is and should be tested in a controlled environment before deployment in production. Always ensure proper backups and configurations before making changes to system settings.

## License

This project is licensed under the [MIT License](LICENSE).
```