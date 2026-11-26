# 魔王討伐RPGパック（Minecraft 1.20.1 / Forge）

ボス・ダンジョン・魔法・サバイバル要素を詰めたmod構成を、**公式ランチャー**から遊べるようにする一発インストーラーです。
`install-maou-rpg.bat` の1ファイルだけで、Forge の導入・mod 66個のダウンロード・影の設定・ランチャーへの起動構成の追加まで全部やります。

## 使い方

1. [Releases](../../releases/latest) から `install-maou-rpg.bat` をダウンロードする
2. Minecraft ランチャーとゲームを閉じる
3. `install-maou-rpg.bat` をダブルクリック
   - 「WindowsによってPCが保護されました」と出たら「詳細情報」→「実行」
4. `DONE.` と出たら、ランチャーを開いて **「魔王討伐RPG (1.20.1 Forge)」**（赤いブロックのアイコン）を選んでプレイ

初回は Forge の導入（Mojang のサーバーから本体を取ってくるので数分〜10分くらい）と mod のダウンロードで時間がかかります。

## 最初に必要なもの

- 公式の Minecraft ランチャーにログインして、一度起動したことがあること
- Java は不要です（PC に Java 17 以上があればそれを使い、なければ一時的な Java 21 を自動で用意します）

## やっていること

| 手順 | 内容 |
| --- | --- |
| 1 | Forge 1.20.1-47.4.29 を `.minecraft` に導入（入っていれば飛ばす） |
| 2 | mod 66個を `%APPDATA%\.minecraft-rpg\mods` にダウンロード（全部 SHA-1 で照合） |
| 3 | 影MOD用のシェーダー Complementary Unbound を入れて、最初から影をオン・言語を日本語に。テクスチャ2つを有効にし、Distant Horizons の描画距離を 1024 に |
| 4 | ランチャーに起動構成「魔王討伐RPG (1.20.1 Forge)」を追加（メモリは PC に合わせて 4〜8GB） |

- いつもの `.minecraft` の mod やワールドには触りません（専用フォルダ `.minecraft-rpg` を使います）。
- Forge のインストーラーは既存の「forge」という起動構成を書き換えてしまうので、bat が元に戻します。
  念のため `launcher_profiles.json.bak-maou-rpg` にバックアップを作ります。
- mod は Modrinth / CurseForge の公式配布元から直接ダウンロードします（このリポジトリに mod は入っていません）。

## 入っている mod

**ボス・モブ・戦闘**
L_Ender's Cataclysm / Mutant Iceologer / Peyro's Scythes & Spells / Iron's Spells 'n Spellbooks / Iron's RPG Tweaks / Pufferfish's Attributes / In Control!/ L2 Artifacts（長く育てるアーティファクト装備）/ Pufferfish's Skills + Default Skill Trees（戦闘と採掘のスキルツリー）

**探索・構造物・バイオーム**
Explorify / Deep Waters / Stellarity / MNS - Moog's Nether Structures / Better Trial Chambers / MES - Moog's End Structures / End Remastered / Feur Extension Fossil / aleki's Nifty Ships

**地形生成（v1.11.0〜）**
Terralith（バイオーム95種以上）/ Tectonic 3（大陸と巨大な山脈）/ Incendium（ネザーの地形とバイオーム）

**装備・便利・調整**
Fantasy Armor / Wider Ender Chests / Pehkui / Spice of Life: Carrot Edition / Tough As Nails（喉の渇き。体温は v1.13.3 から切っています）

**料理・農業・別世界（友達の追加分, v1.7.0〜）**
Let's Do Bakery / Brewery / HerbalBrews / Vinery（パン・ビール・ハーブティー・ワイン作り）/ Cooking for Blockheads（キッチンで料理をまとめて作る）/ Mystical Agriculture + Agradditions（鉱石や資源を畑で育てる）/ Sakura（桜と和風の食べ物）/ TofuCraft Reload（豆腐の世界）/ Urushi（和風ブロックと隠世ディメンション）/ Better Advancements（進捗画面が見やすくなる）

**見た目**
MinecraftCapes（マント）/ Oculus + Embeddium（影MOD）/ Distant Horizons（遠くまで描画）/ ItemPhysic Lite（落ちたアイテムが寝転がる・水に浮く）/ Sound Physics Remastered（洞窟で響く・壁の向こうの音がこもる）/ First-person Model（一人称で自分の体が見える）/ Not Enough Animations（一人称でも手の動きが細かくなる）/ Camera Overhaul（歩く・曲がるときにカメラが揺れる）

