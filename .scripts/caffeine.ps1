Add-Type -AssemblyName System.Windows.Forms

while ($true) {
	[System.Windows.Forms.SendKeys]::SendWait("{SCROLLLOCK}")
	Start-Sleep -Seconds 200
}

# powershell -ExecutionPolicy Bypass -File .\Documents\dot\.scripts\caffeine.ps1