# AGENTS.md

このリポジトリ（`3d-models`）で OpenSCAD モデルの編集、STL / G-code ビルド、および幾何干渉チェックを行う際の標準手順と注意事項をまとめます。

---

## 1. リポジトリ構成

- `models/<project>/`: 各プロジェクトの OpenSCAD (`.scad`) ソースファイル
- `profiles/`: PrusaSlicer 用設定ファイル
  - `printer.ini`: プリンタ設定（Ender-3 V2 ベース）
  - `filament_pla.ini`: PLA フィラメント設定（デフォルト）
  - `filament_petg.ini`: PETG フィラメント設定
  - `option_brim.ini`: Brim（5mm）有効化オプション
  - `option_skirt.ini`: Skirt 有効化オプション
- `.gitignore`: `*.stl`, `*.STL`, `*.gcode`, `_assets` は Git 管理対象外（ビルド成果物はコミットしない）

---

## 2. STL / G-code のビルド手順

### 基本の `make` コマンド
`Makefile` のサフィックスルールにより、`.scad` から `.stl` および `.gcode` をビルドできます。

```bash
# STL のみ生成
make models/<dir>/<name>.stl

# G-code 生成（デフォルト: PLA）
make models/<dir>/<name>.gcode

# PETG 指定で G-code 生成
make FILAMENT=petg models/<dir>/<name>.gcode

# 強制再ビルド（-B）＋ サポート材有効
make -B FILAMENT=petg models/<dir>/<name>.gcode+support
```

### Brim / Skirt オプション指定時の注意
`Makefile` 内の `%+brim` / `%+skirt` ターゲットは `--load option_brim.ini`（`profiles/` プレフィックスなし）を参照しているため、そのまま実行するとパスエラーになります。Brim や Skirt を付ける場合は `FLAGS` で明示的に指定してください。

```bash
# PETG + 5mm Brim 付きで強制再スライス
make -B FILAMENT=petg FLAGS="--load profiles/option_brim.ini" models/<dir>/<name>.gcode

# PLA + Skirt 付きで強制再スライス
make -B FILAMENT=pla FLAGS="--load profiles/option_skirt.ini" models/<dir>/<name>.gcode
```

### 1つの `.scad` から複数パーツを出力する場合
`part` 変数などで出力パーツを切り替えている `.scad` ファイルでは、`openscad -D` でパーツ別の STL を出力してから `make` で G-code を生成します。

```bash
openscad -D 'part="spine_plate"' -o models/shishiodoshi/spine_plate.stl models/shishiodoshi/shishiodoshi.scad
make -B FILAMENT=petg FLAGS="--load profiles/option_brim.ini" models/shishiodoshi/spine_plate.gcode
```

### ビルド結果の確認
生成された `.gcode` 内のメタデータから、フィラメント使用量・推定印刷時間・Brim 設定を確認できます。

```bash
grep -E "filament used|estimated printing time|brim_width" models/<dir>/<name>.gcode
```

---

## 3. モデルの品質・干渉チェック手順

`.scad` を変更した際は、STL/G-code 生成とあわせて以下の検証を実施してください。

### (1) 単体モデルの多様体（Manifold）チェック
`openscad` 実行時の標準エラー出力を確認し、メッシュ破綻がないかチェックします。

- `Simple: yes` であること
- `WARNING: Object may not be a valid 2-manifold` が出力されていないこと

### (2) 複数パーツ・組み付け状態の干渉テスト（`intersection()` 検証）
嵌合部、相欠き（ラップジョイント）、対称反転組み付けなどを行うモデルでは、組み付け状態での `intersection()` を CLI から実行し、実体積の干渉がないか検証します。

```bash
# 例: 同一パーツを Z=neck_center_z*2 で 180度反転して組み合わせた際の干渉チェック
openscad -D 'part="none"' -o /tmp/test_intersect.stl /dev/stdin << 'EOF'
include <models/shishiodoshi/shishiodoshi.scad>
intersection() {
    spine_plate();
    translate([0, 0, neck_center_z * 2])
        rotate([180, 0, 0])
        spine_plate();
}
EOF
```

#### 判定基準
- **干渉なし（OK）**:
  - `Current top level object is empty.` または `Facets: 0` となる場合。
  - もしくは出力された STL が合わせ面での 2D 面接触のみ（体積ゼロ）である場合。
- **干渉あり（NG）**:
  - `Volumes:` や `Facets:` に 3D の体積を持つ塊が出力された場合（例: 突起の底突き、クリアランス不足など）。該当箇所の座標とクリアランス（通常 `0.15mm〜0.3mm` 程度）を見直してください。

---

## 4. 成果物の共有
`.stl` や `.gcode` は `.gitignore` 対象のため、印刷用ファイルや確認用モデルをユーザーに渡す場合は、利用環境に応じたファイル転送・共有手段を用いて受け渡してください。
