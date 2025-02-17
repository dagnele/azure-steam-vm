# Define the temporary directory for downloading installers
$installDir = "C:\temp"

# Create the directory if it doesn't exist
if (-not (Test-Path -Path $installDir)) {
    New-Item -ItemType Directory -Path $installDir
}

# Function to download and install software
function Install-Software {
    param (
        [string]$installerUrl,
        [string]$installerName,
        [string]$arguments
    )

    $installerPath = Join-Path -Path $installDir -ChildPath $installerName

    try {
        # Download the installer
        Write-Host "Downloading $installerName..."
        Invoke-WebRequest -Uri $installerUrl -OutFile $installerPath -ErrorAction Stop

        # Run the installer silently
        Write-Host "Installing $installerName..."
        Start-Process -FilePath $installerPath -ArgumentList $arguments -Wait -ErrorAction Stop

        # Clean up the installer
        Remove-Item -Path $installerPath -Force
        Write-Host "$installerName installed successfully."
    } catch {
        Write-Host "Error installing $installerName: $_"
    }
}

# Install Sunshine Streaming Server
$sunshineInstallerUrl = "https://github.com/LizardByte/Sunshine/releases/download/v2025.122.141614/sunshine-windows-installer.exe"
Install-Software -installerUrl $sunshineInstallerUrl -installerName "SunshineInstaller.exe" -arguments "/S"

# Install Steam
$steamInstallerUrl = "https://steamcdn-a.akamaihd.net/client/installer/SteamSetup.exe"
Install-Software -installerUrl $steamInstallerUrl -installerName "SteamSetup.exe" -arguments "/S"

# Optional: Configure Sunshine or Steam further if needed
