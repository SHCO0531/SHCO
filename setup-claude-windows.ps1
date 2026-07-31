<#
.SYNOPSIS
    Windows에서 Claude Code 데스크톱 앱이 Git Bash를 찾도록 설정합니다.

.DESCRIPTION
    "Git 설치 - 로컬 세션을 실행하려면 Git for Windows가 필요합니다" 팝업을 없앱니다.
    다음 순서로 동작합니다.

      1. bash.exe 가 이미 있는지 찾습니다.
      2. 없으면 winget 으로 Git for Windows 를 설치합니다.
      3. 찾은 경로를 CLAUDE_CODE_GIT_BASH_PATH 사용자 환경 변수에 저장합니다.
      4. 실제로 실행되는지 검증합니다.

    관리자 권한은 필요하지 않습니다. 사용자 환경 변수만 건드리며,
    시스템 설정이나 기존 파일을 지우지 않습니다.

.PARAMETER SkipInstall
    Git 이 없어도 설치를 시도하지 않고 안내만 출력합니다.

.EXAMPLE
    powershell -ExecutionPolicy Bypass -File .\setup-claude-windows.ps1
#>

[CmdletBinding()]
param(
    [switch]$SkipInstall
)

$ErrorActionPreference = 'Stop'

$EnvVarName = 'CLAUDE_CODE_GIT_BASH_PATH'

function Write-Step { param($Text) Write-Host "`n=== $Text" -ForegroundColor Cyan }
function Write-Ok   { param($Text) Write-Host "  [OK]   $Text" -ForegroundColor Green }
function Write-Info { param($Text) Write-Host "         $Text" -ForegroundColor DarkGray }
function Write-Warn { param($Text) Write-Host "  [주의] $Text" -ForegroundColor Yellow }
function Write-Fail { param($Text) Write-Host "  [실패] $Text" -ForegroundColor Red }

# Git Bash 실행 파일을 찾습니다.
# 주의: usr\bin\bash.exe 가 아니라 bin\bash.exe 여야 합니다.
function Find-GitBash {
    # 설치 위치 후보. 환경 변수가 비어 있을 수 있으므로 값이 있을 때만 조합합니다.
    $roots = @(
        @{ Base = $env:ProgramFiles        ; Tail = 'Git\bin\bash.exe' }
        @{ Base = ${env:ProgramFiles(x86)} ; Tail = 'Git\bin\bash.exe' }
        @{ Base = $env:LOCALAPPDATA        ; Tail = 'Programs\Git\bin\bash.exe' }
    )

    $candidates = @()
    foreach ($r in $roots) {
        if ($r.Base) { $candidates += (Join-Path $r.Base $r.Tail) }
    }

    # git.exe 가 PATH 에 있으면 설치 루트를 역추적해서 후보에 추가합니다.
    # (cmd\git.exe 든 bin\git.exe 든 상위의 상위가 설치 루트입니다)
    $gitCmd = Get-Command git.exe -ErrorAction SilentlyContinue
    if ($gitCmd) {
        $root = Split-Path (Split-Path $gitCmd.Source -Parent) -Parent
        if ($root) { $candidates += (Join-Path $root 'bin\bash.exe') }
    }

    foreach ($path in $candidates) {
        if ($path -and (Test-Path -LiteralPath $path -PathType Leaf)) {
            return (Resolve-Path -LiteralPath $path).Path
        }
    }
    return $null
}

# winget 설치 후 새 PATH 를 현재 세션에 반영합니다.
function Update-SessionPath {
    $machine = [Environment]::GetEnvironmentVariable('Path', 'Machine')
    $user    = [Environment]::GetEnvironmentVariable('Path', 'User')
    $env:Path = @($machine, $user | Where-Object { $_ }) -join ';'
}

Write-Host ''
Write-Host '  Claude Code - Windows Git Bash 설정' -ForegroundColor White
Write-Host '  -----------------------------------' -ForegroundColor DarkGray

# --- 1. 이미 설치되어 있는지 확인 -------------------------------------------
Write-Step '1/4  Git Bash 찾는 중'

$bash = Find-GitBash

if ($bash) {
    Write-Ok "찾았습니다: $bash"
}
else {
    Write-Info 'Git Bash 를 찾지 못했습니다.'

    # --- 2. 설치 -------------------------------------------------------------
    Write-Step '2/4  Git for Windows 설치'

    if ($SkipInstall) {
        Write-Warn '-SkipInstall 이 지정되어 설치를 건너뜁니다.'
        Write-Info 'https://git-scm.com/downloads/win 에서 설치한 뒤 다시 실행하세요.'
        exit 1
    }

    if (-not (Get-Command winget -ErrorAction SilentlyContinue)) {
        Write-Fail 'winget 을 사용할 수 없습니다.'
        Write-Info 'https://git-scm.com/downloads/win 에서 직접 설치한 뒤 이 스크립트를 다시 실행하세요.'
        exit 1
    }

    Write-Info 'winget install --id Git.Git  (몇 분 걸릴 수 있습니다)'
    winget install --id Git.Git -e --source winget --accept-package-agreements --accept-source-agreements

    Update-SessionPath
    $bash = Find-GitBash

    if (-not $bash) {
        Write-Fail '설치는 끝났지만 bash.exe 를 찾지 못했습니다.'
        Write-Info 'PowerShell 을 새로 연 뒤 이 스크립트를 한 번 더 실행해 보세요.'
        exit 1
    }
    Write-Ok "설치 완료: $bash"
}

# --- 3. 환경 변수 설정 --------------------------------------------------------
Write-Step "3/4  $EnvVarName 설정"

$current = [Environment]::GetEnvironmentVariable($EnvVarName, 'User')

if ($current -eq $bash) {
    Write-Ok '이미 올바른 값으로 설정되어 있습니다.'
}
else {
    if ($current) {
        Write-Info "기존 값: $current"
    }
    [Environment]::SetEnvironmentVariable($EnvVarName, $bash, 'User')
    $env:CLAUDE_CODE_GIT_BASH_PATH = $bash
    Write-Ok "설정했습니다: $bash"
}

# --- 4. 검증 ------------------------------------------------------------------
Write-Step '4/4  동작 확인'

try {
    $version = & $bash --version 2>&1 | Select-Object -First 1
    Write-Ok $version
}
catch {
    Write-Fail "bash.exe 실행에 실패했습니다: $($_.Exception.Message)"
    exit 1
}

Write-Host ''
Write-Host '  준비가 끝났습니다.' -ForegroundColor Green
Write-Host ''
Write-Host '  마지막으로 Claude Code 앱을 완전히 종료했다가 다시 켜세요.' -ForegroundColor White
Write-Host '  창만 닫으면 반영되지 않습니다. 작업 표시줄 오른쪽 트레이 아이콘을' -ForegroundColor DarkGray
Write-Host '  우클릭해서 종료한 뒤 실행해야 환경 변수를 새로 읽습니다.' -ForegroundColor DarkGray
Write-Host ''
