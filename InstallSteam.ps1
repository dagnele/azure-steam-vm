# Set execution policy to allow script execution
Set-ExecutionPolicy -ExecutionPolicy Unrestricted -Force

# Download Steam installer
$steamInstaller = "$env:TEMP\SteamSetup.exe"
Invoke-WebRequest -Uri "https://steamcdn-a.akamaihd.net/client/installer/SteamSetup.exe" -OutFile $steamInstaller

# Install Steam silently
Start-Process -FilePath $steamInstaller -ArgumentList "/S" -NoNewWindow -Wait

# Remove installer
Remove-Item -Path $steamInstaller -Force

# Confirm installation
Write-Output "Steam installation completed."