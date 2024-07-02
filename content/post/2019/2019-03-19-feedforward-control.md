---
date: "2019-03-19T22:00:00+09:00"
title: "機体速度のフィードフォワード制御"
categories:
  - "説明記事"
tags:
  - "マイクロマウス"
  - "制御"
draft: true
---

## 概要

こんにちは。けりです。

今回は、マイクロマウスの制御の話です。

機体のモデルを使ってフィードフォワード制御をやってみたら、速度の追従特性が一気に改善したのでそれをご紹介します。

<!--more-->

## フィードバック制御とフィードフォワード制御

簡単化のため、外乱やモデル化誤差のない理想的なシステムを考えます。

{{< postfig src="block_FF.png" title="フィードフォワード" width="480px" >}}

$$
y(s) = r(s)
$$

{{< postfig src="K_PID.png" title="フィードバック" width="480px" >}}

$$
y(s) = \frac{P(s)K\_{PID}(s)}{P(s)K\_{PID}(s)+1} r(s)
$$

{{< postfig src="K_PID_P_inv.png" title="フィードフォワード＋フィードバック" width="480px" >}}

$$
y(s) = \left\\{P(s)P^{-1}(s) + \frac{P(s)K\_{PID}(s)}{P(s)K\_{PID}(s)+1} \right\\}r(s)
$$

## 機体のモデルを同定

### 機体の伝達関数

左右のモーターの平均電圧から、機体の並進速度への伝達関数を1次系の線形モデルで近似します。

$$
y(s) = \frac{K_1}{T_1s+1} u(s)
$$

ただし、$T_1$は立ち上がり時間、$K_1$は定常ゲインです。

これは、モーター電圧から速度へのステップ応答を取ることで得ることができます。

## 逆モデルを導出

### 入力を出力で表す

機体のモデルを式変形して、 $u(s)$ について解くと、

$$
\begin{align}
T_1 s y(s) + y(s) &= K_1 u(s)
\newline
\Longleftrightarrow \quad u(s) &= \frac{T_1}{K_1} s y(s) + \frac{1}{K_1} y(s)
\end{align}
$$

と表せます。

### 逆ラプラス変換

これを逆ラプラス変換すると、時間の関数として $u(t)$ が得られます。

$$
u(t) = \frac{T_1}{K_1} \dot{y}(t) + \frac{1}{K_1} y(t)
$$

<script type="text/x-mathjax-config">
    MathJax.Hub.Config({tex2jax: {inlineMath: [['$','$'], ['\\(','\\)']]}});
</script>
