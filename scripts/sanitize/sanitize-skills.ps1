<#
.SYNOPSIS
    Remove skills duplicadas da pasta local (exclusivas) se já existirem no catálogo geral.

.DESCRIPTION
    Este script lê o skills_index.json remoto (o catálogo "geral") e compara com as pastas
    de skills locais dentro de .Antigravity/skills (as skills "exclusivas"). 
    Se a skill local já foi promovida para o repositório central, a cópia local é removida.
#>

$globalIndexUrl = "https://raw.githubusercontent.com/ricardoviannajr/antigravity-awesome-skills/main/skills_index.json"

Write-Host "Baixando índice geral de skills..." -ForegroundColor Gray
try {
    $skillsIndex = Invoke-RestMethod -Uri $globalIndexUrl
    $globalSkills = $skillsIndex | Select-Object -ExpandProperty id
} catch {
    Write-Host "Falha ao acessar o índice global. Pulando sanitização." -ForegroundColor Yellow
    exit 0
}

$rootPath = Join-Path $env:USERPROFILE "Documents\projetos antigravity"
if (-not (Test-Path $rootPath)) {
    $rootPath = Join-Path $env:USERPROFILE "Documents\Projetos Antigravity"
}

if (-not (Test-Path $rootPath)) {
    Write-Host "Workspace não encontrado em $rootPath" -ForegroundColor Red
    exit 1
}

$directories = Get-ChildItem -Path $rootPath -Directory

Write-Host "--- Iniciando Sanitização de Skills Exclusivas ---" -ForegroundColor Cyan

foreach ($dir in $directories) {
    $projectPath = $dir.FullName
    $exclusiveSkillsPath = Join-Path $projectPath ".Antigravity\skills"
    
    if (Test-Path $exclusiveSkillsPath) {
        $localSkills = Get-ChildItem -Path $exclusiveSkillsPath -Directory
        foreach ($localSkill in $localSkills) {
            $skillId = $localSkill.Name
            if ($globalSkills -contains $skillId) {
                Write-Host "Skill [$skillId] do projeto [$($dir.Name)] já existe no catálogo geral." -ForegroundColor Yellow
                Write-Host "Removendo versão exclusiva local..." -ForegroundColor Red
                Remove-Item -Path $localSkill.FullName -Recurse -Force
            }
        }
    }
}

Write-Host "--- Sanitização Concluída ---" -ForegroundColor Green
