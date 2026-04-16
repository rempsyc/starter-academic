# reorganize_content.ps1
# Reorganizes content files: active fields at top, unused/commented-out at bottom.
# All comments are PRESERVED — nothing is deleted.

$root = "C:\Users\rt3105\Documents\GitHub\starter-academic"
$stats = @{ pubs = 0; projs = 0; widgets = 0; donate = 0 }

# ============================================================
# 1. PUBLICATION FILES (content/{en,fr}/publication/*/index.md)
# ============================================================
# Goal: Active fields at top in standard order, commented-out block at bottom.

$pubFiles = @()
$pubFiles += Get-ChildItem "$root\content\en\publication\*\index.md" -ErrorAction SilentlyContinue
$pubFiles += Get-ChildItem "$root\content\fr\publication\*\index.md" -ErrorAction SilentlyContinue

foreach ($f in $pubFiles) {
    $raw = [System.IO.File]::ReadAllText($f.FullName)
    if (-not $raw.StartsWith("---")) { continue }

    $parts = $raw -split "(?m)^---\s*$", 3
    if ($parts.Count -lt 3) { continue }
    $fm = $parts[1]
    $body = $parts[2]

    $lines = $fm -split "\r?\n"
    
    # Parse into chunks: each chunk is a YAML field (key + its continuation/comment lines)
    $chunks = [System.Collections.ArrayList]::new()
    $currentChunk = [System.Collections.ArrayList]::new()
    $currentKey = $null
    
    for ($i = 0; $i -lt $lines.Count; $i++) {
        $line = $lines[$i]
        
        # Top-level YAML key (non-indented, non-comment, has colon)
        if ($line -match '^([a-z_]+)\s*:' -and $line -notmatch '^\s') {
            if ($currentChunk.Count -gt 0) {
                [void]$chunks.Add(@{ key = $currentKey; lines = [string[]]$currentChunk.ToArray() })
                $currentChunk = [System.Collections.ArrayList]::new()
            }
            $currentKey = $matches[1]
            [void]$currentChunk.Add($line)
        }
        # Commented-out YAML key
        elseif ($line -match '^#\s*([a-z_]+)\s*:') {
            $commentedKey = $matches[1]
            # Start new chunk if this is a different key
            if ($null -ne $currentKey -and $currentKey -ne "#$commentedKey" -and $currentChunk.Count -gt 0) {
                [void]$chunks.Add(@{ key = $currentKey; lines = [string[]]$currentChunk.ToArray() })
                $currentChunk = [System.Collections.ArrayList]::new()
            }
            $currentKey = "#$commentedKey"
            [void]$currentChunk.Add($line)
        }
        # The "# ####..." separator line — starts the big boilerplate block
        elseif ($line -match '^#\s*#{4,}') {
            if ($currentChunk.Count -gt 0) {
                [void]$chunks.Add(@{ key = $currentKey; lines = [string[]]$currentChunk.ToArray() })
                $currentChunk = [System.Collections.ArrayList]::new()
            }
            $currentKey = '#_separator'
            [void]$currentChunk.Add($line)
        }
        # Regular comment (not a key) — attach to current chunk
        elseif ($line -match '^#') {
            [void]$currentChunk.Add($line)
        }
        # Continuation line: indented, list item, blank, or multi-line value
        else {
            [void]$currentChunk.Add($line)
        }
    }
    if ($currentChunk.Count -gt 0) {
        [void]$chunks.Add(@{ key = $currentKey; lines = [string[]]$currentChunk.ToArray() })
    }

    # Classify chunks as "active" or "inactive"
    $activeChunks = [System.Collections.ArrayList]::new()
    $inactiveChunks = [System.Collections.ArrayList]::new()
    
    foreach ($chunk in $chunks) {
        $key = $chunk.key
        $text = ($chunk.lines -join "`n").Trim()
        
        if ($null -eq $key -or $text -eq '') { continue }
        
        # Commented-out keys -> inactive
        if ($key -match '^#') {
            [void]$inactiveChunks.Add($chunk)
        }
        # slides: example -> inactive (unused boilerplate)
        elseif ($key -eq 'slides' -and $text -match 'slides:\s*example') {
            [void]$inactiveChunks.Add($chunk)
        }
        # math: true -> inactive
        elseif ($key -eq 'math' -and $text -match 'math:\s*true') {
            [void]$inactiveChunks.Add($chunk)
        }
        # external_link with no value -> inactive
        elseif ($key -eq 'external_link' -and $text -match 'external_link:\s*$') {
            [void]$inactiveChunks.Add($chunk)
        }
        else {
            [void]$activeChunks.Add($chunk)
        }
    }

    # Reorder active chunks into standard field order
    $standardOrder = @('title', 'publication', 'authors', 'publication_types', 'date', 'doi',
                       'add_badge', 'featured', 'external_link', 'links', 'abstract',
                       'url_code', 'url_dataset', 'url_pdf', 'url_poster', 'url_preprint',
                       'url_project', 'url_slides', 'url_source', 'url_video', 'tags')

    $orderedActive = [System.Collections.ArrayList]::new()
    foreach ($key in $standardOrder) {
        foreach ($chunk in $activeChunks) {
            if ($chunk.key -eq $key) { [void]$orderedActive.Add($chunk) }
        }
    }
    # Any active chunks not in the standard order
    foreach ($chunk in $activeChunks) {
        if ($chunk.key -notin $standardOrder) { [void]$orderedActive.Add($chunk) }
    }

    # Build new frontmatter
    $newLines = [System.Collections.ArrayList]::new()
    
    foreach ($chunk in $orderedActive) {
        foreach ($line in $chunk.lines) { [void]$newLines.Add($line) }
        [void]$newLines.Add('')
    }
    
    if ($inactiveChunks.Count -gt 0) {
        [void]$newLines.Add('')
        [void]$newLines.Add('# --- Unused/optional fields below ---')
        [void]$newLines.Add('')
        foreach ($chunk in $inactiveChunks) {
            foreach ($line in $chunk.lines) { [void]$newLines.Add($line) }
            [void]$newLines.Add('')
        }
    }

    $newFm = ($newLines -join "`n").Trim()
    $newContent = "---`n" + $newFm + "`n---" + $body
    $newContent = $newContent -replace '(\r?\n){4,}', "`n`n`n"

    [System.IO.File]::WriteAllText($f.FullName, $newContent, [System.Text.UTF8Encoding]::new($false))
    $stats.pubs++
    Write-Host "  pub: $($f.Directory.Name)"
}

