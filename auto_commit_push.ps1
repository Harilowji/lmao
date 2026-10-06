# ============================================================
# Script: auto_commit_push.ps1
# Description: Kiem tra thay doi va tu dong commit, push len GitHub
# Repo: D:\Project\01_My_GitHub_Repos\lmao
# ============================================================

[CmdletBinding()]
param(
    [string]$RepoPath = "D:\Project\01_My_GitHub_Repos\lmao",
    [string]$Branch = "main"
)

$ErrorActionPreference = "Continue"

if (-not (Test-Path $RepoPath)) {
    Write-Error "Repository path not found: $RepoPath"
    exit 1
}

Set-Location $RepoPath

# Dam bao git co trong PATH
if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
    $env:PATH += ";C:\Program Files\Git\cmd"
}

$logFile = Join-Path $RepoPath "auto_commit.log"

function Write-Log {
    param([string]$Message)
    $ts = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $line = "[$ts] $Message"
    Write-Host $line
    try {
        Add-Content -Path $logFile -Value $line -Encoding UTF8 -ErrorAction SilentlyContinue
    } catch {}
}

# Don bot log neu vuot qua 2MB
if (Test-Path $logFile) {
    try {
        $size = (Get-Item $logFile).Length
        if ($size -gt 2MB) {
            $lines = Get-Content $logFile -Tail 1000
            $lines | Set-Content $logFile -Encoding UTF8
        }
    } catch {}
}

# Kiem tra trang thai Git
$statusOutput = git status --porcelain 2>&1
$hasChanges = $false

if ($statusOutput) {
    $validChanges = $statusOutput | Where-Object { $_ -ne $null -and $_.Trim() -ne "" }
    if ($validChanges.Count -gt 0) {
        $hasChanges = $true
    }
}

if ($hasChanges) {
    $changeCount = ($statusOutput | Where-Object { $_ -ne $null -and $_.Trim() -ne "" }).Count
    Write-Log "Detected $changeCount modified/untracked files. Committing..."
    
    # Git add tat ca thay doi
    git add -A

    # Tao commit
    $commitTime = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $commitMsg = "chore(auto): backup and periodic commit at $commitTime"
    $commitRes = git commit -m "$commitMsg" 2>&1
    Write-Log "Committed: $commitMsg"

    # Push len GitHub
    $pushRes = git push origin $Branch 2>&1
    if ($LASTEXITCODE -eq 0) {
        Write-Log "Push to origin/$Branch successful!"
    } else {
        Write-Log "Failed to push to GitHub: $pushRes"
    }
} else {
    # Kiem tra commit cuc bo chua duoc push
    $unpushed = git log "origin/$Branch..HEAD" --oneline 2>&1
    $hasUnpushed = $false
    if ($unpushed) {
        $validUnpushed = $unpushed | Where-Object { $_ -ne $null -and $_.Trim() -ne "" }
        if ($validUnpushed.Count -gt 0) {
            $hasUnpushed = $true
        }
    }

    if ($hasUnpushed) {
        Write-Log "Found unpushed commits. Pushing to origin/$Branch..."
        $pushRes = git push origin $Branch 2>&1
        if ($LASTEXITCODE -eq 0) {
            Write-Log "Successfully pushed unpushed commits to origin/$Branch."
        } else {
            Write-Log "Failed to push to GitHub: $pushRes"
        }
    }
}
