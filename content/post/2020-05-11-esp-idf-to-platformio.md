---
title: "ESP-IDFプロジェクトをPlatformIOプロジェクトに変換する"
date: "2020-05-11T23:11:57+09:00"
categories:
  - "説明記事"
tags:
  - "ESP32"
  - "PlatformIO"
---

## 概要

ESP32 の公式開発環境は [ESP-IDF](https://github.com/espressif/esp-idf) ですが，コマンドライン開発環境なので初心者向けではないかもしれません．

一方，以前の記事 [PlatformIOでESP32の開発をしよう](/posts/2018-12-22-platformio/)で紹介した [PlatformIO](https://platformio.org/) では，GUIのVSCodeに拡張機能としてインストールするだけで環境が整うのでとても便利です．

しかしながら，ESP-IDFやGitHubなどにあるたくさんのサンプルコードは，PlatformIOで直接実行することができません．

そこで今回は，単純なESP-IDFのプロジェクトをPlatformIOプロジェクトに変換する方法を紹介します．

<!--more-->

<!-- ## サンプルコード

今回使用するサンプルコードは下記のリポジトリにあります．

- [GitHub - PlatformIO Compatible ESP-IDF Project Example](https://github.com/kerikun11/esp-idf-platformio-example.git) -->

## 方法

### ESP-IDF プロジェクトを作成

まずはじめに，ESP-IDFのプロジェクトを用意します．ただし， ESP-IDF の開発環境は必要ありません．

例えば，ESP-IDF のリポジトリから [ESP-IDF Hello World Example](https://github.com/espressif/esp-idf/tree/master/examples/get-started/hello_world) などのサンプルプロジェクトをコピーします．

サンプルプロジェクトをコピーすると，ディレクトリ構造は下記のようになります．

```tree
hello_world
├── CMakeLists.txt
├── Makefile
├── README.md
└── main
    ├── CMakeLists.txt
    ├── component.mk
    └── hello_world_main.c
```

### PlatformIOの設定ファイルの追加

ESP-IDF プロジェクトに `platformio.ini` を新規作成します．

`platformio.ini`:

```ini
; PlatformIO Project Configuration File
;
;   Build options: build flags, source filter, extra scripting
;   Upload options: custom port, speed and extra flags
;   Library options: dependencies, extra library storages
;
; Please visit documentation for the other options and examples
; http://docs.platformio.org/page/projectconf.html

[platformio]
src_dir = main

[env:esp32dev]
platform = espressif32
framework = espidf
board = esp32dev

monitor_speed = 115200
monitor_filters = colorize
monitor_flags= --raw
```

ソースファイルのある `main` ディレクトリやその他の環境設定をしています．

### 必要に応じて .gitignore を更新

プロジェクトを Git で管理する場合，`.gitignore` は欠かすことができません．

今回のPlatformIO互換ESP-IDFプロジェクトの場合，`.gitignore`は下記のようになります．

`.gitignore`:

```gitignore
# PlatformIO
.pio
.pioenvs
.piolibdeps

# VSCode
.vscode

# ESP-IDF
sdkconfig
sdkconfig.old
build
```

### 実行

この時点でディレクトリは下記のようになっています．

```tree
hello_world
├── CMakeLists.txt
├── Makefile
├── README.md
├── main
│   ├── CMakeLists.txt
│   ├── component.mk
│   └── hello_world_main.c
├── platformio.ini
└── .gitignore
```

あとは，通常通り `Ctrl+Alt+B` でコンパイル， `Ctrl+Alt+U` で書き込み，`Ctrl+Alt+S` でシリアルポートの確認ができます．

### 注意事項

main ディレクトリ内に .cpp ファイルを追加した場合は， `main/CMakeLists.txt` にファイル名を追記してください．

`main/CMakeLists.txt`:

```cmake
idf_component_register(SRCS "hello_world_main.c" "added_src.cpp"
                    INCLUDE_DIRS "")
```

## まとめ

今回は簡単な例でしたが，下記のドキュメントには様々な機能が書かれているので是非ご一読ください！

- https://docs.platformio.org/en/latest/frameworks/espidf.html

例えば， `menuconfig` を実行して `sdkconfig` を編集することも可能です．
