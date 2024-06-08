# Define the path to the log file
$logFilePath = "C:\GPUlog.txt"
$logDir = [System.IO.Path]::GetDirectoryName($logFilePath)

# Function to write output to the log file and console
function Write-Log {
    param (
        [string]$message
    )
    if (!(Test-Path -Path $logDir)) {
        New-Item -Path $logDir -ItemType Directory -Force
    }
    Add-Content -Path $logFilePath -Value $message
    Write-Output $message
}

# Clear the log file at the beginning of the script
if (Test-Path -Path $logFilePath) {
    Clear-Content -Path $logFilePath -ErrorAction SilentlyContinue
}

# Original GPU model to be replaced
$oldGpuModel = "NVIDIA GeForce GTX 2060 SUPER"

# New GPU model name for simulation
$newGpuModel = "NVIDIA GeForce GTX 1660 SUPER"

# Specific registry paths and value names to modify
$registryPaths = @{
    "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\WinSAT" = @("PrimaryAdapterString");
    "HKEY_LOCAL_MACHINE\SYSTEM\ControlSet001\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" = @("DriverDesc", "HardwareInformation.AdapterString", "HardwareInformation.ChipType");
    "HKEY_LOCAL_MACHINE\SYSTEM\ControlSet001\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0001" = @("DriverDesc", "HardwareInformation.AdapterString", "HardwareInformation.ChipType");
    "HKEY_LOCAL_MACHINE\SYSTEM\ControlSet001\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0002" = @("DriverDesc", "HardwareInformation.AdapterString", "HardwareInformation.ChipType");
    "HKEY_LOCAL_MACHINE\SYSTEM\ControlSet001\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0003" = @("DriverDesc", "HardwareInformation.AdapterString", "HardwareInformation.ChipType");
    "HKEY_LOCAL_MACHINE\SYSTEM\ControlSet001\Control\Video\{850000A1-ADE9-11EE-927A-806E6F6E6963}\Video" = @("DeviceDesc");
    "HKEY_LOCAL_MACHINE\SYSTEM\ControlSet001\Services\nvlddmkm\Video" = @("DeviceDesc");
    "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" = @("DriverDesc", "HardwareInformation.AdapterString", "HardwareInformation.ChipType");
    "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Video\{850000A1-ADE9-11EE-927A-806E6F6E6963}\0001" = @("DriverDesc", "HardwareInformation.AdapterString", "HardwareInformation.ChipType");
    "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Video\{850000A1-ADE9-11EE-927A-806E6F6E6963}\0002" = @("DriverDesc", "HardwareInformation.AdapterString", "HardwareInformation.ChipType");
    "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Video\{850000A1-ADE9-11EE-927A-806E6F6E6963}\0003" = @("DriverDesc", "HardwareInformation.AdapterString", "HardwareInformation.ChipType");
    "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Video\{850000A1-ADE9-11EE-927A-806E6F6E6963}\Video" = @("DeviceDesc");
    "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\nvlddmkm\Video" = @("DeviceDesc");
}

# Function to search and replace the GPU name in registry values
function SearchAndReplaceRegistryForGPU {
    param (
        [string]$oldGpuName,
        [string]$newGpuName,
        [hashtable]$paths
    )

    $notFoundPaths = @()
    $alreadyModifiedPaths = @()

    foreach ($path in $paths.Keys) {
        foreach ($valueName in $paths[$path]) {
            Write-Log "Checking Path: $path - Value: $valueName"
            try {
                if (Test-Path -Path "Registry::$path") {
                    $value = Get-ItemProperty -Path "Registry::$path" -Name $valueName -ErrorAction SilentlyContinue
                    if ($null -ne $value) {
                        if ($value.$valueName -is [string]) {
                            if ($value.$valueName -like "*$newGpuName*") {
                                Write-Log "Already modified: Path: $path - Property: $valueName - Data: $($value.$valueName)"
                                $alreadyModifiedPaths += "$path - Property: $valueName - Data: $($value.$valueName)"
                            } elseif ($value.$valueName -like "*$oldGpuName*") {
                                $newValue = $value.$valueName -replace [regex]::Escape($oldGpuName), $newGpuName
                                Set-ItemProperty -Path "Registry::$path" -Name $valueName -Value $newValue -ErrorAction SilentlyContinue
                                Write-Log "Replaced value: Path: $path - Property: $valueName - Data: $newValue"
                            } else {
                                Write-Log "No match found: Path: $path - Property: $valueName - Data: $($value.$valueName)"
                            }
                        } else {
                            Write-Log "Value not found: Path: $path - Property: $valueName"
                            $notFoundPaths += "$path - Property: $valueName"
                        }
                    } else {
                        Write-Log "Value not found: Path: $path - Property: $valueName"
                        $notFoundPaths += "$path - Property: $valueName"
                    }
                } else {
                    Write-Log "Path not found: $path"
                    $notFoundPaths += "$path"
                }
            } catch {
                Write-Log "Error accessing path: $path - Property: $valueName"
            }
        }
    }

    Write-Log "`n### Paths not found ###"
    $notFoundPaths | ForEach-Object { Write-Log $_ }

    Write-Log "`n### Paths already modified ###"
    $alreadyModifiedPaths | ForEach-Object { Write-Log $_ }
}

# Search and replace the registry entries for the GPU name
Write-Log "Commencing registry search and replace operation..."
SearchAndReplaceRegistryForGPU -oldGpuName $oldGpuModel -newGpuName $newGpuModel -paths $registryPaths


$asciiArt = @"
------------------------------------------------
"GPU TA REVERTIDA, AGORA PODE ABRIR O SCRIPT DO PROCESSADOR"

                                      ___
   
                                    ./  _)                                               O
                             _.---._|____\__________________,-------.------------==-.____|]
    ____                    /  ##-|=======--------===-----==-|-----=|=-------------._______)
   (####L-.________________/  /___|__________________________ ______|               )-------.
    \###|  ________________) `--- |---------------------===== ,_____|         _____/========"
     |##F-'              | /\ --- |         __mmmmm__________(======|...---''/
     |###/               (_\ \    |_______ ' "-L  nn [mf]    |      |
     |##|                     """"        \__________________|      |
    /##/                                   )       //((  // ||   _,-/
   /##/                                   /       /\\_V_//   |,-"  (
   \#/                                  ./       /  `---"     \     \
    v                                  /_       /              \     `.
                                      /_ `-.___/                \      `.
                                        `-.___/                  ".      `.        [DREW CODIGOS]
                                                                   ".      `.
                                                                     ".    _,"
                                                                       ".-"
   
"GPU TA REVERTIDA, AGORA PODE ABRIR O SCRIPT DO PROCESSADOR"
------------------------------------------------


"@
Write-Output $asciiArt

