---
date: "2019-12-23T09:00:00+09:00"
title: "Cheese Timer の紹介"
categories:
  - "作品紹介"
tags:
  - "マイクロマウス"
  - "迷路"
  - "Cheese"
thumbnail: "icon.jpg"
---

## はじめに

こんにちは．けりです．

先日，12月15日(日) に **第3回Cheese杯** を開催しました．

Cheese杯とは，東京工業大学ロボット技術会Cheeseが主催するマイクロマウスのプチ大会です．

おかげさまで，今年，第3回目を開催することができました！

今回の記事では，そのとき登場した，
マイクロマウス計測装置 **Cheese Timer** を簡単に紹介します．

<!--more-->

## Cheese Timer の紹介

Cheese Timer とは，Cheeseのメンバーが共同で制作した**マイクロマウスのタイム計測装置**です．

マイコンや開発環境などがみんなバラバラのCheeseとしては，
**初めての共同作業** とも言える Cheese Timer です！

### 全体構成

Cheese Timer は，
次の3つの部分によって構成されています．

- スタートラインの計測部
- ゴールラインの計測部
- タイム表示部(PC)

計測部は無線化されていて，PC側に通過時のタイムを送信します．

{{< postfig src="cheese-timer-1.jpg" title="Cheese Timer: ゴールラインのセンサ" width="360px" >}}

これらについて簡単に紹介します．

### 計測部

Cheese Timer の発端となった計測部は，僕が制作しました．

無線搭載マイコンモジュール ESP-WROOM-32 を使用して，ToF センサのサンプリングと無線によるデータ送信を行っています．

{{< postfig src="cheese-timer-2.jpg" title="Cheese Timer: ゴールラインのセンサ" width="360px" >}}

{{< postfig src="cheese-timer-3.jpg" title="Cheese Timer の計測は ToF センサ" width="360px" >}}

基板を発注する時間がなかったので，そのへんに落ちていた基板を使いました．

なんと，これはマイクロマウス KERISE v4 の先頭に立っている基板です！！

{{< postfig src="reflector.jpg" title="KERISE v4 の ToFセンサ" width="360px" >}}

### クラッシック柱への変換部分

上記のセンサをクラシックとハーフの双方のフィールドで使えるように，
後輩のだんごくんが次のようなアダプタを作ってくれました．

{{< postfig src="pillar-adapter.png" title="柱アダプタ" width="240px" >}}

{{< postfig src="pillar-adapter.jpg" title="Cheese Timer の計測部" width="360px" >}}

ちゃんとハマっていないようにも見えますが，そこは見なかったことにしましょう．

### 表示部

タイムの表示部は，先輩のところさんが **MATLAB** で作ってくださいました．

{{< postfig src="cheese-timer-gui-kerise-v4.png" title="Cheese Timer の表示部" width="480px" >}}

これはもう公式のものと区別がつきませんね！！すごい！！

ちなみに，無線で送られてきたデータを受信してMATLABに送る部分は，
僕と同期の sekiくんが作成してくれました．

### Google スプレットシートと連携

出走者には Google フォームでエントリーをして頂きましたが，
その集計結果のスプレットシートと Cheese Timer はリンクしています．

機体名や走行タイムなどが自動で反映されるようになっています！  
この部分は，後輩のiimuroくんが作ってくれました．

## Cheese Timerの未来形

1年前くらいから開発が止まってしまっているのですが，
当初Cheese Timerの計測部は，ハーフサイズの壁の中に収める計画がありました．

次の写真はその試作品です．

試作とは言っても，ちゃんと使うことができます．

壁の中を削る作業がかなり辛くて，量産はできませんでした...

{{< postfig src="next-cheese-timer-1.jpg" title="ハーフの壁に収納可能な Cheese Timer" width="360px" >}}
{{< postfig src="next-cheese-timer-2.jpg" title="ハーフの壁に収納可能な Cheese Timer" width="360px" >}}
{{< postfig src="next-cheese-timer-3.jpg" title="ハーフの壁に収納可能な Cheese Timer" width="360px" >}}
{{< postfig src="next-cheese-timer-4.jpg" title="ハーフの壁に収納可能な Cheese Timer" width="360px" >}}

中では，表面実装のESP-WROOM-32とレギュレータなどが空中配線で繋がれています...

来年のCheese杯あたりには完成させたいところです...

## おわりに

マイクロマウスでは，基本的に個人での作業が多いので，
こうやって分担してものづくりをすると，
いろいろなセンスやスキルが盛り込まれるので，とてもいいですね！

自分とは関係ないところでどんどん進捗が産まれていくのはなんとも言えない感動でした．

### お詫びとお礼

Cheese杯では，出走中，通信の不具合などでご迷惑をおかけしました．
安定して動くものを作るのって，本当に難しいですね...

また，今年は会場の都合で懇親会が開けなかったのですが，
空き時間にたくさん交流ができて，
とても充実したCheese杯になりました．

会場に足を運んでくださった方々，本当にありがとうございました！

今後もCheeseをよろしくお願いします．

{{< postfig src="group-photo.jpg" title="Cheese杯2019に参加したマウスたち" >}}
