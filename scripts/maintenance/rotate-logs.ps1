$logDir = "$env:USERPROFILE\Documents\Projetos Antigravity\AIConfig\session_log"
$archiveDir = Join-Path $logDir "archive"

# Garante que o diretório de arquivamento exista
if (-not (Test-Path $archiveDir)) {
    New-Item -ItemType Directory -Path $archiveDir | Out-Null
}

# Data de corte: arquivos mais antigos que 7 dias
$cutoff = (Get-Date).AddDays(-7)

# Seleciona logs de propagação antigos
$oldLogs = Get-ChildItem -Path $logDir -Filter "propagation-*.log" | Where-Object { $_.CreationTime -lt $cutoff }

if ($oldLogs.Count -eq 0) {
    Write-Host "Nenhum log antigo encontrado para arquivar."
    exit 0
}

# Cria nome de arquivo zip baseado na data atual
$zipName = "logs_$(Get-Date -Format 'yyyyMMdd_HHmmss').zip"
$zipPath = Join-Path $archiveDir $zipName

# Compacta os arquivos selecionados
Compress-Archive -Path $oldLogs.FullName -DestinationPath $zipPath -Force

# Remove os logs originais após compressão bem‑sucedida
foreach ($file in $oldLogs) {
    Remove-Item $file.FullName -Force
}

Write-Host "Arquivamento concluído: $zipPath"
