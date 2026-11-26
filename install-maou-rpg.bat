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

$PackVersion = '1.13.4'
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
    @('L_Enders_Cataclysm-3.31.jar', 'https://cdn.modrinth.com/data/46KJle7n/versions/C3H0azzB/L_Enders_Cataclysm-3.31.jar', '4f1165cb39521292e826b471b4808bb89f0f4f3f'),
    @('Mutant Iceologer 2.0.2.jar', 'https://cdn.modrinth.com/data/9lbfIPsl/versions/JKht7D2L/Mutant%20Iceologer%202.0.2.jar', 'b6922c916f99ccacdce04b22e334c30709a533c0'),
    @('irons_rpg_tweaks-1.20.1-2.2.3.jar', 'https://cdn.modrinth.com/data/otXdBiS4/versions/MzBQUoDf/irons_rpg_tweaks-1.20.1-2.2.3.jar', '610d660a9044fa15a07f84cec59c01ab5dfc7fed'),
    @('l2hostility-2.5.19.jar', 'https://cdn.modrinth.com/data/CbV689EN/versions/ou0FsY4Y/l2hostility-2.5.19.jar', 'c6ffd9632fd372e83e1ef4d3cc35c8d3c4e15be7'),
    @('irons_spellbooks-1.20.1-3.16.4.jar', 'https://cdn.modrinth.com/data/s4OWxYQQ/versions/cBUZsds9/irons_spellbooks-1.20.1-3.16.4.jar', '7b41fc23ef37f9fa6f1ba747e5d24dae8ac4c3ed'),
    @('puffish_attributes-0.8.2-1.20-forge.jar', 'https://cdn.modrinth.com/data/FCFcFw09/versions/IG5KY4Qf/puffish_attributes-0.8.2-1.20-forge.jar', 'c6ff07c4ee3111b480fee577cb98c3671cf063b8'),
    @('incontrol-1.20-9.5.1.jar', 'https://cdn.modrinth.com/data/KpICtuVx/versions/gkF4yuGW/incontrol-1.20-9.5.1.jar', '57db24e561a4aa373ca6832816e010ed03bd6a1a'),
    @('l2artifacts-2.4.28.jar', 'https://cdn.modrinth.com/data/8RtpLoXH/versions/J6xK6xft/l2artifacts-2.4.28.jar', '0b70963d598fb41a0a235c28bfec57e3cdfbdb55'),
    @('AttributeFix-Forge-1.20.1-21.0.5.jar', 'https://cdn.modrinth.com/data/lOOpEntO/versions/ihWybkI9/AttributeFix-Forge-1.20.1-21.0.5.jar', '76d6b2d0f2a3c9842587ad20666ba419cd8c1efa'),
    @('enhancedai-3.3.7.5.jar', 'https://cdn.modrinth.com/data/TDdoftI1/versions/FNZd08F4/enhancedai-3.3.7.5.jar', '8cb138410fd857d457a26eca5315546fd0417319'),
    @('insanelib-1.23.4.6.jar', 'https://cdn.modrinth.com/data/USZyvOJq/versions/azl3fnxF/insanelib-1.23.4.6.jar', 'cca086a7ff34c4ffadb3caf3e825acb87f7e7322'),
    @('eh2.0-forge1.20.1.jar', 'https://cdn.modrinth.com/data/WzjqFyWg/versions/ik3VZul9/eh2.0-forge1.20.1.jar', '3bcc0609965bb082764f43c75020b33e95bdda88'),
    @('puffish_skills-0.19.2-1.20-forge.jar', 'https://cdn.modrinth.com/data/hqQqvaa4/versions/zfbPzmtb/puffish_skills-0.19.2-1.20-forge.jar', '7646e1a377506dcdd6d3b0806321ba429392155a'),
    @('default_skill_trees-1.1.jar', 'https://cdn.modrinth.com/data/4w7YR25f/versions/x7XL8Z3U/default_skill_trees-1.1.jar', '564a1320a4d26de1ad476687ce1920ccd12c142c'),
    @('Explorify v1.6.6.mod.jar', 'https://cdn.modrinth.com/data/HSfsxuTo/versions/oyrAnNG8/Explorify%20v1.6.6.mod.jar', 'd7b21626ad33d898536634764cec6c9a8cd55063'),
    @('deepwaters-25_5 forge 1_20_1.jar', 'https://cdn.modrinth.com/data/buvNMuzc/versions/3o5AjcRZ/deepwaters-25_5%20forge%201_20_1.jar', 'e59c6b5cda6642f2f502de72eb3efe3c8f255d92'),
    @('Stellarity-v2-0e.jar', 'https://cdn.modrinth.com/data/bZgeDzN8/versions/RKcXZAPf/Stellarity-v2-0e.jar', 'd54f54446b7afaed0c7bdf9679bc376f4913d16c'),
    @('MoogsNetherStructures-universal-1.20-3.1.0.jar', 'https://cdn.modrinth.com/data/nGUXvjTa/versions/bcwhyj8t/MoogsNetherStructures-universal-1.20-3.1.0.jar', 'fcfef161397f7865e3a6642c5170cd13fd7ad9ef'),
    @('Better_Trial_Chambers_1.2.0_version_1.20.1.jar', 'https://cdn.modrinth.com/data/llAgr1pa/versions/FYdegIUn/Better_Trial_Chambers_1.2.0_version_1.20.1.jar', '16d450e25ee667cb5cec5ae87006019db902ab48'),
    @('integrated_stronghold-1.1.1+1.20.1-forge.jar', 'https://cdn.modrinth.com/data/KUJdfPQz/versions/HX8UIG5u/integrated_stronghold-1.1.1%2B1.20.1-forge.jar', 'bfc95490873ae0563c9df4613f7ad70f3b17b402'),
    @('MoogsEndStructures-universal-1.20-2.1.0.jar', 'https://cdn.modrinth.com/data/r4PuRGfV/versions/ROvChtQg/MoogsEndStructures-universal-1.20-2.1.0.jar', 'a581935313f819fe67bbe810e03fb8a44b356089'),
    @('endrem_forge-5.3.3-R-1.20.1.jar', 'https://cdn.modrinth.com/data/ZJTGwAND/versions/SQS2aSUl/endrem_forge-5.3.3-R-1.20.1.jar', 'b4df41de8439e834a493fe59842709ef33ecfa82'),
    @('feur_extension_fossil-1.20.1-forge.jar', 'https://cdn.modrinth.com/data/yGr5XHdT/versions/flNgX6Hq/feur_extension_fossil-1.20.1-forge.jar', '30924088094cecbc8837a8c21f3c55fedcd63450'),
    @('alekiNiftyShips-FORGE-1.20.1-1.0.14.jar', 'https://cdn.modrinth.com/data/vuNeeDyl/versions/VX4fjmf1/alekiNiftyShips-FORGE-1.20.1-1.0.14.jar', 'c42aaab43cd524c45c4065996cc06b9b48c5682a'),
    @('Terralith_1.20.x_v2.5.4.jar', 'https://cdn.modrinth.com/data/8oi3bsk5/versions/WeYhEb5d/Terralith_1.20.x_v2.5.4.jar', '79e1409b8db4ce86df9d6d6730f09c4bd8860a30'),
    @('tectonic-3.0.17-forge-1.20.1.jar', 'https://cdn.modrinth.com/data/lWDHr9jE/versions/KLmvRxwh/tectonic-3.0.17-forge-1.20.1.jar', '07bfe13bc1bd75a6277f3d62bf92a549b33067a9'),
    @('lithostitched-forge-1.20.1-1.4.12.jar', 'https://cdn.modrinth.com/data/XaDC71GB/versions/Uqt1Zm1l/lithostitched-forge-1.20.1-1.4.12.jar', 'c8a23f9c1975f11a8d10110aa862251a6043db78'),
    @('Incendium_1.20.x_v5.3.5.jar', 'https://cdn.modrinth.com/data/ZVzW5oNS/versions/uUqarp2H/Incendium_1.20.x_v5.3.5.jar', '484556937b1b2dde2682144e7953e79bff717104'),
    @('fantasy-armor-1.3.1-1.20.1-forge.jar', 'https://cdn.modrinth.com/data/oVmpjYQ5/versions/e2QSYfvf/fantasy-armor-1.3.1-1.20.1-forge.jar', '270d1b008faf53015a4223923671d9e375e9ff81'),
    @('wider_ender_chests-forge-1.20.1-1.0.4.jar', 'https://cdn.modrinth.com/data/EDVt0J2I/versions/D91QPP3a/wider_ender_chests-forge-1.20.1-1.0.4.jar', '4bf753f31205a66a5502ba1875f7daf011e94e67'),
    @('Pehkui-3.8.2+1.20.1-forge.jar', 'https://cdn.modrinth.com/data/t5W7Jfwy/versions/SQpqSgAE/Pehkui-3.8.2%2B1.20.1-forge.jar', '4bc816efdd8e5e2a97423313674401351710e403'),
    @('ToughAsNails-forge-1.20.1-9.2.0.171.jar', 'https://cdn.modrinth.com/data/ge1sOdFH/versions/kWVOI0iS/ToughAsNails-forge-1.20.1-9.2.0.171.jar', '2aa5d544d8bdfebd4f258899b008f8e7e252167a'),
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
    @('curios-forge-5.14.1+1.20.1.jar', 'https://cdn.modrinth.com/data/vvuO3ImH/versions/IPQlZkz1/curios-forge-5.14.1%2B1.20.1.jar', '452175b95ad3db6ff58bb8968f6bf7a9d1e0f480'),
    @('geckolib-forge-1.20.1-4.8.5.jar', 'https://cdn.modrinth.com/data/8BmcQJ2H/versions/dBtjgm8n/geckolib-forge-1.20.1-4.8.5.jar', 'a117dc87ce46a5ea0da0f549199d2e80e81a26fe'),
    @('lionfishapi-3.0.jar', 'https://cdn.modrinth.com/data/FoVacERa/versions/CPftDBcY/lionfishapi-3.0.jar', '79d0404f87fa066480b18c844c1e0b1c5f5475f9'),
    @('l2library-2.5.7.jar', 'https://cdn.modrinth.com/data/4Vh3BQ3F/versions/sQK4WsgJ/l2library-2.5.7.jar', 'a5c488b8ded665d33add1e5bc58b823ef4b70883'),
    @('l2complements-2.6.1.jar', 'https://cdn.modrinth.com/data/oPrh2Lz3/versions/TvdiYrC4/l2complements-2.6.1.jar', '7f00690dcc850e65cae7fc6012cec37fee8664b0'),
    @('Patchouli-1.20.1-85-FORGE.jar', 'https://cdn.modrinth.com/data/nU0bVIaL/versions/94dtOLgZ/Patchouli-1.20.1-85-FORGE.jar', 'd4614507d6e4c7cb464bba5eca891978272062ef'),
    @('MoogsStructureLib-forge-1.20-3.4.2.jar', 'https://cdn.modrinth.com/data/1oUDhxuy/versions/zuKYMmUt/MoogsStructureLib-forge-1.20-3.4.2.jar', 'f91a62466de6e9b3a1166a1e88a837668cbb6eae'),
    @('integrated_api-forge-1.20.1-1.9.2.jar', 'https://cdn.modrinth.com/data/V6fKbpBN/versions/4x5T8HMF/integrated_api-forge-1.20.1-1.9.2.jar', '986d3db1bd31af79b3c27d26197f249babf597ad'),
    @('GlitchCore-forge-1.20.1-0.0.1.1.jar', 'https://cdn.modrinth.com/data/s3dmwKy5/versions/pYPZ5MNI/GlitchCore-forge-1.20.1-0.0.1.1.jar', 'bba0b08fe76b28b35243fee53f99d54a18153b53'),
    @('caelus-forge-3.2.0+1.20.1.jar', 'https://cdn.modrinth.com/data/40FYwb4z/versions/mRry0DgY/caelus-forge-3.2.0%2B1.20.1.jar', 'd14e8ee892d4d8764f523ad0e89bdcfc061fb007'),
    @('player-animation-lib-forge-1.0.2-rc1+1.20.jar', 'https://cdn.modrinth.com/data/gedNE4y2/versions/xe2EVE6q/player-animation-lib-forge-1.0.2-rc1%2B1.20.jar', '16808f94a41d45d8e986b4e4ea6b02ba57fa058a'),
    @('irons_lib-1.20.1-2.4.0.jar', 'https://cdn.modrinth.com/data/9nfaJPtX/versions/GxKHQobH/irons_lib-1.20.1-2.4.0.jar', '30f90c83ac5a2c0f1ccc9a11666a1d5469b524c0'),
    @('create-1.20.1-6.0.8.jar', 'https://cdn.modrinth.com/data/LNytGWDc/versions/8amzvn9x/create-1.20.1-6.0.8.jar', 'b13d912b9247a38d66d11598c121442585a1c1e9'),
    @('supplementaries-1.20-3.1.45-forge.jar', 'https://cdn.modrinth.com/data/fFEIiSDQ/versions/geO7x6Vi/supplementaries-1.20-3.1.45-forge.jar', 'cca362c149570e3926aac82be199d66aaf94928a'),
    @('Quark-4.0-462.jar', 'https://cdn.modrinth.com/data/qnQsVE2z/versions/DijQLauD/Quark-4.0-462.jar', '9b0fb82995622a0070c00827c698c43b49d9d14b'),
    @('Zeta-1.0-31.jar', 'https://cdn.modrinth.com/data/MVARlG2f/versions/mSER3jBI/Zeta-1.0-31.jar', '8c4a8ef0444b53ff408d5b89126285031081d92f'),
    @('moonlight-1.20-2.16.39-forge.jar', 'https://cdn.modrinth.com/data/twkfQtEc/versions/rF6052yd/moonlight-1.20-2.16.39-forge.jar', '12405de298c0d6c8ba53effdc5c8f28edee3aadc'),
    @('solcarrot-1.20.1-1.15.1.jar', 'https://mediafilez.forgecdn.net/files/4888/575/solcarrot-1.20.1-1.15.1.jar', 'f7fa1fd0c633b10f98d7f0f97766b95aac1a2dc0'),
    @('PeyroScythe-Forge-1.20.1-1.3.3.jar', 'https://mediafilez.forgecdn.net/files/8220/963/PeyroScythe-Forge-1.20.1-1.3.3.jar', '70cbd842c70c2f3967177ce60feabc8a2b60012f'),
    @('architectury-9.1.13-forge.jar', 'https://cdn.modrinth.com/data/lhGA9TYQ/versions/tBWqtdBO/architectury-9.1.13-forge.jar', 'ef7558f149fc5db623f15aa7bf942f7ead5b8f0d'),
    @('letsdo-API-forge-1.2.15-forge.jar', 'https://cdn.modrinth.com/data/4XJZeZbM/versions/uEaTMht9/letsdo-API-forge-1.2.15-forge.jar', 'a261043a45097d861a13a63ebdbb0ca350e06a63'),
    @('mysterious_mountain_lib-1.6.34-1.20.1.jar', 'https://cdn.modrinth.com/data/ntMyNH8c/versions/m0IYPVS4/mysterious_mountain_lib-1.6.34-1.20.1.jar', '4fb6e35edf9384fde736cd9ee972468d65f61dce'),
    @('Cucumber-1.20.1-7.0.16.jar', 'https://cdn.modrinth.com/data/Rw1NrDzF/versions/xnLznSfT/Cucumber-1.20.1-7.0.16.jar', '88a9ec30e4acb5c80a3ae060ad70b79e945293c6'),
    @('balm-forge-1.20.1-7.3.44.jar', 'https://mediafilez.forgecdn.net/files/8969/708/balm-forge-1.20.1-7.3.44.jar', 'b3f8a6a5823d3b4f2dce19c8aea9373e24bcb443'),
    @('bagus_lib-1.20.1-5.6.1.jar', 'https://cdn.modrinth.com/data/95nSN4Rd/versions/EutpppUn/bagus_lib-1.20.1-5.6.1.jar', 'd62b6b77efc3c6a25eb72b2f7bcf53b6d09d47ba'),
    @('BetterAdvancements-Forge-1.20.1-0.4.2.60.jar', 'https://cdn.modrinth.com/data/Q2OqKxDG/versions/EKwDaD23/BetterAdvancements-Forge-1.20.1-0.4.2.60.jar', '42be4c5315133a8059c27e15c41b22edc26e9a98'),
    @('cookingforblockheads-forge-1.20.1-16.0.16.jar', 'https://mediafilez.forgecdn.net/files/9647/269/cookingforblockheads-forge-1.20.1-16.0.16.jar', 'bec451505c1173cccb6dcd648d8ccf53d72a95cf'),
    @('letsdo-bakery-forge-1.1.15.jar', 'https://cdn.modrinth.com/data/WFwYiVoG/versions/Jo8EwiDR/letsdo-bakery-forge-1.1.15.jar', 'c5cd44088089fca03f3291b851dcb0d00018fecb'),
    @('letsdo-brewery-forge-1.1.9.jar', 'https://cdn.modrinth.com/data/cV5LQXKx/versions/vqYszE4F/letsdo-brewery-forge-1.1.9.jar', '50e5181e734dcfc599aa0eaac376ff4e312f63c2'),
    @('letsdo-herbalbrews-forge-1.0.12.jar', 'https://cdn.modrinth.com/data/Eh11TaTm/versions/qKfEj2BA/letsdo-herbalbrews-forge-1.0.12.jar', '3de7feb383868a0db45351580d6ef5b05b776f16'),
    @('letsdo-vinery-forge-1.4.41.jar', 'https://cdn.modrinth.com/data/1DWmBJVA/versions/2I4cH49O/letsdo-vinery-forge-1.4.41.jar', '68ed3fa9524bef601064f49f60a30423db2f8fdc'),
    @('MysticalAgradditions-1.20.1-7.0.12.jar', 'https://cdn.modrinth.com/data/pl0jGXIx/versions/48qKWNA7/MysticalAgradditions-1.20.1-7.0.12.jar', 'b4fcc78796a6e1f637523298cf7b3fe7f1dd3ed9'),
    @('MysticalAgriculture-1.20.1-7.0.24.jar', 'https://cdn.modrinth.com/data/C95ReXie/versions/EEilTecF/MysticalAgriculture-1.20.1-7.0.24.jar', 'e8839d207456a47ed6a576469901a087319b505f'),
    @('Sakura-1.1.16-1.20.1.jar', 'https://cdn.modrinth.com/data/U5QgI9Bi/versions/dNA724FP/Sakura-1.1.16-1.20.1.jar', '03ce0fdaf0827d39b6223556aac25b39f5309323'),
    @('TofuCraftReload-1.20.1-5.18.4.0.jar', 'https://cdn.modrinth.com/data/69rMY8bC/versions/WPZTUJy7/TofuCraftReload-1.20.1-5.18.4.0.jar', 'a3c1ef9f3d1f808f55ee34447747441e9f9f1195'),
    @('urushi-1.20.1-6.7.0.jar', 'https://mediafilez.forgecdn.net/files/9235/710/urushi-1.20.1-6.7.0.jar', '5f9be08bf26b7750029aed63d7d4c20688e7065f')
)
$Shader = @('ComplementaryUnbound_r5.10.zip', 'https://cdn.modrinth.com/data/R6NEzAwj/versions/QJiYQisE/ComplementaryUnbound_r5.10.zip', '7a9a6b667b89d6b442837c5c367cd6cc8356b400')
# Texture packs (resource packs): file name, download URL, SHA-1. Turned on in options.txt.
$Packs = @(
    @('NewGlowingOres-Border-1.3-1.20.zip', 'https://cdn.modrinth.com/data/oL18adaQ/versions/YoXl9tp0/NewGlowingOres%C2%A76%5BBV-1.3%5D%5B1.20%5D.zip', '5386de443f769021ac09e7be77f04faf4198b7bf'),
    @('PvPSwords-1.0.1.zip', 'https://cdn.modrinth.com/data/BpaObV8j/versions/m6EWsDYh/shorterswords.zip', '5a0a83f4ea4cd524fd1d9b4709720fd3743c20ab')
)
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

