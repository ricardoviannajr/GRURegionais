$projectsDir = "$env:USERPROFILE\Documents\Projetos Antigravity"
$repos = Get-ChildItem $projectsDir -Directory

foreach ($repo in $repos) {
    Write-Host "Verificando: $($repo.Name)..." -ForegroundColor Gray
    Set-Location $repo.FullName
    if (Test-Path .git) {
        $status = git status --porcelain
        if ($status) {
            Write-Host "`n>>> Salvando progresso em: $($repo.Name)" -ForegroundColor Green

            # 1. Check for MEMORIA.md
            if (-not (Test-Path "MEMORIA.md")) {
                Write-Host "Criando MEMORIA.md inicial..." -ForegroundColor Gray
                "# MEMORIA - $($repo.Name)`n`nSTATUS: ATIVO`n`n## Checkpoints de Consciência`n`n### $(Get-Date -Format 'yyyy-MM-dd')`n- Checkpoint automático via /save-all." | Out-File "MEMORIA.md" -Encoding UTF8
            } else {
                # Add a line to MEMORIA.md if it doesn't have today's checkpoint (simplified)
                $date = Get-Date -Format "yyyy-MM-dd"
                $content = Get-Content "MEMORIA.md" -Raw
                if ($content -notmatch $date) {
                    Write-Host "Atualizando MEMORIA.md com checkpoint de hoje..." -ForegroundColor Gray
                    "`n### $date`n- Checkpoint automático via /save-all." | Out-File "MEMORIA.md" -Append -Encoding UTF8
                }
            }
            
            # 2. Operação Git
            git add .
            $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm"
            git commit -m "[Log: Sincronização global e checkpoint de memória - $timestamp]"
            
            # 3. Identificar branch principal (main ou master)
            $branch = "main"
            if (-not (git show-ref --verify --quiet refs/heads/main)) {
                $branch = "master"
            }

            Write-Host "Fazendo push para $branch..." -ForegroundColor Cyan
            if (-not (git push origin $branch)) {
                Write-Host "Conflito detectado, tentando rebase..." -ForegroundColor Yellow
                git pull --rebase origin $branch
                git push origin $branch
            }
        } else {
            # Write-Host "Sem mudanças em $($repo.Name)" -ForegroundColor Gray
        }
    }
}
