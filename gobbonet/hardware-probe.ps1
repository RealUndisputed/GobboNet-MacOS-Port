# Hardware Probe Script for Gobbonet

# This script detects hardware specifications such as GPU and RAM for model recommendations.

# Function to get GPU information
function Get-GPUInfo {
    $gpuInfo = Get-WmiObject -Class Win32_VideoController | Select-Object Name, AdapterRAM
    return $gpuInfo
}

# Function to get RAM information
function Get-RAMInfo {
    $ramInfo = Get-WmiObject -Class Win32_PhysicalMemory | Measure-Object -Property Capacity -Sum
    return $ramInfo.Sum
}

# Function to get Disk Space information
function Get-DiskSpaceInfo {
    $diskInfo = Get-PSDrive -PSProvider FileSystem | Select-Object Name, @{Name="Used(GB)";Expression={[math]::round($_.Used/1GB, 2)}}, @{Name="Free(GB)";Expression={[math]::round($_.Free/1GB, 2)}}
    return $diskInfo
}

# Main function to gather all hardware information
function Get-HardwareInfo {
    $hardwareInfo = @{
        GPU = Get-GPUInfo
        RAM = Get-RAMInfo
        DiskSpace = Get-DiskSpaceInfo
    }
    return $hardwareInfo
}

# Output the hardware information
$hardwareInfo = Get-HardwareInfo
$hardwareInfo | ConvertTo-Json | Out-File -FilePath "hardware-info.json" -Encoding utf8

# Notify user of completion
Write-Host "Hardware information has been collected and saved to hardware-info.json"