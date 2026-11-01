# .SYNOPSIS
#   Purga total do Cursor IDE em todos os projetos do ecossistema Antigravity.
#
# .DESCRIPTION
#   Este script percorre a pasta de projetos, remove diretórios/arquivos do Cursor 
#   e sincroniza a nova governança Architecture Exclusive a partir do repositório AIConfig.

$ProjectsRoot = Join-Path $env:USERPROFILE "Documents\projetos antigravity"
if (-not (Test-Path $ProjectsRoot)) {
    $ProjectsRoot = Join-Path $env:USERPROFILE "Documents\Projetos Antigravity"
}
$AIConfigRoot = Join-Path $ProjectsRoot "AIConfig"

Write-Host "Iniciando Operação Architecture Exclusive (Purge Cursor)..." -ForegroundColor Cyan

# 1. Validar se o AIConfig (Mestre) está disponível
if (-not (Test-Path $AIConfigRoot)) {
    Write-Error "Repositório AIConfig não encontrado em $AIConfigRoot. Abortando."
    exit 1
}

# 2. Listar projetos (pastas que contêm .git ou AGENTS.md)
$Projects = Get-ChildItem -Path $ProjectsRoot -Directory | Where-Object { 
    (Test-Path (Join-Path $_.FullName ".git")) -or (Test-Path (Join-Path $_.FullName "AGENTS.md"))
}

Write-Host "Encontrados $($Projects.Count) projetos para processamento." -ForegroundColor Yellow

foreach ($Project in $Projects) {
    $ProjectPath = $Project.FullName
    if ($ProjectPath -eq $AIConfigRoot) { continue } # Pula o mestre, já limpo

    Write-Host "Processando: $($Project.Name)..." -ForegroundColor Gray

    # A) Remoção de Lixo do Cursor
    $TargetsToRemove = @(".cursor", "cursor", "USER_RULES_CURSOR.md", ".cursorignore")
    foreach ($Target in $TargetsToRemove) {
        $FullTarget = Join-Path $ProjectPath $Target
        if (Test-Path $FullTarget) {
            Write-Host "  [-] Removendo $Target..." -ForegroundColor Red
            Remove-Item -Path $FullTarget -Recurse -Force -ErrorAction SilentlyContinue
        }
    }

    # B) Sincronização de Governança Architecture (Root Consolidation)
    Write-Host "  [+] Sincronizando governança Architecture..." -ForegroundColor Green
    
    # Pasta de infraestrutura
    $ArchitectureDir = Join-Path $ProjectPath "Antigravity"
    if (-not (Test-Path $ArchitectureDir)) {
        New-Item -ItemType Directory -Path $ArchitectureDir -Force | Out-Null
    }

    # Copiar Infra (scripts, rules)
    Copy-Item -Path (Join-Path $AIConfigRoot "Antigravity\*") -Destination $ArchitectureDir -Recurse -Force

    # Copiar Core para a Raiz (Consolidado)
    $CoreFiles = @("AGENTS.md", "Core.md", "SKILLS.md", "walkthrough.md", ".antigravityignore")
    foreach ($File in $CoreFiles) {
        Copy-Item -Path (Join-Path $AIConfigRoot $File) -Destination (Join-Path $ProjectPath $File) -Force
    }

    # C) Git Sync Automático (Obrigatório pela governança)
    if (Test-Path (Join-Path $ProjectPath ".git")) {
        Write-Host "  [*] Realizando Git Sync..." -ForegroundColor Yellow
        try {
            git -C $ProjectPath add .
            git -C $ProjectPath commit -m "[Log: Architecture Exclusive Optimization - Purge Cursor]" --allow-empty
            git -C $ProjectPath push origin master
        } catch {
            Write-Host "  [!] Falha no sync para $($Project.Name). Verifique manualmente." -ForegroundColor DarkYellow
        }
    }
}

Write-Host "Operação concluída. O ecossistema está 100% otimizado para Architecture!" -ForegroundColor Green


