---
title: "なめらかなスラロームの設計④ 生成結果"
date: "2020-04-25T14:00:00+09:00"
categories:
  - "説明記事"
tags:
  - "マイクロマウス"
  - "制御"
thumbnail: "icon.png"
---

[前回の記事](/posts/2020-04-25-slalom-trajectory-3/)の続きです．

今回の記事では，
前回までに紹介してきた内容をもとに，
[マイクロマウスの走行パターン](/posts/2017-09-03-pattern-of-turn/)の軌道設計結果を紹介します．

<!--more-->

### なめらかなスラロームの設計 目次

- [なめらかなスラロームの設計① スラローム概要](/posts/2020-04-25-slalom-trajectory-1/)
- [なめらかなスラロームの設計② 設計方法](/posts/2020-04-25-slalom-trajectory-2/)
- [なめらかなスラロームの設計③ C++による実装](/posts/2020-04-25-slalom-trajectory-3/)
- [なめらかなスラロームの設計④ 生成結果](/posts/2020-04-25-slalom-trajectory-4/)

## スラローム軌道の生成

ここでは，1区画が 90 [mm] のマイクロマウス競技のスラローム走行軌道を紹介します．

### 最大角躍度，角加速度，角速度

設計に必要な共通のパラメータを以下に示します．

| 項目         | 値                 |
| ------------ | ------------------ |
| 最大角躍度   | 216000 [deg/s/s/s] |
| 最大角加速度 | 6480 [deg/s/s]     |
| 最大角速度   | 540 [deg/s]        |

これらの値は実際の生成結果のグラフを見ながら選定した値です．

### 生成結果

マイクロマウスの各走行パターンに対して，スラローム軌道の生成を行いました．

まずは，結果のパラメータを以下の表に示します．

| 種類 | 旋回角度 $\theta_\mathrm{end}$ [deg] | 移動変位 $(x_\mathrm{end}$, $y_\mathrm{end})$ [mm] | 曲線部分 $(x_\mathrm{curve}$, $y_\mathrm{curve})$ [mm] | 基準並進速度 [mm/s] | 旋回前直線長 [mm] | 旋回後直線長 [mm] |
| ---- | ------------------------------------ | -------------------------------------------------- | ------------------------------------------------------ | ------------------- | ----------------- | ----------------- |
| S90  | 90                                   | (45, 45)                                           | (40, 40)                                               | 241.59              | 5.00001           | 5                 |
| F45  | 45                                   | (90, 45)                                           | (72.4263, 30)                                          | 411.636             | 2.57365           | 21.2132           |
| F90  | 90                                   | (90, 90)                                           | (70, 70)                                               | 422.783             | 20                | 20                |
| F135 | 135                                  | (45, 90)                                           | (33.1373, 80)                                          | 353.609             | 21.8627           | 14.1421           |
| F180 | 180                                  | (0, 90)                                            | (0, 90)                                                | 412.228             | 24                | 24                |
| FV90 | 90                                   | (63.6396, 63.6396)                                 | (48, 48)                                               | 289.908             | 15.6396           | 15.6396           |

次にそれぞれの軌道のグラフを示します．

#### #0 探索 90 度

![スラローム形状](shape/shape_0_xy.svg)

角速度曲線のグラフは[こちら](shape/shape_0_t.svg)

#### #1 最短 45 度

![スラローム形状](shape/shape_1_xy.svg)

角速度曲線のグラフは[こちら](shape/shape_1_t.svg)

#### #2 最短 90 度

![スラローム形状](shape/shape_2_xy.svg)

角速度曲線のグラフは[こちら](shape/shape_2_t.svg)

#### #3 最短 135 度

![スラローム形状](shape/shape_3_xy.svg)

角速度曲線のグラフは[こちら](shape/shape_3_t.svg)

#### #4 最短 180 度

![スラローム形状](shape/shape_4_xy.svg)

角速度曲線のグラフは[こちら](shape/shape_4_t.svg)

#### #5 最短斜め 90 度

![スラローム形状](shape/shape_5_xy.svg)

角速度曲線のグラフは[こちら](shape/shape_5_t.svg)

なめらかなスラロームの軌道が生成されていますね！

## おわりに

今回の記事では，マイクロマウスの各走行パターンを実現する軌道の生成例を紹介しました．

ステッピングモーターのマイクロマウスなどでは，この軌道をフィードフォワード的に与えるだけでそれなりに走ってくれると思います．

### 総まとめ

さて，一連の記事でなめらかなスラローム軌道の設計を紹介しました．

実際に [KERISE v4](/posts/2018-05-03-kerise-v4-coming/) は今回の方法でスラローム走行しています．

このように理論的に走りやすいなめらかな目標軌道を与えることで，拘束でもクラッシュしづらい安定した走行が期待できます．

今回の記事では目標軌道の生成までだったので，時間があれば次は軌道追従制御についてのC++実装を紹介したいと思っています．

それではまた！

<script type="text/x-mathjax-config">
    MathJax.Hub.Config({tex2jax: {inlineMath: [['$','$'], ['\\(','\\)']]}});
</script>