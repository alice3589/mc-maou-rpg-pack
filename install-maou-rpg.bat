<# :
@echo off
setlocal
title Maou RPG 1.20.1 Forge installer
powershell -NoProfile -ExecutionPolicy Bypass -Command "$env:RPG_BAT='%~f0'; iex ([IO.File]::ReadAllText($env:RPG_BAT))"
echo.
pause
exit /b
#>
# ---------------------------------------------------------------------------
# Maou RPG pack installer (Minecraft 1.20.1 / Forge) for the official launcher.
# Everything below is PowerShell. The batch lines above run this file through
# PowerShell, so this one .bat file is all you need.
# ASCII only on purpose (Windows PowerShell 5.1 / cmd code pages).
# ---------------------------------------------------------------------------
$ErrorActionPreference = 'Stop'
$ProgressPreference = 'SilentlyContinue'
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

$PackVersion = '2.3.0'
$McVersion   = '1.20.1'
$ForgeBuild  = '47.4.29'
$ForgeSha1   = '5061de68499474cc8eeeede3d794afb063dd3e6d'
$ForgeVer    = "$McVersion-forge-$ForgeBuild"
$ForgeUrl    = "https://maven.minecraftforge.net/net/minecraftforge/forge/$McVersion-$ForgeBuild/forge-$McVersion-$ForgeBuild-installer.jar"
$JreUrl      = 'https://api.adoptium.net/v3/binary/latest/21/ga/windows/x64/jre/hotspot/normal/eclipse'
$ProfileId   = 'rpg-1201'
$ProfileName = [regex]::Unescape('\u9b54\u738b\u8a0e\u4f10RPG (1.20.1 Forge)')

if ($env:RPG_MC_DIR)   { $McDir = $env:RPG_MC_DIR }     else { $McDir = Join-Path $env:APPDATA '.minecraft' }
if ($env:RPG_GAME_DIR) { $GameDir = $env:RPG_GAME_DIR } else { $GameDir = Join-Path $env:APPDATA '.minecraft-rpg' }
$ProfilesJson = Join-Path $McDir 'launcher_profiles.json'
$Work = Join-Path $env:TEMP 'maou-rpg-installer'

