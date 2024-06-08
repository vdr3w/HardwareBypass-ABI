# Define the path to the log file
$logFilePath = "C:\CPUNameChangeLog-Revert.txt"
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

# Solicitar ao usuário para coletar o caminho da instância do dispositivo
Write-Log "Por favor, siga estes passos para coletar o Caminho da Instancia do Dispositivo do seu CPU:"
Write-Log "1. Abra o Gerenciador de Dispositivos."
Write-Log "2. Clique em 'Processadores'."
Write-Log "3. De um duplo clique em qualquer um dos processadores listados."
Write-Log "4. Va para a aba 'Detalhes'."
Write-Log "5. No menu suspenso 'Propriedade', selecione 'Caminho da Instancia do Dispositivo'."
Write-Log "6. Copie o valor exibido abaixo."


# Prompt the user to paste the Device Instance Path
$deviceInstancePath = Read-Host -Prompt "Cole o 'Caminho da Instancia do Dispositivo' aqui"

# Display the collected Device Instance Path
Write-Log "Device Instance Path collected: $deviceInstancePath"

# Define the new CPU name
$newCpuName = "AMD Ryzen 5 1600X 6-Core Processor           "

# Função para atualizar o nome da CPU no registro
function UpdateCpuName {
    param (
        [string]$instancePath,
        [string]$cpuName
    )

    # Remover a última parte do caminho do dispositivo que geralmente é uma subchave como '0'
    $basePath = $instancePath.Substring(0, $instancePath.LastIndexOf("\"))
    
    $subKeys = '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'a', 'b'

    foreach ($key in $subKeys) {
        $regPath = "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Enum\$basePath\$key"

        Write-Log "Atualizando nome da CPU no caminho do registro: $regPath"

        try {
            # Verificar se o caminho do registro existe
            if (Test-Path -Path "Registry::$regPath") {
                # Atualizar o valor FriendlyName
                Set-ItemProperty -Path "Registry::$regPath" -Name "FriendlyName" -Value $cpuName -ErrorAction SilentlyContinue
                Write-Log "Nome da CPU atualizado com sucesso para: $cpuName na subchave $key"
            } else {
                Write-Log "Caminho do registro não encontrado: $regPath"
            }
        } catch {
            Write-Log "Erro ao acessar ou atualizar o caminho do registro: $regPath"
        }
    }
}



# Call the function to update the CPU name
UpdateCpuName -instancePath $deviceInstancePath -cpuName $newCpuName

$asciiArt = @"
------------------------------------------------
"ACABOU, CPU REVERTIDA."

   
                                         ____    _     __     _    ____
                                        |####`--|#|---|##|---|#|--'##|#|
      _                                 |____,--|#|---|##|---|#|--.__|_|
    _|#)_____________________________________,--'EEEEEEEEEEEEEE'_=-.
   ((_____((_________________________,--------[JW](___(____(____(_==)        _________
                                  .--|##,----o  o  o  o  o  o  o__|/`---,-,-'=========`=+==.
                                  |##|_Y__,__.-._,__,  __,-.___/ J \ .----.#############|##|
                                  |##|              `-.|#|##|#|`===l##\   ___\############|##| [DREW CODIGOS]
                                 =======-===l          |_|__|_|     \##`-"___,=======.###|##|
                                                                     \__,"          '======'
   
      
"ACABOU, CPU REVERETIDA."
------------------------------------------------


"@
Write-Output $asciiArt
