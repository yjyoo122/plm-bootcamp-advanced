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
    [string]$SourceName = "PLM Technical Bootcamp - Advanced.html",
    [string]$Notes      = "",
    [switch]$NoBump,
    [switch]$NoRelease
)

$ErrorActionPreference = 'Stop'
$RepoDir = $PSScriptRoot
$LiveUrl = "https://yjyoo122.github.io/plm-bootcamp-advanced/"
$RepoSlug      = "yjyoo122/plm-bootcamp-advanced"
$VersionFile   = Join-Path $RepoDir 'VERSION'
$ChangelogFile = Join-Path $RepoDir 'CHANGELOG.md'
$ChangelogMark = '<!-- newest first -->'

# --- current published version, read from the VERSION file (plain integer) ---
$currentVersion = 0
if (Test-Path -LiteralPath $VersionFile) {
    $raw = (Get-Content -LiteralPath $VersionFile -Raw).Trim()
    if ($raw -match '^\d+$') { $currentVersion = [int]$raw }
}

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

# ---------------------------------------------------------------- 3. version, commit, tag, release
Push-Location $RepoDir
try {
    $dirty = git status --porcelain
    if ([string]::IsNullOrWhiteSpace($dirty)) {
        Say "No changes - the published version already matches this file."
        Say "Nothing to do. This stays Version $currentVersion. Live at:"
        Say "  $LiveUrl"
        Say ""
        exit 0
    }

    # A version bump means the module itself changed. Doc-only edits (README, notes)
    # ride along on the current version instead of inventing a new one.
    $deckDirty   = git status --porcelain -- index.html
    $deckChanged = -not [string]::IsNullOrWhiteSpace($deckDirty)
    $bump        = $deckChanged -and (-not $NoBump)
    $newVersion  = if ($bump) { $currentVersion + 1 } else { $currentVersion }

    # what goes in the changelog entry and the GitHub release body
    $entryNotes = if (-not [string]::IsNullOrWhiteSpace($Notes))   { $Notes }
                  elseif (-not [string]::IsNullOrWhiteSpace($Message)) { $Message }
                  else { "Update advanced module." }

    if ($bump) {
        # --- VERSION file ---------------------------------------------------
        $utf8NoBomEnc = New-Object System.Text.UTF8Encoding($false)
        [System.IO.File]::WriteAllBytes($VersionFile, $utf8NoBomEnc.GetBytes("$newVersion`n"))
        Good "VERSION bumped: $currentVersion -> $newVersion"

        # --- CHANGELOG.md ---------------------------------------------------
        if (Test-Path -LiteralPath $ChangelogFile) {
            $clBytes = [System.IO.File]::ReadAllBytes($ChangelogFile)
            $cl      = [System.Text.Encoding]::UTF8.GetString($clBytes)
            $entry   = "## Version $newVersion" + " - " + (Get-Date -Format 'yyyy-MM-dd') + "`n`n" + $entryNotes
            if ($cl.Contains($ChangelogMark)) {
                $cl = $cl.Replace($ChangelogMark, "$ChangelogMark`n`n$entry")
                [System.IO.File]::WriteAllBytes($ChangelogFile, $utf8NoBomEnc.GetBytes($cl))
                Good "CHANGELOG.md updated"
            } else {
                Warn "CHANGELOG marker '$ChangelogMark' not found - add the entry by hand."
            }
        } else {
            Warn "CHANGELOG.md not found - skipped."
        }

        $Message = "Version $newVersion - $entryNotes"
    }
    elseif ([string]::IsNullOrWhiteSpace($Message)) {
        $Message = "Update advanced module - $(Get-Date -Format 'yyyy-MM-dd HH:mm')"
    }

    if (-not $bump) {
        if ($NoBump)          { Say "-NoBump given: staying on Version $currentVersion." }
        elseif (-not $deckChanged) { Say "index.html unchanged: staying on Version $currentVersion (docs-only update)." }
        Say ""
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

    # --- tag + GitHub release, so the repo page shows the version -----------
    if ($bump) {
        $tag = "v$newVersion"
        $existing = git tag --list $tag
        if ([string]::IsNullOrWhiteSpace($existing)) {
            git tag -a $tag -m "Version $newVersion"
            if (-not $?) { Warn "git tag failed - version not tagged." }
        } else {
            Warn "Tag $tag already exists locally - reusing it."
        }

        git push -q origin $tag
        if ($LASTEXITCODE -eq 0) { Good "Tagged $tag" } else { Warn "Could not push tag $tag." }

        if (-not $NoRelease) {
            if (Get-Command gh -ErrorAction SilentlyContinue) {
                $relOut = gh release create $tag --repo $RepoSlug --title "Version $newVersion" --notes $entryNotes
                if ($LASTEXITCODE -eq 0) {
                    Good "Published release: Version $newVersion"
                    Say  "  $relOut"
                } else {
                    Warn "gh release create failed. Make one by hand at:"
                    Warn "  https://github.com/$RepoSlug/releases/new?tag=$tag"
                }
            } else {
                Warn "GitHub CLI (gh) not installed - tag pushed, but no release page created."
                Warn "  Install from https://cli.github.com/ or create it at:"
                Warn "  https://github.com/$RepoSlug/releases/new?tag=$tag"
            }
        }
    }

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
Say "Published as: Version $newVersion"
Say ""
Say "GitHub Pages rebuilds in about a minute. Then it is live at:"
Say "  $LiveUrl"
Say ""
Say "Note: browsers cache the page for up to 10 minutes. If you still see the old"
Say "version, press Ctrl+Shift+R to force a reload."
Say ""
