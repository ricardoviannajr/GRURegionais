$projectsDir = "$env:USERPROFILE\Documents\Projetos Antigravity"
$repos = Get-ChildItem $projectsDir -Directory

foreach ($repo in $repos) {
    Set-Location $repo.FullName
    if (Test-Path .git) {
        $status = git status --porcelain
        if ($status) {
            Write-Host "Salvando progresso em: $($repo.Name)" -ForegroundColor Green

            # 1. Atualização de Memória (Obrigatório antes do Push)
            # O Colaborador deve garantir que o arquivo MEMORIA.md reflita o estado atual
            
            # 2. Operação Git Pré-Autorizada
            git add .
            $date = Get-Date -Format "yyyy-MM-dd HH:mm"
            git commit -m "[Log: Sincronização global e checkpoint de memória - $date]"
            
            # 3. Resiliência CLI (Regra 6)
            if (-not (git push origin master)) {
                Write-Host "Conflito detectado, tentando rebase..." -ForegroundColor Yellow
                git pull --rebase origin master
                git push origin master
            }
        }
    }
}