# Texture packs: download, then add them to resourcePacks in options.txt (other packs you chose are kept)
$PackDir = Join-Path $GameDir 'resourcepacks'
New-Item -ItemType Directory -Force -Path $PackDir | Out-Null
foreach ($pk in $Packs) {
    $r = Get-Verified $pk[1] (Join-Path $PackDir $pk[0]) $pk[2]
    Say ("    texture pack {0} {1}" -f $r.PadRight(3), $pk[0])
}
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
foreach ($pk in $Packs) { $id = 'file/' + $pk[0]; if (-not $sel.Contains($id)) { $sel.Add($id) } }
$packLine = 'resourcePacks:' + (ConvertTo-Json -InputObject ([string[]]$sel.ToArray()) -Compress)
if ($idx -ge 0) { $lines[$idx] = $packLine } else { $lines.Add($packLine) }
[IO.File]::WriteAllLines($opt, [string[]]$lines.ToArray(), (New-Object Text.UTF8Encoding $false))
Say '    texture packs turned on (New Glowing Ores + PvP Swords)'

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

# Body temperature (hot/cold) is turned OFF since v1.13.3. Tough As Nails is kept for thirst.
# TAN 9.2.0 has enable_temperature = true by default. GlitchCore keeps values already in the file and
# fills in the rest, so a new file with only this key is fine. On a server, the server's file wins (synced on join).
$TanDir = Join-Path (Join-Path $GameDir 'config') 'toughasnails'
$Tan = Join-Path $TanDir 'temperature.toml'
New-Item -ItemType Directory -Force -Path $TanDir | Out-Null
if (Test-Path -LiteralPath $Tan) {
    $t = [IO.File]::ReadAllText($Tan)
    $t2 = [regex]::Replace($t, '(?m)^(\s*enable_temperature\s*=\s*)true', '${1}false')
    if ($t2 -ne $t) { [IO.File]::WriteAllText($Tan, $t2) }
} else {
    [IO.File]::WriteAllText($Tan, "[toggles]`n`tenable_temperature = false`n")
}
Say '    Tough As Nails: body temperature off (thirst stays on)'

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
