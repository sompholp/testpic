# Set wallpaper URL
$wallpaperUrl = "https://website-branches-search.obs.ap-southeast-2.myhuaweicloud.com/intune/screen_20250915.png"

# Get currently logged-in user profile
$explorer = Get-Process explorer -ErrorAction SilentlyContinue | Select-Object -First 1
$SID = (Get-WmiObject Win32_Process -Filter "ProcessId=$($explorer.Id)").GetOwner().Sid
$profilePath = (Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\ProfileList\$SID").ProfileImagePath

# Build file path safely
$localPath = Join-Path $profilePath "Pictures\screen_20250915.png"

# Create folder if missing
New-Item -ItemType Directory -Force -Path (Split-Path $localPath) | Out-Null

# Download wallpaper
Invoke-WebRequest -Uri $wallpaperUrl -OutFile $localPath

# Load Windows API
Add-Type @"
using System.Runtime.InteropServices;
public class Wallpaper {
    [DllImport("user32.dll", SetLastError = true)]
    public static extern bool SystemParametersInfo(int uAction, int uParam, string lpvParam, int fuWinIni);
}
"@

$SPI_SETDESKWALLPAPER = 20
$SPIF_UPDATEINIFILE   = 0x01
$SPIF_SENDCHANGE      = 0x02

# Set wallpaper for that user
[Wallpaper]::SystemParametersInfo($SPI_SETDESKWALLPAPER, 0, $localPath, $SPIF_UPDATEINIFILE -bor $SPIF_SENDCHANGE)

Write-Output "✅ Wallpaper updated successfully for $profilePath"
