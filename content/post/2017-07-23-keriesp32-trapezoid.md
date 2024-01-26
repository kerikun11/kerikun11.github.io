---
date: "2017-07-23"
title: "KERIESP32 Trapezoid"
categories:
  - "作品紹介"
tags:
  - "ESP-WROOM-32"
  - "KiCad"
thumbnail: "icon.png"
---

## ESP-WROOM-32のブレークアウトボード

WiFiとBluetoothが載ったデュアルコアなマイコン **ESP32** のピッチ変換基板を新たに作ったので紹介します。

<!--more-->

{{< postfig src="esp-wroom-32.jpg" title="ESP-WROOM-32" link="https://akizukidenshi.com/catalog/g/g111647/" width="240px" >}}

## 基板名: KERIESP32 Trapezoid

Trapezoidとは英語で台形のことです。見てのとおり、基板の形が由来です。

{{< postfig src="keriesp32-trapezoid-top.png" title="KERIESP32 Trapezoid" width="480px" >}}
{{< postfig src="keriesp32-trapezoid-back.png" title="KERIESP32 Trapezoid" width="480px" >}}

## 他社の基板との違い

### 1. I/Oピンが順に並んだSIP基板

ESP-WROOM-32はI/Oピンが謎の順番に配置されており、はっきり言って使いにくいです。

KERIESP32の基板は、I/Oピンが順番に並び変えてあります。  
さらに基板上にI/O番号が書いてあるので、作業が捗ること間違いなし！

SIP (Single Inline Package) ⇔ DIP (Dual Inline Package)

### 2. あえて乗せなかったシリアル変換IC

ESP32のブレークアウト基板のほとんどはUSB-UART変換ICが載っています。  
しかし、今回のKERIESP32 Trapezoidには、シリアル変換ICは載せませんでした。

この基板は、試作用だけでなくいろいろな作品中に組み込みたいと思ったからです。  
バッテリーで動かそうとするとき、シリアル変換ICが載っているとそちら側に電流が流れてしまいます。

### 3. 内蔵SPI-Flashのピンは封印

IO6-IO11はモジュール内部にあるSPI-Flashメモリと接続されていて、一般には使えません。間違えて使ってしまうと、壊してしまう恐れもありますし、そもそも正常に動作しません。使わないピンが出ていても仕方がないので、カットしました。

そのおかげでSIPの30pinに収めることができ、ブレッドボードにさすことができます。

{{< postfig src="brb.jpg" title="ブレッドボードに刺した様子" width="480px" >}}

### 4. 裏側にはMicro-SDカードスロットがある

ESP32はSDIOを持っており、SDカードと高速に通信することができます。

Micro SDカードを使わない場合はSDスロットをはんだ付けしなければ、SDカード用のI/Oピンは自由に使うことができます。

{{< postfig src="back.jpg" title="裏側" width="480px" >}}

## 回路図

とてもシンプルです。

{{< postfig src="sketch.png" title="回路図" link="sketch.png" >}}

## まとめ

ESP32の開発環境がかなり整ってきました。デュアルコアな電子工作を満喫しましょう！

