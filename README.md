# 魔王討伐RPGパック（Minecraft 1.20.1 / Forge）

地形・見た目・農業や和風の別世界の mod 構成を、**公式ランチャー**から遊べるようにする一発インストーラーです。
（v2.0.0 で、ボス・魔法・構造物などの mod はいったん外しています）
`install-maou-rpg.bat` の1ファイルだけで、Forge の導入・mod 28個のダウンロード・影の設定・ランチャーへの起動構成の追加まで全部やります。

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
| 2 | mod 28個を `%APPDATA%\.minecraft-rpg\mods` にダウンロード（全部 SHA-1 で照合） |
| 3 | 影MOD用のシェーダー Complementary Unbound を入れて、最初から影をオン・言語を日本語に。テクスチャ2つを1つにまとめて有効にし、Distant Horizons の描画距離を 1024 に |
| 4 | ランチャーに起動構成「魔王討伐RPG (1.20.1 Forge)」を追加（メモリは PC に合わせて 4〜8GB） |

- いつもの `.minecraft` の mod やワールドには触りません（専用フォルダ `.minecraft-rpg` を使います）。
- Forge のインストーラーは既存の「forge」という起動構成を書き換えてしまうので、bat が元に戻します。
  念のため `launcher_profiles.json.bak-maou-rpg` にバックアップを作ります。
- mod は Modrinth / CurseForge の公式配布元から直接ダウンロードします（このリポジトリに mod は入っていません）。

## 入っている mod（v2.0.0〜）

**地形生成**
Terralith（バイオーム95種以上）/ Tectonic 3（大陸と巨大な山脈）/ Incendium（ネザーの地形とバイオーム）

**農業・和風・別世界**
Mystical Agriculture + Agradditions（鉱石や資源を畑で育てる）/ Sakura（桜と和風の食べ物）/ TofuCraft Reload（豆腐の世界）/ Urushi（和風ブロックと隠世ディメンション）/ Heat and Climate（季節・天気・作物の気候。体温は切っています）

**便利・仲間（v2.2.0〜）**
FTB Ultimine（キーを押しながら壊すと、つながったブロックをまとめて掘る・伐る）/ Touhou Little Maid（東方リトルメイド。メイドを雇って家事や戦闘を任せる）

**見た目**
MinecraftCapes（マント）/ Oculus + Embeddium（影MOD）/ Distant Horizons（遠くまで描画）/ ItemPhysic Lite（落ちたアイテムが寝転がる・水に浮く）/ Sound Physics Remastered（洞窟で響く・壁の向こうの音がこもる）/ First-person Model（一人称で自分の体が見える）/ Not Enough Animations（一人称でも手の動きが細かくなる）/ Camera Overhaul（歩く・曲がるときにカメラが揺れる）

**前提mod**
Lithostitched / CreativeCore / Cloth Config / Mysterious Mountain Lib / Cucumber / Bagus Lib / FTB Library / Architectury

## 地形生成について（v1.11.0〜）

- オーバーワールドは **Terralith + Tectonic 3**、ネザーは **Incendium** で作り直されます
- Tectonic は v3 系（3.0.17）です。前提の Lithostitched も入ります
- v1.3.0〜v1.8.0 に入れていた WWOO / CTOV / RoadWeaver / Streams Reflowing / Cristel Lib は入れていません。前の版の bat で入ったものは、bat をもう一度実行すると自動で消えます
- エンドは v2.0.0 からバニラのままです（Stellarity を外したため）
- **新しいワールドで遊んでください。** 地形の mod は、まだ生成されていない場所にしか効きません。前からあるワールドだと、境目で地形がぶつ切りになります

## v2.0.0 でいったん減らした mod

地形・見た目・農業や和風の mod だけにして、64個から24個（サーバー用 53個から14個）に減らしました。外したのは次の mod です。

- ボス・モブ・戦闘: L_Ender's Cataclysm / Mutant Iceologer / Peyro's Scythes & Spells / Iron's Spells 'n Spellbooks / Iron's RPG Tweaks / Pufferfish's Attributes / Pufferfish's Skills + Default Skill Trees / In Control! / L2 Artifacts
- 探索・構造物: Explorify / Deep Waters / Stellarity / MNS / MES / Better Trial Chambers / End Remastered / Feur Extension Fossil / aleki's Nifty Ships
- 装備・便利: Fantasy Armor / Wider Ender Chests / Pehkui / Spice of Life: Carrot Edition
- 料理: Let's Do Bakery / Brewery / HerbalBrews / Vinery / Cooking for Blockheads / Better Advancements
- 前提: Curios API / GeckoLib / Iron's Lib / Caelus / playerAnimator / Lionfish API / L2 Library / Moog's Structure Lib / AttributeFix / Architectury / Let's Do API / Balm

注意:
- bat をもう一度実行すると `mods` から自動で消えます
- **サーバーは `mods` を一度空にして、[server-mods.md](server-mods.md) の14個を入れ直してください**
- **外した mod のブロックやアイテムはワールドから消えます。** 先にワールドのバックアップを取ってください
- 前の版で入れて外したもの（v1.14.0 の Integrated Stronghold / Create / Quark / Enhanced AI / L2 Hostility など、v1.13.4 の YDM's Weapon Master、v1.13.2 の Cataclysm: Spellbooks、v1.15.0 の Tough As Nails）は、それぞれの版の Release に理由を書いています

