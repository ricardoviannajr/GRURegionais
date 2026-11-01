# Script de Propagação de Governança Antigravity/Architecture (v3)
# Output redirecionado para log para economia de tokens.

param(
    [switch]$Verbose  # Se presente, imprime tudo no console (modo legado)
)

$SourceDir = Get-Location
$CoreSource = Join-Path $SourceDir "Core.md"
$AgentsSource = Join-Path $SourceDir "AGENTS.md"
$IgnoreSource = Join-Path $SourceDir ".antigravityignore"
$LogDir = Join-Path $SourceDir "session_log"
if (!(Test-Path $LogDir)) { New-Item -ItemType Directory -Path $LogDir -Force | Out-Null }
$LogFile = Join-Path $LogDir "propagation-$(Get-Date -Format 'yyyy-MM-dd-HHmmss').log"

function Log($msg) {
    Add-Content -Path $LogFile -Value $msg
    if ($Verbose) { Write-Host $msg }
}

$SuccessCount = 0
$SkipCount = 0
$ErrorCount = 0

$ProjectsRoot = Join-Path $env:USERPROFILE "Documents\projetos antigravity"
if (-not (Test-Path $ProjectsRoot)) {
    $ProjectsRoot = Join-Path $env:USERPROFILE "Documents\Projetos Antigravity"
}

# 1. Atualizar Global
$GlobalPath = "$env:USERPROFILE\.gemini"
if (!(Test-Path $GlobalPath)) { New-Item -ItemType Directory -Path $GlobalPath -Force | Out-Null }
Copy-Item $CoreSource (Join-Path $GlobalPath "Core.md") -Force
Copy-Item $CoreSource (Join-Path $GlobalPath "GEMINI.md") -Force
Copy-Item $AgentsSource (Join-Path $GlobalPath "AGENTS.md") -Force
Log "[OK] Global rules updated in $GlobalPath"

# 2. Iterar sobre projetos
$Projects = Get-ChildItem $ProjectsRoot -Directory | Where-Object { $_.Name -ne "AIConfig" }

foreach ($Project in $Projects) {
    Log "`n>>> Processando projeto: $($Project.Name)"
    $ProjectPath = $Project.FullName
    
    $GeminiDest = Join-Path $ProjectPath "GEMINI.md"
    $CoreDest = Join-Path $ProjectPath "Core.md"
    $AgentsDest = Join-Path $ProjectPath "AGENTS.md"
    $IgnoreDest = Join-Path $ProjectPath ".antigravityignore"
    $OldIgnoreDest = Join-Path $ProjectPath ".antigravityignore"
    
    # Função para fazer merge de seções [LOCAL]
    function Merge-Governance($SourceFile, $DestFile) {
        if (!(Test-Path $SourceFile)) { return }
        
        $SourceContent = Get-Content $SourceFile -Raw
        if (Test-Path $DestFile) {
            $DestContent = Get-Content $DestFile -Raw
            $LocalPattern = '(?s)## \[LOCAL\].*'
            $LocalMatch = [regex]::Match($DestContent, $LocalPattern)
            
            if ($LocalMatch.Success) {
                Log "  - Preservando seção [LOCAL] em $(Split-Path $DestFile -Leaf)..."
                $NewContent = $SourceContent + "`n`n" + $LocalMatch.Value
                $NewContent | Set-Content $DestFile -Encoding UTF8
            } else {
                Copy-Item $SourceFile $DestFile -Force
            }
        } else {
            Copy-Item $SourceFile $DestFile -Force
        }
    }

    # Propagar Core/Governance (Migrando GEMINI.md para Core.md se necessário)
    if (Test-Path $GeminiDest) {
        Log "  - Migrando GEMINI.md para Core.md..."
        Merge-Governance $CoreSource $GeminiDest
        Move-Item $GeminiDest $CoreDest -Force
    } else {
        Merge-Governance $CoreSource $CoreDest
    }

    # Propagar AGENTS.md
    Merge-Governance $AgentsSource $AgentsDest

    # Propagar .antigravityignore (Migrando .antigravityignore se necessário)
    if (Test-Path $OldIgnoreDest) {
        Log "  - Migrando .antigravityignore para .antigravityignore..."
        Merge-Governance $IgnoreSource $OldIgnoreDest
        Move-Item $OldIgnoreDest $IgnoreDest -Force
    } else {
        Merge-Governance $IgnoreSource $IgnoreDest
    }
    # Commit e Push
    if (Test-Path (Join-Path $ProjectPath ".git")) {
        $FilesToStage = @("Core.md", "GEMINI.md", "AGENTS.md", ".antigravityignore", ".antigravityignore")
        foreach ($f in $FilesToStage) {
            if (Test-Path (Join-Path $ProjectPath $f)) {
                git -C $ProjectPath add $f 2>$null
            }
        }

        # Garantir remoção do ignore legado quando não existir mais no filesystem,
        # mas ainda estiver rastreado pelo Git.
        git -C $ProjectPath rm --ignore-unmatch ".antigravityignore" 2>$null | Out-Null
        
        $Status = git -C $ProjectPath status --porcelain
        if ($Status) {
            git -C $ProjectPath commit -m "[Sync: Governança atualizada via AIConfig]" 2>&1 | Out-Null
            git -C $ProjectPath push 2>&1 | Out-Null
            if ($LASTEXITCODE -eq 0) {
                Log "  - Sincronizado com sucesso."
                $SuccessCount++
            } else {
                Log "  - ERRO ao fazer push."
                $ErrorCount++
            }
        } else {
            Log "  - Sem alterações para commit."
            $SkipCount++
        }
    }
}

Log "`nPropagação concluída!"

# Resumo compacto para stdout (economia de tokens)
Write-Host "Propagacao: OK=$SuccessCount SKIP=$SkipCount ERR=$ErrorCount | Log: $LogFile"
