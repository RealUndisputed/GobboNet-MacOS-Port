# PowerShell script to extract model metadata

param (
    [string]$modelPath
)

if (-Not (Test-Path $modelPath)) {
    Write-Host "Model path does not exist."
    exit 1
}

# Load the model metadata
$modelMetadata = Get-Content -Path $modelPath | ConvertFrom-Json

# Extract relevant information
$modelFamily = $modelMetadata.family
$maxContext = $modelMetadata.max_context

# Output the extracted information
Write-Host "Model Family: $modelFamily"
Write-Host "Max Context: $maxContext"