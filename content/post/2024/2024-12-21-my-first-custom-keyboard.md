---
date: "2024-12-21T00:23:00+09:00"
title: "自作キーボード、はじめました。"
categories:
  - "作品紹介"
tags:
  - "キーボード"
  - "Corne V4"
thumbnail: "icon.jpg"
---

## はじめに

こんにちは、最近3Dプリンタを購入してテンションが上がっているけりです。

今回はついに自作キーボードに手を出してしまったので、作成したキーボードについて説明します。

<!--more-->

ただし、作成したと言っても1から作ったわけではなく、[Corne V4](https://shop.yushakobo.jp/products/8962?_pos=10&_sid=5609e7c92&_ss=r)という自作キーボードのキットを購入して、3Dプリンタでケースを造形したり、ファームウェアを改変したりしてカスタマイズしている形です。

### これまで使っていたキーボードについて

ちなみに、ここ3年くらいは[ZSA Moonlander Mark I](/posts/2021-10-31-moonlander/)という左右分離キーボードを使っていました。

{{< postfig src="moonlander.jpg" title="MoonLander Mark I" width="540px" link="/posts/2021-10-31-moonlander/">}}

もうこれがないとタイピングができないほど慣れ親しんでいたのですが、親指付近のキー配置が少し手に合わないところが気になっていました。

また、レイヤー切り替えに慣れてくると上段の数字キーですらホームポジションから遠く感じてきていたので、数字キーもないコンパクトなキーボードが欲しくなりました。

### Corne V4 Chocolate

そんなとき、[Corne V4 Chocolate](https://shop.yushakobo.jp/products/8962?_pos=10&_sid=5609e7c92&_ss=r)という自作キーボードのキットを見つけました。

キーの数がちょうど良さそうなのと、シンプルなデザインが好みだったので買ってみることにしました。

{{< postfig src="corne-v4-chocolate.jpg" title="Corne V4 Chocolate" width="480px" >}}

Corne V4 Chocolate の特徴としては以下の通りです。

- 左右分離キーボード
- Functionや数字キーがない、いわゆる40%サイズ
- 親指キーが左右それぞれ3つずつある
- ロープロファイルキースイッチに対応
- Type-C接続
- 比較的新しい[RP2040](https://www.raspberrypi.com/documentation/microcontrollers/silicon.html#rp2040)マイコンを使用
- オープンソースキーボードファームウェア [QMK](https://qmk.fm/) に対応

スタイリッシュでミニマム、魅力的なキーボードです。

## 購入したもの

Corne V4は基板部分のキットなので、キースイッチなどは自前で用意する必要があります。

今回のキーボード作成にあたって購入したしたものはこちらです。

| 項目             | 名前                                                                                                                | 購入先     | 金額     |
| :--------------- | :------------------------------------------------------------------------------------------------------------------ | :--------- | :------- |
| キーボードキット | [Corne V4 Chocolate](https://shop.yushakobo.jp/products/8962?_pos=10&_sid=5609e7c92&_ss=r)                          | 遊舎工房   | 17,600円 |
| キースイッチ     | [Kailh Deep Sea Silent Mini Low Profile Key Switch (Linear)](https://www.aliexpress.com/item/1005007364820059.html) | AliExpress | 4,823円  |
| キーキャップ     | [NuPhy nSA Keycaps (Shine-through White)](https://www.aliexpress.com/item/1005006384968360.html)                    | AliExpress | 4,431円  |
| 左右接続ケーブル | [10cm 3.5mm AUX Cable (White 4 Pole)](https://www.aliexpress.com/item/1005002484746676.html)                        | AliExpress | 126円    |
| フェルト(静音用) | 普通のフェルト                                                                                                      | Seria      | 110円    |

合計は27,000円ほどでした。自作キーボードとしてはかなり安い方ですね。

## キットの組み立て

まずはCorneV4自作キーボードを説明書に従って組み立てます。

### 基板とケースの組み立て

なんと、このCorne V4キットは部品実装済みで、はんだ付け不要です。

一瞬で組み上がりました。

<blockquote class="twitter-tweet"><p lang="ja" dir="ltr">まいにゅーきーぼーど（キースイッチはまだ） <a href="https://t.co/wrcqRBTwgX">pic.twitter.com/wrcqRBTwgX</a></p>&mdash; けり (@kerikun11) <a href="https://twitter.com/kerikun11/status/1859227954951450933?ref_src=twsrc%5Etfw">November 20, 2024</a></blockquote> <script async src="https://platform.twitter.com/widgets.js" charset="utf-8"></script>

### キースイッチの取り付け

さて、キースイッチはキーボードの中で一番大事なパーツと言ってもよいでしょう。

私は過去にHHKBを使っていたこともあり、スコスコ感のある静音キーが好みです。

それに近そうなキースイッチとして、[Kailh Deep Sea Silent Mini Low Profile Key Switch (Linear)](https://www.aliexpress.com/item/1005007364820059.html)をAliExpressで購入しました。

{{< postfig src="keyswitch.jpg" title="Kailh Deep Sea Silent Mini" width="480px" >}}

ちなみに、AliExpressではキースイッチのテスターというのも販売されていて、さまざまなスイッチを実際に比較することもできます。

<blockquote class="twitter-tweet"><p lang="ja" dir="ltr">ロープロファイル版キースイッチの選定をしている。 <a href="https://t.co/tpfjpKLmgZ">pic.twitter.com/tpfjpKLmgZ</a></p>&mdash; けり (@kerikun11) <a href="https://twitter.com/kerikun11/status/1858494667006099646?ref_src=twsrc%5Etfw">November 18, 2024</a></blockquote> <script async src="https://platform.twitter.com/widgets.js" charset="utf-8"></script>

ただ、今回はDeep Sea Silent Miniが含まれていないテスターを購入してしまったので、反発力の参考程度にしかなりませんでした。

### キーキャップの取り付け

自作キーボードで地味に大事なのがキーキャップです。

見た目、触り心地、バックライトの透過具合など好みがわかれるところです。

バックライト対応のキーキャップをAliExpressで購入しました。デザインもいい感じです。

<blockquote class="twitter-tweet"><p lang="ja" dir="ltr">キーキャップが届いた！！<br>（キースイッチはまだ…） <a href="https://t.co/cgrtvj7Wi6">pic.twitter.com/cgrtvj7Wi6</a></p>&mdash; けり (@kerikun11) <a href="https://twitter.com/kerikun11/status/1860677630120591427?ref_src=twsrc%5Etfw">November 24, 2024</a></blockquote> <script async src="https://platform.twitter.com/widgets.js" charset="utf-8"></script>

キースイッチとキーキャップを一緒に購入したのですが、キーキャップが先に届きました。

キーボードキットとキーキャップはあるのにキースイッチがない状態が数日続いて、しばらくそわそわしていました。

### とりあえず完成

無事キースイッチも届いてパーツが全部そろったので、とりあえず完成しました！

ファームウェアもデフォルトで適当なものが書き込まれているので、既にキーボードして使える状態です。

いやぁ、コンパクトでめっちゃいいですね。

<blockquote class="twitter-tweet"><p lang="ja" dir="ltr">ようやくキースイッチが届いた！！ <a href="https://t.co/eY8tcdbsLj">pic.twitter.com/eY8tcdbsLj</a></p>&mdash; けり (@kerikun11) <a href="https://twitter.com/kerikun11/status/1861733436698038567?ref_src=twsrc%5Etfw">November 27, 2024</a></blockquote> <script async src="https://platform.twitter.com/widgets.js" charset="utf-8"></script>

そしてこのキーボード、七色に光ります。

<blockquote class="twitter-tweet"><p lang="ja" dir="ltr">やっぱキーボードは光らないとダメだよね <a href="https://t.co/lATHM2VxSb">pic.twitter.com/lATHM2VxSb</a></p>&mdash; けり (@kerikun11) <a href="https://twitter.com/kerikun11/status/1862831634380464597?ref_src=twsrc%5Etfw">November 30, 2024</a></blockquote> <script async src="https://platform.twitter.com/widgets.js" charset="utf-8"></script>

## 自己流にカスタマイズ

さて、ここからはキーボードを自己流にカスタマイズしていきます。

### ケースを3Dプリンタで作成

まずは外側のケースを3Dプリンタで印刷します。

[GitHub](https://github.com/foostan/crkbd)にケースの3Dモデルがあったので、[手持ちの3Dプリンタ](https://jp.store.bambulab.com/products/p1s)で印刷しました。

さらにフロントパネルも追加で作成して、かなりいい感じの見た目になりました。

<blockquote class="twitter-tweet"><p lang="ja" dir="ltr">3DプリンタでCorne V4 Chocolateのケースを作った。フロントパネルもいい感じ。 <a href="https://t.co/z2TzUt2Ye6">pic.twitter.com/z2TzUt2Ye6</a></p>&mdash; けり (@kerikun11) <a href="https://twitter.com/kerikun11/status/1870120182922072117?ref_src=twsrc%5Etfw">December 20, 2024</a></blockquote> <script async src="https://platform.twitter.com/widgets.js" charset="utf-8"></script>

ちなみに、こちらの3Dプリンタのフィラメントは[PLA Marble](https://jp.store.bambulab.com/products/pla-marble)という大理石調のちょっと面白い柄です。

### 静音化

既に静音スイッチを使用しているので十分静音ですが、さらに打鍵感を高めるためケースの底にフェルトを敷いて無駄な反響を抑えます。

<blockquote class="twitter-tweet"><p lang="ja" dir="ltr">ケースの内側にフェルトを敷いてさらに静音化。キースイッチはKailh Deep Sea Silent Mini。 <a href="https://t.co/tPwsHy3Ljc">pic.twitter.com/tPwsHy3Ljc</a></p>&mdash; けり (@kerikun11) <a href="https://twitter.com/kerikun11/status/1870120677505999181?ref_src=twsrc%5Etfw">December 20, 2024</a></blockquote> <script async src="https://platform.twitter.com/widgets.js" charset="utf-8"></script>

### キーボードのファームウェアをカスタマイズ

ようやくソフトウェアエンジニアの役目が来ました。

今回のキーボードはオープンソースの[QMK](https://qmk.fm/)というプロジェクトに対応していて、豊富なライブラリを使用しつつ自前でファームウェアをカスタマイズすることができます。

今回はMoonlanderのときに活用していた、キーの種類ごとにバックライトLEDの色を変える機能を追加しました。

これがあるとキーの位置を覚えやすいんですよね。

<blockquote class="twitter-tweet"><p lang="ja" dir="ltr">よしよし、キーの種類ごとに色が変わるようにしてレイヤーがわかりやすくなってきた。 <a href="https://t.co/VX6UiZSWhj">pic.twitter.com/VX6UiZSWhj</a></p>&mdash; けり (@kerikun11) <a href="https://twitter.com/kerikun11/status/1863961620143353858?ref_src=twsrc%5Etfw">December 3, 2024</a></blockquote> <script async src="https://platform.twitter.com/widgets.js" charset="utf-8"></script>

作成したファームウェアは[GitHub](https://github.com/kerikun11/kerigokbd)で公開しています。

### レイアウトの最適化

さて、ここからが自作キーボードで最も沼と言われている、レイアウトのカスタマイズです。

あまりカスタマイズをしすぎるとノートPCなどのキーボードが全然打てなくなってしまうのでご注意を。

ちょっとずつ変更して局所最適を探しつつ、時々がらっと変更して大域最適を探す旅です。

<blockquote class="twitter-tweet"><p lang="ja" dir="ltr">今日のレイアウト <a href="https://t.co/FXKVET4Je3">pic.twitter.com/FXKVET4Je3</a></p>&mdash; けり (@kerikun11) <a href="https://twitter.com/kerikun11/status/1865394759625593334?ref_src=twsrc%5Etfw">December 7, 2024</a></blockquote> <script async src="https://platform.twitter.com/widgets.js" charset="utf-8"></script>

## まとめ

いやぁ、ついに自作キーボードに手を出してしまいました。

まずはキットをカスタマイズするところから始めましたが、今後は基板設計もやってみたいと思っています。

ケースや基板の設計からファームウェアまで無限にカスタマイズできるので、この沼はかなり深そうです。

<blockquote class="twitter-tweet"><p lang="ja" dir="ltr">「50年に1度の出来」 <a href="https://t.co/3UhY3Rr4QX">pic.twitter.com/3UhY3Rr4QX</a></p>&mdash; けり (@kerikun11) <a href="https://twitter.com/kerikun11/status/1867200484395851845?ref_src=twsrc%5Etfw">December 12, 2024</a></blockquote> <script async src="https://platform.twitter.com/widgets.js" charset="utf-8"></script>
