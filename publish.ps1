<#
  Publish a new version of the PLM Bootcamp ADVANCED module to GitHub Pages.

  Publishes the Advanced deck only. The Fundamentals deck lives in its own
  repo folder (plm-bootcamp) with its own copy of this script.

  Usage:
    Double-click  "Publish deck.bat"           -> publishes "PLM Technical Bootcamp - Advanced.html"
    Drag an .html file onto "Publish deck.bat" -> publishes that specific file instead
    .\publish.ps1 -SourceFile "C:\path\to\deck.html" -Message "Reworked the scripts chapter"

  What it does, in order:
    1. Finds the deck HTML to publish
    2. Copies it over index.html, re-applying the browser-tab title
       (a fresh export from source would otherwise revert it)
    3. Commits and pushes; GitHub Pages rebuilds automatically

  The cover heading ("Build the mechanism") is deliberately NOT touched -- it is
  designed copy, not a generic title. Only the browser-tab title is normalised.
#>

[CmdletBinding()]
param(
    [string]$SourceFile = "",
    [string]$Message    = "",
    [string]$SourceDir  = "C:\Users\yooy\OneDrive - Autodesk\Fusion Manage\Enablement materials\PLM BOOTCAMP",
    [string]$SourceName = "PLM Technical Bootcamp - Advanced.html"
)

$ErrorActionPreference = 'Stop'
$RepoDir = $PSScriptRoot
$LiveUrl = "https://yjyoo122.github.io/plm-bootcamp-advanced/"

# --- the browser-tab title applied on every publish. Change this line to retitle. ---
$TabTitle = "PLM Bootcamp - Advanced"

function Say  ($m) { Write-Host $m }
function Good ($m) { Write-Host "  OK    $m" -ForegroundColor Green }
function Warn ($m) { Write-Host "  WARN  $m" -ForegroundColor Yellow }
function Die  ($m) { Write-Host ""; Write-Host "  STOP  $m" -ForegroundColor Red; Write-Host ""; exit 1 }

Say ""
Say "=== Publish PLM Bootcamp - ADVANCED module ==="
Say ""

# ---------------------------------------------------------------- 1. find the source
if ([string]::IsNullOrWhiteSpace($SourceFile)) {
    # Pinned to one filename on purpose. Picking "newest .html in the folder" would
    # publish the Fundamentals deck over this site the moment that file was updated.
    $pinned = Join-Path $SourceDir $SourceName
    if (-not (Test-Path -LiteralPath $pinned)) {
        Die "Expected deck file not found:`n        $pinned`n`n        If it was renamed, drag the new file onto 'Publish deck.bat',`n        or update the SourceName line at the top of publish.ps1."
    }
    $SourceFile = $pinned
    Say "Source (the Advanced deck):"
} else {
    Say "Source (you chose):"
}

if (-not (Test-Path -LiteralPath $SourceFile)) { Die "File not found: $SourceFile" }

$src = Get-Item -LiteralPath $SourceFile
if ($src.Extension -notmatch '^\.html?$') { Die "Not an HTML file: $($src.Name)" }

$srcMiB = [math]::Round($src.Length / 1MB, 1)
Say "  $($src.Name)"
Say "  $srcMiB MiB, modified $($src.LastWriteTime.ToString('yyyy-MM-dd HH:mm'))"
Say ""

if ($src.Name -like '*Fundamentals*') {
    Die "That is the FUNDAMENTALS deck. This repo publishes the Advanced module.`n`n        Publish Fundamentals from: C:\Users\yooy\plm-bootcamp"
}
if ($src.Length -lt 100KB) { Warn "That file is unusually small for this deck. Double-check it is the right one." }
if ($src.Length -gt 100MB) { Die  "File is over 100 MiB. GitHub blocks files that large. Reduce the embedded images." }
if ($src.Length -gt 25MB)  { Warn "Over 25 MiB - too big for GitHub's browser upload. This script still works (it uses git)." }

# ---------------------------------------------------------------- 2. copy + retitle
$target = Join-Path $RepoDir 'index.html'

$bytes = [System.IO.File]::ReadAllBytes($src.FullName)
$html  = [System.Text.Encoding]::UTF8.GetString($bytes)

$titleHits = ([regex]'<title>.*?</title>').Matches($html).Count
$html = [regex]::Replace($html, '<title>.*?</title>', "<title>$TabTitle</title>")

if ($titleHits -eq 0) { Warn "No <title> tag found - browser tab title not set." }
else                  { Good "Tab title set to '$TabTitle'" }

# UTF8Encoding($false) = no byte-order mark, so the file stays byte-faithful
$utf8NoBom = New-Object System.Text.UTF8Encoding($false)
[System.IO.File]::WriteAllBytes($target, $utf8NoBom.GetBytes($html))
Good "Wrote index.html"
Say ""

# ---------------------------------------------------------------- 3. commit + push
Push-Location $RepoDir
try {
    $dirty = git status --porcelain
    if ([string]::IsNullOrWhiteSpace($dirty)) {
        Say "No changes - the published version already matches this file."
        Say "Nothing to do. Live at:"
        Say "  $LiveUrl"
        Say ""
        exit 0
    }

    if ([string]::IsNullOrWhiteSpace($Message)) {
        $Message = "Update advanced module - $(Get-Date -Format 'yyyy-MM-dd HH:mm')"
    }

    git add -A
    if (-not $?) { Die "git add failed." }

    git commit -q -m $Message
    if (-not $?) { Die "git commit failed." }
    Good "Committed: $Message"

    Say "Pushing (about $srcMiB MiB, please wait)..."
    git push -q origin main
    if (-not $?) { Die "git push failed. Check your internet connection, then run this again." }
    Good "Pushed to GitHub"

    $gitMiB = [math]::Round(((Get-ChildItem "$RepoDir\.git" -Recurse -File -ErrorAction SilentlyContinue |
                Measure-Object -Property Length -Sum).Sum / 1MB), 0)
    $revs = git rev-list --count HEAD
    Say ""
    Say "History: $revs revisions, $gitMiB MiB stored"
    if ($gitMiB -gt 700) {
        Warn "Approaching GitHub's recommended 1 GB limit. Time to squash old revisions."
    } elseif ($gitMiB -gt 300) {
        $headroom = [math]::Round((1024 - $gitMiB) / 9)
        Say "  (GitHub recommends under 1024 MiB - roughly $headroom more updates of headroom.)"
    }
}
finally { Pop-Location }

Say ""
Say "=== Done ==="
Say ""
Say "GitHub Pages rebuilds in about a minute. Then it is live at:"
Say "  $LiveUrl"
Say ""
Say "Note: browsers cache the page for up to 10 minutes. If you still see the old"
Say "version, press Ctrl+Shift+R to force a reload."
Say ""
