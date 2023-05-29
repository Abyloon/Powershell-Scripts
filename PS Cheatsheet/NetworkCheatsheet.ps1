'''Check Ports'''
New-Object System.Net.Sockets.TcpClient(IP ADDRESS, PORT)
#Reverse DNS lookups
nslookup
set q=ptr      
<YOUR IP ADDRESS>
 
'''Network ping command - troubleshooting network/vpn issues'''
# pinging google pretty much
ping 8.8.8.8 -t > C:\withVPN.txt

Get-NetTCPConnections > C:\Status.txt

#pathping VS Tracert
pathping 8.8.8.8 #pathping it runs ping with traceroute. Tracert displays routers and their corresponding time taken, while Pathping provides additional information such as latency and packet loss.
tracert 8.8.8.8 #traceroute

""" Firewall management """
#lists of goto commands, I have used:
Get-Command -Module NetSecurity
#To enable all three network profiles: Domain, Public and Private, use this command:
Set-NetFirewallProfile -All -Enabled True

#Specific profile instead All:
Set-NetFirewallProfile -Profile Public -Enabled True

#To disable the firewall for all three network location, use the command:
Set-NetFirewallProfile -All -Enabled False
<#You can customize Windows Firewall using the Set-NetFirewallProfile cmdlet. 
Change default action, logging, and notifications. Newer OS blocks inbound and allows outbound connections, but you can use the cmdlet to block all inbound for Public profiles.
#>
Set-NetFirewallProfile –Name Public –DefaultInboundAction Block

#You can display the current profile settings as follows:
Get-NetFirewallProfile -Name Public

#To Ensure that all firewall settings are applied to all network interfaces of the computer.
Get-NetFirewallProfile -Name Public | fl DisabledInterfaceAliases

#Disable specific interface
Set-NetFirewallProfile -Name Public -DisabledInterfaceAliases "Ethernet1"

<#
A lot more amazing firewall managemetns commands can be located in https://woshub.com/manage-windows-firewall-powershell/ 
#>