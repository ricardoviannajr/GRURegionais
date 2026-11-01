param()

# Verifica presença dos artefatos obrigatórios
$required = @(
    "Core.md",
    "AGENTS.md",
    "SKILLS_SUMMARY.md",
    "MEMORIA.md",
    "README.md",
    ".antigravityignore"
)
$missing = @()
foreach ($file in $required) {
    if (-not (Test-Path $file)) { $missing += $file }
}
if ($missing.Count -gt 0) {
    Write-Host "[ERROR] Artefatos obrigatórios ausentes:" $missing
    exit 1
}

# Verifica arquivos ignorados que ainda estão versionados
$gitIgnored = git ls-files -v | Where-Object { $_ -match "^[[:lower:]]" } | ForEach-Object { $_.Substring(2) }
$problem = @()
foreach ($path in $gitIgnored) {
    if (Test-Path $path) {
        $problem += $path
    }
}
if ($problem.Count -gt 0) {
    Write-Host "[WARNING] Arquivos ignorados porém versionados:" $problem
    exit 2
}

Write-Host "[OK] Estrutura de repositório válida."
exit 0
