$projectsDir = "$env:USERPROFILE\Documents\Projetos Antigravity"
$repos = Get-ChildItem $projectsDir -Directory
foreach ($repo in $repos) {
    if (Test-Path (Join-Path $repo.FullName ".git")) {
        Push-Location $repo.FullName
        try {
            $status = git status --porcelain
            if ($status) {
                Write-Host "Salvando progresso em: $($repo.Name)" -ForegroundColor Green
                git add .
                $date = Get-Date -Format "yyyy-MM-dd HH:mm"
                git commit -m "[Log: Sincronização global e autonomia total - $date]"
                $branch = git branch --show-current
                if (-not (git push origin $branch)) {
                    Write-Host "Tentando rebase em $branch..." -ForegroundColor Yellow
                    git pull --rebase origin $branch
                    git push origin $branch
                }
            } else {
                Write-Host "Sem alterações em: $($repo.Name)" -ForegroundColor Gray
            }
        } catch {
            Write-Host "Erro ao processar $($repo.Name): $_" -ForegroundColor Red
        } finally {
            Pop-Location
        }
    }
}
