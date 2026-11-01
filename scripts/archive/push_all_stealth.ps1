
$projectsDir = "C:\Users\User\Documents\projetos antigravity"
$projects = Get-ChildItem $projectsDir -Directory

foreach ($project in $projects) {
    if (Test-Path (Join-Path $project.FullName ".git")) {
        Write-Host "Committing changes in $($project.Name)..."
        git -C $project.FullName add .
        git -C $project.FullName commit -m "[Log: Implementação da Regra 11 e saneamento global de marca]"
        git -C $project.FullName push origin master
    }
}
