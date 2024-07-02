---
title: "Manjaro Linux でデスクトップがしばしばフリーズする問題の解決方法"
date: "2020-04-24T12:05:29+09:00"
categories:
  - "備忘録"
tags:
  - "Linux"
---

今回の記事は、同じような不具合を抱えている方への情報共有です。

<!--more-->

## 症状

私が Manjaro Linux Cinnamon で体験したフリーズの症状は以下のとおりです。

- ウィンドウを動かしたときや、文字入力中などにデスクトップが突然フリーズしてしまう
- マウスは動くがクリックなどをしても反応がない
- キーボードを押しても反応がない
- `Ctrl+Alt+F2` を押すとターミナルが起動する
- そのターミナルで、コマンド `killall -HUP cinnamon; cinnamon --replace --display=:0` を実行すると、セッションが再起動されて復旧する
- ソフトウェアレンダリングセッションでは、デスクトップ全体はフリーズしないが、ウィンドウ単位でフリーズすることがある

## 環境

私のPC環境は以下のとおりです。

![システム情報](sysinfo.png)

構成は、`DELL XPS 13 (9380)` + `Manjaro Linux Lysia 20.0 Cinnamon` です。

グラフィックスは、CPU内臓の `Intel UHD Graphics 620` です。

## 解決策

以下のようにファイルを記述することで完全に治りました。

```sh
$ cat /etc/X11/xorg.conf.d/20-intel.conf
Section "Device"
   Identifier  "Intel Graphics"
   Driver      "intel"
   Option      "AccelMethod"  "uxa"
EndSection
```

どうやらグラフィックドライバのオプションの設定が必要だったようです。

## おわりに

これが正しい方法かはわかりませんが、治ったのでよしとしましょう。

同じような不具合を抱えている方は是非試してみてくだい。

- 参考文献: [アクセラレーションメソッドの選択 - Arch Wiki](https://wiki.archlinux.jp/index.php/Intel_Graphics#.E3.82.A2.E3.82.AF.E3.82.BB.E3.83.A9.E3.83.AC.E3.83.BC.E3.82.B7.E3.83.A7.E3.83.B3.E3.83.A1.E3.82.BD.E3.83.83.E3.83.89.E3.81.AE.E9.81.B8.E6.8A.9E)
