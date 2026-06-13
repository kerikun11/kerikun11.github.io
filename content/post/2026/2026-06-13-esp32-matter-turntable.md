---
date: "2026-06-13T18:00:00+09:00"
title: "Matter対応、Echo Show回転台の紹介"
categories:
  - "作品紹介"
tags:
  - "ESP32"
  - "Matter"
  - "Amazon Echo"
thumbnail: "icon.jpg"
spotlight: "true"
---

## はじめに

こんにちは。コーディングは完全にAIに任せっきりのけりです。

今回は、**Amazon Echo Showの向きを音声で切り替えられる回転台**を作ったので紹介します。

<!--more-->

{{< postfig src="turntable-complete.jpg" title="Matter対応 Echo Show回転台" width="480px">}}

## なぜ作ったのか

我が家ではキッチンとダイニングの間にあるカウンターで **Amazon Echo Show 10** を使っていました。

{{< postfig src="echo-show-10.jpg" title="回転機構を内蔵した Amazon Echo Show 10" width="240px">}}

Echo Show 10 は、人のいる方向へ画面を自動で向けてくれます。キッチンで料理をしているときも、ダイニングで食事をしているときも画面を見ることができて、かなり便利でした。

ところが、長年使っていた本体が故障してしまいました。Echo Show 10 はすでに製造終了しており、自動回転する現行モデルもありません。

{{< postfig src="echo-show-5.jpg" title="回転機構のない Amazon Echo Show 5" width="240px">}}

とりあえず代わりとして **Amazon Echo Show 5** を購入しましたが、単純な据え置き型です。キッチンに向けるとダイニングから見えず、ダイニングに向けるとキッチンから見えません。

仕方がないので、Echo Show 5ごと方向転換できる回転台を自作することにしました。

## 作ったもの

今回作ったのは、Echo Show 5をサーボモーターで回転させるシンプルな装置です。

ESP32をMatter対応のスイッチデバイスとして登録しており、Alexaから音声で操作できます。

下の動画は、基板と配線を台座へ収納する前の試作段階の様子です。

<div class="video"><video src="turntable-demo.mp4" width="100%" controls preload="metadata"></video></div>

スイッチデバイスの仕様としては下記のとおりです。

- **ON** にするとキッチン側へ回転
- **OFF** にするとダイニング側へ回転

Alexaアプリでは、「こっち向いて」と「あっち向いて」のどちらも、ON/OFFを反転するToggle操作に設定しています。

声をかけるのは現在と反対方向へ向けたいときなので、単純なToggle操作で実用上は十分です。

これなら、人がキッチンとダイニングのどちら側にいるかをセンサで判定する必要もありません。

## ハードウェア

家の中に転がっていた部品と自宅の3Dプリンタで作成しました。

| 主な部品                  | 用途                               |
| :------------------------ | :--------------------------------- |
| Seeed Studio XIAO ESP32C6 | Matter通信とサーボ制御             |
| SG90互換サーボモーター    | Echo Show 5 の回転                 |
| FET 2SK4017               | サーボモーター電源のON / OFF       |
| ユニバーサル基板          | マイコン・FET・モーターの接続      |
| 3Dプリントケース          | 回転台機能と、基板やケーブルの格納 |

本体の重心付近を回転軸にしたことで、小型のSG90互換サーボでも問題なく回転できました。

回路はユニバーサル基板で作成し、サーボの電源はFETでON / OFFしています。基板とサーボモーターは、3Dプリントした台座の内部にすべて収めました。

{{< postfig src="turntable-open.jpg" title="回転台の中身" width="480px">}}

Echo Show 5の電源ケーブルも台座の内部を通し、接続に必要なプラグだけを上面から出しています。

{{< postfig src="turntable-power-cable.jpg" title="回転台の蓋を閉じた状態" width="480px">}}

電源ケーブルが外に広がらず、背面もかなりすっきりしました。

{{< postfig src="turntable-back.jpg" title="すっきりとした背面" width="480px">}}

## ファームウェア

主な機能は以下の通りです。

- Matter対応により、AlexaからON/OFFを操作
- Web画面からON/OFFを操作
- Web画面からON/OFFそれぞれの角度を設定
- Web画面からサーボの回転速度を設定

{{< postfig src="web-settings.png" title="回転角度と動作速度を設定するWeb操作画面" width="480px">}}

## 設計データ

ファームウェアや3Dモデルは下記リンクで公開しています。興味がある方はご覧ください。

- ファームウェア：[ESP32 Matter Turntable - GitHub](https://github.com/kerikun11/esp32-matter-turntable)
- 3Dモデル：[Servo Turntable - MakerWorld](https://makerworld.com/en/models/1740771-servo-turntable#profileId-1849949)

## おわりに

Echo Show 10のような自動追尾はありませんが、我が家ではキッチンとダイニングの2方向を切り替えられれば十分です。

「こっち向いて」と「あっち向いて」の意味が多少曖昧でも、声をかけたら反対を向くので困ることはありません。**それっぽく便利に動けばOK** と割り切れるのも、自作のいいところですね。

ちなみに、今回もファームウェアはほとんどAIに実装してもらいました。

コーディングに関しては欲しい機能を言葉で説明するだけでかなりのところまでやってくれます。

そうなると、これからは**ハードウェアを用意できるか**が重要になってくるかと思っています。

もともと私の趣味は電子工作から始まり、マイコンに触れ、いつの間にかプログラムを書く時間が増えていました。

そしてAIがプログラムを書いてくれるようになった今、また電子工作に帰ってきたような気がします。
