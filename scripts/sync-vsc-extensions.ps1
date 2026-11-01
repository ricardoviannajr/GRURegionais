<#
.SYNOPSIS
    Sincroniza extensões do VS Code (base do Architecture) com base no arquivo vscode-extensions.list.

.DESCRIPTION
    - Import: Lê a lista e instala extensões ausentes.
    - Export: Atualiza a lista com as extensões atualmente instaladas.

.EXAMPLE
    .\sync-vsc-extensions.ps1 -Mode Import
#>

param (
    [Parameter(Mandatory = $false)]
    [ValidateSet("Import", "Export")]
    [string]$Mode = "Import"
)

$ideCmd = "code"

# Mapeamento de possíveis comandos da IDE e caminhos alternativos de instalação para robustez.
# Isso garante o funcionamento mesmo quando os executáveis não estão adicionados ao PATH do sistema.
$knownPaths = @(
    @{ Cmd = "code"; Path = "code" },
    @{ Cmd = "antigravity-ide"; Path = "antigravity-ide" },
    @{ Cmd = "code"; Path = "$env:USERPROFILE\AppData\Local\Programs\Microsoft VS Code\bin\code.cmd" },
    @{ Cmd = "code"; Path = "$env:ProgramFiles\Microsoft VS Code\bin\code.cmd" },
    @{ Cmd = "antigravity-ide"; Path = "$env:USERPROFILE\AppData\Local\Programs\Antigravity IDE\bin\antigravity-ide.cmd" }
)

$found = $false
foreach ($target in $knownPaths) {
    if ($target.Path -eq $target.Cmd) {
        # Tenta localizar o comando globalmente no PATH
        if (Get-Command $target.Cmd -ErrorAction SilentlyContinue) {
            $ideCmd = $target.Cmd
            $found = $true
            break
        }
    } else {
        # Caso não esteja no PATH, verifica a existência física nos caminhos de instalação padrão
        if (Test-Path $target.Path) {
            $ideCmd = $target.Path
            $found = $true
            break
        }
    }
}

if (-not $found) {
    Write-Error "Comando executável da IDE não encontrado no PATH nem nos locais padrões de instalação. Por favor, adicione a IDE ao PATH ou verifique a instalação."
    exit 1
}

$extensionFile = Join-Path $PSScriptRoot "..\vscode-extensions.list"

if ($Mode -eq "Export") {
    Write-Host "Exportando extensões ($ideCmd) para $extensionFile..." -ForegroundColor Cyan
    & $ideCmd --list-extensions | Out-File -FilePath $extensionFile -Encoding utf8
    Write-Host "Exportação concluída com sucesso!" -ForegroundColor Green
}
else {
    if (-not (Test-Path $extensionFile)) {
        Write-Error "Arquivo de extensões não encontrado: $extensionFile"
        return
    }

    Write-Host "Iniciando sincronização (Import) - $ideCmd..." -ForegroundColor Cyan
    $installed = & $ideCmd --list-extensions
    $toBeInstalled = Get-Content $extensionFile | Where-Object { $_ -and $_ -notin $installed }

    if ($null -eq $toBeInstalled -or @($toBeInstalled).Count -eq 0) {
        Write-Host "Todas as extensões da lista já estão instaladas." -ForegroundColor Green
        return
    }

    Write-Host "Encontradas $(@($toBeInstalled).Count) extensões para instalar." -ForegroundColor Yellow
    foreach ($ext in $toBeInstalled) {
        Write-Host "Instalando: $ext..." -ForegroundColor Gray
        & $ideCmd --install-extension $ext --force
        # Pausa curta para mitigar limites de taxa (HTTP 429) no servidor de extensões
        Start-Sleep -Seconds 3
    }

    Write-Host "Sincronização de extensões concluída!" -ForegroundColor Green
}

