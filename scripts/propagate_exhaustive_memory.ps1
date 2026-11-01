$sourceDir = "c:\Users\User\Documents\projetos antigravity\AIConfig"
$globalDir = "$env:USERPROFILE\.Core"
$projectsDir = "c:\Users\User\Documents\projetos antigravity"

# 1. Atualizar Global
Write-Host "Atualizando diretório global..."
Copy-Item "$sourceDir\Core.md" "$globalDir\Core.md" -Force
Copy-Item "$sourceDir\AGENTS.md" "$globalDir\AGENTS.md" -Force
Copy-Item "$sourceDir\MEMORIA_TEMPLATE.md" "$globalDir\MEMORIA_TEMPLATE.md" -Force

# 2. Iterar sobre projetos
$projects = Get-ChildItem $projectsDir -Directory | Where-Object { $_.Name -ne "AIConfig" }

foreach ($project in $projects) {
    Write-Host "Processando $($project.Name)..."
    
    $destCore = Join-Path $project.FullName "Core.md"
    $destAgents = Join-Path $project.FullName "AGENTS.md"
    $destTemplate = Join-Path $project.FullName "MEMORIA_TEMPLATE.md"

    # Merge Inteligente (Preservar ## [LOCAL] se existir)
    function Merge-File($source, $dest) {
        if (Test-Path $dest) {
            $currentContent = Get-Content $dest -Raw
            if ($currentContent -match '## \[LOCAL\]') {
                $localSection = $currentContent -split '## \[LOCAL\]'
                $newContent = (Get-Content $source -Raw) + "`n`n## [LOCAL]" + $localSection[1]
                $newContent | Set-Content $dest -Force
            } else {
                Copy-Item $source $dest -Force
            }
        } else {
            Copy-Item $source $dest -Force
        }
    }

    Merge-File "$sourceDir\Core.md" $destCore
    Merge-File "$sourceDir\AGENTS.md" $destAgents
    Copy-Item "$sourceDir\MEMORIA_TEMPLATE.md" $destTemplate -Force

    # Git Sync
    if (Test-Path (Join-Path $project.FullName ".git")) {
        Write-Host "  Realizando Git Push para $($project.Name)..."
        try {
            git -C $project.FullName add Core.md AGENTS.md MEMORIA_TEMPLATE.md
            git -C $project.FullName commit -m "[Sync: Regras de Memória Técnica Exaustiva atualizadas]"
            git -C $project.FullName push origin master --force # Usando force para garantir sincronia em ambientes controlados
        } catch {
            Write-Warning "  Falha ao sincronizar git em $($project.Name)"
        }
    }
}

Write-Host "Propagação concluída!"
