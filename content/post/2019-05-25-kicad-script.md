---
date: "2019-05-25T13:00:00+09:00"
title: "KiCadのフットプリントをPythonで一括編集"
categories:
  - "備忘録"
tags:
  - "KiCad"
  - "Python"
---

## 概要

KiCad の基板エディタ Pcbnew では、デフォルトでPythonスクリプトエディタが付属していて、すでにフットプリントがオブジェクトとして定義されています。

今回は私がよく使う一括変更を紹介します。

<!--more-->

## 使い方

Pcbnew の右のほうにコンソールのアイコンがあるので、そこをクリックするとエディタが立ち上がります。

![Pcbnew](console_icon.png)

そこにPythonコードを書くことで、スクリプトによる一括編集をすることができます。

## よく使うスクリプト

### すべてのリファレンスを非表示にする

```python
import pcbnew
board = pcbnew.GetBoard()
mods = board.GetModules()
for mod in mods:
    ref = mod.Reference()
    print ref.GetText()
    ref.SetVisible(False)
```

### すべてのリファレンスサイズを変更する

```python
import pcbnew
board = pcbnew.GetBoard()
mods = board.GetModules()
for mod in mods:
    ref = mod.Reference()
    print ref.GetText()
    ref.SetTextSize(pcbnew.wxSize(pcbnew.FromMM(0.8),pcbnew.FromMM(0.8)))
    ref.SetThickness(pcbnew.FromMM(0.15))
```

## まとめ

既にPythonのオブジェクトが用意されているので、簡単に使うことができました。

私自身、まだあまり使いこなせていないので大したことはできてませんが、for文による一括編集などができるととても便利です。

リファレンスを深く読めばもっと強力なことができそうですね！

## 参考資料

- [KiCad Pcbnew Python Scripting](https://kicad-downloads.s3.cern.ch/doxygen-python/classpcbnew_1_1MODULE.html)