# file name, download URL, SHA-1
$Mods = @(
    @('Terralith_1.20.x_v2.5.4.jar', 'https://cdn.modrinth.com/data/8oi3bsk5/versions/WeYhEb5d/Terralith_1.20.x_v2.5.4.jar', '79e1409b8db4ce86df9d6d6730f09c4bd8860a30'),
    @('tectonic-3.0.17-forge-1.20.1.jar', 'https://cdn.modrinth.com/data/lWDHr9jE/versions/KLmvRxwh/tectonic-3.0.17-forge-1.20.1.jar', '07bfe13bc1bd75a6277f3d62bf92a549b33067a9'),
    @('lithostitched-forge-1.20.1-1.4.12.jar', 'https://cdn.modrinth.com/data/XaDC71GB/versions/Uqt1Zm1l/lithostitched-forge-1.20.1-1.4.12.jar', 'c8a23f9c1975f11a8d10110aa862251a6043db78'),
    @('Incendium_1.20.x_v5.3.5.jar', 'https://cdn.modrinth.com/data/ZVzW5oNS/versions/uUqarp2H/Incendium_1.20.x_v5.3.5.jar', '484556937b1b2dde2682144e7953e79bff717104'),
    @('MinecraftCapes Forge 1.20.1-1.1.0.jar', 'https://cdn.modrinth.com/data/9gNVPfzw/versions/d5ILkObu/MinecraftCapes%20Forge%201.20.1-1.1.0.jar', '0bf2b5ce31b177b1472ed7f33b2e7452bcbf9955'),
    @('oculus-mc1.20.1-1.8.0.jar', 'https://cdn.modrinth.com/data/GchcoXML/versions/iQ1SwGc3/oculus-mc1.20.1-1.8.0.jar', '984f774e71790deaec674c7587bd24e0711871b2'),
    @('embeddium-0.3.31+mc1.20.1.jar', 'https://cdn.modrinth.com/data/sk9rgfiA/versions/UTbfe5d1/embeddium-0.3.31%2Bmc1.20.1.jar', 'bb2fa8f3e493af16af9160d049f96c614a1faf2f'),
    @('DistantHorizons-3.3.3-1.20.1-fabric-forge.jar', 'https://cdn.modrinth.com/data/uCdwusMi/versions/6UnEfsRQ/DistantHorizons-3.3.3-1.20.1-fabric-forge.jar', '5447c4716571bfdba817c85278a9ce0d411573ec'),
    @('ItemPhysicLite_FORGE_v1.6.13_mc1.20.1.jar', 'https://cdn.modrinth.com/data/OuyCgP8t/versions/frnHNN8n/ItemPhysicLite_FORGE_v1.6.13_mc1.20.1.jar', 'cd2e5d5f7406dc4a6bfa28873308a9f9d6a7e5a1'),
    @('CreativeCore_FORGE_v2.12.42_mc1.20.1.jar', 'https://cdn.modrinth.com/data/OsZiaDHq/versions/HGkNDl47/CreativeCore_FORGE_v2.12.42_mc1.20.1.jar', '1df289c0ac3ffb4b924eb73dc3d673af961479a8'),
    @('sound-physics-remastered-forge-1.20.1-1.5.1.jar', 'https://cdn.modrinth.com/data/qyVF9oeo/versions/x0sJ9PeR/sound-physics-remastered-forge-1.20.1-1.5.1.jar', '944b4673bcab118f411d050b2cd6b693262bb664'),
    @('firstperson-forge-2.7.3-mc1.20.1.jar', 'https://cdn.modrinth.com/data/H5XMjpHi/versions/kxFDUOmS/firstperson-forge-2.7.3-mc1.20.1.jar', '229a85332b026a027e960919a263742f1eafbbc2'),
    @('CameraOverhaul-v2.1.2-forge+mc[1.20-1.20.5].jar', 'https://cdn.modrinth.com/data/m0oRwcZx/versions/Apl3bbtA/CameraOverhaul-v2.1.2-forge%2Bmc%5B1.20-1.20.5%5D.jar', '2b9e4499b00449e670a9dd399dddbb9cd7c0e531'),
    @('notenoughanimations-forge-1.12.7-mc1.20.1.jar', 'https://cdn.modrinth.com/data/MPCX6s5C/versions/3YRHi2mE/notenoughanimations-forge-1.12.7-mc1.20.1.jar', '94b051bda7fd0e7f8e8b119db779d3a9c8730f80'),
    @('cloth-config-11.1.136-forge.jar', 'https://cdn.modrinth.com/data/9s6osm5g/versions/t8TXrZvZ/cloth-config-11.1.136-forge.jar', 'c65d07748acc57ceb45d53b3964368b84f34d54f'),
    @('mysterious_mountain_lib-1.6.34-1.20.1.jar', 'https://cdn.modrinth.com/data/ntMyNH8c/versions/m0IYPVS4/mysterious_mountain_lib-1.6.34-1.20.1.jar', '4fb6e35edf9384fde736cd9ee972468d65f61dce'),
    @('Cucumber-1.20.1-7.0.16.jar', 'https://cdn.modrinth.com/data/Rw1NrDzF/versions/xnLznSfT/Cucumber-1.20.1-7.0.16.jar', '88a9ec30e4acb5c80a3ae060ad70b79e945293c6'),
    @('bagus_lib-1.20.1-5.6.1.jar', 'https://cdn.modrinth.com/data/95nSN4Rd/versions/EutpppUn/bagus_lib-1.20.1-5.6.1.jar', 'd62b6b77efc3c6a25eb72b2f7bcf53b6d09d47ba'),
    @('MysticalAgradditions-1.20.1-7.0.12.jar', 'https://cdn.modrinth.com/data/pl0jGXIx/versions/48qKWNA7/MysticalAgradditions-1.20.1-7.0.12.jar', 'b4fcc78796a6e1f637523298cf7b3fe7f1dd3ed9'),
    @('MysticalAgriculture-1.20.1-7.0.24.jar', 'https://cdn.modrinth.com/data/C95ReXie/versions/EEilTecF/MysticalAgriculture-1.20.1-7.0.24.jar', 'e8839d207456a47ed6a576469901a087319b505f'),
    @('Sakura-1.1.16-1.20.1.jar', 'https://cdn.modrinth.com/data/U5QgI9Bi/versions/dNA724FP/Sakura-1.1.16-1.20.1.jar', '03ce0fdaf0827d39b6223556aac25b39f5309323'),
    @('TofuCraftReload-1.20.1-5.18.4.0.jar', 'https://cdn.modrinth.com/data/69rMY8bC/versions/WPZTUJy7/TofuCraftReload-1.20.1-5.18.4.0.jar', 'a3c1ef9f3d1f808f55ee34447747441e9f9f1195'),
    @('HeatAndClimate-1.20.1-v5.0.6.jar', 'https://mediafilez.forgecdn.net/files/9322/626/HeatAndClimate-1.20.1-v5.0.6.jar', 'f8e5dab4794c54fb3cff27ac6e814778bb416d38'),
    @('architectury-9.2.14-forge.jar', 'https://cdn.modrinth.com/data/lhGA9TYQ/versions/1MKTLiiG/architectury-9.2.14-forge.jar', 'a52918a500ff421180a1cbd1a0cabee712134ec4'),
    @('ftb-library-forge-2001.2.13.jar', 'https://mediafilez.forgecdn.net/files/8226/927/ftb-library-forge-2001.2.13.jar', 'a5427d5ff07eb044144ed0b54308370d88bce17e'),
    @('ftb-ultimine-forge-2001.1.8.jar', 'https://mediafilez.forgecdn.net/files/7880/472/ftb-ultimine-forge-2001.1.8.jar', 'c2a1eb72c36ad067faafbff4e1618c4db906de74'),
    @('LMML-1.20.1-8.3.1-Forge.jar', 'https://github.com/SistrScarlet/LittleMaidModelLoader-Architectury/releases/download/v8.3.1/LMML-1.20.1-8.3.1-Forge.jar', 'a3c3cf051dc6617338682e681ef2f90205c61c9f'),
    @('LMRB-1.20.1-8.11.1-Forge.jar', 'https://github.com/SistrScarlet/LittleMaidReBirth-Architectury/releases/download/v8.11.1/LMRB-1.20.1-8.11.1-Forge.jar', '7b6da1ab000f61d77e12d8b08c96ab29b0dbd727'),
    @('urushi-1.20.1-6.7.0.jar', 'https://mediafilez.forgecdn.net/files/9235/710/urushi-1.20.1-6.7.0.jar', '5f9be08bf26b7750029aed63d7d4c20688e7065f')
)
$Shader = @('ComplementaryUnbound_r5.10.zip', 'https://cdn.modrinth.com/data/R6NEzAwj/versions/QJiYQisE/ComplementaryUnbound_r5.10.zip', '7a9a6b667b89d6b442837c5c367cd6cc8356b400')
# Texture packs (resource packs): file name, download URL, SHA-1. They are merged into one pack
# ($MergedPackName) on this PC, and only that one is turned on in options.txt.
$Packs = @(
    @('NewGlowingOres-Border-1.3-1.20.zip', 'https://cdn.modrinth.com/data/oL18adaQ/versions/YoXl9tp0/NewGlowingOres%C2%A76%5BBV-1.3%5D%5B1.20%5D.zip', '5386de443f769021ac09e7be77f04faf4198b7bf'),
    @('PvPSwords-1.0.1.zip', 'https://cdn.modrinth.com/data/BpaObV8j/versions/m6EWsDYh/shorterswords.zip', '5a0a83f4ea4cd524fd1d9b4709720fd3743c20ab')
)
$MergedPackName = 'MaouRPG-Textures.zip'
$DhRenderDistance = 1024

