<#
.SYNOPSIS
    Exports Intune device compliance state to CSV.

.DESCRIPTION
    Queries all managed devices via Microsoft Graph and exports
    their compliance state, OS version, and last sync time.

.PARAMETER OutputPath
    Path to the output CSV file. Defaults to .\compliance-report.csv

.EXAMPLE
    .\Get-IntuneDeviceComplianceReport.ps1 -OutputPath "C:\Reports\compliance.csv"

.NOTES
    Requires: Microsoft.Graph module, DeviceManagementManagedDevices.Read.All
#>

[CmdletBinding()]
param(
    [string]$OutputPath = ".\compliance-report.csv"
)

# Verify Graph connection
$context = Get-MgContext
if (-not $context) {
    Write-Warning "Not connected to Microsoft Graph. Run: Connect-MgGraph -Scopes 'DeviceManagementManagedDevices.Read.All'"
    exit 1
}

Write-Host "Connected as: $($context.Account)" -ForegroundColor Cyan
Write-Host "Fetching managed devices..." -ForegroundColor Yellow

$devices = Get-MgDeviceManagementManagedDevice -All -Property `
    DisplayName, ComplianceState, OperatingSystem, OsVersion, `
    LastSyncDateTime, UserPrincipalName, Id

$report = $devices | Select-Object `
    @{N='DeviceName';    E={$_.DisplayName}},
    @{N='User';          E={$_.UserPrincipalName}},
    @{N='OS';            E={$_.OperatingSystem}},
    @{N='OSVersion';     E={$_.OsVersion}},
    @{N='Compliance';    E={$_.ComplianceState}},
    @{N='LastSync';      E={$_.LastSyncDateTime}}

$report | Export-Csv -Path $OutputPath -NoTypeInformation -Encoding UTF8

Write-Host "Done. $($report.Count) devices exported to: $OutputPath" -ForegroundColor Green
