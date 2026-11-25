"""サーバー用の mod 一式と一覧を作るスクリプト。

install-maou-rpg.bat の mod リストを読み、クライアント専用の mod を除いたものを
サーバー用として扱う。

    python make-server-mods.py                 # server-mods.md だけ作り直す
    python make-server-mods.py --out DIR       # DIR/mods に jar を集めて DIR.zip も作る
    python make-server-mods.py --out DIR --from %APPDATA%/.minecraft-rpg/mods
                                               # 手元の jar を使う(SHA-1 が合うものだけ)。足りない分はダウンロード

bat の mod を変えたら、これを実行して server-mods.md を更新すること。
"""
import argparse
import hashlib
import os
import re
import shutil
import sys
import urllib.request
import zipfile

HERE = os.path.dirname(os.path.abspath(__file__))
BAT = os.path.join(HERE, 'install-maou-rpg.bat')
MD = os.path.join(HERE, 'server-mods.md')

# クライアント専用(サーバーに入れない) mod: ファイル名 -> 理由
CLIENT_ONLY = {
    'MinecraftCapes Forge 1.20.1-1.1.0.jar': 'マント（画面に描くだけ）。サーバーに入れると起動時にクラッシュする',
    'oculus-mc1.20.1-1.8.0.jar': '影MOD。サーバーに入れると起動時にクラッシュする',
    'embeddium-0.3.31+mc1.20.1.jar': '描画の高速化（Oculus 用）',
    'ItemPhysicLite_FORGE_v1.6.13_mc1.20.1.jar': '落ちたアイテムの見た目。サーバーに入れると起動時にクラッシュする',
    'CreativeCore_FORGE_v2.12.42_mc1.20.1.jar': 'ItemPhysic Lite の前提。ほかに使う mod がない',
    'sound-physics-remastered-forge-1.20.1-1.5.1.jar': '音の響き（自分の PC で鳴らす音だけ）',
    'firstperson-forge-2.7.3-mc1.20.1.jar': '一人称で体が見える（クライアント専用）',
    'notenoughanimations-forge-1.12.7-mc1.20.1.jar': '手の動き（クライアント専用）',
    'CameraOverhaul-v2.1.2-forge+mc[1.20-1.20.5].jar': 'カメラの揺れ',
    'cloth-config-11.1.136-forge.jar': 'Camera Overhaul の設定画面用。ほかに使う mod がない',
    'BetterAdvancements-Forge-1.20.1-0.4.2.60.jar': '進捗画面の見た目だけ',
}

# 前の版から外した mod(サーバーからも消してもらう): (外した版, ファイル名)
REMOVED = [
    ('v1.9.0', 'tectonic-forge-1.20.1-2.4.1.jar'),  # v1.11.0 で 3.0.17 に入れ替え
    ('v1.9.0', 'WWOO-FABRIC+FORGE+QUILT-2.0.0.jar'),
    ('v1.9.0', '[forge]ctov-3.4.14.jar'),
    ('v1.9.0', 'roadweaver-forge-2.3.2-1.20.1.jar'),
    ('v1.9.0', 'StreamsReflowing-1.20.1-forge-2.17.5.jar'),
    ('v1.9.0', 'cristellib-1.1.6-forge.jar'),
    ('v1.10.0', 'HeatAndClimate-1.20.1-v5.0.6.jar'),
]


def read_bat():
    src = open(BAT, encoding='ascii').read()
    ver = re.search(r"^\$PackVersion = '([^']+)'", src, re.M).group(1)
    mods = re.findall(r"^    @\('([^']+\.jar)', '([^']+)', '([0-9a-f]{40})'\)", src, re.M)
    names = [m[0] for m in mods]
    for c in CLIENT_ONLY:
        if c not in names:
            sys.exit(f'CLIENT_ONLY にある {c} が bat にありません')
    return ver, mods


def sha1(path):
    h = hashlib.sha1()
    with open(path, 'rb') as f:
        for b in iter(lambda: f.read(1 << 20), b''):
            h.update(b)
    return h.hexdigest()


