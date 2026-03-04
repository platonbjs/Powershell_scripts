#Import-Module Microsoft.Graph.DeviceManagement 
Connect-MgGraph -Scopes "DeviceManagementServiceConfig.ReadWrite.All" -NoWelcome

# Cargar CSV con SerialNumber
$csv = Import-Csv ".\SNs.csv"
Write-Host "$csv"

# Obtener todas las identidades Autopilot
$apDevices = Get-MgDeviceManagementWindowsAutopilotDeviceIdentity -All

foreach ($row in $csv) {
    $sn = $row.SerialNumber
    Write-Host "$sn"
    $ap = $apDevices | Where-Object { $_.SerialNumber -eq $sn }

    if ($ap) {
        Write-Host "Eliminando Autopilot para $sn"
        Remove-MgDeviceManagementWindowsAutopilotDeviceIdentity `
            -WindowsAutopilotDeviceIdentityId $ap.Id `
            -Confirm:$false
    }
    else {
        Write-Host "SN $sn no está en Autopilot"
    }
}