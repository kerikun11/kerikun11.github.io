---
date: "2017-11-01T10:31:52+09:00"
title: "僕の迷路クラスの紹介"
categories:
  - "作品紹介"
tags:
  - "マイクロマウス"
  - "迷路"
thumbnail: "icon.png"
---

こんにちは．けりです．  

今回もマイクロマウスの話題です．僕が使っている迷路クラスを紹介します．

<!--more-->

## 壁の保管方法

### 壁の冗長表現を廃止

よく使われている壁の変数定義方法に，各区画に1バイト確保して，下位4bitを壁情報，上位4bitを既知壁情報として保存する方法があります．

~~~cpp
/* 1区画の壁構造体 */
union Wall{
    uint8_t flags; //< all
    struct{
        uint8_t e:1; //< east
        uint8_t n:1; //< north
        uint8_t w:1; //< west
        uint8_t s:1; //< south
        uint8_t E:1; //< known east
        uint8_t N:1; //< known north
        uint8_t W:1; //< known west
        uint8_t S:1; //< known south
    };
};

/* 迷路データ */
Wall wall[MAZE_SIZE][MAZE_SIZE];
~~~

しかしこの方法では，1つの壁に対して隣接する2つの区画がそれぞれ壁情報を保持するので冗長な表現になってしまいます．

冗長表現の矛盾を無くすために，壁を更新する際に毎回2つの変数を書き換えるのは無駄です．

メモリを多く消費してしまいますので，迷路のバックアップなどにも時間がかかるでしょう．

### 最小限の壁情報

そこで今回の定義方法は

- 直線状に並んだ32枚の壁を32bitの変数の各bitに割り当て
- 迷路の外周に壁があることは既知なので，変数には含めない

とし，壁の情報を最小限にとどめます．

~~~cpp
#define MAZE_SIZE      32

/* 迷路データ */
uint32_t wall[2][MAZE_SIZE-1]; /**< 壁情報 */
uint32_t known[2][MAZE_SIZE-1]; /**< 既知壁情報 */

wall[0] //< 横並びの壁
wall[1] //< 縦並びの壁
~~~

{{< postfig src="least-maze.png" title="最小限の壁定義方法" >}}

### 情報量の比較

32 x 32 のハーフ迷路の場合，

各区画を1バイトとすると

    1 Byte * 32 区画 * 32 区画 = 1024 Bytes

今回の最小限の壁定義だと

    32bit * (31列 + 31行) * 2 (壁・既知壁) = 496 Bytes

サイズは半分以下になりました．しかも冗長表現はないので，矛盾が生じることはありません．

迷路データのサイズの一覧表

| 迷路の一辺の区画数 | 各区画1Byte表現 [Bytes] | 最小表現 [Bytes] |
| :----------------- | :---------------------- | :--------------- |
| n                  | n^2                     | 1/2*n*(n-1)      |
| 8                  | 64                      | 28               |
| 16                 | 256                     | 120              |
| 32                 | 1024                    | 496              |

## ソースコード

[Maze.h](Maze.h)について，以下の内容を紹介します．

  * includeとマクロ
  * Dir 方向構造体
  * Vector 区画座標構造体
  * Maze 迷路の壁情報を保持するクラス

### includeとマクロ

~~~cpp
/**
* @file Maze.h
* @brief マイクロマウスの迷路クラスを定義
* @author KERI (GitHub: kerikun11)
* @date 2017.10.30
*/
#pragma once

#include <queue>
#include <vector>
#include <array>
#include <algorithm>

/** @def MAZE_SIZE
*  @brief 迷路の1辺の区画数
*/
#define MAZE_SIZE      32
/** @typedef
*   @brief 迷路のサイズのbit数の整数型
*   32x32の迷路ならuint32_t，16x16ならuint16_t，8x8ならuint8_t
*/
typedef uint32_t wall_size_t;
~~~

### Dir構造体

~~~cpp
/** @struc Dir
*  @brief 迷路上の方向を定義
*/
struct Dir{
public:
    /** @enum Dir::AbsoluteDir
    *  @brief 絶対方向の列挙型
    */
    enum AbsoluteDir: int8_t { East, North, West, South, AbsMax };
    /** @enum Dir::RelativeDir
    *  @brief 相対方向の列挙型
    */
    enum RelativeDir: int8_t { Forward, Left, Back, Right, RelMax };
    /** @function Constructor
    *  @param d Absolute Direction
    */
    Dir(const enum AbsoluteDir d = East) : d(d) {}
    Dir(const int8_t d) : d(AbsoluteDir(d&3)) {}

    /** @brief 整数へのキャスト
    */
    operator int8_t() const { return d; }
    /** @brief 代入演算子のオーバーロード
    */
    inline const Dir operator=(const Dir& obj) { this->d = obj.d; return *this; }

    /** @function getRelative
    *  @brief 自オブジェクト方向から見た引数方向を返す．
    *  @param rd 対象方向
    *  @return 相対方向
    */
    inline const Dir getRelative(const enum RelativeDir& rd) const { return Dir(rd-d); }
    /** @function ordered
    *  @brief 「正面，左，右，後」の順序の方向配列を生成する関数
    */
    inline const std::array<Dir, 4> ordered() const ;
    /** @function All
    *  @brief 全方向の方向配列を生成する静的関数
    */
    static const std::array<Dir, 4>& All();
private:
    enum AbsoluteDir d; /**< @brief 方向の実体 */
};
~~~