Write-Host "`nPublication files: $($stats.pubs) reorganized"

# ============================================================
# 2. PROJECT ITEM FILES (content/{en,fr}/project-*/*/index.md)
# ============================================================

$projDirs = @("project-blog", "project-tutorials", "project-media", "project-news")
$projFiles = @()
foreach ($d in $projDirs) {
    $projFiles += Get-ChildItem "$root\content\en\$d\*\index.md" -ErrorAction SilentlyContinue
    $projFiles += Get-ChildItem "$root\content\fr\$d\*\index.md" -ErrorAction SilentlyContinue
}

foreach ($f in $projFiles) {
    $raw = [System.IO.File]::ReadAllText($f.FullName)
    if (-not $raw.StartsWith("---")) { continue }

    $parts = $raw -split "(?m)^---\s*$", 3
    if ($parts.Count -lt 3) { continue }
    $fm = $parts[1]
    $body = $parts[2]

    $lines = $fm -split "\r?\n"
    
    $chunks = [System.Collections.ArrayList]::new()
    $currentChunk = [System.Collections.ArrayList]::new()
    $currentKey = $null
    
    for ($i = 0; $i -lt $lines.Count; $i++) {
        $line = $lines[$i]
        if ($line -match '^([a-z_]+)\s*:' -and $line -notmatch '^\s') {
            if ($currentChunk.Count -gt 0) {
                [void]$chunks.Add(@{ key = $currentKey; lines = [string[]]$currentChunk.ToArray() })
                $currentChunk = [System.Collections.ArrayList]::new()
            }
            $currentKey = $matches[1]
            [void]$currentChunk.Add($line)
        }
        elseif ($line -match '^#\s*([a-z_-]+)\s*:') {
            if ($currentChunk.Count -gt 0 -and $currentKey -ne "#$($matches[1])") {
                [void]$chunks.Add(@{ key = $currentKey; lines = [string[]]$currentChunk.ToArray() })
                $currentChunk = [System.Collections.ArrayList]::new()
            }
            $currentKey = "#$($matches[1])"
            [void]$currentChunk.Add($line)
        }
        elseif ($line -match '^#') {
            [void]$currentChunk.Add($line)
        }
        # Continuation line: indented, list item, blank, or multi-line value
        else {
            [void]$currentChunk.Add($line)
        }
    }
    if ($currentChunk.Count -gt 0) {
        [void]$chunks.Add(@{ key = $currentKey; lines = [string[]]$currentChunk.ToArray() })
    }

    $activeChunks = [System.Collections.ArrayList]::new()
    $inactiveChunks = [System.Collections.ArrayList]::new()

    foreach ($chunk in $chunks) {
        $key = $chunk.key
        $text = ($chunk.lines -join "`n").Trim()
        if ($null -eq $key -or $text -eq '') { continue }
        
        # Commented-out -> inactive
        if ($key -match '^#') {
            [void]$inactiveChunks.Add($chunk)
        }
        # slides: example -> inactive
        elseif ($key -eq 'slides' -and $text -match 'slides:\s*example') {
            [void]$inactiveChunks.Add($chunk)
        }
        # Empty string fields like summary: "" or url_code: ""
        elseif ($key -in @('summary','url_code','url_pdf','url_slides','url_video') -and $text -match ':\s*""\s*$') {
            [void]$inactiveChunks.Add($chunk)
        }
        # Empty image block (caption: "" and no real focal_point)
        elseif ($key -eq 'image' -and $text -match 'caption:\s*""') {
            [void]$inactiveChunks.Add($chunk)
        }
        else {
            [void]$activeChunks.Add($chunk)
        }
    }

    # Standard order for project items
    $projOrder = @('title', 'summary', 'tags', 'date', 'external_link', 'image', 'links')
    $orderedActive = [System.Collections.ArrayList]::new()
    foreach ($key in $projOrder) {
        foreach ($chunk in $activeChunks) {
            if ($chunk.key -eq $key) { [void]$orderedActive.Add($chunk) }
        }
    }
    foreach ($chunk in $activeChunks) {
        if ($chunk.key -notin $projOrder) { [void]$orderedActive.Add($chunk) }
    }

    $newLines = [System.Collections.ArrayList]::new()
    foreach ($chunk in $orderedActive) {
        foreach ($line in $chunk.lines) { [void]$newLines.Add($line) }
        [void]$newLines.Add('')
    }
    if ($inactiveChunks.Count -gt 0) {
        [void]$newLines.Add('')
        [void]$newLines.Add('# --- Unused/optional fields below ---')
        [void]$newLines.Add('')
        foreach ($chunk in $inactiveChunks) {
            foreach ($line in $chunk.lines) { [void]$newLines.Add($line) }
            [void]$newLines.Add('')
        }
    }

    $newFm = ($newLines -join "`n").Trim()
    $newContent = "---`n" + $newFm + "`n---" + $body
    $newContent = $newContent -replace '(\r?\n){4,}', "`n`n`n"

    [System.IO.File]::WriteAllText($f.FullName, $newContent, [System.Text.UTF8Encoding]::new($false))
    $stats.projs++
    Write-Host "  proj: $($f.Directory.Parent.Name)/$($f.Directory.Name)"
}

