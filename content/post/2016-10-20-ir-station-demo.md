---
date: "2016-10-20"
title: "IR-Stationのデモンストレーションサイト"
categories:
  - "作品紹介"
tags:
  - "IR-Station"
  - "赤外線学習リモコン"
  - "Sinatra"
thumbnail: "icon.png"
---

## IR-Stationの操作を体験できます！

### IR-Stationとは

IR-Stationとは，WiFi接続に対応した赤外線学習リモコンです．これがあればスマートフォンなどから家電製品をコントロールすることができます．

IR-Stationについては，[IR-Stationについての記事一覧](/tags/ir-station)をご覧ください．

### IR-Stationのデモンストレーション

IR-Stationを持っていない方でもIR-Stationの操作を体験できるように，操作画面を再現したサイトを作りました．

[IR-Stationのデモンストレーションサイト](http://ir-station.kerikun11.mydns.jp)

<!--more-->

## 使い方

  1. まずは，[デモサイト](http://ir-station.kerikun11.mydns.jp)にアクセスしてください．
  1. 画面のボタンを押すと，赤外線信号が送信されます．(デモサイトなので，実際には送信されません)
  1. 画面下部から各種機能を体験することができます．

IR-Stationの使い方は，[過去の記事](/tags/ir-station)をご覧ください．

### 注意

前の人が使ったものが残らないように，リロードするとデフォルト状態に初期化されるようになっています．使用中はリロードをしないように注意してください．

## 動作環境

### Raspberry Pi 2 Type B

このサーバーはこのブログと同様に，家においてあるRaspberry Pi 2 Type B により動いています．
あまり強いサーバーではないのでいじめないであげてください．．．

### Sinatra

サーバーアプリケーションはRubyのSinatraにより動いています．

## まとめ

もともとは開発用に使っていたデモ環境ですが，外部に公開して一般に見れるようにしました．これで多くの人にIR-Stationを体験してもらいたいです．

