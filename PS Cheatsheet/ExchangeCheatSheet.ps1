<#Note, please replace anytime @domain.com or @email.com is mentioned to what it should be.
commands will apply to O365 directly. If a system applied on premises and on cloud.
For example, a user should be created on-premises. It will be created on prem
Additional information will be provided at a later date.
#>

#List a specific user permissions such as SendAs
Get-RecipientPermission -Trustee "user@email.com"
 
#List all members full access to the sharedmailbox
Get-MailboxPermission -Identity SharedMailbox@email.com 
 
#List all members who have permission to a SharedMailbox
Get-RecipientPermission "SharedMailbox@domain.com"
 
#FullAccess:
Add-MailboxPermission -Identity SHAREDMBX@emaildomain.com -User username@emaildomain.com -AccessRights FullAccess -InheritanceType All
 
#SendAs
Add-RecipientPermission SHAREDMBX@emaildomain.com -AccessRights SendAs -Trustee username@emaildomain.com
#List SendAs
Get-RecipientPermission "SharedMailbox@Domain.com"

#SendOnBehalfTo 
#Note Doing without @ syntax will blow away everyone else
Set-Mailbox SharedMailbox@emaildomain.com -GrantSendOnBehalfTo @{Add=”username@emaildomain.com”, “username@emaildomain.com”}

#List SendOnBehalf Access on a specific shared mailbox:
Get-Mailbox SharedMailbox@domain.com | select Name,Alias,UserPrincipalName,PrimarySmtpAddress,@{l='SendOnBehalfOf';e={$_.GrantSendOnBehalfTo -join ";"}} 

#Add-DistributionGroupMember
Add-DistributionGroupMember -Identity "Staff" -Member "JohnEvans@domain.com"

#List members in the dist group:
Get-DistributionGroup -Identity "Marketing Reports" | Format-List
 
#To add X500:
Set-Mailbox -Identity "Stuff@domain.com" -EmailAddresses @{add="X500:/o=URS/ou=Exchange Administrative Group (FYDIBOHF99SPDLT)/cn=Recipients/cn=Stuff"}

#Get-MailboxFolderStatistics 
Get-MailboxFolderStatistics -Identity "Abyloon@domain.com" -IncludeAnalysis -FolderScope RecoverableItems | FT Name,ItemsInFolder,FolderAndSubfolderSize
 

#Message Tracing
#change the dates to the dates you want to investigate
Get-MessageTrackingLog -Start "08/07/2021 00:00" -End "08/13/2021 23:59" -Sender sender@email.com -Recipients abyloon@domain.com
 
Get-MessageTrace -Start "08/07/2021 00:00" -End "08/13/2021 23:59" -SenderAddress sender@email.com -RecipientAddress abyloon@domain.com

# Get size of subfolders in mailbox and the item count 
Get-MailboxFolderStatistics -Identity someuser@domain.com -FolderScope all  -IncludeAnalysis | select name, itemsinfolder, foldersize 
 
#Gather list of mailboxes with forwarding on + forwarding address  
get-mailbox -resultsize unlimited | where {$_.ForwardingAddress -ne $null} | select Name, ForwardingAddress, DeliverToMailboxAndForward | export-csv -path "C:\Users\$env:UserName\URS_mailforwarding.csv" 
 
#Get Forwarding address:
Get-Mailbox <The mailbox> | Select *forward*
 
#Set forwarding Regular
Set-Mailbox <mailbox> -ForwardingAddress <Mailbox forward to?> -DeliverToMailboxAndForward $true
 
#Set SMTP Forwarding
Set-Mailbox <From> -ForwardingSMTPAddress <Mailbox forward to?>  -DeliverToMailboxAndForward $True
