# 魔王討伐RPGパック（Minecraft 1.20.1 / Forge）

ボス・ダンジョン・魔法・サバイバル要素を詰めたmod構成を、**公式ランチャー**から遊べるようにする一発インストーラーです。
`install-maou-rpg.bat` の1ファイルだけで、Forge の導入・mod 46個のダウンロード・影の設定・ランチャーへの起動構成の追加まで全部やります。

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
| 2 | mod 46個を `%APPDATA%\.minecraft-rpg\mods` にダウンロード（全部 SHA-1 で照合） |
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

**装備・便利・調整**
Fantasy Armor / Wider Ender Chests / Pehkui / Spice of Life: Carrot Edition / Tough As Nails

**見た目**
MinecraftCapes（マント）/ Oculus + Embeddium（影MOD）/ Distant Horizons（遠くまで描画）/ ItemPhysic Lite（落ちたアイテムが寝転がる・水に浮く）

**前提mod**
Curios API / GeckoLib / Iron's Lib / Caelus / playerAnimator / Lionfish API / L2 Library / L2 Complements / Patchouli / Moog's Structure Lib / Integrated API / GlitchCore / CreativeCore / Create / Supplementaries / Quark / Zeta / Moonlight Lib

> Create・Supplementaries・Quark は、Integrated Stronghold の最新版が必須にしているため入っています。

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
- **重い** → ランチャーの「起動構成」→「魔王討伐RPG」→「その他のオプション」の JVM 引数 `-Xmx8G` を変える。影はゲーム内の「ビデオ設定」→「シェーダーパック」でオフにできます。Distant Horizons の描画距離は、ゲーム内の設定画面にある Distant Horizons のボタン（またはオプション → ビデオ設定）から下げられます

## アンインストール

1. ランチャーの「起動構成」から「魔王討伐RPG (1.20.1 Forge)」を削除
2. `%APPDATA%\.minecraft-rpg` フォルダを削除（ワールドもここに入っているので注意）
