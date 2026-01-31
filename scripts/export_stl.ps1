$ErrorActionPreference = "Stop"

$inputPath = Join-Path $PSScriptRoot "..\models\box.scad"
$outputDir = Join-Path $PSScriptRoot "..\build"
$outputFile = "drawer_insert_70x105x95.stl"
$outputPath = Join-Path $outputDir $outputFile

# Ensure build directory exists
if (-not (Test-Path -Path $outputDir)) {
    Write-Host "Creating build directory..."
    New-Item -ItemType Directory -Path $outputDir | Out-Null
}

Write-Host "Exporting model to STL..."
Write-Host "Input: $inputPath"
Write-Host "Output: $outputPath"

try {
    # Run OpenSCAD via command line
    # -o : Output file
    openscad -o $outputPath $inputPath
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host "Export successful!" -ForegroundColor Green
    } else {
        Write-Host "OpenSCAD exited with code $LASTEXITCODE" -ForegroundColor Red
    }
}
catch {
    Write-Error "Failed to run OpenSCAD. Please ensure it is installed and added to your PATH."
    Write-Error $_
}
