# ============================================
# Office 365 Hybrid Migration Automation Script
# ============================================

# --------------------------------------------
# Variables - Customize these as per your environment
# --------------------------------------------
$ExchangeServer = "SKY-EXCHP01"                # Name of the on-prem Exchange server
$TenantAdmin = "admin@skystar.onmicrosoft.com"  # Office 365 admin account
$Password = ConvertTo-SecureString "YourSecurePasswordHere" -AsPlainText -Force
$MigrationBatchName = "HybridMigrationBatch"       # Name of the migration batch
$MigrationCSVPath = "C:\Migration\migration.csv"   # CSV file with user mailboxes to migrate
$MigrationEndpointName = "DefaultMigrationEndpoint" # Name of the migration endpoint in Exchange Online
$Credential = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $TenantAdmin, $Password

# --------------------------------------------
# Functions
# --------------------------------------------

# Function to install required modules
function Install-RequiredModules {
    Write-Host "Checking and Installing Required Modules..." -ForegroundColor Cyan
    Install-Module -Name ExchangeOnlineManagement -Force -AllowClobber
    Install-Module -Name MSOnline -Force -AllowClobber
    Write-Host "Required Modules Installed." -ForegroundColor Green
}

# Function to connect to Exchange Online
function Connect-ExchangeOnline {
    Write-Host "Connecting to Exchange Online..." -ForegroundColor Cyan
    try {
        Connect-ExchangeOnline -Credential $Credential
        Write-Host "Connected to Exchange Online successfully." -ForegroundColor Green
    } catch {
        Write-Host "Failed to connect to Exchange Online." -ForegroundColor Red
        throw $_
    }
}

# Function to connect to On-Premises Exchange
function Connect-OnPremExchange {
    Write-Host "Connecting to On-Premises Exchange Server..." -ForegroundColor Cyan
    try {
        $session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri http://$ExchangeServer/PowerShell/ -Authentication Kerberos -Credential $Credential
        Import-PSSession $session -DisableNameChecking
        Write-Host "Connected to On-Premises Exchange Server successfully." -ForegroundColor Green
    } catch {
        Write-Host "Failed to connect to On-Premises Exchange Server." -ForegroundColor Red
        throw $_
    }
}

# Function to create a migration endpoint
function CreateMigrationEndpoint {
    Write-Host "Creating Migration Endpoint..." -ForegroundColor Cyan
    try {
        New-MigrationEndpoint -ExchangeRemoteMove -Name $MigrationEndpointName -RemoteServer $ExchangeServer -Credentials $Credential -Authentication Basic -AutoDetect
        Write-Host "Migration Endpoint created successfully." -ForegroundColor Green
    } catch {
        Write-Host "Migration Endpoint already exists or failed to create." -ForegroundColor Yellow
    }
}

# Function to create a migration batch
function CreateMigrationBatch {
    Write-Host "Creating Migration Batch..." -ForegroundColor Cyan
    try {
        New-MigrationBatch -Name $MigrationBatchName -SourceEndpoint $MigrationEndpointName -CSVData ([System.IO.File]::ReadAllBytes($MigrationCSVPath)) -TargetDeliveryDomain "yourdomain.mail.onmicrosoft.com" -AutoStart
        Write-Host "Migration Batch created successfully." -ForegroundColor Green
    } catch {
        Write-Host "Failed to create Migration Batch." -ForegroundColor Red
        throw $_
    }
}

# Function to start a migration batch
function Start-MigrationBatch {
    Write-Host "Starting Migration Batch..." -ForegroundColor Cyan
    try {
        Start-MigrationBatch -Identity $MigrationBatchName
        Write-Host "Migration Batch started successfully." -ForegroundColor Green
    } catch {
        Write-Host "Failed to start Migration Batch." -ForegroundColor Red
        throw $_
    }
}

# Function to monitor the migration batch status
function MonitorMigrationStatus {
    Write-Host "Monitoring Migration Status..." -ForegroundColor Cyan
    try {
        Get-MigrationBatch -Identity $MigrationBatchName | Select-Object Status, PercentComplete
    } catch {
        Write-Host "Failed to retrieve Migration Status." -ForegroundColor Red
        throw $_
    }
}

# Function to complete the migration batch
function Complete-MigrationBatch {
    Write-Host "Completing Migration Batch..." -ForegroundColor Cyan
    try {
        Complete-MigrationBatch -Identity $MigrationBatchName
        Write-Host "Migration Batch completed successfully." -ForegroundColor Green
    } catch {
        Write-Host "Failed to complete Migration Batch." -ForegroundColor Red
        throw $_
    }
}

# --------------------------------------------
# Execution Section
# --------------------------------------------

# Step 1: Install Required Modules
Install-RequiredModules

# Step 2: Connect to Exchange Online
Connect-ExchangeOnline

# Step 3: Connect to On-Prem Exchange Server
Connect-OnPremExchange

# Step 4: Create Migration Endpoint
CreateMigrationEndpoint

# Step 5: Create Migration Batch
CreateMigrationBatch

# Step 6: Start the Migration Batch
Start-MigrationBatch

# Step 7: Monitor Migration Progress
Write-Host "Monitoring migration status for 30 minutes..." -ForegroundColor Cyan
for ($i = 0; $i -lt 30; $i++) {
    MonitorMigrationStatus
    Start-Sleep -Seconds 60
}

# Step 8: Complete the Migration Batch
Complete-MigrationBatch