function Say($t) { Write-Host $t }
function Fail($t) { Write-Host ''; Write-Host "[ERROR] $t" -ForegroundColor Red; exit 1 }
function Get-Sha1($p) { (Get-FileHash -Algorithm SHA1 -LiteralPath $p).Hash.ToLower() }

# launcher_profiles.json is read and written with .NET JavaScriptSerializer, not ConvertFrom-Json:
# PowerShell 5.1 ConvertFrom-Json stops when two keys differ only in case (e.g. profiles "Forge" and "forge").
Add-Type -AssemblyName System.Web.Extensions
function New-JsonSerializer {
    $s = New-Object System.Web.Script.Serialization.JavaScriptSerializer
    $s.MaxJsonLength = [int]::MaxValue
    $s.RecursionLimit = 512
    return $s
}
function Read-LauncherJson {
    $d = (New-JsonSerializer).DeserializeObject([IO.File]::ReadAllText($ProfilesJson, [Text.Encoding]::UTF8))
    if (-not ($d -is [System.Collections.Generic.Dictionary[string, object]])) { Fail "launcher_profiles.json is broken: $ProfilesJson" }
    return $d
}
function Write-LauncherJson($d) {
    [IO.File]::WriteAllText($ProfilesJson, (New-JsonSerializer).Serialize($d), (New-Object Text.UTF8Encoding $false))
}

