# install-workflows.ps1
# Script para garantir que os workflows globais estejam instalados na máquina atual em todos os destinos da IDE.

$targetDirs = @(
    "$env:USERPROFILE\.Core\Antigravity\global_workflows",
    "$env:USERPROFILE\.gemini\antigravity\global_workflows",
    "$env:USERPROFILE\.gemini\antigravity-ide\global_workflows",
    "$env:USERPROFILE\.gemini\config\global_workflows",
    "$env:USERPROFILE\.Core\Antigravity\workflows",
    "$env:USERPROFILE\.gemini\antigravity\workflows",
    "$env:USERPROFILE\.gemini\antigravity-ide\workflows",
    "$env:USERPROFILE\.gemini\config\workflows"
)
$sourceDir = "$PSScriptRoot\..\workflows"

if (-not (Test-Path $sourceDir)) {
    Write-Error "Diretório de origem dos workflows não encontrado: $sourceDir"
    exit 1
}

Write-Host "Instalando/Atualizando workflows globais..." -ForegroundColor Green

foreach ($globalDir in $targetDirs) {
    if (-not (Test-Path $globalDir)) {
        Write-Host "Criando diretório de workflows globais: $globalDir" -ForegroundColor Cyan
        New-Item -Path $globalDir -ItemType Directory -Force | Out-Null
    }

    Get-ChildItem "$sourceDir\*.md" | ForEach-Object {
        Copy-Item $_.FullName -Destination $globalDir -Force
        Write-Host " - $($_.Name) instalado em $globalDir."
    }
}

Write-Host "Workflows instalados com sucesso em todos os destinos." -ForegroundColor Green

