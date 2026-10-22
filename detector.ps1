# ============================================
# WIFI DRIVER DETECTOR - SIMPLE
# ============================================

Clear-Host
Write-Host "=============================================" -ForegroundColor Cyan
Write-Host "         DETEKSI DRIVER WIFI                 " -ForegroundColor Cyan
Write-Host "=============================================" -ForegroundColor Cyan
Write-Host ""

# Cari adapter WiFi
$wifi = Get-NetAdapter | Where-Object { $_.InterfaceDescription -match "Wireless|WiFi|WLAN|802.11" }

if ($wifi) {
    foreach ($w in $wifi) {
        Write-Host "Nama Adapter    : " -NoNewline
        Write-Host $w.InterfaceDescription -ForegroundColor Yellow

        Write-Host "Status          : " -NoNewline
        if ($w.Status -eq "Up") {
            Write-Host $w.Status -ForegroundColor Green
        } else {
            Write-Host $w.Status -ForegroundColor Red
        }

        Write-Host "MAC Address     : " -NoNewline
        Write-Host $w.MacAddress -ForegroundColor Yellow

        # Ambil info driver dari WMI
        $driver = Get-WmiObject Win32_PnPSignedDriver | Where-Object { 
            $_.DeviceName -eq $w.InterfaceDescription 
        }

        if ($driver) {
            Write-Host "Driver Version  : " -NoNewline
            Write-Host $driver.DriverVersion -ForegroundColor Yellow

            Write-Host "Driver Provider : " -NoNewline
            Write-Host $driver.DriverProviderName -ForegroundColor Yellow

            if ($driver.DriverDate) {
                $tgl = [Management.ManagementDateTimeConverter]::ToDateTime($driver.DriverDate)
                Write-Host "Tanggal Driver  : " -NoNewline
                Write-Host $tgl.ToString("dd-MM-yyyy") -ForegroundColor Yellow
            }
        }

        Write-Host "---------------------------------------------"
    }
} else {
    Write-Host "[!] Driver WiFi TIDAK ditemukan di sistem ini." -ForegroundColor Red
}

Write-Host ""
Read-Host "Tekan ENTER untuk keluar"