# Download $url to $dest and check SHA-1. Skips the download when the file is already correct.
function Get-Verified($url, $dest, $sha1) {
    if ((Test-Path -LiteralPath $dest) -and ((Get-Sha1 $dest) -eq $sha1)) { return 'ok' }
    # temp name without [ ] (Invoke-WebRequest -OutFile treats them as wildcards)
    $tmp = Join-Path $Work ([guid]::NewGuid().ToString('N') + '.part')
    for ($i = 1; $i -le 3; $i++) {
        try {
            Invoke-WebRequest -Uri $url -OutFile $tmp -UseBasicParsing -UserAgent 'maou-rpg-installer'
            if ((Get-Sha1 $tmp) -eq $sha1) {
                if (Test-Path -LiteralPath $dest) { Remove-Item -LiteralPath $dest -Force }
                Move-Item -LiteralPath $tmp -Destination $dest
                return 'new'
            }
            Write-Host "    hash mismatch (try $i/3)" -ForegroundColor Yellow
        } catch {
            Write-Host "    download failed: $($_.Exception.Message) (try $i/3)" -ForegroundColor Yellow
        }
        Start-Sleep -Seconds 3
    }
    if (Test-Path -LiteralPath $tmp) { Remove-Item -LiteralPath $tmp -Force }
    Fail "Could not download: $url"
}

# Java major version from <java home>\release (0 if unknown)
function Get-JavaMajor($exe) {
    $jh = Split-Path (Split-Path $exe -Parent) -Parent
    $rel = Join-Path $jh 'release'
    if (-not (Test-Path -LiteralPath $rel)) { return 0 }
    $m = Select-String -LiteralPath $rel -Pattern 'JAVA_VERSION="(\d+)(?:\.(\d+))?' | Select-Object -First 1
    if (-not $m) { return 0 }
    $a = [int]$m.Matches[0].Groups[1].Value
    if ($a -eq 1) { return [int]$m.Matches[0].Groups[2].Value }
    return $a
}

