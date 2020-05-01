---
title: "C++による迷路ライブラリの実装"
date: "2020-04-07T17:26:54+09:00"
categories:
  - "作品紹介"
tags:
  - "マイクロマウス"
  - "迷路"
thumbnail: ""
draft: true
---

マイクロマウスの迷路探索ライブラリ

[GitHub](https://github.com/kerikun11/MazeLibrary)

<!--more-->

## ライブラリ構成

### 名前空間

この迷路探索ライブラリは，すべて `MazeLib` 名前空間に収められている．

### クラス・構造体・共用体・型

| 型         | 意味       | 用途                                                   |
| ---------- | ---------- | ------------------------------------------------------ |
| Position   | 区画位置   | 迷路上の区画の位置を表すクラス．                       |
| Positions  | 位置の配列 | ゴール位置などの位置の集合を表せる．                   |
| Direction  | 方向       | 迷路上の方向（東西南北，左右，斜めなど）を表すクラス． |
| Directions | 方向の配列 | 始点位置を指定することで移動経路を表せる．             |
| WallIndex  | 壁の識別   | 迷路上の壁の位置を表すクラス．壁情報の管理に使用．     |
| Maze       | 迷路       | 迷路のスタートやゴール位置，壁情報などを保持するクラス |
| StepMap    | 歩数マップ | 足立法の歩数マップを表すクラス．移動経路導出に使用．   |

### 定数

| 定数          | 意味                    | 用途                              |
| ------------- | ----------------------- | --------------------------------- |
| MAZE_SIZE     | 迷路の最大区画          | 16 or 32 などの迷路サイズを定義． |
| MAZE_SIZE_BIT | 迷路の最大区画の bit 数 | bit shift などに使用．            |

## コンピュータでの動作確認

### 依存パッケージ

- gcc
- cmake

### 動作確認 Linux コマンド

```sh
## クローン
git clone https://github.com/kerikun11/MazeLibrary.git
## 移動
cd MazeLibrary
## 作業ディレクトリを作成
mkdir build
cd build
## 初期化 (Makefileの生成)
cmake ..
## 実行
make search
## コマンドラインにアニメーションが流れる
```

## 使用例

- [main.cpp](test_search/main.cpp)

## 設定項目

### 迷路サイズ

- [include/Maze.h](include/Maze.h)

```cpp
static constexpr int MAZE_SIZE = 16;
```