Write-Host "`nProject item files: $($stats.projs) reorganized"

# ============================================================
# 3. PORTFOLIO/WIDGET FILES (projects.md)
# ============================================================
# Move commented-out [design.background] and [advanced] to bottom.

$widgetDirs = @("blog", "news", "media", "tutorials")
foreach ($lang in @("en", "fr")) {
    foreach ($d in $widgetDirs) {
        $p = "$root\content\$lang\$d\projects.md"
        if (-not (Test-Path $p)) { continue }
        $raw = [System.IO.File]::ReadAllText($p)

        # Extract the design.background block (header + all-commented lines)
        $bgBlock = $null
        if ($raw -match '(?ms)(\[design\.background\]\r?\n([ \t]*#[^\n]*\r?\n|[ \t]*\r?\n)+)') {
            $bgBlock = $matches[1]
            $raw = $raw.Replace($bgBlock, '')
        }
        
        # Extract empty [advanced] section
        $advBlock = $null
        if ($raw -match '(?ms)(\[advanced\]\r?\n([ \t]*#[^\n]*\r?\n)*[ \t]*css_style\s*=\s*""\s*\r?\n((\r?\n)?([ \t]*#[^\n]*\r?\n)*[ \t]*css_class\s*=\s*""\s*\r?\n)?)') {
            $advBlock = $matches[1]
            $raw = $raw.Replace($advBlock, '')
        }
        
        if ($bgBlock -or $advBlock) {
            $lastIdx = $raw.LastIndexOf("+++")
            if ($lastIdx -gt 0) {
                $before = $raw.Substring(0, $lastIdx).TrimEnd()
                $after = $raw.Substring($lastIdx)
                $insert = "`n`n# --- Unused/optional fields below ---`n`n"
                if ($bgBlock) { $insert += $bgBlock.Trim() + "`n`n" }
                if ($advBlock) { $insert += $advBlock.Trim() + "`n`n" }
                $raw = $before + $insert + $after
            }
        }

        $raw = $raw -replace '(\r?\n){4,}', "`n`n`n"
        [System.IO.File]::WriteAllText($p, $raw, [System.Text.UTF8Encoding]::new($false))
        $stats.widgets++
        Write-Host "  widget: $lang/$d/projects.md"
    }
}

