Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

function Press-Spacebar {
    [System.Windows.Forms.SendKeys]::SendWait(" ")
}

while ($true) {
    $delay = Get-Random -Minimum 65 -Maximum 300  # Random delay between 5 and 300 seconds
    Start-Sleep -Seconds $delay

    Press-Spacebar
    Write-Output "Pressed spacebar after waiting $delay seconds at $(Get-Date)"
}

# RUN SCRIPT WITH COMMAND BELOW
# powershell -ExecutionPolicy Bypass -File .\caffeine.ps1
