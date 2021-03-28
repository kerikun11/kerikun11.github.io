---
date: "2018-12-22T00:00:00+09:00"
title: "PlatformIOでESP32の開発をしよう"
categories:
  - "説明記事"
tags:
  - "ESP32"
  - "PlatformIO"
thumbnail: "icon.png"
---

## 概要

この記事は [東京工業大学ロボット技術研究会(rogy) Advent Calendar 2018](https://adventar.org/calendars/3279) の
22日目の記事です。

こんにちは。けりです。

今回は、PlatformIOという強力な **マイコン開発環境** の紹介です。

### PlatformIO とは？

[PlatformIO](https://platformio.org/)とは、mbedやArduinoと似たような感じで、さまざまなボードやライブラリを統一的に開発できる開発環境です。

PlatformIO はESP32マイコンを公式にサポートしていて、[ESP-IDF](https://github.com/espressif/esp-idf)と[Arduino Core for the ESP32](https://github.com/espressif/arduino-esp32)から選んで開発することができます。

<!--more-->

### なぜPlatformIOを使うの？

PlatformIOのいいところは、強力なエディタである[Visual Studio Code (VSCode)](https://code.visualstudio.com/)のプラグインとして使用できるところです。

私は最近、あらゆるコーディングをVSCodeで行っています。

これを使えば、さまざまなマイコンをVSCodeで開発することができます。

さらに、PlatformIOの[Library Manager](https://docs.platformio.org/en/latest/librarymanager/index.html)はとても優秀で、
VSCodeのC/C++プラグインと連携して関数の定義への移動などを自動的に設定してくれます。

### VSCode + PlatformIO = 強力なマイコン開発環境

というわけで、VSCodeとPlatformIOの組み合わせは、あらゆるマイコンに対する強力な開発環境となります。

## PlatformIO の導入

[こちら](https://platformio.org/install/ide?install=vscode)に手順があります。

1. [VSCode](https://code.visualstudio.com/)をインストールする
2. VSCodeの拡張機能からPlatformIOをインストールする
3. VSCodeを再起動

### PlatformIO で ESP32 を使うには

なんと、設定ファイルにESP32を指定するだけで、toolchain、SDKなどを自動的に取得してくれます。
たとえWindowsでもOSXでもLinuxでも、自動で開発環境が整います。

これはESP32だけではなく、他の対応マイコンも同様です。  
PlatformIOすごいですね...

## 動作確認

VSCodeのコマンドパレット `Ctrl+Shift+P` で `Platformio home` と入力すると、PlatformIOのHome画面が出てきます。

### プロジェクトの作成

1. New Project
2. プロジェクト名を適当に入力
3. `ESP32 Dev Module` というボードを選ぶ
4. Frameworkは `Arduino` か `ESP-IDF`の好きな方を選ぶ
5. 完了

### ビルド

コマンドパレットで `Platformio: Build`を選ぶとビルドできます。

### 書き込み

1. ESP32をPCに接続して、書き込みモードで起動
2. コマンドパレットで`PlatformIO: Upload`を選択
3. 適当なCOMポートが自動的に選択されて書き込みがされる

もし複数のデバイスが接続されていて、シリアルポートを選択したい場合は、
既にある`platformio.ini`ファイルに

```ini
upload_port = COM11
monitor_port = COM11
```

などと記入すればそのポートに接続されます。

詳しくは[こちら](https://docs.platformio.org/en/latest/projectconf.html)

### シリアルモニタの表示

コマンドパレットで`PlatformIO: Serial Monitor`を選択すると、上記のポートに接続されます。

ここで便利なのが、
ESP32のようにシリアルで書き込みするマイコンの場合、
一度シリアルポートを切断して、書き込みをして、シリアルポートを開きなおさなければなりませんが、
PlatformIOの場合、自動でそれをやってくれます。

## まとめ

これまでPlatformIOを使ってよかったところを上げてみると

- 導入が簡単
- 公式のドキュメントが充実
- VSCodeで開発できる
- ちゃんとマイコンのSDKなどのバージョンを選択できる
- オンラインの汎用ライブラリをインストールできる
- マイコンに直接書き込みができる
- 書き込み時にシリアルモニタを開いていても大丈夫

って感じでしょうか。

あまりに使やすいので、一度使うとやめられなくなりそうです。

ぜひ使ってみてくださいね！
