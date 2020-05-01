---
date: "2016-03-14"
title: "メダカの照明 Ver.2"
categories:
  - "作品紹介"
tags:
  - "ESP-WROOM-02"
  - "ESP8266"
  - "WiFi"
  - "サーバー"
  - "めだか"
  - "Arduino"
thumbnail: "icon.png"
---

## 概要

### メダカの水槽の照明

以前、PICで作った[メダカの水槽の照明](/posts/2015-06-04-killifish-light/)(←リンク)を紹介しましたが、今回はこれをバージョンアップしました。めだかの照明がどのようなものかは以前の記事を参考にしてください。

{{< postfig src="fish.jpg" title="めだか" >}}

### 格安WiFiモジュール

今注目のWiFiモジュールであるESP-WROOM-02を使ってWiFiに対応しました。これにより、スマートフォンなどからブラウザ経由で操作できます。

このWiFiモジュールを使った赤外線学習リモコンの記事も書きましたので合わせてご覧ください。

  * [赤外線学習リモコン（日本語による紹介記事）](/posts/2015-12-30-ir-station/)
  * [赤外線学習リモコン（英語によるリファレンス）](/posts/2016-03-11-ir-station-reference/)

[ESP-WROOM-02 WiFiモジュール　秋月電子にて550円(2016/3/14現在)](http://akizukidenshi.com/catalog/g/gM-09607/)

{{< postfig src="esp-wroom-02.jpg" title="ESP-WROOM-02" width="240px" >}}
<!--more-->

## ギャラリー

### 全体

LEDはなんと、

  * 白色LED12個
  * 赤色LED6個
  * 緑色LED6個
  * 青色LED6個

の計30個の1WパワーLEDを備えています。

{{< postfig src="all.jpg" title="全体" >}}

### 基板

Dサイズのユニバーサル基板に実装しました。回路はとても簡単です。

{{< postfig src="board1.jpg" title="基板1" >}}
{{< postfig src="board2.jpg" title="基板2" >}}

### LED


{{< postfig src="light.jpg" title="光っているところ" >}}

### 回路図

{{< postfig src="sketch.png" title="回路図" link="sketch.png" >}}

### スマホからの操作画面

ボタンを押すことでLEDの明るさを11段階で変えることができます。

{{< postfig src="page.png" title="操作画面" >}}

## 時間同期モード

「Set Time Sync」から時間同期モードに設定すると、朝6時から徐々に明るくなり正午にMAXになり、午後6時までに消灯するようになっています。これでめだかは時間感覚が狂わず、健康に生きることができます！！


時刻はNTPサーバーから取得しているので時計合わせも不要で正確です。

## ソースファイル

ソースファイルはGitHubに公開していますので興味がある方はご覧ください。[→リンク](https://github.com/kerikun11/Light-for-Fish.git)

ただし、他人に見せるつもりで書いたソースではないので説明は皆無です。

## まとめ

シリアルによるコントロールだった前のバージョンに比べてかなり進化しました！今後はJavaScriptなどを使ってさらに進化させていきたいですね！

{{< postfig src="fish_up.jpg" title="めだか" >}}

