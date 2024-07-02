---
date: "2023-07-03T15:45:00+09:00"
title: "単眼鏡をスマホに固定する治具の作成"
categories:
  - "作品紹介"
tags:
  - "カメラ"
  - "3Dプリント"
thumbnail: "icon.jpg"
---

## はじめに

こんにちは。  
マウス合宿に参加して開発モチベーションを少し取り戻したけりです。

今回の記事はマウスとは関係ありませんが、  
3Dプリンタで作った単眼鏡の固定治具を紹介します。

<!--more-->

## スマホに単眼鏡を固定したい

なんとなくスマホのカメラに単眼鏡を当ててみたところ、思ったよりいい感じに撮ることができることがわかりました。

ただ、単眼鏡はリングを回してピントを合わせる必要があり、手持ちだと光軸がすぐにズレてしまって撮影するのは結構大変です。

そこで単眼鏡をスマホに固定する治具を作ってみることにしました。

{{< postfig src="monocular.jpg" title="スマホに単眼鏡を固定したい" width="360px" >}}

## 作ったもの

さて、今回制作したものはこちらです。

画面が若干ふさがっていますが、まあ使えるのでよしとしましよう。

単眼鏡は[Vixen Multi Monocular 4x12](https://www.vixen.co.jp/product/1105_06/)、スマホは[HUAWEI P30 Pro](https://consumer.huawei.com/jp/phones/p30-pro/specs/)です。

{{< postfig src="monocular-jig-1.jpg" title="単眼鏡をスマホに固定する治具" width="360px" >}}
{{< postfig src="monocular-jig-2.jpg" title="単眼鏡をスマホに固定する治具（表）" width="360px" >}}
{{< postfig src="monocular-jig-3.jpg" title="単眼鏡をスマホに固定する治具（横）" width="360px" >}}
{{< postfig src="monocular-jig-4.jpg" title="単眼鏡をスマホに固定する治具（上）" width="360px" >}}

## 3D モデル

3D モデルは使い慣れている Fusion 360 で作成しました。

寸法はノギスで適当に測り、1回目の試作ではスマホの厚みがちょっと合っていなかったので、2回目で微調整して仕上げました。

{{< postfig src="monocular-jig-3d-model.jpg" title="3Dモデル" width="360px" >}}

### Fusion360 モデル

Fusion 360 はクラウド型の CAD なので、ブログに埋め込みができます。
ぐるぐる回してみてください。

<iframe src="https://myhub.autodesk360.com/ue2805ff3/shares/public/SHd38bfQT1fb47330c996711fccc8eb96cbd?mode=embed" width="640" height="480" allowfullscreen="true" webkitallowfullscreen="true" mozallowfullscreen="true"  frameborder="0"></iframe>

### モデルのダウンロード

手元でモデルを見てみたい方は下記からダウンロードできます。

- [lens-mount.f3d](lens-mount.f3d) (Fusion 360 Archive 形式)
- [lens-mount.stl](lens-mount.stl) (STL 形式)

## 3D プリント

たまたま家に3Dプリンタがあったので、それで印刷しました。

[ダヴィンチ nano w](https://www.xyzprinting.com/ja-JP/product/da-vinci-nano-w) という3Dプリンタで、材質は PLA です。

{{< postfig src="monocular-jig-3d-print.jpg" title="治具" width="360px" >}}

## 撮影例

実際に単眼鏡を通して撮影した画像はこちらです。  
画角が広いので黒い丸が写り込んでいますね。

{{< postfig src="monocular-jig-test.jpg" title="撮影例" width="360px" >}}

黒い丸が消えるようにトリミングした結果がこちらです。  
くっきりいい感じに写っています。

{{< postfig src="monocular-jig-test-zoom.jpg" title="中央だけトリミングした結果" width="360px" >}}

ちなみに、単眼鏡をつける前のスマホで撮った写真はこちらです。全前違いますね。

{{< postfig src="monocular-jig-test-original.jpg" title="単眼鏡をつける前の画角" width="360px" >}}

## おわりに

3Dプリンタがあるとこのような治具をすぐに作ることができて楽しいですね。

こういうものをいろいろ作って3Dプリンタに慣れて行きたいです。

それではまた！

{{< postfig src="monocular-jig-mt-fuji.jpg" title="単眼鏡を使って撮影した富士山" width="360px" >}}
