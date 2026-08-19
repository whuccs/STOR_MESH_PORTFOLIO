$ErrorActionPreference = "Stop"

$repoRoot = Split-Path -Parent $PSScriptRoot
$buildDir = Join-Path $repoRoot "build"
$iverilog = Get-Command iverilog -ErrorAction SilentlyContinue
$vvp = Get-Command vvp -ErrorAction SilentlyContinue

if (-not $iverilog) {
    $fallbackIverilog = "C:\iverilog\bin\iverilog.exe"
    if (Test-Path -LiteralPath $fallbackIverilog) {
        $iverilog = $fallbackIverilog
    } else {
        throw "iverilog not found. Install Icarus Verilog or add it to PATH."
    }
}

if (-not $vvp) {
    $fallbackVvp = "C:\iverilog\bin\vvp.exe"
    if (Test-Path -LiteralPath $fallbackVvp) {
        $vvp = $fallbackVvp
    } else {
        throw "vvp not found. Install Icarus Verilog or add it to PATH."
    }
}

New-Item -ItemType Directory -Force -Path $buildDir | Out-Null
$output = Join-Path $buildDir "tb_golden_owner_arbiter.vvp"

& $iverilog -g2012 -s tb_golden_owner_arbiter -o $output `
    (Join-Path $repoRoot "rtl_demo\golden_owner_arbiter.sv") `
    (Join-Path $repoRoot "tb\tb_golden_owner_arbiter.sv")
& $vvp $output
