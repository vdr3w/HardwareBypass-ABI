## Arquivo GPU1.ps1
Dentro de `$oldGpuModel = "ADICIONAR O NOME DA SUA GPU AQUI"`, conforme retornado com o comando `wmic path win32_videocontroller get caption` no PowerShell.

## Arquivo GPU1-revert.ps1
Dentro de `$newGpuModel = "ADICIONAR O NOME DA SUA GPU AQUI"`, conforme retornado com o comando `wmic path win32_videocontroller get caption` no PowerShell.

## Arquivo CPU1.ps1
Nenhuma mudança precisa ser feita.

## Arquivo CPU1-revert.ps1
![Instruções de Hardware Bypass](https://github.com/vdr3w/HardwareBypass-ABI/assets/84882983/9243dfec-4efe-443b-85ed-bfa9b25b25bc)
</br>
Dentro de `$newCpuName = "AMD Ryzen 5 1600X 6-Core Processor           "` (⚠️ **NÃO TIRE OS ESPAÇOS DO ARQUIVO ORIGINAL, MODIFIQUE APENAS O NOME** ⚠️ antes dos espaços em branco), adicione o modelo exato do seu processador, que você pode encontrar no gerenciador de dispositivos o nome exato.

### Instruções de Execução
Após modificar os arquivos conforme necessário:
1. Execute primeiro o `GPU1.ps1`, seguido pelo `CPU1.ps1`.
2. Clique na bandeira do Windows na barra de tarefas, clique na sua foto de usuário e selecione **Sair**.
3. Após sair, entre novamente. Isso aplicará as mudanças sem reiniciar o sistema.

**Aviso:** Se reiniciar o PC, as alterações nos registros da GPU voltarão ao normal, mas as da CPU não.

### Instruções para Reversão
Se precisar reverter as mudanças, tanto de GPU como de CPU, por qualquer motivo:
1. Execute primeiro `GPU1-revert.ps1` e depois `CPU1-revert.ps1`.
2. Reinicie o PC. (Reiniciar é necessário apenas para reverter as mudanças).


