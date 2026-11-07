<#
.SYNOPSIS
    xMacro Live GitHub Sync Bridge
    Tự động kiểm tra và đồng bộ macro rotation từ kho lưu trữ GitHub BDMacro.
#>

[CmdletBinding()]
param(
    [string]$AddonDir,
    [string]$Repo = "PersonalProjectJob/BDMacro",
    [string]$Branch = "main",
    [int]$IntervalSec = 180,
    [switch]$Watch,
    [switch]$Once
)

$ErrorActionPreference = 'SilentlyContinue'

# Ép buộc TLS 1.2 cho kết nối an toàn tới GitHub API trên mọi phiên bản Windows
[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.SecurityProtocolType]::Tls12 -bor [System.Net.SecurityProtocolType]::Tls11 -bor [System.Net.SecurityProtocolType]::Tls

if (-not $AddonDir) {
    $parent = Split-Path -Parent $PSScriptRoot
    if ((Split-Path -Leaf $parent) -eq "xMacro") {
        $AddonDir = $parent
    } else {
        $AddonDir = [IO.Path]::GetFullPath((Join-Path $PSScriptRoot "..\..\interface\xMacro"))
    }
}
$AddonDir = [IO.Path]::GetFullPath($AddonDir)

$CommitFile = Join-Path $AddonDir "github_commit.txt"
$StatusFile = Join-Path $AddonDir "github_sync_status.jx3dat"
$RequestFile = Join-Path $AddonDir "github_sync_request.jx3dat"

function Write-SyncStatus([string]$status, [string]$sha, [string]$msg, [bool]$newUpdate) {
    $nowStr = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")
    $shortSha = if ($sha -and $sha.Length -ge 7) { $sha.Substring(0, 7) } else { $sha }
    $escapedMsg = if ($msg) { $msg.Replace('\', '\\').Replace('"', '\"').Replace("`r", "").Replace("`n", " ") } else { "" }
    $content = @"
return {
  ["status"] = "$status",
  ["sha"] = "$shortSha",
  ["full_sha"] = "$sha",
  ["message"] = "$escapedMsg",
  ["updated_at"] = "$nowStr",
  ["new_update"] = $(if ($newUpdate) { "true" } else { "false" })
}
"@
    $bytes = [Text.Encoding]::UTF8.GetBytes($content)
    $bom = [byte[]]@(0xEF, 0xBB, 0xBF)
    [IO.File]::WriteAllBytes($StatusFile, $bom + $bytes)
}

function Check-And-Update() {
    $currentSha = ""
    if (Test-Path -LiteralPath $CommitFile) {
        $currentSha = (Get-Content -LiteralPath $CommitFile -Raw).Trim()
    }

    $apiUrl = "https://api.github.com/repos/$Repo/commits/$Branch"
    $headers = @{
        "User-Agent" = "xMacro-BDMacro-SyncBridge"
        "Accept" = "application/vnd.github.v3+json"
    }

    try {
        $resp = Invoke-RestMethod -Uri $apiUrl -Headers $headers -TimeoutSec 15 -ErrorAction Stop
        $latestSha = $resp.sha
        $commitMsg = ($resp.commit.message -split "`n")[0]

        if (-not $latestSha) { return }

        if ($currentSha -ne $latestSha) {
            # Tải gói cập nhật ZIP chuẩn phát hành từ GitHub
            $zipUrl = "https://raw.githubusercontent.com/$Repo/$Branch/releases/xMacro-v80-HCNC-0.9.7-addon.zip"
            $tempZip = Join-Path $env:TEMP ("xmacro_update_" + [guid]::NewGuid().ToString("N") + ".zip")
            $tempExtract = Join-Path $env:TEMP ("xmacro_extract_" + [guid]::NewGuid().ToString("N"))

            try {
                Invoke-WebRequest -Uri $zipUrl -Headers $headers -OutFile $tempZip -TimeoutSec 40 -ErrorAction Stop
                
                # Giải nén tạm thời
                New-Item -ItemType Directory -Path $tempExtract -Force | Out-Null
                Expand-Archive -LiteralPath $tempZip -DestinationPath $tempExtract -Force

                $extractedAddon = Join-Path $tempExtract "interface\xMacro"
                if (Test-Path -LiteralPath $extractedAddon) {
                    # Cập nhật các Native modules (XM00..XM15)
                    $extractedNative = Join-Path $extractedAddon "Native"
                    $targetNative = Join-Path $AddonDir "Native"
                    if (Test-Path -LiteralPath $extractedNative) {
                        if (-not (Test-Path -LiteralPath $targetNative)) { New-Item -ItemType Directory -Path $targetNative -Force | Out-Null }
                        Copy-Item -Path (Join-Path $extractedNative "*") -Destination (Join-Path $targetNative "\") -Force
                    }

                    # Cập nhật Runtime.lua & info.ini
                    $extractedRuntime = Join-Path $extractedAddon "Runtime.lua"
                    if (Test-Path -LiteralPath $extractedRuntime) {
                        Copy-Item -Path $extractedRuntime -Destination (Join-Path $AddonDir "Runtime.lua") -Force
                    }
                    $extractedIni = Join-Path $extractedAddon "info.ini"
                    if (Test-Path -LiteralPath $extractedIni) {
                        Copy-Item -Path $extractedIni -Destination (Join-Path $AddonDir "info.ini") -Force
                    }

                    # Lưu SHA mới
                    Set-Content -LiteralPath $CommitFile -Value $latestSha -NoNewline

                    # Báo trạng thái thành công cho addon trong game
                    Write-SyncStatus -status "UPDATED" -sha $latestSha -msg $commitMsg -newUpdate $true
                    Write-Output ("[xMacro Sync] Updated to commit: " + $latestSha.Substring(0, 7) + " - " + $commitMsg)
                }
            } finally {
                if (Test-Path -LiteralPath $tempZip) { Remove-Item -LiteralPath $tempZip -Force }
                if (Test-Path -LiteralPath $tempExtract) { Remove-Item -LiteralPath $tempExtract -Recurse -Force }
            }
        } else {
            # Đã khớp bản mới nhất
            if (-not (Test-Path -LiteralPath $StatusFile)) {
                Write-SyncStatus -status "UP_TO_DATE" -sha $latestSha -msg $commitMsg -newUpdate $false
            }
        }
    } catch {
        # Bỏ qua lỗi mạng im lặng để không gián đoạn game
    }
}

# Đồng bộ lần đầu khi khởi động bridge
Check-And-Update

if ($Once) { exit 0 }

# Vòng lặp lắng nghe signal từ in-game /xmacro sync và định kỳ
$elapsed = 0
while ($true) {
    Start-Sleep -Seconds 3
    $elapsed += 3

    if (Test-Path -LiteralPath $RequestFile) {
        Remove-Item -LiteralPath $RequestFile -Force
        Check-And-Update
        $elapsed = 0
    }
    elseif ($elapsed -ge $IntervalSec) {
        Check-And-Update
        $elapsed = 0
    }
}