**前提mod**
Curios API / GeckoLib / Iron's Lib / Caelus / playerAnimator / Lionfish API / L2 Library / Moog's Structure Lib / Lithostitched / AttributeFix / GlitchCore / CreativeCore / Cloth Config / Architectury / Let's Do API / Mysterious Mountain Lib / Cucumber / Balm / Bagus Lib

## 地形生成について（v1.11.0〜）

- オーバーワールドは **Terralith + Tectonic 3**、ネザーは **Incendium** で作り直されます
- Tectonic は v3 系（3.0.17）です。前提の Lithostitched も入ります
- v1.3.0〜v1.8.0 に入れていた WWOO / CTOV / RoadWeaver / Streams Reflowing / Cristel Lib は入れていません。前の版の bat で入ったものは、bat をもう一度実行すると自動で消えます
- **Nullscape（エンドの地形）は入れていません。** Stellarity と同じエンドのファイル（`the_end.json` やエンドのバイオーム）を書き換えるので、両方入れるとエンドがおかしくなります。エンドは Stellarity が担当します
- **新しいワールドで遊んでください。** 地形の mod は、まだ生成されていない場所にしか効きません。前からあるワールドだと、境目で地形がぶつ切りになります

## サーバーを軽くするために外した mod（v1.14.0）

サーバーが重くて遊べなかったので、サーバーの負担が大きい mod を外しました（79個 → 66個、サーバー用 68個 → 55個）。

| 外した mod | 一緒に外した前提 mod | 重かった理由 |
| --- | --- | --- |
| Integrated Stronghold（大きくなった要塞） | Integrated API / Create / Supplementaries / Quark / Zeta / Moonlight Lib | Create・Supplementaries・Quark はこの mod の前提として入れていただけで、どれもメモリを多く使う大きな mod でした（Create の中に Flywheel・Ponder も入っています） |
| Enhanced AI（モブが壁を壊す・掘る・狙撃する） | InsaneLib | すべてのモブの AI の処理が重くなる |
| Enhanced Hordes（ゾンビの群れ） | — | モブの数が増える |
| L2 Hostility（モブに特性がついて強くなる） | L2 Complements / Patchouli | モブ1体ごとに処理が増える |

- bat をもう一度実行すると `mods` から自動で消えます
- **サーバーの `mods` からも、この13個の .jar を消してください**（[server-mods.md](server-mods.md) の一覧にない .jar がそれです）
- **外した mod のブロックやアイテムはワールドから消えます。** 外す前にワールドのバックアップを取ってください

## Cataclysm: Spellbooks を外した理由（v1.13.2）

- v1.13.0〜v1.13.1 に入れていた **Cataclysm: Spellbooks 1.2.9** は、起動時に `ModLoadingException ... cataclysm_spellbooks ... common_setup` で落ちるため外しました
- 原因: Spellbooks は Cataclysm 3.16 の古い Ancient Remnant の描画クラス（`Ancient_Remnant_Rework_Renderer`）を使っていますが、Cataclysm 3.24 以降でこのボスが作り直されてクラスがなくなりました。このパックの Cataclysm は 3.31 です。1.20.1 用の Spellbooks は 1.2.9 が最新で、新しい Cataclysm に対応した版はまだありません
- 前提だった AzureLib も、ほかに使う mod がないので一緒に外しました。bat をもう一度実行すると `mods` から自動で消えます

## YDM's Weapon Master を外しました（v1.13.4）

- v1.12.0〜v1.13.3 に入れていた **YDM's Weapon Master**（ホットバーの武器を背中・腰に表示する mod）を外しました
- bat をもう一度実行すると `mods` から自動で消えます。サーバーの `mods` からも `weaponmaster_ydm-forge-1.20.1-4.2.3.jar` を消してください

## 暑さ・寒さについて（v1.13.3〜）

- **暑さ・寒さ（体温）は切っています。** 喉の渇きは **Tough As Nails** がそのまま担当します
- bat を実行すると `config\toughasnails\temperature.toml` の `enable_temperature` を `false` にします
- **サーバーで遊ぶときは、サーバーの設定が使われます**（入ったときにサーバーから送られてきます）。サーバーでも同じ設定にしてください（[server-mods.md](server-mods.md) の「サーバーの設定」）
- 体温を戻したいときは、`enable_temperature` を `true` にします
- Heat and Climate は v1.10.0 で外しました（v1.6.0〜v1.9.0 に入っていました）。bat をもう一度実行すると `mods` から自動で消えます

## サーバーを立てるとき

