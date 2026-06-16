# intune-scripts

PowerShell scripts for Microsoft Intune device management — built and tested in a lab environment during SC-300 exam preparation.

## Contents

| Script | Purpose |
|---|---|
| `scripts/Get-IntuneDeviceComplianceReport.ps1` | Exports compliance state for all managed devices |
| `scripts/Set-WindowsUpdateRing.ps1` | Assigns devices to Windows Update rings via Graph API |
| `scripts/Invoke-RemoteWipe.ps1` | Triggers selective wipe for non-compliant devices |

## Requirements

- PowerShell 7.x
- Microsoft.Graph PowerShell SDK (`Install-Module Microsoft.Graph`)
- Entra App Registration with `DeviceManagementManagedDevices.Read.All` (or `.ReadWrite.All` for write ops)
- Permissions consented at tenant level

## Setup

```powershell
# Install required module
Install-Module Microsoft.Graph -Scope CurrentUser

# Connect (interactive, MFA-aware)
Connect-MgGraph -Scopes "DeviceManagementManagedDevices.Read.All"
```

## Usage Example

```powershell
# Export compliance report to CSV
.\scripts\Get-IntuneDeviceComplianceReport.ps1 -OutputPath "C:\Reports\compliance.csv"
```

## Notes

- Scripts use the **Microsoft Graph PowerShell SDK** (v2+), not the deprecated AzureAD module
- Tested against Entra ID P2 trial tenant
- All write operations require explicit confirmation prompt before execution

## Related

- [SC-300 Exam Skills Outline](https://learn.microsoft.com/en-us/credentials/certifications/resources/study-guides/sc-300)
- [Microsoft Graph API – Intune reference](https://learn.microsoft.com/en-us/graph/api/resources/intune-graph-overview)
