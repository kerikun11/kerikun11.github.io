---
title: "なめらかなスラロームの設計③ C++による実装"
date: "2020-04-25T13:00:00+09:00"
categories:
  - "説明記事"
tags:
  - "マイクロマウス"
  - "制御"
thumbnail: "icon.png"
---

[前回の記事](/posts/2020-04-25-slalom-trajectory-2/)の続きです．

今回の記事では，なめらかなスラローム軌道の C++による実装例を紹介します．

<!--more-->

### なめらかなスラロームの設計 目次

- [なめらかなスラロームの設計① スラローム概要](/posts/2020-04-25-slalom-trajectory-1/)
- [なめらかなスラロームの設計② 設計方法](/posts/2020-04-25-slalom-trajectory-2/)
- [なめらかなスラロームの設計③ C++による実装](/posts/2020-04-25-slalom-trajectory-3/)
- [なめらかなスラロームの設計④ 生成結果](/posts/2020-04-25-slalom-trajectory-4/)

## ソースコードの取得

今回紹介するソースコードは，マイクロマウス制御モジュールの一部として

- [GitHub - kerikun11/micromouse-control-module](https://github.com/kerikun11/micromouse-control-module)

に公開しています．

GitHub のコードが最新なので，実際に使用する際はそちらのほうがいいかもしれません．

### 執筆時点のソースコードの取得方法

以下では，[執筆時点のソースコード](https://github.com/kerikun11/micromouse-control-module/tree/v1.0.1) の設計内容を説明します．

GitHubのリポジトリにタグをつけたので，以下のコマンドによって下記で説明されているバージョンのソースコードを取得できます．

```sh
git clone -b v1.0.1 https://github.com/kerikun11/micromouse-control-module.git
cd micromouse-control-module
```

zipファイルでのダウンロードは [こちら](https://github.com/kerikun11/micromouse-control-module/archive/v1.0.1.zip)

## C++クラス設計

以下では，スラロームの軌道生成に必要なC++クラスを簡単に紹介します．

これらのクラスはすべて名前空間 `ctrl` に収められています．

### AccelDesigner

[以前の記事](/posts/2018-04-29-accel-designer1)で紹介した，拘束条件を満たす曲線加減速の軌道を生成するクラスです．

今回はこのクラスに対して，単位 [m] を [rad] とみなして使用します．

以下， [accel_designer.h](https://github.com/kerikun11/micromouse-control-module/blob/v1.0.1/include/accel_designer.h) の抜粋:

```cpp
/**
 * @brief 拘束条件を満たす曲線加減速の軌道を生成するクラス
 *
 * - 移動距離の拘束条件を満たす曲線加速軌道を生成する
 * - 各時刻 $t$ における躍度 $j(t)$，加速度 $a(t)$，速度 $v(t)$，位置 $x(t)$
 * を提供する
 */
class AccelDesigner {
public:
  /**
   * @brief 初期化付きコンストラクタ
   *
   * @param j_max     最大躍度の大きさ [m/s/s/s]，正であること
   * @param a_max     最大加速度の大きさ [m/s/s], 正であること
   * @param v_max     最大速度の大きさ [m/s]，正であること
   * @param v_start   始点速度 [m/s]
   * @param v_target  目標速度 [m/s]
   * @param dist      移動距離 [m]
   * @param x_start   始点位置 [m] (オプション)
   * @param t_start   始点時刻 [s] (オプション)
   */
  AccelDesigner(const float j_max, const float a_max, const float v_max,
                const float v_start, const float v_target, const float dist,
                const float x_start = 0, const float t_start = 0);
  /**
   * @brief 時刻 t [s] における躍度 j [m/s/s/s]
   */
  float j(const float t) const;
  /**
   * @brief 時刻 t [s] における加速度 a [m/s/s]
   */
  float a(const float t) const;
  /**
   * @brief 時刻 t [s] における速度 v [m/s]
   */
  float v(const float t) const;
  /**
   * @brief 時刻 t [s] における位置 x [m]
   */
  float x(const float t) const;
  /**
   * @brief 終点時刻 [s]
   */
  float t_end() const;

protected:
  float t0, t1, t2, t3; /**< @brief 境界点の時刻 [s] */
  float x0, x3;         /**< @brief 境界点の位置 [m] */
  AccelCurve ac, dc; /**< @brief 曲線加速，曲線減速オブジェクト */
};
```

### Pose

平面上の位置および姿勢を表現する座標を表します．

以下， [pose.h](https://github.com/kerikun11/micromouse-control-module/blob/v1.0.1/include/pose.h) の抜粋:

```cpp
/**
 * @brief 位置姿勢の座標
 */
struct Pose {
  float x, y, th; /*< (x, y, theta) 成分 */
};
```

### State

生成した軌道をやりとりするための状態変数です．

以下， [state.h](https://github.com/kerikun11/micromouse-control-module/blob/v1.0.1/include/state.h) の抜粋:

```cpp
/**
 * @brief 軌道制御の状態変数
 */
struct State {
  Pose q;
  Pose dq;
  Pose ddq;
  Pose dddq;
};
```

### slalom::Shape

事前設計によって得られるスラロームの形状を管理するクラスです．

事前に各ターンごとの `Shape` オブジェクトを生成することになります．

コンストラクタが2つあり，生成済みのスラローム形状を代入するものと，拘束条件を与えてスラローム形状を生成するものがあります．

以下， [slalom.h](https://github.com/kerikun11/micromouse-control-module/blob/v1.0.1/include/slalom.h) の抜粋:

```cpp
/**
 * @brief slalom::Shape スラロームの形状を表す構造体
 *
 * メンバー変数は互いに依存して決定されるので，個別に数値を変更することは許されない，
 * スラローム軌道を得るには slalom::Trajectory を用いる．
 */
struct Shape {
  Pose total; /**< @brief 前後の直線を含めた移動位置姿勢 */
  Pose curve; /**< @brief カーブ部分の移動位置姿勢 */
  float straight_prev; /**< @brief カーブ前の直線の距離 [m] */
  float straight_post; /**< @brief カーブ後の直線の距離 [m] */
  float v_ref;         /**< @brief カーブ部分の基準速度 [m/s] */
  float dddth_max;     /**< @brief 最大角躍度の大きさ [rad/s/s/s] */
  float ddth_max;      /**< @brief 最大角加速度の大きさ [rad/s/s] */
  float dth_max;       /**< @brief 最大角速度の大きさ [rad/s] */

public:
  /**
   * @brief 生成済みスラローム形状を代入するコンストラクタ
   */
  Shape(const Pose total, const Pose curve, float straight_prev,
        const float straight_post, const float v_ref, const float dddth_max,
        const float ddth_max, const float dth_max);
  /**
   * @brief 拘束条件からスラローム形状を生成するコンストラクタ
   *
   * @param total 前後の直線を含めた移動位置姿勢
   * @param y_curve_end
   * $y$方向(進行方向に垂直な方向)の移動距離，
   * カーブの大きさを決めるもので，設計パラメータとなる
   * @param x_adv $x$方向(進行方向)の前後の直線の長さ．180度ターンなどでは
   * y_curve_end で調節できないので，例外的にこの値で調節する．
   * @param dddth_max 最大角躍度の大きさ [rad/s/s/s]
   * @param ddth_max 最大角加速度の大きさ [rad/s/s]
   * @param dth_max 最大角速度の大きさ [rad/s]
   */
  Shape(const Pose total, const float y_curve_end, const float x_adv = 0,
        const float dddth_max = 1200 * M_PI, const float ddth_max = 36 * M_PI,
        const float dth_max = 3 * M_PI);
  /**
   * @brief 軌道の積分を行う関数．ルンゲクッタ法を使用して数値積分を行う．
   *
   * @param ad 角速度分布
   * @param s 状態変数
   * @param v 並進速度
   * @param t 時刻
   * @param Ts 積分時間
   */
  static void integrate(const AccelDesigner &ad, State &s, const float v,
                        const float t, const float Ts);
  /**
   * @brief 情報の表示
   */
  friend std::ostream &operator<<(std::ostream &os, const Shape &obj);
};
```

### slalom::Trajectory

走行時にそのときの並進速度から軌道を生成するクラスです．

コンストラクタにてスラローム形状オブジェクトを渡します．

以下， [slalom.h](https://github.com/kerikun11/micromouse-control-module/blob/v1.0.1/include/slalom.h) の抜粋:

```cpp
/**
 * @brief slalom::Trajectory スラローム軌道を生成するクラス
 *
 * スラローム形状 Shape と並進速度をもとに，各時刻における位置や速度を提供する．
 */
class Trajectory {
public:
  /**
   * @brief コンストラクタ
   *
   * @param shape スラローム形状
   * @param mirror_x スラローム形状を$x$軸反転(進行方向に対して左右反転)する
   */
  Trajectory(const Shape &shape, const bool mirror_x = false);
  /**
   * @brief 並進速度を設定して軌道を初期化する関数
   *
   * @param velocity 並進速度 [m/s]
   * @param th_start 初期姿勢 [rad] (オプション)
   * @param t_start 初期時刻 [s] (オプション)
   */
  void reset(const float velocity, const float th_start = 0,
             const float t_start = 0);
  /**
   * @brief 軌道の更新
   *
   * @param state 次の時刻に更新する現在状態
   * @param t 現在時刻 [s]
   * @param Ts 積分時間 [s]
   */
  void update(State &state, const float t, const float Ts) const;
  /**
   * @brief 並進速度を取得
   */
  float getVelocity() const;
  /**
   * @brief ターンの合計時間を取得
   */
  float getTimeCurve() const;
  /**
   * @brief スラローム形状を取得
   */
  const Shape &getShape() const;
  /**
   * @brief 角速度設計器を取得
   */
  const AccelDesigner &getAccelDesigner() const;

protected:
  Shape shape;      /**< @brief スラロームの形状 */
  AccelDesigner ad; /**< @brief 角速度用の曲線加速生成器 */
  float velocity;   /**< @brief 並進速度 */
};
```

## 使用例

以下に基本的な使用例を示します．

コードの流れを見ると，事前の形状設計と実際の走行の流れがわかると思います．

より詳しい使用例は[GitHub](https://github.com/kerikun11/micromouse-control-module)をご覧ください．

```cpp
#include "slalom.h"
#include <iostream>

using namespace ctrl; //< 非推奨な書き方

int main(void) {
  /* 事前の形状設計 */
  /* 設計パラメータを定義 */
  const Pose pose_total = Pose(45, 45, M_PI / 2); //< 探索90度ターンを想定
  const float y_curve = 40;
  /* スラローム形状を作成 */
  slalom::Shape shape(pose_total, y_curve);
  /* 生成結果パラメータの表示 */
  std::cout << shape << std::endl;

  /* 走行時の軌道生成 */
  slalom::Trajectory trajectory(shape); //< 軌道生成器にスラローム形状を渡す
  /* 制御周期 */
  const float Ts = 0.001f;
  /* 走行する並進速度を用いて軌道の生成 */
  const float v = 600;
  trajectory.reset(v);
  /* 状態変数を定義 */
  State s;
  /* スラローム走行 */
  for (float t = 0; t < trajectory.getTimeCurve(); t += Ts) {
    /* 軌道の更新 */
    trajectory.update(s, t, Ts);
    /* 軌道の csv 出力 */
    std::cout << t;              //< 時刻
    std::cout << "," << v;       //< 並進速度
    std::cout << "," << s.dq.th; //< 角速度
    std::cout << "," << s.q.x;   //< 位置 x
    std::cout << "," << s.q.y;   //< 位置 y
    std::cout << "," << s.q.th;  //< 角度
    std::cout << std::endl;
  }
  return 0;
}
```

このコードを実行すると以下のように表示されます．

```s
Slalom Shape
        total:  (45, 45, 1.5708)
        curve:  (40, 40, 1.5708)
        v_ref:  241.59
        straight_prev:  5.00001
        straight_post:  5
        integral error: (0, 0, 1.19209e-07)

0,600,0.0288747,0.6,1.44374e-06,9.62491e-06
0.001,600,0.115499,1.2,2.30998e-05,7.69993e-05
0.002,600,0.259873,1.8,0.000116943,0.000259873
0.003,600,0.461996,2.4,0.000369597,0.000615994
--- 省略 ---
0.111,600,0.0158959,40,39.5548,1.57079
0.112,600,0,40,40.1548,1.5708
```

生成結果と軌道のcsvが表示されました．

余談ですが，スラローム軌道を設計するときは，カーブ前後の直線の長さが正になっていることをしっかり確認しましょう．

## まとめ

今回の記事では，なめらかなスラローム軌道を生成するクラスを紹介しました．

オブジェクト指向になっているので汎用的に使用することができると思います．

[次回の記事](/posts/2020-04-25-slalom-trajectory-4/)では，実際にマイクロマウスで使うパターンの軌道生成結果を紹介します．

<script type="text/x-mathjax-config">
    MathJax.Hub.Config({tex2jax: {inlineMath: [['$','$'], ['\\(','\\)']]}});
</script>