サーバーに入れる mod の一覧は [server-mods.md](server-mods.md) にあります。`python make-server-mods.py --out フォルダ` を実行すると、サーバーの `mods` にそのまま入れられる jar 一式（と zip）を公式の配布元からダウンロードして作れます。再配布が許されていない mod もあるので、jar 一式は Release には付けていません。影・マント・ItemPhysic Lite などのクライアント専用 mod をサーバーに入れると、起動時にクラッシュします（`Attempted to load class net/minecraft/client/... for invalid dist DEDICATED_SERVER`）。

## 遠くまで見えるようにする（Distant Horizons）

v1.1.0 から入っています。ふつうの描画距離の外側を、軽い簡易モデル（LOD）で描いてくれます。

- 遠くの地形は、そのあたりを一度読み込んだあとから見えるようになります。最初は近くだけで、歩き回るほど遠くまで埋まっていきます
- 影（Complementary Unbound）とも一緒に動きます
- 最初のうちは裏で遠くの地形を作るので、少し重くなります
- v1.8.0 から、bat が描画距離を **1024 チャンク** にします（`config\DistantHorizons.toml` の `lodChunkRenderDistanceRadius`）。かなり重いので、カクつくときはゲーム内の Distant Horizons の設定で下げてください。bat をもう一度実行すると 1024 に戻ります

## テクスチャ（v1.8.0〜）

bat が次の2つをダウンロードして、最初から有効にします（`resourcepacks` フォルダ・`options.txt`）。どちらも Modrinth の配布元から直接ダウンロードしていて、このリポジトリには入っていません。

| パック | 内容 | 作者・ライセンス |
| --- | --- | --- |
| [New Glowing Ores](https://modrinth.com/resourcepack/new-glowing-ores)（Border・1.20用 v1.3） | 鉱石の粒が縁取り付きで光る | GridExpert・CC BY-NC-SA 4.0 |
| [PvP Swords](https://modrinth.com/resourcepack/short-pvp-swords)（1.20.1用 v1.0.1） | バニラの剣6種類が短くなる | All Rights Reserved |

- ゲーム内でテクスチャを切り替えるときは、**ワールドに入ってから**「Esc → 設定 → リソースパック」で切り替えてください。（v1.9.0 までは、タイトル画面で切り替えると Heat and Climate の不具合で全部外れていました）
- 自分で選んだ他のテクスチャは残ります。bat をもう一度実行すると、この2つはまた有効になります

### サーバーで New Glowing Ores を強制する

サーバーの `server.properties` に次の3行を書くと、入ってきた人に New Glowing Ores が配られます。断った人はサーバーに入れません。

```
resource-pack=https://cdn.modrinth.com/data/oL18adaQ/versions/YoXl9tp0/NewGlowingOres%C2%A76%5BBV-1.3%5D%5B1.20%5D.zip
resource-pack-sha1=5386de443f769021ac09e7be77f04faf4198b7bf
require-resource-pack=true
```

サーバーから配れるパックは1つだけです。PvP Swords は再配布が許されていないので、2つをまとめたものは作っていません（PvP Swords は bat で各自に入れます）。

## もう一度実行したとき

- 正しく入っている mod はダウンロードし直さないので、すぐ終わります。
- 新しい版の bat を実行すると、パックから外れた mod だけ消します。自分で足した mod は残ります。
- メモリ設定（JVM引数）をランチャーで変えていれば、その設定を残します。

## うまくいかないとき

- **「Please close the Minecraft Launcher」と出る** → ランチャーとゲームを完全に終了してから、もう一度
- **「launcher_profiles.json not found」と出る** → 公式ランチャーにログインして一度起動してから、もう一度
- **ゲームが落ちる** → `%APPDATA%\.minecraft-rpg\crash-reports` の最新ファイルか `logs\latest.log` を送ってください
- **重い** → ランチャーの「起動構成」→「魔王討伐RPG」→「その他のオプション」の JVM 引数 `-Xmx8G` を変える。カメラの揺れで酔うときは、ゲーム内の mod 一覧から Camera Overhaul の設定を開いて揺れを弱められます。影はゲーム内の「ビデオ設定」→「シェーダーパック」でオフにできます。Distant Horizons の描画距離は、ゲーム内の設定画面にある Distant Horizons のボタン（またはオプション → ビデオ設定）から下げられます

## アンインストール

1. ランチャーの「起動構成」から「魔王討伐RPG (1.20.1 Forge)」を削除
2. `%APPDATA%\.minecraft-rpg` フォルダを削除（ワールドもここに入っているので注意）
