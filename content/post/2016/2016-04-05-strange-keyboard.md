---
date: "2016-04-05"
title: "変なキーボード"
categories:
  - "作品紹介"
tags:
  - "PIC"
  - "PIC18F26K22"
  - "キーボード"
  - "電光掲示板"
  - "ドットマトリクスLED"
thumbnail: "icon.jpg"
---

## つくったもの

ASCIIキーボードとスクロール表示器を作りました。

{{< postfig src="figure.png" title="figure" >}}

## 変なキーボード

  1. キーボードの表面には２つのロータリースイッチがついています。それらを回すことで文字を選び、送信ボタンを押して送信します。
  1. もし間違った文字を送信してしまったら、送信ボタンを長押しすることで１文字ずつ削除することができます。
  1. 文章ができたら、送信ボタンをさらに長押しすることで、Enterになり、文を始めからスクロールします。

<!--more-->

## ASCIIコード表

この表のとおりにロータリースイッチを回せば、好きな文字を表示させることができます。

{{< postfig src="table.png" title="ASCIIコード表" >}}
ただし、SP=スペース、Del=全消去

## メモリー機能

### 使い方

  1. スクロール表示器の裏のボタンを押すとそのボタンに記憶されている文が表示されます。
  1. ボタンが４つあるので、４文まで記憶することができます。
  1. 文がスクロールしている状態で、裏のボタンを長押しすることで、その文を記憶します。

### デフォルトで記憶している文字列

  1. "This is an LED bulletin board."
  1. "4 sentences can be memorized."
  1. "When a button is pressed, the sentence which memorized by the button is shown."
  1. "When a button is pressed for a long time, a sentence is memorized."

## スクロールディスプレイの動画

<iframe width="640" height="360" src="https://www.youtube.com/embed/-ihBUG-Tf2U" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>

## ソースファイル

両方ともPIC18F26K22用のプログラムです。

  * [scroll-display.c](scroll-display.c)
  * [ascii-generator.c](ascii-generator.c)

※文字化けするようでしたら、右クリックで保存してから開いてください。

## まとめ

とても入力に時間がかかって何の役にも立ちませんが、ユニークでおもしろいものができました。プログラムはかなり複雑です。頑張りました。。

