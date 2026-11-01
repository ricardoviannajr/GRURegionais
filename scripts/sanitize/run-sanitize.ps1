param(
    [switch]$Governance,
    [switch]$Skills,
    [switch]$Workflows
)
if ($Governance) {
    Write-Host "Executando sanitize-governance..."
    & "$PSScriptRoot\sanitize-governance.ps1"
}
if ($Skills) {
    Write-Host "Executando sanitize-skills..."
    & "$PSScriptRoot\sanitize-skills.ps1"
}
if ($Workflows) {
    Write-Host "Executando sanitize-workflows..."
    & "$PSScriptRoot\sanitize_workflows.ps1"
}
