---
date: "2017-12-06T00:00:00+09:00"
title: "ESP32のすゝめ"
categories:
  - "説明記事"
tags:
  - "ESP32"
  - "ESP-WROOM-32"
  - "マイコン"
thumbnail: "icon.jpg"
---

こんにちは、けりです。  
これは [東京工業大学ロボット技術研究会(rogy) Advent Calender 2017](https://adventar.org/calendars/2361) の6日目の記事です.

本日は、私が愛用しているマイコン「ESP32」を紹介します。

<!--more-->

## ESP32とは？

ESP32とは上海にある[Espressif Systems](http://espressif.com/)という会社のマイコンです。


最新の IoT マイコンで、240MHzのデュアルコア CPU に WiFi と BLE を備えていながら約5ドルという低価格を実現しました。


{{< postfig src="esp32.jpg" title="ESP32" width="150px" link="http://espressif.com/en/products/hardware/esp32/overview" >}}

## ESP32 と ESP-WROOM-32 の関係

ESP32はWiFiのコントローラでもあるので、日本で使用するには技適が必要です。

その技適を取得したモジュールが[ESP-WROOM-32](https://akizukidenshi.com/catalog/g/g111647/)です。

モジュールになったことでパスコンや無線周りの回路がすべて内蔵されており、電源をつなぐだけで使うことができます。

{{< postfig src="esp-wroom-32.jpg" title="ESP-WROOM-32" width="180px" >}}

## どこで買えるの？

ESP-WROOM-32は[秋月電子](https://akizukidenshi.com/catalog/g/g111647/)で購入できますので、日本ですぐに買うことができます！

## ESP32の長所と短所

### 長所

  * Arduinoと同じコードで開発できる
  * メモリがとても多い (RAM が 520kB、Flash が 4MB(ESP-WROOM-32))
  * CPUの性能が高い (240MHz・デュアルコア)
  * ほぼすべてのピンでSPI、I2C、PWMなどが使える (ピンの再割り当てが可能)
  * 内部に不揮発性ファイルシステムが用意されている (EEPROMより圧倒的に使いやすい)
  * Wi-Fi通信とBluetooth Low Energy (BLE) 通信ができる
  * 価格が安い(700円程度)
  * サンプルコードが豊富 (サンプルコードを切り貼りするだけで割といろいろなことができる)

### 短所

  * スリープしないと電流を結構消費する(CPUが30~50mA)
  * ライブラリが完成していないものもある

## ESP32の開発環境

ESP32の開発環境は主に以下の2つです。どちらもEspressif公式のGitHubリポジトリにあります。

|開発環境|概要|コメント|
|:--|:--|:--|
|[ESP-IDF](https://github.com/espressif/esp-idf)|公式の開発環境(Espressif IoT Development Framework)|ESP32をフル活用したいならこれを使おう|
|[Arduino core for the ESP32](https://github.com/espressif/arduino-esp32)|ESP-IDFをベースとしたArduino IDEプラグイン|簡単に使えてびっくり！|

## 開発に必要なもの

とりあえず、以下のものがあれば動作確認はできます。

  * [ESP32-DevKitC](https://akizukidenshi.com/catalog/g/g111819/)
  * Micro-B USBケーブル
  * パソコン

{{< postfig src="esp32-devkitc.jpg" title="ESP32-DevKitC" width="180px" >}}

## ESP32開発環境づくりの概要

一番簡単な Windows & Arduino IDE で開発する方法の流れを紹介します。詳しくは[公式のドキュメント](https://github.com/espressif/arduino-esp32#installation-instructions)をご覧ください。

  1. [Arduino IDE](https://www.arduino.cc/en/Main/Software) をインストール
  1. [Arduino core for the ESP32](https://github.com/espressif/arduino-esp32)をダウンロードしてArduino IDEのソースディレクトリに展開
  1. コマンドプロンプトで、さっき展開したファイルに含まれる `get.exe` を実行
  1. Arduino IDE を起動すると、ボード一覧に `ESP32 Dev Module` があるので選択する
  1. Arduino IDE のサンプルコード一覧にESP32があるので適当なものを開く
  1. ESP32-DevKitC を PC につないでポートを選択する
  1. Arduino IDE の書き込みボタンを押してプログラムを書きこむ
  1. 書き込みが終わったら RESET ボタンを押してプログラムを実行する

## ESP-WROOM-32を使う上での注意事項一覧

ESP32が動かなくて困ったときは以下のことを確認してみてください。

  * 電源レギュレータが貧弱だと起動できない
  * IO6からIO11までの6ピンは内蔵フラッシュメモリと通信しているので基本的に使えない
  * IO0,IO2,IO5,IO12,IO15は起動時に特定の状態になっていなければならないので使用の際は注意
  * IO34からIO39までのピンは入力専用で、出力には使えない
  * ADC1とADC2があるが、現時点ではADC2とWiFiは同時に使えない(修正される可能性あり)

## デュアルコアについて

ESP32は同じCPUが2つ内蔵されており、デュアルコアとなっています。

デュアルコアの使い方については[以前の記事](/posts/2017-06-24-esp32-dual-core/)をご覧ください。

## まとめ

  * ESP32 とは、超ハイスペックな無線付きマイコン
  * 公式の開発環境は ESP-IDF
  * Arduino IDE でも開発することができて、Arduinoのライブラリをそのまま使える
  * サンプルコードが豊富で、サンプルコードを見ているとなんかできた気になる

ここまで魅力的なマイコンは今まで見たことがありません！  
ぜひ使ってみてくださいね！

## 最後に

世の中にはこの記事含め、二次解説記事が溢れています。

その筆者はさまざまな工夫を凝らしてわかりやすい記事を書くように努めていると思いますが、間違った情報や不確実な情報も含まれていると思います。

是非、公式サイトが提供している **一次ドキュメント** を読む癖をつけましょう。

ESP32の場合、[ESP32 Technical Reference Manual](http://espressif.com/sites/default/files/documentation/esp32_technical_reference_manual_en.pdf)を熟読すると、ESP32の魅力を再確認できます！

### ESP32リンク集

  * [Espressif ESP32 Overview](http://espressif.com/en/products/hardware/esp32/overview)
  * [Espressif ESP32 Resources](http://espressif.com/en/products/hardware/esp32/resources)
  * [Espressif IoT Development Framework](https://github.com/espressif/esp-idf)
  * [ESP-IDF Programming Guide](https://esp-idf.readthedocs.io/en/latest/#)
  * [Arduino core for ESP32 WiFi chip](https://github.com/espressif/arduino-esp32)

最後までお読み頂きありがとうございました。  
明日の [東京工業大学ロボット技術研究会(rogy) Advent Calender 2017](https://adventar.org/calendars/2361) は、Aktzkさんです。お楽しみに！
