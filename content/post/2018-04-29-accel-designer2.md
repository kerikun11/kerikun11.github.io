---
date: "2018-04-29T13:35:38+09:00"
title: "なめらかな加速の設計② 曲線加速の設計"
categories:
  - "説明記事"
tags:
  - "マイクロマウス"
  - "制御"
thumbnail: "icon.png"
---

## 設計1・加速曲線の設計

[前回の記事](/posts/2018-04-29-accel-designer1/)の続きです．

この記事では，前回紹介した **設計1** の曲線加速の設計について考えます．

<!--more-->

### なめらかな加速の設計 目次

- [なめらかな加速の設計① 台形加速と曲線加速](/posts/2018-04-29-accel-designer1/)
- [なめらかな加速の設計② 曲線加速の設計](/posts/2018-04-29-accel-designer2/)
- [なめらかな加速の設計③ 走行距離を考慮した速度設計](/posts/2018-04-29-accel-designer3/)
- [なめらかな加速の設計④ C++による実装例](/posts/2018-04-29-accel-designer4/)

## 設計内容

今回の記事では，下図のように，始点速度 $v_s$ から最大加速度 $a_m$ で加速して終点速度 $v_e$ に達するような速度設計を考えます．

{{< postfig src="design1_cmp.png" title="加速曲線" width="480px" >}}

注意点として，最大加速度 $a_m$ で加速する時間を $t_m$ としたとき，始点速度 $v_s$ と終点速度 $v_e$ の差がある程度小さいと，算出される $t_m$ が負になってしまう場合があります．

したがって，$t_m$の符号によって場合分けをして考える必要があります．

ちなみに，グラフ中の $t_c$ は加速度が曲線である時間を表しています．

加速度が $a_m$ になるまでの時間なので，
最大躍度を $j_m$ と与えると，$t_c = a_m / j_m$ と計算できます．

最大躍度 $j_\max$ や最大加速度 $a_\max$ は，実機の特性や生成した波形を見ながら適当に決めます．

## 拘束条件

今回の設計で与える情報は以下の通りです．

- 最大躍度の大きさ $j_\max > 0$
- 最大加速度の大きさ $a_\max > 0$
- 始点速度 $v_s \in \mathbb{R}$
- 終点速度 $v_e \in \mathbb{R}$

これらをもとに得られる情報は以下の通りです．

- 任意の時刻 $t$ における，加速度 $a(t)$，速度 $v(t)$，位置 $x(t)$ を返す関数

## 導出結果

求めたものは，任意の時刻 $t$ における，加速度 $a(t)$，速度 $v(t)$，位置 $x(t)$ を返す関数です．

### 基本関数

時刻 $t$ における，躍度 $j(t)$, 加速度 $a(t)$, 速度 $v(t)$, 位置 $x(t)$ は，

