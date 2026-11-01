
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

$excludeFolders = @("node_modules", "venv", ".venv", ".git", "dist", "build", ".next", "target")

$filesToProcess = Get-ChildItem $projectsDir -Recurse -File -Include *.md, *.js, *.py, *.html, *.css, *.txt, *.ps1, *.json, *.tsx, *.jsx | 
                  Where-Object { 
                      $path = $_.FullName
                      $shouldInclude = $true
                      foreach ($folder in $excludeFolders) {
                          if ($path -match "\\$folder\\") {
                              $shouldInclude = $false
                              break
                          }
                      }
                      return $shouldInclude
                  }

foreach ($file in $filesToProcess) {
    try {
        $content = Get-Content $file.FullName -Raw -ErrorAction Stop
        if ($null -eq $content) { continue }
        
        $modified = $false
        foreach ($pattern in $replacements.Keys) {
            if ($content -match $pattern) {
                $content = [regex]::Replace($content, $pattern, $replacements[$pattern], [System.Text.RegularExpressions.RegexOptions]::IgnoreCase)
                $modified = $true
            }
        }
        
        if ($modified) {
            $content | Set-Content $file.FullName -Force
            Write-Host "Sanitized: $($file.FullName)"
        }
    } catch {
        Write-Warning "Failed to process: $($file.FullName)"
    }
}


