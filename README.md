# 魔王討伐RPGパック（Minecraft 1.20.1 / Forge）

ボス・ダンジョン・魔法・サバイバル要素を詰めたmod構成を、**公式ランチャー**から遊べるようにする一発インストーラーです。
`install-maou-rpg.bat` の1ファイルだけで、Forge の導入・mod 60個のダウンロード・影の設定・ランチャーへの起動構成の追加まで全部やります。

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
| 2 | mod 60個を `%APPDATA%\.minecraft-rpg\mods` にダウンロード（全部 SHA-1 で照合） |
| 3 | 影MOD用のシェーダー Complementary Unbound を入れて、最初から影をオン・言語を日本語に |
| 4 | ランチャーに起動構成「魔王討伐RPG (1.20.1 Forge)」を追加（メモリは PC に合わせて 4〜8GB） |

- いつもの `.minecraft` の mod やワールドには触りません（専用フォルダ `.minecraft-rpg` を使います）。
- Forge のインストーラーは既存の「forge」という起動構成を書き換えてしまうので、bat が元に戻します。
  念のため `launcher_profiles.json.bak-maou-rpg` にバックアップを作ります。
- mod は Modrinth / CurseForge の公式配布元から直接ダウンロードします（このリポジトリに mod は入っていません）。

## 入っている mod

**ボス・モブ・戦闘**
L_Ender's Cataclysm / Mutant Iceologer / Peyro's Scythes & Spells / Iron's Spells 'n Spellbooks / Iron's RPG Tweaks / L2 Hostility / Pufferfish's Attributes / In Control!

**探索・構造物・バイオーム**
Explorify / Deep Waters / Stellarity / MNS - Moog's Nether Structures / Better Trial Chambers / Integrated Stronghold / MES - Moog's End Structures / End Remastered / Feur Extension Fossil / aleki's Nifty Ships

**地形・バイオーム・村・道**
Tectonic v2（大陸と巨大な山脈）/ Terralith（バイオーム95種以上）/ William Wythers' Overhauled Overworld（バニラのバイオームを作り直す）/ ChoiceTheorem's Overhauled Village（村の作り直し）/ RoadWeaver（村と村をつなぐ道）/ Streams Reflowing（山から海へ流れる川と湖）

**装備・便利・調整**
Fantasy Armor / Wider Ender Chests / Pehkui / Spice of Life: Carrot Edition / Tough As Nails（喉の渇き）/ Heat and Climate（暑さ・寒さ・季節）

**見た目**
MinecraftCapes（マント）/ Oculus + Embeddium（影MOD）/ Distant Horizons（遠くまで描画）/ ItemPhysic Lite（落ちたアイテムが寝転がる・水に浮く）/ Sound Physics Remastered（洞窟で響く・壁の向こうの音がこもる）/ First-person Model（一人称で自分の体が見える）/ Not Enough Animations（一人称でも手の動きが細かくなる）/ Camera Overhaul（歩く・曲がるときにカメラが揺れる）

**前提mod**
Curios API / GeckoLib / Iron's Lib / Caelus / playerAnimator / Lionfish API / L2 Library / L2 Complements / Patchouli / Moog's Structure Lib / Integrated API / GlitchCore / CreativeCore / Lithostitched / Cristel Lib / Cloth Config / Create / Supplementaries / Quark / Zeta / Moonlight Lib

> Create・Supplementaries・Quark は、Integrated Stronghold の最新版が必須にしているため入っています。

## 地形生成について（v1.3.0〜）

- **新しいワールドで遊んでください。** 地形の mod は、まだ生成されていない場所にしか効きません。前からあるワールドだと、境目で地形がぶつ切りになります（Terralith は既存ワールドへの追加を公式に非推奨としています）
- Tectonic は **v2 系（2.4.1）** を使っています。RoadWeaver が Tectonic v3 と組み合わせられないためです
- Larion World Generation は 1.20.1 用が Fabric 版しかないので入れていません
- Streams Reflowing は、ワールドを作るときにスポーン周りの地形を調べるので、最初の読み込みが少し長くなります

## 暑さ・寒さについて（v1.6.0〜）

- 暑さ・寒さのダメージと季節は **Heat and Climate** が担当します
- Tough As Nails にも体温の仕組みがありますが、二重にダメージを受けないように bat が切っています（`config	oughasnails	emperature.toml` の `enable_temperature = false`）。喉の渇きは Tough As Nails のまま残ります
- Tough As Nails の体温を使いたいときは、上の設定を `true` に戻してください。次に bat を実行すると、また `false` に戻ります

## 遠くまで見えるようにする（Distant Horizons）

v1.1.0 から入っています。ふつうの描画距離の外側を、軽い簡易モデル（LOD）で描いてくれます。

- 遠くの地形は、そのあたりを一度読み込んだあとから見えるようになります。最初は近くだけで、歩き回るほど遠くまで埋まっていきます
- 影（Complementary Unbound）とも一緒に動きます
- 最初のうちは裏で遠くの地形を作るので、少し重くなります

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
