# **Network and Firewall Management Cheat Sheet**

## Check Ports
# Check if a port is open on a specific IP address
New-Object System.Net.Sockets.TcpClient("IP_ADDRESS", "PORT")

## Reverse DNS Lookups
# Perform a reverse DNS lookup on an IP address
nslookup
set q=ptr
<YOUR IP ADDRESS>

## Network Troubleshooting Commands
# Ping a network address (Google in this case) for latency troubleshooting
ping 8.8.8.8 -t > C:\withVPN.txt

# Export TCP connections to a text file for review
Get-NetTCPConnections > C:\Status.txt

## Pathping vs Tracert
# Pathping combines ping and traceroute to provide additional information such as packet loss and latency
pathping 8.8.8.8

# Traceroute command to display the route packets take to a destination
tracert 8.8.8.8

## Firewall Management
# Get all available commands in the NetSecurity module
Get-Command -Module NetSecurity

# Enable all three network profiles (Domain, Public, and Private)
Set-NetFirewallProfile -All -Enabled True

# Enable only the Public profile
Set-NetFirewallProfile -Profile Public -Enabled True

# Disable the firewall for all profiles
Set-NetFirewallProfile -All -Enabled False

# Block inbound connections on Public profiles only
Set-NetFirewallProfile –Name Public –DefaultInboundAction Block

# Display the current firewall settings for the Public profile
Get-NetFirewallProfile -Name Public

# Check which interfaces are disabled for a specific firewall profile
Get-NetFirewallProfile -Name Public | fl DisabledInterfaceAliases

# Disable firewall on a specific interface (example: Ethernet1)
Set-NetFirewallProfile -Name Public -DisabledInterfaceAliases "Ethernet1"

## Additional Resources
# For more advanced firewall management commands, visit:
# https://woshub.com/manage-windows-firewall-powershell/
