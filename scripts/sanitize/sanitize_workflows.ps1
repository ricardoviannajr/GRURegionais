# sanitize_workflows.ps1
# Script para higienizar termos e referências de IA/Antigravity nos workflows instalados em todos os destinos.

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

$replacements = @{
    "\bIA\b" = "Desenvolvedor"
    "\bAI\b" = "Desenvolvedor"
    "Assistente" = "Colaborador"
    "Antigravity" = "Antigravity"
    "Gemini" = "Core"
    "Checkpoint de Consciência" = "Ponto de Controle de Desenvolvimento"
    "🤖" = ""
    "Bot" = "Módulo"
}

foreach ($workflowsDir in $targetDirs) {
    if (Test-Path $workflowsDir) {
        Write-Host "Higienizando workflows em: $workflowsDir" -ForegroundColor Green
        Get-ChildItem $workflowsDir -File -Filter "*.md" | ForEach-Object {
            $content = Get-Content $_.FullName -Raw
            $modified = $false
            foreach ($pattern in $replacements.Keys) {
                if ($content -match $pattern) {
                    $content = [regex]::Replace($content, $pattern, $replacements[$pattern], [System.Text.RegularExpressions.RegexOptions]::IgnoreCase)
                    $modified = $true
                }
            }
            if ($modified) {
                $content | Set-Content $_.FullName -Force
                Write-Host " - Sanitized: $($_.Name)"
            }
        }
    }
}
