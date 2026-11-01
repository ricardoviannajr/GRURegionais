<#
.SYNOPSIS
    Script de migração de configurações e extensões entre as pastas do perfil de usuário da IDE.

.DESCRIPTION
    Este script realiza a cópia física local dos dados da versão anterior do perfil da IDE
    para o diretório da versão atual, contornando falhas de rede ou limites de taxa (HTTP 429).
    Ele migra o arquivo de configurações de usuário (settings.json) e todas as extensões instaladas.
#>

# 1. Definição dos caminhos de origem (perfil anterior) e destino (perfil atual)
# Usamos as variáveis de ambiente $env:APPDATA e $env:USERPROFILE para garantir compatibilidade
# e dinamicidade com qualquer usuário no sistema Windows.

$oldAppDataUser = Join-Path $env:APPDATA "Antigravity\User"
$newAppDataUser = Join-Path $env:APPDATA "Antigravity IDE\User"

$oldExtensionsDir = Join-Path $env:USERPROFILE ".antigravity\extensions"
$newExtensionsDir = Join-Path $env:USERPROFILE ".antigravity-ide\extensions"

Write-Host "==========================================================" -ForegroundColor Cyan
Write-Host "Iniciando a migração física de extensões e configurações..." -ForegroundColor Cyan
Write-Host "==========================================================" -ForegroundColor Cyan

# 2. Migração do arquivo settings.json (Configurações Globais de Usuário)
# Verificamos se o diretório de origem existe e se há um settings.json válido nele.
if (Test-Path $oldAppDataUser) {
    $oldSettingsFile = Join-Path $oldAppDataUser "settings.json"
    
    if (Test-Path $oldSettingsFile) {
        # Se a pasta User no destino não existir, nós a criamos primeiro para evitar erros de cópia.
        if (-not (Test-Path $newAppDataUser)) {
            Write-Host "Criando pasta de destino para configurações: $newAppDataUser" -ForegroundColor Yellow
            New-Item -ItemType Directory -Path $newAppDataUser -Force | Out-Null
        }
        
        $newSettingsFile = Join-Path $newAppDataUser "settings.json"
        
        Write-Host "Copiando settings.json para a nova pasta da IDE..." -ForegroundColor Yellow
        Copy-Item -Path $oldSettingsFile -Destination $newSettingsFile -Force
        Write-Host "Configurações (settings.json) importadas com sucesso!" -ForegroundColor Green
    } else {
        Write-Host "Aviso: Nenhum arquivo settings.json encontrado em $oldAppDataUser." -ForegroundColor Yellow
    }
} else {
    Write-Host "Aviso: Pasta de configurações anterior não encontrada em $oldAppDataUser." -ForegroundColor Yellow
}

# 3. Migração de Extensões (Plugins)
# Verificamos se a pasta de extensões da versão anterior existe e possui subdiretórios ou arquivos.
if (Test-Path $oldExtensionsDir) {
    # Criamos a pasta de destino se ela não existir
    if (-not (Test-Path $newExtensionsDir)) {
        Write-Host "Criando pasta de destino para extensões: $newExtensionsDir" -ForegroundColor Yellow
        New-Item -ItemType Directory -Path $newExtensionsDir -Force | Out-Null
    }

    Write-Host "Iniciando a cópia física das extensões..." -ForegroundColor Yellow

    # Listamos todas as subpastas e arquivos da pasta de extensões antiga
    $items = Get-ChildItem -Path $oldExtensionsDir

    foreach ($item in $items) {
        $destPath = Join-Path $newExtensionsDir $item.Name
        
        Write-Host "Copiando item: $($item.Name)..." -ForegroundColor Gray
        
        # Copiamos recursivamente utilizando -Recurse e -Force
        # O -Force garante que arquivos com mesma versão ou chaves obsoletas sejam atualizados/sobrescritos.
        Copy-Item -Path $item.FullName -Destination $destPath -Recurse -Force
    }

    Write-Host "Todas as extensões físicas foram importadas com sucesso!" -ForegroundColor Green
} else {
    Write-Warning "Diretório de extensões anterior não encontrado em $oldExtensionsDir."
}

Write-Host "==========================================================" -ForegroundColor Green
Write-Host "Processo de importação finalizado!" -ForegroundColor Green
Write-Host "==========================================================" -ForegroundColor Green