<div>
$$
\begin{align}
    j(t)
     & :=
    \left\{ \begin{array}{ll}
        0    & (\hspace{2.2em}t \le t_0) \\
        j_m  & (t_0 < t \le t_1)         \\
        0    & (t_1 < t \le t_2)         \\
        -j_m & (t_2 < t \le t_3)         \\
        0    & (t_3 < t \hspace{2.2em})
    \end{array} \right.
    \\
    a(t)
     & :=
    \left\{ \begin{array}{ll}
        0           & (\hspace{2.2em}t \le t_0) \\
        j_m(t-t_0)  & (t_0 < t \le t_1)         \\
        a_m         & (t_1 < t \le t_2)         \\
        -j_m(t-t_3) & (t_2 < t \le t_3)         \\
        0           & (t_3 < t \hspace{2.2em})
    \end{array} \right.
    \\
    v(t)
     & :=
    \left\{ \begin{array}{ll}
        v_0                           & (\hspace{2.2em} t \le t_0) \\
        v_0 + \frac{1}{2}j_m(t-t_0)^2 & (t_0 < t \le t_1)          \\
        v_1 + a_m(t-t_1)              & (t_1 < t \le t_2)          \\
        v_3 - \frac{1}{2}j_m(t-t_3)^2 & (t_2 < t \le t_3)          \\
        v_3                           & (t_3 < t \hspace{2.2em})
    \end{array} \right.
    \\
    x(t)
     & :=
    \left\{ \begin{array}{ll}
        x_0 + v_0(t-t_0)                           & (\hspace{2.2em} t \le t_0) \\
        x_0 + v_0(t-t_0) + \frac{1}{6}j_m(t-t_0)^3 & (t_0 < t \le t_1)          \\
        x_1 + v_1(t-t_1) + \frac{1}{2}a_m(t-t_1)^2 & (t_1 < t \le t_2)          \\
        x_3 + v_3(t-t_3) - \frac{1}{6}j_m(t-t_3)^3 & (t_2 < t \le t_3)          \\
        x_3 + v_3(t-t_3)                           & (t_3 < t \hspace{2.2em})
    \end{array} \right.
\end{align}
$$
</div>

と表すことができます．ただし，各定数は以下の通りです．

### 躍度と加速度の定数

躍度定数 $j_m$,
加速度定数 $a_m$ を以下のように定義します．

<div>
$$
\begin{align}
    j_m & = \mathrm{sign}(v_e-v_s) \times|j_{\max}| \\
    a_m & = \mathrm{sign}(v_e-v_s) \times|a_{\max}|
\end{align}
$$
</div>

$\mathrm{sign}(\cdot)$ は，[引数の符号を返す関数](https://ja.wikipedia.org/wiki/%E7%AC%A6%E5%8F%B7%E9%96%A2%E6%95%B0)です．

このように符号を決定することで，減速の場合にも上記の関数をそのまま使用できるようになります．

### その他の定数

等加速度運動となる時間 $t_m$ および加速度が変化する時間 $t_c$

等加速度時間 $t_m$,
$t_m>0$ のときの曲線速度時間 $t_c$,
$t_m\leq 0$ のときの曲線速度時間 $t_c'$
を以下のように定義します．

<div>
$$
\begin{align}
    t_m  & := \frac{1}{a_m}(v_e - v_s) - \frac{a_m}{j_m} \\
    t_c  & := \frac{a_m}{j_m}                            \\
    t_c' & := \sqrt{\frac{1}{j_m}(v_e-v_s)}
\end{align}
$$
</div>

時刻定数 $t_0,~t_1,~t_2,~t_3$ は，

<div>
$$
\begin{align}
    \begin{array}{ll}
        \left\{ \begin{array}{l}
            t_0 := 0         \\
            t_1 := t_0 + t_c \\
            t_2 := t_1 + t_m \\
            t_3 := t_2 + t_c
        \end{array} \right.
         &
        (t_m > 0)
        \\
        \left\{ \begin{array}{l}
            t_0 := 0          \\
            t_1 := t_0 + t_c' \\
            t_2 := t_1        \\
            t_3 := t_2 + t_c'
        \end{array} \right.
         &
        (t_m \leq 0)
    \end{array}
\end{align}
$$
</div>

と表されます．
$t_m$ によって場合分けがあります．

速度定数 $v_0,~v_1,~v_2,~v_3$ を以下のように定義します．

<div>
$$
\begin{align}
    \begin{array}{ll}
        \left\{ \begin{array}{l}
            v_0 := v_s                        \\
            v_1 := v_0 + \frac{1}{2}j_m t_c^2 \\
            v_2 := v_1 + a_m t_m              \\
            v_3 := v_e
        \end{array} \right.
         &
        (t_m > 0)
        \\
        \left\{ \begin{array}{l}
            v_0 := v_s                                     \\
            v_1 := v_0 + \frac{1}{2}\left( v_s+v_e \right) \\
            v_2 := v_1                                     \\
            v_3 := v_e
        \end{array} \right.
         &
        (t_m \leq 0)
    \end{array}
\end{align}
$$
</div>

位置定数 $x_0,~x_1,~x_2,~x_3$ を以下のように定義します．

<div>
$$
\begin{align}
    \begin{array}{ll}
        \left\{ \begin{array}{l}
            x_0 := 0                         \\
            x_1 := x_0 + v_0 t_c + j_m t_c^3 \\
            x_2 := x_1 + v_1 t_m             \\
            x_3 := x_0 + \frac{1}{2} (v_0+v_3) (2t_c+t_m)
        \end{array} \right.
         &
        (t_m > 0)
        \\
        \left\{ \begin{array}{l}
            x_0 := 0                                       \\
            x_1 := x_0 + v_1 t_c' + \frac{1}{6} j_m t_c'^3 \\
            x_2 := x_1                                     \\
            x_3 := x_0 + 2 v_1 t_c'
        \end{array} \right.
         &
        (t_m \leq 0)
    \end{array}
\end{align}
$$
</div>

## 導出過程

簡単に流れを書きます．

1. とりあえず最大加速度の時間を $t_m$ と置いて，境界点の時刻 $t_0,\cdots,t_3$ を $t_m$ で表す．
1. 図から加速度 $a(t)$ を求める(1次関数)．
1. 加速度の積分 $\int_{t_0}^{t_3}a(t)dt = v_e$ の方程式を解いて， $t_m$ の値を求める．
1. $t_c\leq 0$ なら，図より $t_1=t_2$ であり，$v_1=v_2=\frac{1}{2}(v_s+v_e)$ (←中点)なので，$v_1 = v_s+\\int\_{t_0}^{t_1}a(t)dt = \\frac{1}{2}(v_s+v_e)$ の方程式を解いて $t_1,t_2$ を再定義する．
1. 図より，面積である $x_3$ を求める．
1. 対称性を考えながら，$a(t)$を積分して，$v(t)$を求める．
1. 対称性を考えながら，$v(t)$を積分して，$x(t)$を求める．

ポイントは，積分をする際に，$t_0$ から単純に積分していくのではなく，$t_0$ と $t_3$ の双方から対称性を使って積分しているところです．

これは，$t_m$ の符号による場合分けを最小限に抑えるためです．その結果， $t_m$ による場合分けは境界点の定数のみで，関数の方には現れなくなりました．

## まとめ

今回の記事では，始点速度と終点速度をなめらかにつなぐ曲線加速の設計を行いました．

この時点ではまだ走行距離の拘束については考えられていません．

[次回の記事](/posts/2018-04-29-accel-designer3/)では，走行距離の拘束条件を満たすように，今回設計した曲線加速を組み合わせていきます．

<script type="text/x-mathjax-config">
    MathJax.Hub.Config({tex2jax: {inlineMath: [['$','$'], ['\\(','\\)']]}});
</script>
