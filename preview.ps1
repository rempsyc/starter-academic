[CmdletBinding()]
param(
    [switch]$NoBrowser
)

$ErrorActionPreference = 'Stop'

$projectRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
$hugoVersion = '0.110.0'
$toolDirectory = Join-Path $projectRoot '.tools\hugo'
$hugoExecutable = Join-Path $toolDirectory 'hugo.exe'

Set-Location -LiteralPath $projectRoot

if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
    throw 'Git is required to load the site theme. Install Git for Windows and run this script again.'
}

if (-not (Get-Command go -ErrorAction SilentlyContinue)) {
    throw 'Go is required to load the site theme. Install Go and run this script again.'
}

$previewPort = $null
foreach ($candidatePort in 1313..1323) {
    $testListener = [System.Net.Sockets.TcpListener]::new([System.Net.IPAddress]::Loopback, $candidatePort)
    try {
        $testListener.Start()
        $previewPort = $candidatePort
        break
    }
    catch [System.Net.Sockets.SocketException] {
        continue
    }
    finally {
        $testListener.Stop()
    }
}

if ($null -eq $previewPort) {
    throw 'No free preview port was found between 1313 and 1323. Close an existing preview and try again.'
}

$previewUrl = "http://localhost:$previewPort/"

if (-not (Test-Path -LiteralPath $hugoExecutable)) {
    Write-Host "Preparing Hugo $hugoVersion for this site (one time only)..." -ForegroundColor Cyan

    New-Item -ItemType Directory -Path $toolDirectory -Force | Out-Null
    $archivePath = Join-Path $toolDirectory 'hugo.zip'
    $downloadUrl = "https://github.com/gohugoio/hugo/releases/download/v$hugoVersion/hugo_extended_${hugoVersion}_windows-amd64.zip"

    try {
        Invoke-WebRequest -Uri $downloadUrl -OutFile $archivePath
        Expand-Archive -LiteralPath $archivePath -DestinationPath $toolDirectory -Force
    }
    finally {
        if (Test-Path -LiteralPath $archivePath) {
            Remove-Item -LiteralPath $archivePath -Force
        }
    }
}

$installedVersion = & $hugoExecutable version
if ($LASTEXITCODE -ne 0 -or $installedVersion -notmatch "v$([regex]::Escape($hugoVersion))") {
    throw "The project-local Hugo installation could not be verified. Delete .tools and run this script again."
}

Write-Host ''
Write-Host 'Personal website preview is starting...' -ForegroundColor Green
Write-Host "Open $previewUrl" -ForegroundColor Green
Write-Host 'Changes will refresh automatically. Press Ctrl+C to stop.' -ForegroundColor DarkGray
Write-Host ''

$browserJob = $null
if (-not $NoBrowser) {
    $browserJob = Start-Job -ArgumentList $previewUrl -ScriptBlock {
        param($url)
        Start-Sleep -Seconds 3
        Start-Process $url
    }
}

try {
    & $hugoExecutable server `
        --baseURL $previewUrl `
        --bind 127.0.0.1 `
        --port $previewPort `
        --disableFastRender
}
finally {
    if ($null -ne $browserJob) {
        Stop-Job -Job $browserJob -ErrorAction SilentlyContinue
        Remove-Job -Job $browserJob -Force -ErrorAction SilentlyContinue
    }
}