### Vector構造体

~~~cpp
/** @struct Vector
*  @brief 迷路上の座標を定義．左下の区画が (0,0) の (x,y) 平面
*/
struct Vector{
public:
    int8_t x, y; /**< @brief 迷路の区画座標 */
    Vector(int8_t x=0, int8_t y=0) : x(x), y(y) {} /**< @brief コンストラクタ */
    Vector(const Vector& obj) : x(obj.x), y(obj.y) {} /**< @brief コンストラクタ */
    /** @brief 演算子のオーバーロード
    */
    inline const Vector& operator=(const Vector& obj) { x=obj.x; y=obj.y; return *this; }
    inline const bool operator==(const Vector& obj) const { return x==obj.x && y==obj.y; }
    inline const bool operator!=(const Vector& obj) const { return x!=obj.x || y!=obj.y; }
    /** @function next
    *  @brief 自分の引数方向に隣接した区画のVectorを返す
    *  @param 隣接方向
    *  @return 隣接座標
    */
    inline const Vector next(const Dir &dir) const ;
};
~~~

### Mazeクラス

~~~cpp
/** @class Maze
*  @brief 迷路の壁情報を管理するクラス
*/
class Maze{
public:
    Maze() { reset(); } /**< @brief 空の迷路のコンストラクタ */
    Maze(const Maze& obj){ *this = obj; } /**< @brief コピーコンストラクタ */
    /** @brief 配列から迷路を読み込むコンストラクタ
    *  @param data 各区画16進表記の文字列配列
    *  例：{"abaf", "1234", "abab", "aaff"}
    *  @param east_origin true: 東から反時計回り，false: 北から時計回り に0bitから格納されている
    */
    Maze(const char data[MAZE_SIZE+1][MAZE_SIZE+1], bool east_origin = true);
    /** @brief 代入演算子のオーバーロード，データのコピー
    */
    const Maze& operator=(const Maze& obj);
    /** @function reset
    *  @brief 迷路の初期化．壁を削除し，スタート区画を既知に
    */
    void reset();
    /** @function isWall
    *  @brief 壁の有無を返す
    *  @param v 区画の座標
    *  @param d 壁の方向
    *  @return true: 壁あり，false: 壁なし
    */
    bool isWall(const Vector& v, const Dir& d) const { return isWall(v.x, v.y, d); }
    bool isWall(const int8_t& x, const int8_t& y, const Dir& d) const ;
    /** @function setWall
    *  @brief 壁を更新をする
    *  @param v 区画の座標
    *  @param d 壁の方向
    *  @param b 壁の有無 true:壁あり，false:壁なし
    */
    void setWall(const Vector& v, const Dir& d, const bool& b) { return setWall(v.x, v.y, d, b); }
    void setWall(const int8_t& x, const int8_t& y, const Dir& d, const bool& b) ;
    /** @function isKnown
    *  @brief 壁が探索済みかを返す
    *  @param v 区画の座標
    *  @param d 壁の方向
    *  @return true: 探索済み，false: 未探索
    */
    bool isKnown(const Vector& v, const Dir& d) const { return isKnown(v.x, v.y, d); }
    bool isKnown(const int8_t& x, const int8_t& y, const Dir& d) const ;
    /** @function setWall
    *  @brief 壁の既知を更新する
    *  @param v 区画の座標
    *  @param d 壁の方向
    *  @param b 壁の未知既知 true:既知，false:未知
    */
    void setKnown(const Vector& v, const Dir& d, const bool& b) { return setKnown(v.x, v.y, d, b); }
    void setKnown(const int8_t& x, const int8_t& y, const Dir& d, const bool& b) ;
    /** @function canGo
    *  @brief 通過可能かどうかを返す
    *  @param v 区画の座標
    *  @param d 壁の方向
    *  @return true:既知かつ壁なし，false:それ以外
    */
    bool canGo(const Vector& v, const Dir& d) const ;
    /** @function wallCount
    *  @brief 引数区画の壁の数を返す
    *  @param v 区画の座標
    *  @return 壁の数 0~4
    */
    int8_t wallCount(const Vector& v) const ;
    /** @function wallCount
    *  @brief 引数区画の既知壁の数を返す
    *  @param v 区画の座標
    *  @return 既知壁の数 0~4
    */
    int8_t knownCount(const Vector& v) const ;
    /** @function updateWall
    *  @brief 壁を更新して既知とする関数
    *  @param v 区画の座標
    *  @param d 壁の方向
    */
    void updateWall(const Vector& v, const Dir& d, const bool& b);
    /** @function print
    *  @brief 迷路の表示
    *  @param v ハイライト区画の座標
    */
    void print(const Vector v = Vector(-1,-1)) const ;
    /** @function printPath
    *  @brief パス付の迷路の表示
    *  @param start パスのスタート座標
    *  @param dirs 移動方向の配列
    */
    void printPath(const Vector start, const std::vector<Dir>& dirs) const ;
private:
    wall_size_t wall[2][MAZE_SIZE-1]; /**< 壁情報 */
    wall_size_t known[2][MAZE_SIZE-1]; /**< 既知壁情報 */
};
~~~

## まとめ

迷路の管理方法は様々なものがあります．もっといい方法がありましたら教えてくださいね！
