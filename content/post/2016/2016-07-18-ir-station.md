---
date: "2016-07-18"
title: "赤外線学習リモコン完成"
categories:
  - "作品紹介"
tags:
  - "赤外線学習リモコン"
  - "WiFi"
  - "ESP8266"
  - "ESP-WROOM-02"
  - "Arduino"
  - "IR-Station"
pickup: true
thumbnail: "icon.jpg"
---

## 概要

赤外線学習リモコンとは、市販の家電製品などのリモコンの赤外線信号を記憶し、送信することができるものです。

今回は、WiFi接続に対応した赤外線学習リモコンを作りました。スマートフォンやパソコンなどから、家電製品をコントロールすることができます。

<!--more-->

## 祝・完成

[発注したプリント基板が基板が届き](/posts/2016-07-06-ir-station-board/)、とうとう赤外線学習リモコンが完成しました。

### 本体

{{< postfig src="body.jpg" title="本体" >}}

### 取り付け簡単！

壁に取り付けた様子です。電源は、`USB-micro-B`コネクタから供給します。
{{< postfig src="attach.jpg" title="取り付け" >}}

### 操作画面

複数の機器のリモコンを1つにまとめて、スマホからコントロールすることができます。
{{< postfig src="display.png" title="操作画面" >}}

## 本体内部

### ふたを開けると

ESP8266マイコンを備えたWiFiモジュールである、ESP-WROOM-02が現れます。
{{< postfig src="inside.jpg" title="ふたを開けたところ" >}}

### 基板

{{< postfig src="top.jpg" title="基板の表" >}}
{{< postfig src="back.jpg" title="基板の裏" >}}

## 作り方

すべてのデータをGitHubで公開しています。  
作り方は[ここ](https://github.com/kerikun11/IR-Station)を参考にしてください。

## 最後に

長い間研究をしてきた赤外線学習リモコンがやっと形になりました。とても嬉しいです。

~~この赤外線学習リモコンを使っていただけるテスターを募集しています。使ってみたい方は声をかけてください。(先着数名で打ち切ります)~~  
追記 2016年9月6日 一定数集まったので終了しました。ありがとうございます。


#### リンク

赤外線学習リモコン「IR-Station」についての他の記事:

  * [2015年12月30日 ESP8266で赤外線学習リモコン](/posts/2015-12-30-ir-station/)
  * [2016年03月11日 IR-Station Reference](/posts/2016-03-11-ir-station-reference/)
  * [2016年07月06日 赤外線学習リモコンの基板が届きました](/posts/2016-07-06-ir-station-board/)
  * [IR-Stationの使い方](/posts/2016-07-25-how-to-use-ir-station/)

