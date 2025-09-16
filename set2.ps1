# Specify username
$username = "kbaoadm"

# Build correct path
$localPath = Join-Path "C:\Users\$username" "Pictures\screen_20250915.png"

# Create folder if it doesn't exist
New-Item -ItemType Directory -Force -Path (Split-Path $localPath) | Out-Null

# Download the wallpaper
$wallpaperUrl = "https://website-branches-search.obs.ap-southeast-2.myhuaweicloud.com/intune/screen_20250915.png"
Invoke-WebRequest -Uri $wallpaperUrl -OutFile $localPath

# Load Windows API to change wallpaper
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

# Set wallpaper
[Wallpaper]::SystemParametersInfo($SPI_SETDESKWALLPAPER, 0, $localPath, $SPIF_UPDATEINIFILE -bor $SPIF_SENDCHANGE)

Write-Output "✅ Wallpaper updated successfully: $localPath"
