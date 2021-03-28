---
title: "M5Stackで作るマイクロマウスのタイム表示機"
date: "2020-03-07T12:08:12+09:00"
categories:
  - "作品紹介"
tags:
  - "マイクロマウス"
thumbnail: "icon.jpg"
---

## はじめに

こんにちは。
春休みに行きたい予定が重なっていてどちらに行くか迷っていたのに、
どちらの予定も中止になって虚無になったけりです。

今回は先日制作したマイクロマウスのタイム表示機の紹介です。

<!--more-->

### M5Stackとは

今回使用した[M5Stack](https://m5stack.com/)とは、液晶やボタン、スピーカーなどのUIが搭載されてたマイコンボードです。
ちゃんとケースに収められていて、いい感じの見た目です。

いくつか種類があるM5Stackの中で、今回は
[M5Stack GREY](https://m5stack.com/collections/m5-core/products/grey-development-core)
を使いましたが、特殊な機能は使っていないので他のM5Stackでも動作すると思います。

## 作ったもの

マイクロマウスの時間や走行回数などの記録を管理するデバイスを制作しました。

{{< postfig src="normal.jpg" title="マイクロマウスタイム表示機" width="240px" >}}

### 動画

効果音も再現されているので、音声つきで是非ご覧ください！

<iframe width="640" height="360" src="https://www.youtube.com/embed/T1re2yZW0nY" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>

1. 持ち時間の設定
2. 競技開始
3. スタート → ゴール
4. スタート → タッチ(リタイヤ)
5. 持ち時間の終了

### 表示内容

- 走行中のタイム
- 残りの持ち時間
- 現在の出走回数
- 各出走のタイム

{{< postfig src="normal.jpg" title="マイクロマウスタイム表示機" width="280px" >}}

制限時間内での最短走行記録が黄色で表示されています。

### ボタンの役割

- 左側: スタートセンサの代わり
- 中央: ゴールセンサの代わり
- 右側: リセット/タッチ(リトライ)ボタン

### 持ち時間の設定

起動後の画面で、持ち時間(分単位)を設定できます。

{{< postfig src="time-set.jpg" title="持ち時間の設定画面" width="280px" >}}

## ソースコード

M5Stack のファームウェアは
[GitHub](https://github.com/kerikun11/m5stack-micromouse-timer) に公開しました。

## 今後の展望

今後は、

- センサーとの連携
- WiFiやBLEなどによる時間取得APIの提供

をすることでより実用的になると思います。

## おわりに

ただマイクロマウスを作るだけでなく、
それをきっかけにさまざまなデバイスを作っていきたいですね。

そではまた！
