---
title: "Linuxで画面を3分割して表示する"
date: "2020-04-10T11:13:33+09:00"
categories:
  - "説明記事"
tags:
  - "Linux"
thumbnail: "icon.png"
---

こんにちは．けりです．

最近，縦横比が21:9のウルトラワイドモニタを購入しました．

今回は，そのモニタの画面を3列に分割してウィンドウを配置する方法を紹介します．

私のPCのOSは **Manjaro Linux (Cinnamon)** ですが，他のLinuxでも使える方法だと思います．

<!--more-->

{{< postfig src="monitor.jpg" title="ウルトラワイドモニター" width="300px" >}}

## できたこと

今回の方法の特徴は以下のとおりです．

- 画面を縦に3分割して，ウィンドウを3つ並べる
- 既存の画面2分割のショートカットキー(`Super`+`Left`など)も残す
- デュアルディスプレイ対応
- ショートカットキーで簡単に移動

※LinuxではWindowsキーのことを`Super`キーと呼びます．

### 画面の例

上: 3列に分割したウルトラワイドモニター  
下: 全画面or2列に分割したワイドモニター

{{< postfig src="result.jpg" title="画面を3分割して表示" width="480px" >}}

PCとモニターのスペックは次のとおりです．

| 項目                   | 型番                                                       | 大きさ    | 解像度    |
| ---------------------- | ---------------------------------------------------------- | --------- | --------- |
| ノートPC               | DELL XPS 13 9380                                           | 13.3 inch | 1920x1080 |
| ウルトラワイドモニター | [LG 34WL850-W](https://www.lg.com/jp/monitor/lg-34WL850-W) | 34 inch   | 3440x1440 |

{{< postfig src="info.png" title="PCのシステム情報" >}}

## 試したソフト

画面を3分割する方法はいろいろありますが，  
使いやすいものを見つけるのは結構大変でした．

以下に私が試した方法を列挙します．

- [WinTile](https://github.com/fmstrat/wintile)
  - GNOME Shell の拡張機能
  - 分割数を選ぶが，3分割を選ぶと2分割ができなくなる．
- [gTile](https://cinnamon-spices.linuxmint.com/extensions/view/21)
  - Cinnamon の拡張機能で，ショートカットキーで分割箇所を選択する
  - とりあえず使えたが，毎回いちいち場所を選ぶのが面倒
- [QuickTile](http://ssokolow.com/quicktile/)
  - GTKのAPIをたたくオープンソースソフトウェア
  - 結局これを採用
- [PyGrid](https://github.com/pkkid/pygrid)
  - QuickTileの派生
  - シンプル
- [fakeXRandR](https://github.com/phillipberndt/fakexrandr#how-to)
  - 仮想的にディスプレイを分割して認識させる
  - ディスプレイを分割すると，逆に全画面表示がしづらくなる
  - デュアルディスプレイにしたときに別のモニタに食い込むバグが解決しなかった...

## 最終的に使用した方法

いろいろ試した結果，目的の機能がそろっていたQuickTileを採用しました．

### インストール

[公式ページ](http://ssokolow.com/quicktile/)にしたがってインストールする．

### ショートカットキー

ショートカットキーを以下のように設定しました．

- `Ctrl`+`Super`+`Left`
  - 3分割の左側に配置
- `Ctrl`+`Super`+`Up`
  - 3分割の中央に配置
- `Ctrl`+`Super`+`Right`
  - 3分割の右側に配置
- `Ctrl`+`Super`+`数字`
  - 画面のいろいろな場所に配置

既存の2分割のショートカット`Ctrl`+`Left`などとは重ならないようにしています．

### 設定ファイル

QuickTile の設定ファイルは次の場所に保存されています．

- [~/.config/quicktile.cfg](quicktile.cfg)

```ini
[general]
cfg_schema = 1
ModMask = <Ctrl><Mod4>
MovementsWrap = True
ColumnCount = 3

[keys]
0 = maximize
1 = bottom-left
2 = bottom
3 = bottom-right
4 = left
5 = center
6 = right
7 = top-left
8 = top
9 = top-right
Left = left
Up = center
Right = right
```

### 設定ファイルの中のMod4とは？

`Alt`キーや`Super`キーは，`Mod数字`という名前で記述するようです．

以下のコマンドでSuperキーなどがModいくつなのかを確認できます．

```shell
$ xmodmap
xmodmap:  up to 4 keys per modifier, (keycodes in parentheses):

shift       Shift_L (0x32),  Shift_R (0x3e)
lock
control     Control_L (0x25),  Control_L (0x42),  Control_R (0x69)
mod1        Alt_L (0x40),  Alt_R (0x6c),  Meta_L (0xcd)
mod2        Num_Lock (0x4d)
mod3
mod4        Super_L (0x85),  Super_R (0x86),  Super_L (0xce),  Hyper_L (0xcf)
mod5        ISO_Level3_Shift (0x5c),  Mode_switch (0xcb)
```

### ちょっとした不具合

だいたい目的の機能は得られましたが，ひとつだけ不満な点があります．

なぜか，ウィンドウがスナップされた状態からだと3分割などのコマンドが反応しません．

画面のスナップを解除してから移動する必要がありました．

## まとめ

ウルトラワイドモニターを3分割して表示すると，サイズ感がぴったりでとても見やすいです．

ぜひご活用ください！
