# Printer Profiles

PrusaSlicer 用のプロファイル定義ファイル

## ファイル構成

| ファイル | 役割 |
|---|---|
| `printer.ini` | プリンター・造形設定（Ender-3 V2 共通） |
| `filament_pla.ini` | PLA フィラメント設定 |
| `filament_petg.ini` | PETG フィラメント設定 |

スライス時にプリンター設定の上にフィラメント設定を重ねてロードする。
未記載の設定は PrusaSlicer のデフォルト値が使われる。

## 使用方法

通常は `make` を使う。

```bash
make MODEL=path/to/model.stl slice               # PLA（デフォルト）
make MODEL=path/to/model.stl FILAMENT=petg slice  # PETG
make MODEL=path/to/model.stl slice-support        # サポート材あり
```

直接 PrusaSlicer を呼ぶ場合:

```bash
prusa-slicer --export-gcode \
    --load profiles/printer.ini \
    --load profiles/filament_pla.ini \
    --output model.gcode model.stl
```

## フィラメントの追加

`filament_<name>.ini` を作成して `make FILAMENT=<name> slice` で使用できる。
設定キーの確認は以下で:

```bash
prusa-slicer --save /tmp/full-config.ini
```

## バージョン管理

Dockerfile に記載の PrusaSlicer バージョンに合わせること。
最新リリースは https://github.com/prusa3d/PrusaSlicer/releases を参照。
