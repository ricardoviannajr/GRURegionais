
$projectsDir = "C:\Users\User\Documents\projetos antigravity"
$sourceCore = "C:\Users\User\Documents\projetos antigravity\AIConfig\Core.md"
$sourceAgents = "C:\Users\User\Documents\projetos antigravity\AIConfig\AGENTS.md"
$globalCore = "$env:USERPROFILE\.Core\Core.md"
$globalAgents = "$env:USERPROFILE\.Core\AGENTS.md"

# 1. Atualizar Global
if (!(Test-Path "$env:USERPROFILE\.Core")) { New-Item -ItemType Directory -Path "$env:USERPROFILE\.Core" }
Copy-Item $sourceCore $globalCore -Force
Copy-Item $sourceAgents $globalAgents -Force
Write-Host "Global rules updated."

# 2. Propagar para todos os projetos
$projects = Get-ChildItem $projectsDir -Directory | Where-Object { $_.Name -ne "AIConfig" }

foreach ($project in $projects) {
    $destCore = Join-Path $project.FullName "Core.md"
    $destAgents = Join-Path $project.FullName "AGENTS.md"
    
    # Preservar seções [LOCAL] (conforme Regra 10)
    function Merge-Governance($source, $dest) {
        if (Test-Path $dest) {
            $sourceContent = Get-Content $source -Raw
            $destContent = Get-Content $dest -Raw
            if ($destContent -match "## \[LOCAL\]") {
                $localSection = $destContent -split "## \[LOCAL\]", 2
                $newContent = $sourceContent + "`n`n## [LOCAL]" + $localSection[1]
                $newContent | Set-Content $dest -Force
            } else {
                Copy-Item $source $dest -Force
            }
        } else {
            Copy-Item $source $dest -Force
        }
    }

    Merge-Governance $sourceCore $destCore
    Merge-Governance $sourceAgents $destAgents
    
    Write-Host "Propagated to $($project.Name)"
}


