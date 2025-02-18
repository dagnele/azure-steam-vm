# Check if running as administrator
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)) {
    Write-Host "This script must be run as an administrator." -ForegroundColor Red
    exit 1
}

# Define the temporary directory for downloading installers (using system temp directory)
$installDir = "$env:TEMP\Installers"

# Create the directory if it doesn't exist
if (-not (Test-Path -Path $installDir)) {
    New-Item -ItemType Directory -Path $installDir | Out-Null
}

# Function to download and install software
function Install-Software {
    param (
        [string]$installerUrl,
        [string]$installerName,
        [string]$arguments
    )

    $installerPath = Join-Path -Path $installDir -ChildPath $installerName

    # Remove any existing installer file
    if (Test-Path -Path $installerPath) {
        Remove-Item -Path $installerPath -Force
    }

    try {
        # Download the installer
        Write-Host "Downloading $installerName from $installerUrl..."
        Invoke-WebRequest -Uri $installerUrl -OutFile $installerPath -ErrorAction Stop

        # Verify the file was downloaded
        if (-not (Test-Path -Path $installerPath)) {
            throw "Installer download failed for $installerName."
        }

        # Run the installer silently
        Write-Host "Installing $installerName..."
        $process = Start-Process -FilePath $installerPath -ArgumentList $arguments -Wait -PassThru -NoNewWindow -ErrorAction Stop

        # Check if the process exited with a non-zero exit code
        if ($process.ExitCode -ne 0) {
            throw "$installerName installation failed with exit code $($process.ExitCode)."
        }

        # Clean up the installer
        Remove-Item -Path $installerPath -Force
        Write-Host "$installerName installed successfully."
    } catch {
        Write-Host "Error installing $installerName: $($_.Exception.Message)" -ForegroundColor Red
        exit 1
    }
}

# Install Sunshine Streaming Server
$sunshineInstallerUrl = "https://github.com/LizardByte/Sunshine/releases/download/v2025.122.141614/sunshine-windows-installer.exe"
Install-Software -installerUrl $sunshineInstallerUrl -installerName "SunshineInstaller.exe" -arguments "/S"

# Install Steam
$steamInstallerUrl = "https://steamcdn-a.akamaihd.net/client/installer/SteamSetup.exe"
Install-Software -installerUrl $steamInstallerUrl -installerName "SteamSetup.exe" -arguments "/S"

# Optional: Configure Sunshine or Steam further if needed
