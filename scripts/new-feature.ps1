[CmdletBinding()]
param(
    [Parameter(Mandatory=$true, HelpMessage="Nome descritivo da nova funcionalidade.")]
    [string]$Name
)

# 1. Definir caminhos relativos de trabalho
$workspaceRoot = Resolve-Path (Join-Path $PSScriptRoot "..")
$templatesDir = Join-Path $workspaceRoot "templates\sdd"
$specsDir = Join-Path $workspaceRoot "specs"

# Garantir que o diretório principal de especificações exista
if (-not (Test-Path $specsDir)) {
    New-Item -ItemType Directory -Path $specsDir | Out-Null
}

# 2. Determinar o próximo número incremental da funcionalidade
$existingFeatures = Get-ChildItem -Path $specsDir -Directory | Where-Object { $_.Name -match "^\d+" }
$nextNumber = 1

if ($existingFeatures) {
    # Extrair os números dos nomes das pastas existentes para encontrar o maior
    $numbers = $existingFeatures | ForEach-Object {
        if ($_.Name -match "^(\d+)") {
            [int]$Matches[1]
        }
    }
    $maxNumber = ($numbers | Measure-Object -Maximum).Maximum
    $nextNumber = $maxNumber + 1
}

# Formatar o identificador numérico com 3 dígitos (ex: 001, 002)
$formattedNumber = $nextNumber.ToString("D3")

# 3. Sanitizar o nome do parâmetro para criar caminhos e branches limpos
$sanitizedName = $Name.ToLower() -replace '[^a-z0-9\s-]', ''
$sanitizedName = $sanitizedName -replace '\s+', '-'
$sanitizedName = $sanitizedName -replace '-+', '-'
$sanitizedName = $sanitizedName.Trim('-')

$featureId = "${formattedNumber}-${sanitizedName}"
$featurePath = Join-Path $specsDir $featureId
$branchName = "feature/${featureId}"

Write-Host "Iniciando a funcionalidade: $featureId" -ForegroundColor Green
Write-Host "Branch destino: $branchName" -ForegroundColor Cyan

# 4. Criar branch no Git
try {
    # Verificar se existem modificações pendentes no workspace local
    $gitStatus = git status --porcelain
    if ($gitStatus) {
        Write-Warning "Existem modificações não comitadas no repositório."
    }
    
    # Executar a criação e troca de branch
    git checkout -b $branchName
} catch {
    Write-Error "Falha ao criar ou alternar para a branch $branchName no Git."
    exit 1
}

# 5. Criar diretório local da funcionalidade e copiar os templates de trabalho
if (-not (Test-Path $featurePath)) {
    New-Item -ItemType Directory -Path $featurePath | Out-Null
}

$templateMapping = @{
    "spec_template.md"  = "spec.md"
    "plan_template.md"  = "plan.md"
    "tasks_template.md" = "tasks.md"
}

foreach ($template in $templateMapping.Keys) {
    $src = Join-Path $templatesDir $template
    $dest = Join-Path $featurePath $templateMapping[$template]
    
    if (Test-Path $src) {
        Copy-Item -Path $src -Destination $dest -Force
        
        # Inserir o nome da funcionalidade diretamente no cabeçalho do spec.md
        if ($templateMapping[$template] -eq "spec.md") {
            $content = Get-Content -Path $dest -Raw
            $content = $content -replace '\[Descreva de forma clara o comportamento esperado da funcionalidade\]', $Name
            Set-Content -Path $dest -Value $content -Force
        }
    } else {
        Write-Warning "Template $template não encontrado em $templatesDir."
    }
}

# 6. Commit inicial da estrutura lógica na nova branch
Write-Host "Criando commit inicial dos artefatos da funcionalidade..." -ForegroundColor Green
git add (Join-Path "specs" $featureId)
git commit -m "[Log: Inicializacao do fluxo SDD para a funcionalidade ${featureId}]"

Write-Host "Funcionalidade ${featureId} inicializada com sucesso!" -ForegroundColor Green
Write-Host "Local da especificação: specs/${featureId}/spec.md" -ForegroundColor Yellow
