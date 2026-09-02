# Subnet Scanner

A simple IPv4 subnet scanner written for Windows PowerShell 5.1.

The script scans addresses `1` through `254` in a specified `/24` subnet and reports whether each address responds to an ICMP ping. Online hosts are shown in green and are collected in a summary table when the scan finishes.

## Features

- Compatible with Windows PowerShell 5.1
- No external modules or dependencies required
- Prompts for the subnet at startup
- Validates the entered subnet
- Shows the result of every checked IP address
- Displays ping latency for online hosts
- Shows a summary of all online hosts
- Uses a configurable ping timeout in the script

## Requirements

- Windows PowerShell 5.1 or later
- Permission to send ICMP echo requests on the network
- A network on which you are authorized to perform the scan

## Installation

Download or clone this repository and save the script as:

```text
SubnetScanner.ps1
```

No installation or additional PowerShell modules are required.

## Usage

Open Windows PowerShell and run:

```powershell
.\SubnetScanner.ps1
```

If the script is stored in another directory, use its complete path:

```powershell
C:\Users\YourName\Documents\SubnetScanner.ps1
```

The script prompts for the first three octets of the subnet:

```text
Enter the subnet without the final octet, for example 192.168.38
```

Example input:

```text
192.168.38
```

The script then scans:

```text
192.168.38.1 through 192.168.38.254
```

## Example output

```text
Scanning 192.168.38.1 through 192.168.38.254...
Timeout per address: 300 ms

192.168.38.1 is ONLINE  Latency: 1 ms
192.168.38.2 is offline
192.168.38.3 is ONLINE  Latency: 2 ms

Scan completed.
Online hosts found: 2

Online hosts:

IPAddress       Status  LatencyMs
---------       ------  ---------
192.168.38.1    Online          1
192.168.38.3    Online          2
```

## Execution policy

If PowerShell prevents the script from running, you can start it once with an execution-policy bypass:

```powershell
powershell.exe -ExecutionPolicy Bypass -File .\SubnetScanner.ps1
```

Alternatively, when using a complete path:

```powershell
powershell.exe -ExecutionPolicy Bypass -File "C:\Users\YourName\Documents\SubnetScanner.ps1"
```

Only change PowerShell execution-policy settings when permitted by your organization.

## Configuration

The following values can be adjusted near the top of the script:

```powershell
$startAddress = 1
$endAddress = 254
$timeoutMilliseconds = 300
```

- `startAddress` determines the first host address to scan.
- `endAddress` determines the last host address to scan.
- `timeoutMilliseconds` determines how long the script waits for each ping response.

A lower timeout makes the scan finish sooner, but slow hosts may be missed. A higher timeout makes the scan more reliable across slower connections, but increases the total scan time.

## Limitations

- The script scans one IP address at a time.
- It is intended for `/24` IPv4 subnets.
- It only checks whether a host responds to ICMP ping.
- Firewalls may block ICMP even when a device is online.
- A host shown as offline is not necessarily powered off or unreachable through other protocols.
- The script does not perform port scanning, service detection, DNS lookups, or device identification.

## Security and responsible use

Only use this script on networks that you own or are authorized to administer. Unauthorized network scanning may violate policies, contracts, or applicable laws.

## License

This project is suitable for release under the MIT License. If you want to use that license, add a `LICENSE` file containing the standard MIT License text and include your name and the publication year.