## 暑さ・寒さについて（v2.0.0〜）

- **Heat and Climate** を入れ直しました（v1.6.0〜v1.9.0 にも入っていました）。季節・天気・作物の気候はそのまま働きます
- **体温（暑さ・寒さのダメージ）と気候の HUD は切っています。** bat が `config\dcs_climate-common.toml` の `"Enable Climate Damage"` と `config\dcs_climate-client.toml` の `"Show Climate HUD"` を `false` にします
- **サーバーで遊ぶときは、ダメージはサーバーの設定で決まります。** サーバーの `config/dcs_climate-common.toml` も `false` にしてください（[server-mods.md](server-mods.md) の「サーバーの設定」）
- Tough As Nails は v1.15.0 で外したままです（喉の渇きもありません）

## サーバーを立てるとき

サーバーに入れる mod の一覧は [server-mods.md](server-mods.md) にあります。`python make-server-mods.py --out フォルダ` を実行すると、サーバーの `mods` にそのまま入れられる jar 一式（と zip）を公式の配布元からダウンロードして作れます。再配布が許されていない mod もあるので、jar 一式は Release には付けていません。影・マント・ItemPhysic Lite などのクライアント専用 mod をサーバーに入れると、起動時にクラッシュします（`Attempted to load class net/minecraft/client/... for invalid dist DEDICATED_SERVER`）。

## 遠くまで見えるようにする（Distant Horizons）

v1.1.0 から入っています。ふつうの描画距離の外側を、軽い簡易モデル（LOD）で描いてくれます。

- 遠くの地形は、そのあたりを一度読み込んだあとから見えるようになります。最初は近くだけで、歩き回るほど遠くまで埋まっていきます
- 影（Complementary Unbound）とも一緒に動きます
- 最初のうちは裏で遠くの地形を作るので、少し重くなります
- v1.8.0 から、bat が描画距離を **1024 チャンク** にします（`config\DistantHorizons.toml` の `lodChunkRenderDistanceRadius`）。かなり重いので、カクつくときはゲーム内の Distant Horizons の設定で下げてください。bat をもう一度実行すると 1024 に戻ります

## テクスチャ（v1.8.0〜、v2.1.0 から1つにまとめました）

bat が次の2つを Modrinth の配布元からダウンロードし、**自分の PC の中で1つのパック `MaouRPG-Textures.zip` にまとめて**、最初から有効にします。リソースパックの一覧には、この1つだけが出ます。

| パック | 内容 | 作者・ライセンス |
| --- | --- | --- |
| [New Glowing Ores](https://modrinth.com/resourcepack/new-glowing-ores)（Border・1.20用 v1.3） | 鉱石の粒が縁取り付きで光る | GridExpert・CC BY-NC-SA 4.0 |
| [PvP Swords](https://modrinth.com/resourcepack/short-pvp-swords)（1.20.1用 v1.0.1） | バニラの剣6種類が短くなる | All Rights Reserved |

- ゲーム内でテクスチャを切り替えるときは、**ワールドに入ってから**「Esc → 設定 → リソースパック」で切り替えてください。タイトル画面で切り替えると、Heat and Climate 5.0.6 の不具合で「読み込み失敗」になり、全部外れてしまいます
- ダウンロードした元の2つは `.minecraft-rpg\maou-rpg-packs` に置いてあります（`resourcepacks` には入れないので一覧に出ません）。v2.0.0 までに `resourcepacks` に入った2つは、bat がそこへ移します
- まとめたパックは、bat を実行するたびに作り直します。自分で選んだ他のテクスチャは残ります
- **まとめたパックは人に渡さないでください。** PvP Swords は再配布が許されていません（パックの中の `credits.txt` にも書いてあります）。友達には bat を渡せば、各自の PC で同じものができます

### サーバーでテクスチャを配る（v2.2.0〜）

まとめたパックを Dropbox に置いて、サーバーから配っています。`server.properties` に書く3行は [server-mods.md](server-mods.md) の「テクスチャをサーバーで配る」にあります。リンクは友達だけに教えてください（PvP Swords は再配布が許されていません）。

### （参考）New Glowing Ores だけを配る場合

サーバーの `server.properties` に次の3行を書くと、入ってきた人に New Glowing Ores が配られます。断った人はサーバーに入れません。

```
resource-pack=https://cdn.modrinth.com/data/oL18adaQ/versions/YoXl9tp0/NewGlowingOres%C2%A76%5BBV-1.3%5D%5B1.20%5D.zip
resource-pack-sha1=5386de443f769021ac09e7be77f04faf4198b7bf
require-resource-pack=true
```

サーバーから配れるのは、ネットに置いたパック1つだけです。まとめたパックは PvP Swords が入っていてネットに置けないので、サーバーから配れるのは New Glowing Ores だけです（bat で入れた人は、まとめたパックにも同じものが入っているので、強制しなくても同じ見た目になります）。

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