def write_md(ver, mods):
    srv = [m for m in mods if m[0] not in CLIENT_ONLY]
    o = []
    w = o.append
    w(f'# サーバーに入れる mod 一覧（v{ver}）\n')
    w(f'Forge **1.20.1-47.4.x** のサーバーの `mods` フォルダに、下の **{len(srv)}個** を入れます。')
    w(f'配布用の bat が入れる {len(mods)}個から、クライアント（各自の PC）専用の {len(CLIENT_ONLY)}個を除いたものです。\n')
    w('> この一覧は `make-server-mods.py` が `install-maou-rpg.bat` の mod リストから作っています。')
    w('> `python make-server-mods.py --out フォルダ` で、この jar 一式（とその zip）も作れます。\n')
    w('## 入れる mod\n')
    w('ファイル名だけの一覧（コピー用）:\n')
    w('```')
    for m in srv:
        w(m[0])
    w('```\n')
    w('| # | ファイル | SHA-1 |')
    w('| --- | --- | --- |')
    for i, m in enumerate(srv, 1):
        w(f'| {i} | [{m[0]}]({m[1]}) | `{m[2]}` |')
    w('')
    w('## 入れない mod（クライアント専用）\n')
    w('各自の PC には bat が入れます。サーバーには**入れないでください**。\n')
    w('| ファイル | 理由 |')
    w('| --- | --- |')
    for k, v in CLIENT_ONLY.items():
        w(f'| `{k}` | {v} |')
    w('')
    w('Distant Horizons はサーバーにも入れます（サーバー側で遠くの地形を作って配れるようになります）。\n')
    w('## 前の版から外した mod（サーバーからも消す）\n')
    w('サーバーの `mods` にまだあれば取り除いてください。\n')
    w('| 外した版 | ファイル |')
    w('| --- | --- |')
    for v, r in REMOVED:
        w(f'| {v} | `{r}` |')
    w('')
    w('- v1.9.0: 地形生成の mod を外したため（Tectonic 2.4.1 は v1.11.0 で 3.0.17 に入れ替え）')
    w('- v1.10.0: Heat and Climate を外したため（体温は Tough As Nails だけ）\n')
    w('## 地形生成（v1.11.0〜）\n')
    w('Terralith・Tectonic 3（前提 Lithostitched）・Incendium（ネザー）を入れています。')
    w('**地形の mod を入れ替えたら、ワールドを作り直してください。** 前のワールドをそのまま使うと、')
    w('バイオームが見つからない警告が出たり、地形の境目が切れたりします。')
    w('Nullscape は Stellarity と同じエンドのファイルを書き換えるので入れていません。\n')
    w('## サーバーの設定（config）\n')
    w('v1.13.3 から、暑さ・寒さ（体温）は切っています。Tough As Nails は喉の渇きのために残しています。')
    w('**サーバーに入ると、サーバー側の Tough As Nails の設定がプレイヤーに送られて上書きされます。**')
    w('そのため、サーバーでも次のように書き換えてください。\n')
    w('| ファイル | 項目 | 値 |')
    w('| --- | --- | --- |')
    w('| `config/toughasnails/temperature.toml` | `enable_temperature` | `false` |')
    w('')
    w('ファイルは `[toggles]` の下にある `enable_temperature = true` を `false` に変えます。')
    w('ファイルがなければ、サーバーを一度起動すると作られます。書き換えたらサーバーを再起動します。\n')
    open(MD, 'w', encoding='utf-8', newline='\n').write('\n'.join(o))
    return srv


def build(out, srv, src_dir):
    mods_dir = os.path.join(out, 'mods')
    os.makedirs(mods_dir, exist_ok=True)
    wanted = {m[0] for m in srv}
    for f in os.listdir(mods_dir):
        if f.endswith('.jar') and f not in wanted:
            os.remove(os.path.join(mods_dir, f))
            print('  removed', f)
    for name, url, h in srv:
        dest = os.path.join(mods_dir, name)
        if os.path.exists(dest) and sha1(dest) == h:
            continue
        local = os.path.join(src_dir, name) if src_dir else None
        if local and os.path.exists(local) and sha1(local) == h:
            shutil.copyfile(local, dest)
            print('  copy', name)
        else:
            req = urllib.request.Request(url, headers={'User-Agent': 'maou-rpg-installer'})
            with urllib.request.urlopen(req) as r, open(dest + '.part', 'wb') as f:
                shutil.copyfileobj(r, f)
            if sha1(dest + '.part') != h:
                os.remove(dest + '.part')
                sys.exit(f'SHA-1 が合いません: {name}')
            os.replace(dest + '.part', dest)
            print('  download', name)
    shutil.copyfile(MD, os.path.join(out, 'server-mods.md'))
    zpath = out.rstrip('\\/') + '.zip'
    with zipfile.ZipFile(zpath, 'w', zipfile.ZIP_STORED) as z:
        for name, _, _ in srv:
            z.write(os.path.join(mods_dir, name), 'mods/' + name)
    print(f'{len(srv)} mods -> {mods_dir}')
    print(f'zip -> {zpath}')


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('--out', help='jar 一式を作るフォルダ(mods/ をこの中に作る)')
    ap.add_argument('--from', dest='src', help='先に探す手元の mods フォルダ')
    a = ap.parse_args()
    ver, mods = read_bat()
    srv = write_md(ver, mods)
    print(f'server-mods.md: v{ver} / server {len(srv)} / client-only {len(CLIENT_ONLY)}')
    if a.out:
        build(a.out, srv, a.src)


if __name__ == '__main__':
    main()