function Find-Java17 {
    $cands = @()
    $cands += Get-Command java.exe -All -ErrorAction SilentlyContinue | ForEach-Object { $_.Source }
    $roots = @(
        (Join-Path $McDir 'runtime'),
        (Join-Path $env:LOCALAPPDATA 'Packages\Microsoft.4297127D64EC6_8wekyb3d8bbwe\LocalCache\Local\runtime'),
        (Join-Path ${env:ProgramFiles(x86)} 'Minecraft Launcher\runtime'),
        (Join-Path $env:ProgramFiles 'Java'),
        (Join-Path $env:ProgramFiles 'Eclipse Adoptium'),
        (Join-Path $env:ProgramFiles 'Zulu'),
        (Join-Path $Work 'jre')
    )
    foreach ($r in $roots) {
        if ($r -and (Test-Path -LiteralPath $r)) {
            $cands += Get-ChildItem -LiteralPath $r -Recurse -Filter java.exe -ErrorAction SilentlyContinue | ForEach-Object { $_.FullName }
        }
    }
    foreach ($c in $cands) { if ((Get-JavaMajor $c) -ge 17) { return $c } }
    return $null
}

Say "=== Maou RPG pack v$PackVersion installer (Minecraft $McVersion / Forge $ForgeBuild) ==="
Say ''

# --- 0. Checks ---
if (-not (Test-Path -LiteralPath $ProfilesJson)) {
    Fail "launcher_profiles.json not found in $McDir . Install the official Minecraft Launcher, log in and start it once, then run this again."
}
if ((-not $env:RPG_NO_PROCESS_CHECK) -and (Get-Process -Name 'Minecraft', 'MinecraftLauncher' -ErrorAction SilentlyContinue)) {
    Fail 'Please close the Minecraft Launcher (and the game) first, then run this again.'
}
New-Item -ItemType Directory -Force -Path $Work | Out-Null

# --- 1. Forge ---
$ForgeJson = Join-Path $McDir "versions\$ForgeVer\$ForgeVer.json"
$ForgeJustInstalled = $false
$OldForgeProfile = $null
if (Test-Path -LiteralPath $ForgeJson) {
    Say "[1/4] Forge $ForgeVer is already installed."
} else {
    Say "[1/4] Installing Forge $ForgeVer (this can take several minutes) ..."
    $java = Find-Java17
    if (-not $java) {
        Say '    Java 17+ not found. Downloading a temporary Java 21 (Eclipse Temurin) ...'
        $zip = Join-Path $Work 'jre.zip'
        Invoke-WebRequest -Uri $JreUrl -OutFile $zip -UseBasicParsing -UserAgent 'maou-rpg-installer'
        $jreDir = Join-Path $Work 'jre'
        if (Test-Path -LiteralPath $jreDir) { Remove-Item -LiteralPath $jreDir -Recurse -Force }
        Expand-Archive -LiteralPath $zip -DestinationPath $jreDir
        $java = Find-Java17
        if (-not $java) { Fail 'Could not prepare Java. Install Java 17 or newer and run this again.' }
    }
    Say "    Java: $java"
    # The Forge installer overwrites the launcher profile named "forge". Remember it to put it back later.
    $before = Read-LauncherJson
    $bp = $before['profiles']
    if ($bp -and $bp.ContainsKey('forge')) { $OldForgeProfile = $bp['forge'] }
    Copy-Item -LiteralPath $ProfilesJson -Destination ($ProfilesJson + '.bak-maou-rpg') -Force

    $inst = Join-Path $Work "forge-$McVersion-$ForgeBuild-installer.jar"
    Get-Verified $ForgeUrl $inst $ForgeSha1 | Out-Null
    & $java -jar $inst --installClient $McDir
    if (-not (Test-Path -LiteralPath $ForgeJson)) { Fail 'Forge install failed. See the messages above.' }
    $ForgeJustInstalled = $true
}

