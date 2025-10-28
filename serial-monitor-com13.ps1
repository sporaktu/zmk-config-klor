$port = new-Object System.IO.Ports.SerialPort COM13,115200,None,8,one
$port.Open()
Write-Host "Connected to COM13 at 115200 baud. Waiting for data..."
Write-Host "Press Ctrl+C to stop"
Write-Host ""

try {
    $timeout = 120  # 2 minutes
    $elapsed = 0
    while ($elapsed -lt $timeout) {
        if ($port.BytesToRead -gt 0) {
            $data = $port.ReadExisting()
            Write-Host $data -NoNewline
        }
        Start-Sleep -Milliseconds 50
        $elapsed += 0.05
    }
} finally {
    $port.Close()
    Write-Host ""
    Write-Host "Serial port closed."
}
