<#
.SYNOPSIS
    A simple IPv4 subnet scanner for Windows PowerShell 5.1.

.DESCRIPTION
    Scans addresses 1 through 254 in a specified IPv4 /24 subnet by sending
    one ICMP echo request to each address. The result of every scan is shown
    immediately. Online hosts are collected and displayed in a summary table.

.NOTES
    File name: SubnetScanner.ps1
    Requirements: Windows PowerShell 5.1 or later

.EXAMPLE
    .\SubnetScanner.ps1

    Enter a subnet such as 192.168.38 when prompted.
#>

$subnet = Read-Host "Enter the subnet without the final octet, for example 192.168.38"

# Validate the subnet format and octet values.
if ($subnet -notmatch '^(\d{1,3})\.(\d{1,3})\.(\d{1,3})$') {
    Write-Host "Invalid subnet format. Use a value such as 192.168.38." -ForegroundColor Red
    exit 1
}

$octets = $subnet.Split('.')

foreach ($octet in $octets) {
    if ([int]$octet -lt 0 -or [int]$octet -gt 255) {
        Write-Host "Invalid subnet. Each octet must be between 0 and 255." -ForegroundColor Red
        exit 1
    }
}

$startAddress = 1
$endAddress = 254
$timeoutMilliseconds = 300
$results = @()

Write-Host ""
Write-Host "Scanning $subnet.$startAddress through $subnet.$endAddress..." -ForegroundColor Cyan
Write-Host "Timeout per address: $timeoutMilliseconds ms" -ForegroundColor Cyan
Write-Host ""

foreach ($hostAddress in $startAddress..$endAddress) {
    $ipAddress = "$subnet.$hostAddress"
    $ping = New-Object System.Net.NetworkInformation.Ping

    try {
        $reply = $ping.Send($ipAddress, $timeoutMilliseconds)

        if ($reply.Status -eq "Success") {
            Write-Host "$ipAddress is ONLINE  Latency: $($reply.RoundtripTime) ms" -ForegroundColor Green

            $results += [PSCustomObject]@{
                IPAddress = $ipAddress
                Status    = "Online"
                LatencyMs = $reply.RoundtripTime
            }
        }
        else {
            Write-Host "$ipAddress is offline" -ForegroundColor DarkGray
        }
    }
    catch {
        Write-Host "$ipAddress is offline or could not be checked" -ForegroundColor DarkGray
    }
    finally {
        $ping.Dispose()
    }
}

Write-Host ""
Write-Host "Scan completed." -ForegroundColor Green
Write-Host "Online hosts found: $($results.Count)" -ForegroundColor Green
Write-Host ""

if ($results.Count -gt 0) {
    Write-Host "Online hosts:" -ForegroundColor Cyan
    $results | Format-Table -AutoSize
}
else {
    Write-Host "No online hosts responded to ICMP ping." -ForegroundColor Yellow
}
