<#
.SYNOPSIS
  Syncs the skill .md files in this repo into ~/.claude/skills/<name>/SKILL.md
  so Claude Code picks up edits made here.

.DESCRIPTION
  Windows symlinks require Developer Mode or an elevated shell, so this repo
  uses plain-file copies instead. Run this script after editing/adding any
  skill file in this directory to push the changes to the global skills folder.

.USAGE
  Run from anywhere:
    powershell -File d:\sources\my-skills\sync-skills.ps1
#>

$ErrorActionPreference = "Stop"

$repoDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$skillsRoot = Join-Path $env:USERPROFILE ".claude\skills"

$mdFiles = Get-ChildItem -Path $repoDir -Filter "*.md" -File

$synced = @()
foreach ($file in $mdFiles) {
    $lines = Get-Content $file.FullName -TotalCount 20
    if ($lines[0] -ne "---") { continue }

    $nameLine = $lines | Where-Object { $_ -match '^name:\s*(.+)$' } | Select-Object -First 1
    if (-not $nameLine) { continue }

    $skillName = ($nameLine -replace '^name:\s*', '').Trim().Trim('"')

    $targetDir = Join-Path $skillsRoot $skillName
    New-Item -ItemType Directory -Force -Path $targetDir | Out-Null

    $targetFile = Join-Path $targetDir "SKILL.md"
    Copy-Item -Path $file.FullName -Destination $targetFile -Force

    $synced += $skillName
}

Write-Host "Synced $($synced.Count) skill(s) to $skillsRoot :"
$synced | ForEach-Object { Write-Host "  - $_" }