# --- 2. Mods (own game folder; your normal .minecraft mods are not touched) ---
$ModsDir = Join-Path $GameDir 'mods'
New-Item -ItemType Directory -Force -Path $ModsDir, (Join-Path $GameDir 'shaderpacks'), (Join-Path $GameDir 'config') | Out-Null
Say "[2/4] Downloading $($Mods.Count) mods to $ModsDir ..."
$ListFile = Join-Path $ModsDir '.maou-rpg-pack.txt'
$wanted = @($Mods | ForEach-Object { $_[0] })
if (Test-Path -LiteralPath $ListFile) {
    # Remove old pack files that are not in this version (mods you added yourself are kept)
    foreach ($old in (Get-Content -LiteralPath $ListFile -Encoding UTF8)) {
        if ($old -and ($wanted -notcontains $old)) {
            $op = Join-Path $ModsDir $old
            if (Test-Path -LiteralPath $op) { Remove-Item -LiteralPath $op -Force; Say "    removed old: $old" }
        }
    }
}
$i = 0
foreach ($m in $Mods) {
    $i++
    $r = Get-Verified $m[1] (Join-Path $ModsDir $m[0]) $m[2]
    Say ("    [{0,2}/{1}] {2} {3}" -f $i, $Mods.Count, $r.PadRight(3), $m[0])
}
[IO.File]::WriteAllLines($ListFile, [string[]]$wanted, (New-Object Text.UTF8Encoding $false))

# --- 3. Shaders + first-time settings ---
Say '[3/4] Shaders (Oculus + Complementary Unbound), texture packs, settings ...'
Get-Verified $Shader[1] (Join-Path $GameDir ('shaderpacks\' + $Shader[0])) $Shader[2] | Out-Null
$oc = Join-Path $GameDir 'config\oculus.properties'
if (-not (Test-Path -LiteralPath $oc)) {
    [IO.File]::WriteAllText($oc, "shaderPack=$($Shader[0])`nenableShaders=true`n")
}
$opt = Join-Path $GameDir 'options.txt'
if (-not (Test-Path -LiteralPath $opt)) { [IO.File]::WriteAllText($opt, "lang:ja_jp`n") }

# Texture packs (v2.1.0~): download the packs into a cache folder, then merge them into ONE pack
# on this PC (the merged file is never uploaded anywhere, because PvP Swords may not be redistributed).
$PackDir = Join-Path $GameDir 'resourcepacks'
$PackCache = Join-Path $GameDir 'maou-rpg-packs'
New-Item -ItemType Directory -Force -Path $PackDir, $PackCache | Out-Null
foreach ($pk in $Packs) {
    $old = Join-Path $PackDir $pk[0]   # v1.8.0-v2.0.0 put the packs straight into resourcepacks
    $dst = Join-Path $PackCache $pk[0]
    if ((Test-Path -LiteralPath $old) -and -not (Test-Path -LiteralPath $dst)) { Move-Item -LiteralPath $old -Destination $dst }
    elseif (Test-Path -LiteralPath $old) { Remove-Item -LiteralPath $old -Force }
    $r = Get-Verified $pk[1] $dst $pk[2]
    Say ("    texture pack {0} {1}" -f $r.PadRight(3), $pk[0])
}
Add-Type -AssemblyName System.IO.Compression, System.IO.Compression.FileSystem
$Merged = Join-Path $PackDir $MergedPackName
$mtmp = "$Merged.tmp"
if (Test-Path -LiteralPath $mtmp) { Remove-Item -LiteralPath $mtmp -Force }
$fs = [IO.File]::Open($mtmp, 'Create')
$zout = New-Object IO.Compression.ZipArchive($fs, [IO.Compression.ZipArchiveMode]::Create)
$done = New-Object 'System.Collections.Generic.HashSet[string]'
function Add-ZipText($name, $text) {
    $e = $zout.CreateEntry($name)
    $w = New-Object IO.StreamWriter($e.Open(), (New-Object Text.UTF8Encoding $false))
    $w.Write($text); $w.Dispose()
    [void]$done.Add($name)
}
Add-ZipText 'pack.mcmeta' "{`n  `"pack`": {`n    `"pack_format`": 15,`n    `"description`": `"Maou RPG textures: New Glowing Ores + PvP Swords`"`n  }`n}`n"
Add-ZipText 'credits.txt' ("This pack was made on your PC by install-maou-rpg.bat from these packs:`n" +
    "- New Glowing Ores (Border, v1.3) by GridExpert - CC BY-NC-SA 4.0 - https://modrinth.com/resourcepack/new-glowing-ores`n" +
    "- PvP Swords (v1.0.1) - All Rights Reserved - https://modrinth.com/resourcepack/short-pvp-swords`n" +
    "Do not share this file. PvP Swords may not be redistributed.`n")
