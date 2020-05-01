---
title: "機体速度のフィードフォワード補償付きフィードバック制御① モデルと実装"
date: "2020-04-26T11:00:00+09:00"
categories:
  - "作品紹介"
tags:
  - "マイクロマウス"
  - "制御"
thumbnail: ""
draft: true
---

## はじめに

こんにちは．けりです．

今回はマイクロマウスの制御関連の話題です．

C++で実装した制御器クラスとゲインチューニング方法について紹介します．

マイクロマウスなどの2輪自動車においては，モーター電圧を調整して機体の速度を制御する部分です．

具体的には，フィードフォワード補償付きPIDフィードバック制御を紹介します．

<!--more-->

### もくじ

記事が少し長くなったので，次のように2ページにわけました．

1. 制御器の構造と実装
1. ゲインチューニング方法の紹介

## 制御の概要

今回対象とする部分は，機体の速度制御です．

左右のモーターのPWMを調節して，目標の並進速度および角速度に追従させる部分です．

## 機体のモデル

まずはじめにフィードフォワード補償のための機体のモデルを説明します．

### 入出力

簡単のため，機体のモデルは，並進と回転それぞれ線形1次遅れ系であると考えます．

つまり，機体のモデルとして，次のような入出力を考えます．

- 並進
  - 入力 $u(t)$: 左右のモーターのPWMデューティー比の平均
  - 出力 $y(t)$: 並進速度
- 回転
  - 入力 $u(t)$: 左右のモーターのPWMデューティー比の差
  - 出力 $y(t)$: 回転角速度

### 機体の伝達関数

PWM値から，機体の速度への伝達関数を1次系の線形モデルで近似します．

$$
y(s) = \frac{K_1}{T_1s+1} u(s)
$$

ただし，$T_1$は立ち上がり時間，$K_1$は定常ゲインです．

これは，PWMのデューティ比から速度へのステップ応答を取ることで得ることができます．

### 入力を出力で表す

機体のモデルを式変形して， $u(s)$ について解くと，

$$
\begin{align}
T_1 s y(s) + y(s) &= K_1 u(s)
\newline
\Longleftrightarrow \quad u(s) &= \frac{T_1}{K_1} s y(s) + \frac{1}{K_1} y(s)
\end{align}
$$

と表せます．

これを逆ラプラス変換すると，時間の関数として $u(t)$ が得られます．

$$
u(t) = \frac{T_1}{K_1} \dot{y}(t) + \frac{1}{K_1} y(t)
$$

## C++実装

### 状態変数の型

状態変数の型は，テンプレート引数で受け取ります．

```cpp
/**
 * @tparam T 状態変数の型
 */
template <typename T>
```

### フィードフォワードモデル構造体

```cpp
/**
 * @brief フィードフォワード成分に使用する1次モデル
 * @tparam T 状態変数の型
 */
template <typename T>
struct Model {
  T K1; /** 1次モデルの定常ゲイン (使用しない場合は 0 とすること) */
  T T1; /** 1次モデルの時定数 (使用しない場合は 1 とすること) */
};
```

### フィードバックゲイン構造体

```cpp
/**
 * @brief フィードバック成分に使用するPIDゲイン
 * @tparam T 状態変数の型
 */
template <typename T>
struct Gain {
  T Kp; /**< フィードバック比例ゲイン */
  T Ki; /**< フィードバック積分ゲイン */
  T Kd; /**< フィードバック微分ゲイン */
};
```

### ゲインチューニング用の成分内訳構造体

```cpp
/**
 * @brief 制御入力の成分内訳．
 * ゲインチューニングの際に可視化するために使用する．
 */
template <typename T>
struct Breakdown {
  T ff;  /**< フィードフォワード成分 */
  T fb;  /**< フィードバック成分 */
  T fbp; /**< フィードバック成分のうち比例成分 */
  T fbi; /**< フィードバック成分のうち積分成分 */
  T fbd; /**< フィードバック成分のうち微分成分 */
  T u;   /**< 成分の総和 */
};;
```

### 制御器クラス

```cpp
/**
 * @brief 1次フィードフォワード補償付きフィードバック制御器クラス
 * @tparam T 状態変数の型
 */
template <typename T>
class FeedbackController {
public:
  /**
   * @brief コンストラクタ
   *
   * @param M フィードフォワードモデル
   * @param G フィードバックゲイン
   */
  FeedbackController(const Model &M, const Gain &G) : M(M), G(G) { reset(); }
  /**
   * @brief 積分項をリセットする関数
   */
  void reset() { e_int = T(); }
  /**
   * @brief 状態を更新して，次の制御入力を得る関数
   *
   * @param r 目標値
   * @param y 観測値
   * @param dr 目標値の微分
   * @param dy 観測値の微分
   * @param Ts 離散時間周期
   */
  const T update(const T &r, const T &y, const T &dr, const T &dy,
                 const float Ts) {
    /* feedforward signal */
    bd.ff = (M.T1 * dr + r) / M.K1;
    /* feedback signal */
    bd.fbp = G.Kp * (r - y);
    bd.fbi = G.Ki * e_int;
    bd.fbd = G.Kd * (dr - dy);
    bd.fb = bd.fbp + bd.fbi + bd.fbd;
    /* calculate control input value */
    bd.u = bd.ff + bd.fb;
    /* integral error */
    e_int += (r - y) * Ts;
    /* complete */
    return bd.u;
  }
  /** @brief フィードフォワードモデルを取得する関数 */
  const Model &getModel() const { return M; }
  /** @brief フィードバックゲインを取得する関数 */
  const Gain &getGain() const { return G; }
  /** @brief 制御入力の内訳を取得する関数 */
  const Breakdown &getBreakdown() const { return bd; }

protected:
  Model M;      /**< @brief フィードフォワードモデル */
  Gain G;       /**< @brief フィードバックゲイン */
  Breakdown bd; /**< @brief 制御入力の計算内訳 */
  T e_int;      /**< @brief 追従誤差の積分値 */
};
```

### ライブラリ化したもの

名前空間 `ctrl` などを追加して，ファイルにまとめたものが以下です．

- [feedback_controller.h](feedback_controller.h)

### 使用例

```cpp
#include "feedback_controller.h"
#include <iostream>

int main(void) {
  /* Feedforward Model and Feedback Gain */
  ctrl::FeedbackController<float>::Model model;
  ctrl::FeedbackController<float>::Gain gain;
  /* Controller */
  ctrl::FeedbackController<float> feedback_controller(model, gain);
  /* Control Period [s] */
  const float Ts = 0.001f;
  /* Control */
  feedback_controller.reset();
  while (1 /* write breaking condition */) {
    const float r = 1.0f;  //< reference of output
    const float y = 0.5f;  //< measurement output
    const float dr = 0.0f; //< reference of output
    const float dy = 0.0f; //< measurement output
    const float u = feedback_controller.update(r, y, dr, dy, Ts);
    /* apply control input u here */
  }
  return 0;
}
```

## おわりに

<script type="text/x-mathjax-config">
    MathJax.Hub.Config({tex2jax: {inlineMath: [['$','$'], ['\\(','\\)']]}});
</script>
