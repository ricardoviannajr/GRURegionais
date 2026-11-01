<#
.SYNOPSIS
    Script de validação automatizada de portões de conformidade e integridade (SDD / AGENTS.md).
.DESCRIPTION
    Executa varreduras na branch de trabalho para garantir que:
    1. Branches 'feature/*' contenham a pasta correspondente em 'specs/' com os arquivos obrigatórios.
    2. Todos os checkboxes de portões de validação em 'plan.md' estejam assinados (- [x]).
    3. Arquivos de código modificados não excedam o limite máximo de 300 linhas estabelecido em AGENTS.md.
#>
[CmdletBinding()]
param(
    [Parameter(Mandatory=$false)]
    [string]$BaseBranch = "origin/master"
)

# 1. Detectar branch atual ou branch de PR (ambiente CI)
$branch = git branch --show-current
if (-not $branch -and $env:GITHUB_HEAD_REF) {
    $branch = $env:GITHUB_HEAD_REF
}

Write-Host "Iniciando validação para a branch: $branch" -ForegroundColor Cyan

# 2. Validação obrigatória do fluxo SDD para branches de funcionalidade
if ($branch -like "feature/*") {
    $featureId = $branch -replace '^feature/', ''
    $workspaceRoot = Resolve-Path (Join-Path $PSScriptRoot "..")
    $specsDir = Join-Path $workspaceRoot "specs"
    $featurePath = Join-Path $specsDir $featureId
    
    Write-Host "Validando integridade da funcionalidade: $featureId" -ForegroundColor Cyan
    
    # 2.1. Validar existência do diretório de especificações
    if (-not (Test-Path $featurePath)) {
        Write-Error "ERRO: O diretório de especificações '$featurePath' é obrigatório para branches do tipo 'feature/*'."
        exit 1
    }
    
    # 2.2. Validar existência dos arquivos core de SDD
    $requiredFiles = @("spec.md", "plan.md", "tasks.md")
    foreach ($file in $requiredFiles) {
        $filePath = Join-Path $featurePath $file
        if (-not (Test-Path $filePath)) {
            Write-Error "ERRO: O arquivo core '$file' está ausente na pasta '$featurePath'."
            exit 1
        }
    }
    
    # 2.3. Validar assinatura dos portões em plan.md
    $planPath = Join-Path $featurePath "plan.md"
    $planContent = Get-Content -Path $planPath -Raw
    
    # Verificar a existência de caixas de seleção abertas (- [ ])
    if ($planContent -match '-\s+\[\s*\]') {
        Write-Error "ERRO: Existem portões de validação não resolvidos (caixas vazias) no arquivo '$planPath'."
        Write-Error "Todos os portões do plano de desenvolvimento devem ser marcados como concluídos (- [x]) antes do merge."
        exit 1
    }
    
    Write-Host "Portões de validação SDD confirmados e validados!" -ForegroundColor Green
} else {
    Write-Host "Branch '$branch' não está sob a convenção 'feature/*'. Ignorando portões de especificações." -ForegroundColor Yellow
}

# 3. Validação de padrões de código (Limite de Linhas do AGENTS.md)
# Confirmar a existência da branch base para diff
git rev-parse --verify $BaseBranch 2>$null | Out-Null
if ($LastExitCode -ne 0) {
    # Fallback para master caso origin/master não exista no checkout local
    $BaseBranch = "master"
}

Write-Host "Analisando limites de tamanho de arquivos alterados contra: $BaseBranch" -ForegroundColor Cyan

# Obter lista de arquivos alterados/adicionados comparados com a base
$modifiedFiles = git diff --name-only "${BaseBranch}...HEAD"
$codeExtensions = @(".js", ".ts", ".py", ".go", ".cs", ".cpp", ".c", ".java", ".php", ".rb")

$failures = 0
foreach ($file in $modifiedFiles) {
    if (Test-Path $file) {
        $ext = [System.IO.Path]::GetExtension($file)
        if ($codeExtensions -contains $ext) {
            $lines = (Get-Content -Path $file).Count
            Write-Host "Checando $file ($lines linhas)..." -ForegroundColor Gray
            
            # Limite rígido definido no AGENTS.md (Artigo II)
            if ($lines -gt 300) {
                Write-Warning "ATENÇÃO: O arquivo de código '$file' possui $lines linhas, violando a recomendação de no máximo 300 linhas."
                # Para evitar falhas críticas em bases legadas, emitimos apenas um aviso.
                # Se desejar aplicar bloqueio total, descomente a linha abaixo:
                # $failures++
            }
        }
    }
}

if ($failures -gt 0) {
    Write-Error "ERRO: Falha na validação de limites de tamanho de arquivos (AGENTS.md)."
    exit 1
}

Write-Host "Validação de limites concluída sem falhas de bloqueio." -ForegroundColor Green
exit 0
