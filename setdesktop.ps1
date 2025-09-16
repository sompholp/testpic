# กำหนด URL ของภาพ
$wallpaperUrl = "https://website-branches-search.obs.ap-southeast-2.myhuaweicloud.com/intune/screen_20250915.png"
$localPath    = "$env:USERPROFILE\Pictures\screen_20250915.png"

# ✅ สร้างโฟลเดอร์ถ้ายังไม่มี
New-Item -ItemType Directory -Force -Path (Split-Path $localPath) | Out-Null

# ✅ ดาวน์โหลดภาพ
Invoke-WebRequest -Uri $wallpaperUrl -OutFile $localPath

# ✅ โหลด Windows API เพื่อเปลี่ยน Wallpaper แบบทันที
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

# ✅ ตั้งค่า wallpaper และ refresh ทันที
[Wallpaper]::SystemParametersInfo($SPI_SETDESKWALLPAPER, 0, $localPath, $SPIF_UPDATEINIFILE -bor $SPIF_SENDCHANGE)

Write-Output "✅ Wallpaper updated successfully: $localPath"

 