foreach ($pk in $Packs) {
    $zin = [IO.Compression.ZipFile]::OpenRead((Join-Path $PackCache $pk[0]))
    try {
        foreach ($e in $zin.Entries) {
            if ($e.FullName.EndsWith('/') -or $e.FullName -eq 'pack.mcmeta') { continue }
            if (-not $done.Add($e.FullName)) { continue }   # first pack wins (only pack.png is in both)
            $ne = $zout.CreateEntry($e.FullName)
            $src = $e.Open(); $dstS = $ne.Open()
            $src.CopyTo($dstS); $dstS.Dispose(); $src.Dispose()
        }
    } finally { $zin.Dispose() }
}
$zout.Dispose(); $fs.Dispose()
Move-Item -LiteralPath $mtmp -Destination $Merged -Force
Say "    texture packs merged into one: $MergedPackName"
$lines = [System.Collections.Generic.List[string]]([IO.File]::ReadAllLines($opt))
$idx = -1
for ($k = 0; $k -lt $lines.Count; $k++) { if ($lines[$k].StartsWith('resourcePacks:')) { $idx = $k; break } }
$sel = New-Object System.Collections.Generic.List[string]
if ($idx -ge 0) {
    $parsed = ConvertFrom-Json -InputObject $lines[$idx].Substring(14)
    foreach ($s in $parsed) { if ($s) { $sel.Add([string]$s) } }
} else {
    $sel.Add('vanilla'); $sel.Add('mod_resources')
}
foreach ($pk in $Packs) { [void]$sel.Remove('file/' + $pk[0]) }   # the 2 separate packs (v1.8.0-v2.0.0)
if (-not $sel.Contains("file/$MergedPackName")) { $sel.Add("file/$MergedPackName") }
$packLine = 'resourcePacks:' + (ConvertTo-Json -InputObject ([string[]]$sel.ToArray()) -Compress)
if ($idx -ge 0) { $lines[$idx] = $packLine } else { $lines.Add($packLine) }
$inc = -1
for ($k = 0; $k -lt $lines.Count; $k++) { if ($lines[$k].StartsWith('incompatibleResourcePacks:')) { $inc = $k; break } }
if ($inc -ge 0) {
    $il = New-Object System.Collections.Generic.List[string]
    foreach ($s in (ConvertFrom-Json -InputObject $lines[$inc].Substring(26))) { if ($s) { $il.Add([string]$s) } }
    foreach ($pk in $Packs) { [void]$il.Remove('file/' + $pk[0]) }
    $lines[$inc] = 'incompatibleResourcePacks:' + (ConvertTo-Json -InputObject ([string[]]$il.ToArray()) -Compress)
}
[IO.File]::WriteAllLines($opt, [string[]]$lines.ToArray(), (New-Object Text.UTF8Encoding $false))
Say "    texture pack turned on ($MergedPackName)"

# Distant Horizons: LOD render distance
$Dh = Join-Path $GameDir 'config\DistantHorizons.toml'
if (Test-Path -LiteralPath $Dh) {
    $t = [IO.File]::ReadAllText($Dh)
    $t2 = [regex]::Replace($t, '(?m)^(\s*lodChunkRenderDistanceRadius\s*=\s*)\d+', ('${1}' + $DhRenderDistance))
    if ($t2 -ne $t) { [IO.File]::WriteAllText($Dh, $t2) }
} else {
    # Distant Horizons fills in the other settings on first start
    [IO.File]::WriteAllText($Dh, "_version = 5`n`n[client.advanced.graphics.quality]`n`tlodChunkRenderDistanceRadius = $DhRenderDistance`n")
}
Say "    Distant Horizons: render distance $DhRenderDistance chunks"

