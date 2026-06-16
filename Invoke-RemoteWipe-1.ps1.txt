<#
.SYNOPSIS
    Triggers selective wipe on a managed Intune device.

.DESCRIPTION
    Finds a device by display name and initiates a selective wipe
    (removes corporate data, preserves personal data).
    Requires explicit confirmation before execution.

.PARAMETER DeviceName
    Display name of the device as shown in Intune.

.EXAMPLE
    .\Invoke-RemoteWipe.ps1 -DeviceName "DESKTOP-ABC123"

.NOTES
    Requires: DeviceManagementManagedDevices.ReadWrite.All
    Write operation — use with caution.
#>

[CmdletBinding(SupportsShouldProcess)]
param(
    [Parameter(Mandatory)]
    [string]$DeviceName
)

$context = Get-MgContext
if (-not $context) {
    Write-Warning "Not connected. Run: Connect-MgGraph -Scopes 'DeviceManagementManagedDevices.ReadWrite.All'"
    exit 1
}

Write-Host "Searching for device: $DeviceName" -ForegroundColor Yellow

$device = Get-MgDeviceManagementManagedDevice -Filter "displayName eq '$DeviceName'" | Select-Object -First 1

if (-not $device) {
    Write-Error "Device '$DeviceName' not found in Intune."
    exit 1
}

Write-Host "Found: $($device.DisplayName) | User: $($device.UserPrincipalName) | OS: $($device.OperatingSystem)" -ForegroundColor Cyan

$confirm = Read-Host "Confirm selective wipe for '$($device.DisplayName)'? (yes/no)"
if ($confirm -ne "yes") {
    Write-Host "Aborted." -ForegroundColor Yellow
    exit 0
}

if ($PSCmdlet.ShouldProcess($device.DisplayName, "Selective Wipe")) {
    Invoke-MgRetireManagedDevice -ManagedDeviceId $device.Id
    Write-Host "Selective wipe initiated for: $($device.DisplayName)" -ForegroundColor Green
}
