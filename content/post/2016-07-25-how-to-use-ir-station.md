---
date: "2016-07-25"
title: "IR-Stationの使い方"
categories:
  - "作品紹介"
tags:
  - "IR-Station"
  - "ESP8266"
  - "ESP-WROOM-02"
  - "赤外線学習リモコン"
thumbnail: "icon.png"
spotlight: "true"
---

## IR-Stationとは

自作のWiFi接続の赤外線学習リモコンです．IR-Stationを使えば，スマホやPCから家電製品をコントロールすることができます．

<!--more-->

### 本体の写真

上面の4つの点が赤外線LEDです．

{{< postfig src="body.jpg" title="本体" width="480px" >}}

### 壁に取り付けた時の様子

とてもコンパクトです．

{{< postfig src="on-the-wall.jpg" title="壁に取り付けた様子" width="480px" >}}

## IR-Stationのバージョン

この記事の内容は，IR-Stationの「**v1.4.0**」に対応しております．ご注意ください．

## 2つの動作モード

### WiFiステーションモード

IR-Stationを家のルーターなどに接続して，スマホやPCからはルーター経由でIR-Stationに接続するモードです．

普通はこちらのモードを使います．

### WiFiアクセスポイントモード

IR-StationがWiFiのアクセスポイントになり，スマホやPCがIR-StationのWiFiに接続して使用するモードです．

このモードの場合，ルーターが不要なのでお手軽ですが，IR-StationのWiFiはインターネットに接続されていないので，スマホもインターネットにはつなぐことができないので注意が必要です．

## IR-Stationのセットアップ

### IR-Stationに電源を供給

電源はUSB-Micro-Bケーブルを使って，適当なUSB電源から供給します．

{{< postfig src="01-power-supply.jpg" title="電源を供給" width="480px" >}}

### IR-Stationが出現

電源を供給すると，`IR-Station`という名前のWiFiが出現します．  
セキュリティがかかっている場合はパスワード「IR-Station」を使ってください．

{{< postfig src="02-find-ssid.png" title="SSIDを検出" width="480px" >}}

### 自動でウィンドウが現れる
AppleのデバイスやWindowsの場合，自動でログイン画面が現れます．

自動で画面が現れない場合や，その他のデバイスを使っている場合は，適当なブラウザで[http://192.168.4.1](http://192.168.4.1)を開いてください．

{{< postfig src="03-connect-ssid.png" title="IR-Stationに接続" width="480px" >}}

### 付近のWiFiを検出

ログイン画面が現れて，しばらくすると，IR-Stationのセットアップ画面が表示されます．

#### IR-Stationをステーションモードで使う場合

`WiFi Setup Mode`内に必要事項を記入し，`Confirm`ボタンを押します．

#### IR-Stationをアクセスポイントモードで使う場合

`Access Point Mode`内に必要事項を記入し，`Access Point Mode`ボタンを押します．

{{< postfig src="04-get-wifi-list.png" title="WiFiのリストを取得" width="480px" >}}

### 接続成功画面→スクリーンショット

入力したWiFi情報が正しく，接続に成功した場合，以下のような画面になります．この画面に表示されるURLを控えておかないといけないので，この画面を**スクリーンショット**することをお勧めします．

失敗した場合は前の画面に戻るので，もう一度正しく入力してください．(時々，入力したWiFi情報が正しくても接続に失敗することがあるので，その場合はもう一度試してください．)

{{< postfig src="06-successful.png" title="成功" width="480px" >}}

### 上手くいくとSSIDが消える

設定が完了するとIR-StationのWiFiが消えてなくなります．

{{< postfig src="07-disappear.png" title="SSIDが消える" width="480px" >}}

## IR-Stationを使う

### IPアドレスでアクセス(すべての機器で使えます)

{{< postfig src="08-ip-address.png" title="IPアドレスでアクセス(すべての機器)" width="480px" >}}

### mDNSホスト名でアクセス（対応機器のみ）

mDNS対応機器には，Appleデバイス，iTunesのインストールされたWindows PCなどがあります．これらのデバイスからは，IPアドレスだけでなく，わかりやすい名前のURLでアクセスすることができます．表示される画面は同じです．

{{< postfig src="09-mdns-hostname.png" title="mDNSホスト名でアクセス(Bonjour対応機器)" width="480px" >}}

### 赤外線信号を登録する

  1. 画面の下の方の`Recode a Signal`というボタンを押すと，メニューが現れます．
  1. 登録したいチャンネルを選び，ボタンの名前を入力します．
  1. `Recode`ボタンを押すと，IR-StationのLEDの色が変わります．
  1. その状態でIR-Stationにリモコンを向けて，登録したいリモコンのボタンを押してください．
  1. 登録に成功すると，IR-Stationの画面上のボタンの名前が更新されます．

### 赤外線信号を送る（IR-Stationをリモコンとして使う）

画面上のボタンを押すだけです．そのボタンに割り当てられた赤外線信号がIR-Stationから送られます．送信中は画面のボタンがピンクに変わります．ピンク色が元の白色に戻ったら送信完了です．

## まとめ

IR-Stationは，僕ひとりでかなりの時間をかけて開発してきたものです．やっと実用できるレベルまで来ました．これからもバージョンアップを重ねて，より便利にしていきたいです．