# Heat and Climate (v2.0.0~): seasons, weather and crop climate stay, but body temperature is off:
# climate damage (common, the server's file decides on a server) and the climate HUD (client) are turned off.
# If a file does not exist yet, write only that option; Forge fills in the rest with defaults on first start.
function Set-HacOption($file, $section, $key, $value) {
    $line = "`t""$key"" = $value"
    if (Test-Path -LiteralPath $file) {
        $t = [IO.File]::ReadAllText($file)
        $t2 = [regex]::Replace($t, '(?m)^(\s*"' + [regex]::Escape($key) + '"\s*=\s*)\S+', ('${1}' + $value))
        if ($t2 -ne $t) { [IO.File]::WriteAllText($file, $t2) }
    } else {
        [IO.File]::WriteAllText($file, "[$section]`n$line`n")
    }
}
Set-HacOption (Join-Path $GameDir 'config\dcs_climate-common.toml') 'climate_config' 'Enable Climate Damage' 'false'
Set-HacOption (Join-Path $GameDir 'config\dcs_climate-client.toml') 'render_config' 'Show Climate HUD' 'false'
Say '    Heat and Climate: climate damage off, climate HUD off (seasons and crops stay)'

# --- 4. Launcher profile ---
Say '[4/4] Adding the launcher profile ...'
$ramGB = [math]::Floor((Get-CimInstance Win32_ComputerSystem).TotalPhysicalMemory / 1GB)
if ($ramGB -ge 16) { $xmx = 8 } elseif ($ramGB -ge 12) { $xmx = 6 } else { $xmx = 4 }
$json = Read-LauncherJson
if (-not $json.ContainsKey('profiles')) { $json['profiles'] = [System.Collections.Generic.Dictionary[string,object]]::new() }
$profiles = $json['profiles']
if ($ForgeJustInstalled) {
    [void]$profiles.Remove('forge')
    if ($OldForgeProfile) { $profiles['forge'] = $OldForgeProfile }
}
$now = (Get-Date).ToUniversalTime().ToString('yyyy-MM-ddTHH:mm:ss.000Z')
$created = $now
$javaArgs = "-Xmx${xmx}G -Xms2G"
if ($profiles.ContainsKey($ProfileId)) {
    $prev = $profiles[$ProfileId]
    if ($prev.ContainsKey('created') -and $prev['created']) { $created = $prev['created'] }
    if ($prev.ContainsKey('javaArgs') -and $prev['javaArgs']) { $javaArgs = $prev['javaArgs'] }   # keep your own memory setting
}
$prof = [System.Collections.Generic.Dictionary[string,object]]::new()
# [string] casts: values from cmdlets (Join-Path etc.) are PSObject-wrapped and JavaScriptSerializer cannot write those
$prof['name']          = [string]$ProfileName
$prof['type']          = 'custom'
$prof['created']       = [string]$created
$prof['lastUsed']      = [string]$now
$prof['icon']          = 'Redstone_Block'
$prof['lastVersionId'] = [string]$ForgeVer
$prof['gameDir']       = [string]$GameDir
$prof['javaArgs']      = [string]$javaArgs
$profiles[$ProfileId] = $prof
Write-LauncherJson $json

Say ''
Say 'DONE.'
Say "  Open the Minecraft Launcher, pick the profile 'Maou...RPG (1.20.1 Forge)' (red block icon), press Play."
Say "  Game folder: $GameDir   Memory: $javaArgs"
Say '  Your normal .minecraft mods and worlds were not changed.'
exit 0
