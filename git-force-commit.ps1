#!/usr/bin/env pwsh
# Fuerza el stage y commit de todos los archivos del repositorio, incluso sin cambios

Write-Host "🔍 Buscando la raíz del repositorio..." -ForegroundColor Cyan
$repoRoot = git rev-parse --show-toplevel 2>$null

if (-not $repoRoot) {
    Write-Host "❌ No se detecta un repositorio Git en este directorio." -ForegroundColor Red
    exit 1
}

Set-Location $repoRoot
Write-Host "📂 Repositorio: $repoRoot" -ForegroundColor Yellow

# 1️⃣ Eliminar todo del índice (sin tocar los archivos)
Write-Host "`n🧹 Limpiando índice..."
git rm --cached -r . | Out-Null

# 2️⃣ Volver a añadir todos los archivos
Write-Host "➕ Añadiendo todos los archivos..."
git add -A

# 3️⃣ Mostrar estado
Write-Host "`n---------------------------------"
Write-Host "📦 Archivos en stage:" -ForegroundColor Green
git status --short

# 4️⃣ Pedir mensaje de commit
Write-Host ""
$commitMsg = Read-Host "📝 Escribe el mensaje del commit"
if ([string]::IsNullOrWhiteSpace($commitMsg)) {
    $commitMsg = "Commit forzado de todos los archivos"
}

# 5️⃣ Crear commit
Write-Host "`n💾 Creando commit..."
$commitResult = git commit -m "$commitMsg" 2>&1

if ($LASTEXITCODE -ne 0) {
    Write-Host "⚠️ No se pudo crear el commit (puede que no haya cambios detectables)." -ForegroundColor Red
    Write-Host $commitResult
    exit 1
}

# 6️⃣ Mostrar resumen del commit
Write-Host "`n✅ Commit creado con todos los archivos actuales:" -ForegroundColor Green
git show --stat HEAD

Write-Host "`n✨ Proceso completado correctamente." -ForegroundColor Cyan
