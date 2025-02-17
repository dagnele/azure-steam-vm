# Define the temporary directory for downloading installers
$installDir = "C:\temp"
if (-not (Test-Path -Path $installDir)) {
    New-Item -ItemType Directory -Path $installDir
}

# Install Sunshine Streaming Server

# Define Sunshine installer URL and path
$sunshineInstallerUrl = "https://github.com/LizardByte/Sunshine/releases/download/v2025.213.180858/Sunshine-0.23.1-Installer.exe"
$sunshineInstallerPath = "$installDir\SunshineInstaller.exe"

# Download Sunshine installer
Invoke-WebRequest -Uri $sunshineInstallerUrl -OutFile $sunshineInstallerPath

# Run Sunshine installer silently
Start-Process -FilePath $sunshineInstallerPath -ArgumentList "/S" -Wait

# Clean up Sunshine installer
Remove-Item -Path $sunshineInstallerPath -Force

# Install Steam

# Define Steam installer URL and path
$steamInstallerUrl = "https://steamcdn-a.akamaihd.net/client/installer/SteamSetup.exe"
$steamInstallerPath = "$installDir\SteamSetup.exe"

# Download Steam installer
Invoke-WebRequest -Uri $steamInstallerUrl -OutFile $steamInstallerPath

# Run Steam installer silently
Start-Process -FilePath $steamInstallerPath -ArgumentList "/S" -Wait

# Clean up Steam installer
Remove-Item -Path $steamInstallerPath -Force

# Optional: Configure Sunshine or Steam further if needed