Write-Host "`nWidget files: $($stats.widgets) reorganized"

# ============================================================
# 4. DONATE HERO FILES
# ============================================================

foreach ($lang in @("en", "fr")) {
    $p = "$root\content\$lang\donate\hero.md"
    if (-not (Test-Path $p)) { continue }
    $raw = [System.IO.File]::ReadAllText($p)

    $bgColorBlock = $null
    if ($raw -match '(?ms)([ \t]*# Background color\.\s*\r?\n[ \t]*#\s*color\s*=.*\r?\n)') {
        $bgColorBlock = $matches[1]
        $raw = $raw.Replace($bgColorBlock, '')
    }

    $bgImgBlock = $null
    if ($raw -match '(?ms)([ \t]*# Background image\.\s*\r?\n([ \t]*#\s+\w+\s*=.*\r?\n)*)') {
        $bgImgBlock = $matches[1]
        $raw = $raw.Replace($bgImgBlock, '')
    }

    $ctaAltBlock = $null
    if ($raw -match '(?ms)(#\s+url = "https://sourcethemes.*\r?\n#\s+label = "View Documentation"\s*\r?\n)') {
        $ctaAltBlock = $matches[1]
        $raw = $raw.Replace($ctaAltBlock, '')
    }

    $ctaNoteBlock = $null
    if ($raw -match "(?ms)(# Note\. An optional note.*?\r?\n(#\s*\[cta_note\]\s*\r?\n)?#\s+label = '<a class.*\r?\n)") {
        $ctaNoteBlock = $matches[1]
        $raw = $raw.Replace($ctaNoteBlock, '')
    }

    if ($bgColorBlock -or $bgImgBlock -or $ctaAltBlock -or $ctaNoteBlock) {
        $lastIdx = $raw.LastIndexOf("+++")
        if ($lastIdx -gt 0) {
            $before = $raw.Substring(0, $lastIdx).TrimEnd()
            $after = $raw.Substring($lastIdx)
            $insert = "`n`n# --- Unused/optional fields below ---`n`n"
            if ($bgColorBlock) { $insert += $bgColorBlock.Trim() + "`n`n" }
            if ($bgImgBlock) { $insert += $bgImgBlock.Trim() + "`n`n" }
            if ($ctaAltBlock) { $insert += $ctaAltBlock.Trim() + "`n`n" }
            if ($ctaNoteBlock) { $insert += $ctaNoteBlock.Trim() + "`n`n" }
            $raw = $before + $insert + $after
        }
    }

    $raw = $raw -replace '(\r?\n){4,}', "`n`n`n"
    [System.IO.File]::WriteAllText($p, $raw, [System.Text.UTF8Encoding]::new($false))
    $stats.donate++
    Write-Host "  donate: $lang/donate/hero.md"
}

Write-Host "`nDonate hero files: $($stats.donate) reorganized"
Write-Host "`n=== SUMMARY ==="
Write-Host "Publications: $($stats.pubs)"
Write-Host "Project items: $($stats.projs)"
Write-Host "Widgets: $($stats.widgets)"
Write-Host "Donate: $($stats.donate)"
Write-Host "Total: $($stats.pubs + $stats.projs + $stats.widgets + $stats.donate) files reorganized"
