param(
  [string]$Path = '.',
  [string]$Name = '*',
  [string]$NameRegex,
  [string[]]$Extensions,
  [string]$ContentPattern,
  [switch]$SimpleContent,
  [string[]]$ExcludeDir,
  [int]$MaxDepth = -1,
  [switch]$IncludeHidden,
  [long]$MinSizeBytes,
  [long]$MaxSizeBytes,
  [datetime]$MinDate,
  [datetime]$MaxDate,
  [ValidateSet('Console','Csv','Json')][string]$Output = 'Console',
  [string]$OutFile
)

$base = (Resolve-Path -LiteralPath $Path).Path

# Gyűjtés
$files = Get-ChildItem -LiteralPath $base -File -Recurse -Force:$IncludeHidden -ErrorAction SilentlyContinue

# Könyvtár-kizárások (útvonalrészlet alapján)
if ($ExcludeDir) {
  $files = $files | Where-Object {
    $full = $_.FullName
    $hit = $false
    foreach ($ex in $ExcludeDir) {
      if ($full -like "*\$ex*" -or $full -like "*/$ex/*") { $hit = $true; break }
    }
    -not $hit
  }
}

# Mélységszűrés (0 = csak gyökérben lévő fájlok)
if ($MaxDepth -ge 0) {
  $files = $files | Where-Object {
    $rel = $_.FullName.Substring($base.Length).TrimStart('\\','/')
    $rel -eq '' -or (($rel -split '[\\/]').Count -le ($MaxDepth + 1))
  }
}

# Név és név-regex
if ($Name) { $files = $files | Where-Object { $_.Name -like $Name } }
if ($NameRegex) {
  $nameRe = [regex]$NameRegex
  $files = $files | Where-Object { $nameRe.IsMatch($_.Name) }
}

# Kiterjesztések (pl. .md, .txt)
if ($Extensions) {
  $exts = $Extensions | ForEach-Object { if ($_ -notmatch '^\.') { ".$_" } else { $_ } }
  $files = $files | Where-Object { $exts -contains $_.Extension }
}

# Méret
if ($PSBoundParameters.ContainsKey('MinSizeBytes')) { $files = $files | Where-Object { $_.Length -ge $MinSizeBytes } }
if ($PSBoundParameters.ContainsKey('MaxSizeBytes')) { $files = $files | Where-Object { $_.Length -le $MaxSizeBytes } }

# Dátum
if ($PSBoundParameters.ContainsKey('MinDate')) { $files = $files | Where-Object { $_.LastWriteTime -ge $MinDate } }
if ($PSBoundParameters.ContainsKey('MaxDate')) { $files = $files | Where-Object { $_.LastWriteTime -le $MaxDate } }

# Tartalomkeresés
$results = if ($ContentPattern) {
  $files | ForEach-Object {
    $matches = try {
      if ($SimpleContent) {
        Select-String -Path $_.FullName -SimpleMatch -Pattern $ContentPattern -ErrorAction SilentlyContinue
      } else {
        Select-String -Path $_.FullName -Pattern $ContentPattern -ErrorAction SilentlyContinue
      }
    } catch { $null }
    if ($matches) {
      [pscustomobject]@{
        Path          = $_.FullName
        Name          = $_.Name
        Extension     = $_.Extension
        Size          = $_.Length
        LastWriteTime = $_.LastWriteTime
        Depth         = (($_.FullName.Substring($base.Length).TrimStart('\\','/') -split '[\\/]').Count)
        MatchCount    = ($matches | Measure-Object).Count
        FirstMatch    = ($matches | Select-Object -First 1 | ForEach-Object { "L$($_.LineNumber): $($_.Line.Trim())" })
      }
    }
  }
} else {
  $files | Select-Object `
    @{n='Path';e={$_.FullName}}, Name, Extension, `
    @{n='Size';e={$_.Length}}, LastWriteTime, `
    @{n='Depth';e={(($_.FullName.Substring($base.Length).TrimStart('\\','/') -split '[\\/]').Count)}}
}

switch ($Output) {
  'Csv' {
    if (-not $OutFile) { $OutFile = Join-Path $PWD 'search-results.csv' }
    $results | Export-Csv -NoTypeInformation -Path $OutFile -Encoding UTF8
    Write-Host "CSV exported to $OutFile"
  }
  'Json' {
    if (-not $OutFile) { $OutFile = Join-Path $PWD 'search-results.json' }
    $results | ConvertTo-Json -Depth 4 | Set-Content -Path $OutFile -Encoding UTF8
    Write-Host "JSON exported to $OutFile"
  }
  Default { $results }
}

