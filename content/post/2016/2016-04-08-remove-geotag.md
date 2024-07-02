---
date: "2016-04-08"
title: "写真から位置情報タグを削除する"
categories:
  - "備忘録"
tags:
  - "ターミナル"
  - "Exiftool"
---

## 概要

写真をブログやSNSにアップロードするときに位置情報のタグをつけたままだと自宅を特定される可能性があり、非常に危険である。今回はそれを削除する方法を紹介する。
<!--more-->

## ツール

  * exiftool

### インストール方法(Linux)

    $ sudo apt-get install exiftool

### インストール方法(Windows)

[ここ](http://www.sno.phy.queensu.ca/~phil/exiftool/)からzipファイルをダウンロードする。

## 使い方

### geotagを削除する

`geotag=`で何も書かなければ、位置情報はなくなる。

    $ exiftool -overwrite_original -geotag= filename

### ついでに回転した写真の修正方法も

エクスプローラ上では正常な写真がBlogなどに乗せると回転してしまう現象がある。それは写真の回転タグが影響しているので、下記コマンドで修正できる。

    $ exiftool -overwrite_original -n -Orientation=1 filename

