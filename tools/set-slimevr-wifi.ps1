param(
  [Parameter(Mandatory = $true)]
  [string] $Port,

  [Parameter(Mandatory = $true)]
  [string] $Ssid,

  [Parameter(Mandatory = $true)]
  [string] $Password,

  [int] $BaudRate = 115200,

  [switch] $Reboot
)

$ErrorActionPreference = 'Stop'

function Convert-ToBase64Utf8([string] $Value) {
  $bytes = [System.Text.Encoding]::UTF8.GetBytes($Value)
  [Convert]::ToBase64String($bytes)
}

$b64Ssid = Convert-ToBase64Utf8 $Ssid
$b64Password = Convert-ToBase64Utf8 $Password
$wifiCommand = "SET BWIFI $b64Ssid $b64Password"

$serial = [System.IO.Ports.SerialPort]::new($Port, $BaudRate, 'None', 8, 'One')
$serial.DtrEnable = $false
$serial.RtsEnable = $false
$serial.NewLine = "`n"
$serial.ReadTimeout = 500

try {
  $serial.Open()
  Write-Host "[SERIAL] Opened $Port at $BaudRate"
  Start-Sleep -Milliseconds 1000

  Write-Host "[SERIAL] Sending: SET BWIFI <ssid-b64> <password-b64>"
  $serial.WriteLine($wifiCommand)

  if ($Reboot) {
    Start-Sleep -Milliseconds 800
    Write-Host "[SERIAL] Sending: REBOOT"
    $serial.WriteLine('REBOOT')
  }

  $deadline = (Get-Date).AddSeconds(35)
  while ((Get-Date) -lt $deadline) {
    try {
      $line = $serial.ReadLine()
      Write-Host $line

      if ($line -match 'CMD SET BWIFI OK') {
        Write-Host '[SERIAL] Wi-Fi credentials accepted by tracker.'
      }

      if ($line -match 'Connected successfully') {
        Write-Host '[SERIAL] Tracker connected to Wi-Fi.'
      }
    } catch [System.TimeoutException] {
    }
  }
} finally {
  if ($serial.IsOpen) {
    $serial.Close()
    Write-Host "[SERIAL] Closed $Port"
  }
}
