
$projectsDir = "C:\Users\User\Documents\projetos antigravity"
$replacements = @{
    "\bIA\b" = "Desenvolvedor"
    "\bAI\b" = "Desenvolvedor"
    "Colaborador" = "Colaborador"
    "Antigravity" = "Antigravity"
    "Core" = "Core"
    "Ponto de Controle de Desenvolvimento" = "Ponto de Controle de Desenvolvimento"
    "" = ""
    "Módulo" = "Módulo"
}

$filesToProcess = Get-ChildItem $projectsDir -Recurse -Include *.md, *.js, *.py, *.html, *.css, *.txt, *.ps1, *.json | 
                  Where-Object { $_.FullName -notmatch "\\node_modules\\" -and $_.FullName -notmatch "\\\.git\\" }

foreach ($file in $filesToProcess) {
    $content = Get-Content $file.FullName -Raw
    $modified = $false
    
    foreach ($pattern in $replacements.Keys) {
        if ($content -match $pattern) {
            $content = $content -replace $pattern, $replacements[$pattern]
            $modified = $true
        }
    }
    
    if ($modified) {
        $content | Set-Content $file.FullName -Force
        Write-Host "Sanitized: $($file.FullName)"
    }
}


