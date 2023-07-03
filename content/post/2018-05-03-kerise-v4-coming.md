---
date: "2018-05-02T14:53:42+09:00"
title: "New KERISE v4, 登場"
categories:
  - "作品紹介"
tags:
  - "マイクロマウス"
  - "ロボット"
  - "KERISEv4"
thumbnail: "icon.jpg"
---

こんにちは。けりです。

ようやく形になった今年の新作「KERISE v4」を紹介します。

<!--more-->

{{< postfig src="kerisev4.jpg" title="KERISE v4" width="360px" >}}

## KERISE v4

見た目は KERISE v3 とそっくりですが、中身はいろいろ変わった KERISE v4 です。

{{< postfig src="kerisev4-front1.jpg" title="KERISE v4" width="360px" >}}
{{< postfig src="kerisev4-front.jpg" title="KERISE v4" width="360px" >}}
{{< postfig src="kerisev4-left.jpg" title="KERISE v4" width="360px" >}}
{{< postfig src="kerisev4-right.jpg" title="KERISE v4" width="360px" >}}
{{< postfig src="kerisev4-back.jpg" title="KERISE v4" width="360px" >}}
{{< postfig src="kerisev4-bottom.jpg" title="KERISE v4" width="360px" >}}

<!-- ## スペック

| 項目             | 型番                    |
| :--------------- | :---------------------- |
| マイコン         | ESP32                   |
| 動作周波数       | 240MHz                  |
| RAM              | 520kB                   |
| Flash Memory     | 4MB                     |
| バッテリ         | ノーブランド 100mAh     |
| モータ           | ノーブランド 0610サイズ |
| モータードライバ | DRV8835                 |
| 6軸センサ        | ICM-20602               | --> |

## KERISE v3 との比較

KERISE v3 と比較すると、一回り小さくなったことが分かります。

{{< postfig src="kerise_cmp1.jpg" title="KERISE v3 と KERISE v4 と 100円玉" width="480px" >}}
{{< postfig src="kerise_cmp2.jpg" title="KERISE v3 と KERISE v4 と 100円玉" width="480px" >}}

| サイズ    | KERISE v3 | KERISE v4 |
| :-------- | :------- | :------- |
| 縦 [mm]   | 46       | 43       |
| 横 [mm]   | 37       | 33       |
| 高さ [mm] | 22       | 22       |
| 重さ [g]  | 15.91    | 12.97    |

## 特徴

### 6軸センサを2つ搭載

今回のマウスには、6軸モーションセンサを2つ搭載しました。

これは、角加速度を測定するためです。PID制御のD成分を計算する際に役立つと思います。

{{< postfig src="board.jpg" title="KERISE v4 基板" width="360px" >}}

細い部分の両サイドについている正方形の黒いICが6軸センサです。

LGAというパッドが裏側にしかない部品なので、ちゃんとついているのかよくわかりません...(汗

### フォトリフレクタの改良

今までのフォトリフレクタは電源のノイズに弱く、モーターのノイズの影響を受けていました。

そこで、回路を改良してノイズ対策をしました。

{{< postfig src="reflector.png" title="リフレクタの回路" width="480px" >}}

変わった部分は発光回路です。森永式発光回路を拡張して、充電と放電をFETによって分離しました。

この発光回路は、電源ノイズの影響を受けづらくなっています。

※執筆時の回路ではQ1のFETの極性が間違っていたので修正しました。

### 遮光基板

遮光板は基板を使っており、はんだ付けで固定してあるので外れることはありません。

{{< postfig src="reflector.jpg" title="リフレクタ" width="360px" >}}

### 車輪の軸受けの改良

今までは、1つの車輪に対し、ベアリングは1つだったので、軸が少しぐらぐらしていました。

そこで、マウンタの中にベアリングを2枚置いて、安定させました。

{{< postfig src="axis.png" title="軸の断面" width="360px" >}}

内径1mm 外形3mm 厚み1mmのかなり小さいベアリングです。

## まとめ

昨年末から設計を続けてきた新しいKERISEですが、やっと形になってきました。

これが上手く動いてくれると嬉しいのですが、さあどうでしょうか...

ではまた！
