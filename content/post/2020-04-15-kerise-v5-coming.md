---
date: "2020-04-15T21:53:42+09:00"
title: "New KERISE v5，登場"
categories:
  - "作品紹介"
tags:
  - "マイクロマウス"
  - "ロボット"
  - "KERISE"
thumbnail: "icon.jpg"
---

こんにちは．けりです．

今回の記事では，新作マイクロマウス「KERISE v5」を紹介します．

<!--more-->

{{< postfig src="kerise-v5-coin.jpg" title="KERISE v5" width="300px" >}}

## New KERISE v5，登場

KERISE v5は私が制作しているマイクロマウス **KERISE** の第5作目です．

{{< postfig src="kerise-v5.jpg" title="KERISE v5" width="300px" >}}
{{< postfig src="kerise-v5-1.jpg" title="KERISE v5" width="300px" >}}
{{< postfig src="kerise-v5-2.jpg" title="KERISE v5" width="300px" >}}
{{< postfig src="kerise-v5-3.jpg" title="KERISE v5" width="300px" >}}
{{< postfig src="kerise-v5-6.jpg" title="KERISE v5" width="300px" >}}

### コンセプト

コンセプトは，動きやすい小型2輪です．

KERISE v4からタイヤ径やモーターの大きさは維持しつつ，吸引ファンを取り除いて2輪にしたことで，極限まで小型化しました．

KERISE v3 と KERISE v4 は4輪でしたが，
厳密に制御できない4輪の機体ではわからないことが多かったので，
思い切って2輪に戻すことにしました．

これでしばらくは制御の確認をしたいと思っています．

回路自体はKERISE v4のマイナーアップデートなので，
安定性が向上しているはずです．

### スペック

KERISE v5 のスペックは以下の通りです．

WiFi機能を搭載したマイコンを使用していますが，技適などの問題からアンテナを搭載しておらず，使用することはできません．

| 項目             | 値                            | 注記                           |
| ---------------- | ----------------------------- | ------------------------------ |
| 縦 x 横 x 高     | 30 [mm] x 32 [mm] x 12.6 [mm] |                                |
| 重量             | 8.72 [g] / 6.08 [g]           | バッテリー あり/なし           |
| マイコン         | ESP32-PICO-D4                 | 240MHz dual core               |
| モーター         | Φ6 [mm] x 10 [mm]             | AliExpress ノーブランド        |
| モータードライバ | DRV8835                       | 1.5A x 2ch                     |
| エンコーダ       | MA730 + Φ3 x 1 [mm] 磁石      | 自作磁気式エンコーダ           |
| IMU              | ICM-20602                     | 3軸加速度 + 3軸ジャイロ        |
| ToF              | VL6180X                       | 赤外線レーザー測距センサ       |
| フォトリフレクタ | SFH4045N + SFH3015FA          | 赤外線LED + フォトトランジスタ |
| バッテリー       | 100 [mAh], 16 x 18 x 6.5 [mm] | AliExpress ノーブランド Li-Po  |

{{< postfig src="kerise-v5-weight.jpg" title="KERISE v5 の重量" width="240px" >}}

重量は1.6こじまうす程度ですね．こじまうす軽すぎ...

### 基板設計

2層基板ですが，吸引ファンがない分，比較的余裕があります(?)

{{< postfig src="kerise-v5-8.jpg" title="KERISE v5 の基板" width="300px" >}}

{{< postfig src="kerise-v5-board-3d.png" title="KERISE v4 の基板設計" width="300px" >}}

## 特徴

今作の特徴をいくつか紹介します．

### 小型設計

なんといってもKERISE v5の特徴は小さいことです．

なんと，ハーフサイズのさらに半分の**クオーターサイズ**の迷路を走ることができます．(斜めは走れませんが...)

{{< postfig src="kerise-v5-coin.jpg" title="KERISE v5" width="300px" >}}

500円玉と比較すると，その小ささをおわかり頂けるでしょう．

僕は**小さくて賢い**ロボットが好きなので，とにかく小さく作ることに注力しています．

### 低重心

以下の写真は横から見たKERISE v5です．

{{< postfig src="kerise-v5-5.jpg" title="KERISE v5" width="300px" >}}

すべてのボディは車輪の直径よりも低い位置に収まっています．

車高もかなり低く，さらにモーターも基板上に接していて，十分低い位置にあります．

段差にはあまり強くないかもしれませんが，走行自体は比較的安定すると思います．

### 低慣性

今回は(珍しく)バッテリーの大きさを考えながら設計したので，バッテリーが中央にぴったりハマっています．

重い部品が機体中央に寄っているので，慣性モーメントが小さく，回転しやすくなっています．

{{< postfig src="kerise-v5-7.jpg" title="KERISE v5" width="300px" >}}

重量も 10g を切っているので，総合的に低慣性と言えるでしょう．

### フォトリフレクタの更新

今までは，基板の正面に赤外線LEDとセンサを配置して，間に別の基板を挟んで遮光をしていました．

はんだ付け難易度が高く，4つのセンサの特性を揃えるのが大変でした．

それに対して今作では，基板の表に赤外線LED，裏側に赤外線センサを設置することで，基板自体を遮光板として使用しています．

部品点数や信頼性が向上しました．

{{< postfig src="photo-reflector-v4.jpg" title="KERISE v4 のフォトリフレクタ" width="300px" >}}
{{< postfig src="photo-reflector-v5.jpg" title="KERISE v5 のフォトリフレクタ" width="300px" >}}

## 過去のKERISEとの比較

最後に過去のKERISEと並べて撮った写真を紹介します．

### KERISE v4 との比較

吸引4輪機構のKERISE v4とは形がかなり異なり，KERISE v5は非吸引の2輪です．

{{< postfig src="kerise-v4-v5.jpg" title="KERISE v4 と KERISE v5" width="360px" >}}

### 歴代KERISE

久々に過去のKERISEを取り出して記念撮影をしてみました．

{{< postfig src="kerise-v1-v5.jpg" title="KERISE v1 から KERISE v5 までの集合" width="480px" >}}

右上がKERISE v1，左上がKERISE v2，左下から順にKERISE v3，KERISE v4，KERISE v5です．

こうしてみると，KERISEは順調に小型化を繰り返してきたことがわかります．

KERISE v5は，KERISE v1を相似比2:1で小型化させたような形をしています．

今後のKERISEはさらに小さくなるのでしょうか...?

## おわりに

しばらく4輪のマウスしか触っていなかったのですが，
久々に2輪のマウスに戻ってきました．

果たして制御はしやすいのでしょうか...

4輪のKERISE v4と2輪のKERISE v5のマイコンは同じなので，
ファームウェアは共通にして，比較しながら調整してみようと思っています．

これをもとに制御のアルゴリズムをいろいろ検討していきたいです．
