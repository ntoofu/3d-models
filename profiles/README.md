# Printer Profiles

CuraEngine 用のプリンタープロファイル定義ファイル

## ファイル構成

| ファイル | 役割 |
|---|---|
| `fdmprinter.def.json` | 全設定のルート定義（Cura 共通） |
| `fdmextruder.def.json` | エクストルーダー定義（Cura 共通） |
| `creality_base.def.json` | Creality プリンター共通設定 |
| `creality_base_extruder_0.def.json` | Creality 共通エクストルーダー定義 |
| `creality_ender3.def.json` | Ender-3 ベースプロファイル（V2 も同一仕様） |
| `custom.def.json` | **カスタム設定（編集対象はここのみ）** |

継承チェーン:
```
fdmprinter.def.json
  └─ creality_base.def.json (→ creality_base_extruder_0.def.json を参照)
       └─ creality_ender3.def.json
            └─ custom.def.json
```

ベンダーファイルは Cura **5.12.0** から取得。LGPL-3.0 ライセンス（詳細は LICENSE 参照）。

### 注意

CuraEngine 5.x は Ubuntu 24.04 の apt リポジトリに存在しない。
Dockerfile ではビルド時に Cura AppImage（~335MB）から取得しているので、
バージョンアップ時はプロファイルと AppImage のバージョンを合わせること。

## 使用方法

* 通常はmakeにて実行するため意識する必要はない
* CuraEngineを直接呼び出すときはプロファイルを以下の用に指定
  * `-l model.stl` でSTLファイル指定
  * `-o model.gcode` で出力G-codeファイル名指定
  * `-s support_enable=true` はオーバーライドする設定を指定(optional)

```bash
CuraEngine slice -j profiles/custom.def.json -l model.stl -o model.gcode -s support_enable=true
```

## カスタム設定の変更

* `custom.def.json` の `overrides` セクションを編集する
* 設定キー名は `fdmprinter.def.json` 内を検索すればOK