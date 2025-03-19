---
date: "2025-03-20T00:00:00+09:00"
title: "自作キーボード KERIgoKBD v1 の紹介"
categories:
  - "作品紹介"
tags:
  - "キーボード"
  - "KERIgoKBD"
thumbnail: "icon.jpg"
---

## はじめに

こんにちは、自作キーボード沼に完全にハマってしまったけりです。

今回の記事では私がはじめて設計した自作キーボード KERIgoKBD v1 を紹介します。

<!--more-->

{{< postfig src="kerigokbd_v1_bird_view.jpg" title="KERIgoKBD v1" width="480px">}}

## 今までに使ってきたキーボード

はじめに、私がキーボード沼に沈み込んだ背景として、これまで愛用してきたキーボードたちを紹介します。

| 時期        | キーボード                                                      |
| :---------- | :-------------------------------------------------------------- |
| 2020年8月~  | [HHKB Professional Type-S (JIS配列)](#hhkb-professional-type-s) |
| 2021年7月~  | [Moonlander Mark I](#moonlander-mark-i)                         |
| 2024年11月~ | [Corne V4 Chocolate](#corne-v4-chocolate)                       |
| 2025年1月~  | **KERIgoKBD v1 (この記事)**                                     |

### HHKB Professional Type-S

社会人になってはじめに購入したのが HHKB (Happy Hacking Keyboard) です。

{{< postfig src="hhkb_hybrid_type-s_jis.jpg" title="HHKB Professional Hybrid Type-S JIS配列" width="480px" link="https://www.pfu.ricoh.com/direct/hhkb/detail_pd-kb820w.html" >}}

気持ちのいいスコスコした打鍵感がたまらないキーボードです。

HHKBはUS配列版も人気ですが、US配列はスペースが長くて親指部分のキーが少ないので、キーが多くて割り当て自由度の高いJIS配列を購入しました。

ファンクションキーの位置とかもカスタマイズできるのがいいですよね。

### Moonlander Mark I

約1年間HHKBを愛用していたのですが、通常のキーボードだと肩が窮屈になるため、左右分離のキーボードとして[ZSA Moonlander Mark I](/posts/2021-10-31-moonlander/)というちょっと奇抜なキーボードに手を出しました。

{{< postfig src="moonlander.jpg" title="Moonlander Mark I キーボード" width="480px" link="/posts/2021-10-31-moonlander/">}}

このキーボード、全キーの割り当てを自由にカスタマイズできて、自分の好みに最適化した独自のレイアウトを作り上げることができます。

会社でこのキーボードを使っていると、通る人みんながナニコレ？って聞いてくるのがおもしろかったです。

もうMoonlanderがないとまともにタイピングができないほど慣れ親しんでいたのですが、親指付近のキー配置が少し手に合わないところが気になっていました。

また、レイヤー切り替えに慣れてくると最上段の数字キーですらホームポジションから遠く感じてきていたので、数字キーもないコンパクトなキーボードが欲しくなりました。

### Corne V4 Chocolate

そんなとき、[Corne V4 Chocolate](https://shop.yushakobo.jp/products/8962?_pos=10&_sid=5609e7c92&_ss=r)という自作キーボードのキットを見つけました。

数字キーのない、いわゆる40%サイズの左右分離キーボードです。

{{< postfig src="corne-v4-chocolate.jpg" link="/posts/2024-12-21-my-first-custom-keyboard/" title="Corne V4 Chocolate キーボード" width="480px" >}}

シンプルなデザインが好みだったのでキットを購入して、いろいろカスタマイズしながら自作キーボードを勉強しました。

ついに自作キーボードの沼に足を踏み入れてしまったわけです。

上記、Corne V4のカスタマイズについては[こちら](/posts/2024-12-21-my-first-custom-keyboard/)の記事をご覧ください。

## KERIgoKBD v1 の登場

さて、Corne V4 は設計データが公開されていたため、それを参考にしつつ独自に基板設計を行い、新たなキーボードを設計しました。

その結果、完成したのが KERIgoKBD v1 です。

{{< postfig src="kerigokbd_v1_top.jpg" title="KERIgoKBD v1 (KERI's Ergonomic Keyboard Version 1)" width="480px" >}}

KERIgoKBD とは KERI's Ergonomic Keyboard の略で、けりの人間工学キーボードという意味です。

### KERIgoKBD v1 の特徴

KERIgoKBD v1 の特徴としては以下の通りです。

- 肩への負担を和らげる左右分離キーボード
- ファンクションキーや数字キーがない、いわゆる40%サイズ
- レイヤ切り替えなどに使用できる親指キーを左右に4個ずつ搭載
- ロープロファイルのキースイッチで薄型・軽量 (約238g)
- 120円程度と安価ながらハイスペックな[RP2040](https://www.raspberrypi.com/documentation/microcontrollers/silicon.html#rp2040)マイコンを使用
- 全キーにバックライトを搭載、キーの種類ごとに色を変えて表示
- オープンソースキーボードファームウェア [QMK](https://qmk.fm/) 対応していて、ブラウザにてキーレイアウトをカスタマイズ可能

以下では注目ポイントを説明します。

### 自分の手にぴったり合わせたキー配置

自作キーボードの最大のメリットは自分の手の形状に合わせてキーを配置できることです。

{{< postfig src="kerigokbd_v1_hand.jpg" title="自分の手にぴったりの物理的キー配置" width="480px" >}}

特に親指の位置にはけっこう個人差があり、数ミリずれているだけでも押しやすさが変わってきます。

ホームポジションからほとんど手を動かすことなく全キーにアクセスすることがでる、まさに人間工学キーボードです。

### レイアウト

さて、この記事の執筆時点のファームウェアでは下図の論理レイアウトで使用しています。

{{< postfig src="kerigokbd_v1_layout.png" link="kerigokbd_v1_layout.png" title="KERIgoKBD v1 のレイアウト" width="640px" >}}

親指キーの「Num」や「Fn」キーを押すことでホームポジションに手を置いたまま数字や記号、ファンクションキーを押すことができ、手をほとんど動かす必要がありません。

数か月ほど試行錯誤して、レイアウトがかなり洗練されてきました。

なお、上記のレイアウト図の作成には下記のKeyboard Layout Editorを使用しました。

- [KERIgoKBD v1 - Keyboard Layout Editor](https://www.keyboard-layout-editor.com/#/gists/ef55d575836d948b814d1c28ccc5c396)

### QMK Remap 対応

KERIgoKBD v1 はオープンソースのキーボードファームウェアプロジェクトである [QMK](https://qmk.fm/) を使用して開発されています。

また、オンラインキーマップエディタの[Remap](https://remap-keys.app/)に登録済みなので、ブラウザ上でキーレイアウトのカスタマイズが可能です。

- [KERIgoKBD v1 - Remap](https://remap-keys.app/catalog/8pqWZfIyb0UqzhvSmsgh/keymap?id=74vyciDXcUU3OP2Ju8dM)

キーレイアウトの試行錯誤する際に、 Remapを使うととても便利です。

### 全キーバックライトLED対応

自作キーボードにおいて地味に大切なのがバックライトLEDです。

KERIgoKBD v1 のようにキーが少ないキーボードではレイヤキーを使ってキーを切り替えるため、トップレイヤ以外は刻印がありません。

KERIgoKBD v1 ではアルファベットは青、数字はピンク、記号は黄色など、キーの種類に応じて色を変えて表示することで、レイヤが切り替わったときにどこに目的のキーがあるかがわかるようになっています。

この機能は QMK にはない機能だったので、自前で実装しました。

{{< postfig src="kerigokbd_v1_top_light.jpg" title="バックライトでキーの種類を判別" width="480px" >}}

### 静音キースイッチ

私は HHKB のような静音リニアな打鍵感が好みなので、今回はそれに近そうなキースイッチを選びました。

Kailh の Deep Sea Silent Mini というキースイッチは内部にゴムクッションが入っていて、打鍵音を極限まで抑えています。

{{< postfig src="kerigokbd_v1_keycap_removed.jpg" title="Kailh Deep Sea Silent Mini Key Switch" width="360px" >}}

### スタイリッシュでマットなキーキャップ

キーキャップにはデザインと触り心地がとてもよかった [NuPhy nSA Keycaps (Shine-through White)](https://www.aliexpress.com/item/1005006384968360.html) を使用しています。

{{< postfig src="kerigokbd_v1_key_cap.jpg" title="NuPhy nSA Keycaps (Shine-through White)" width="360px" >}}

3Dプリンタで作ることもできるのですが、やはり触り心地が既製品にはかないません。

### ケースは3Dプリンタで印刷

ケースは [Autodesk Fusion](https://www.autodesk.com/jp/solutions/what-is-fusion-360) で設計して、自宅にある3Dプリンタ [Bambu Lab P1S](https://jp.store.bambulab.com/products/p1s) で造形しました。

{{< postfig src="kerigokbd_v1_case_top.jpg" title="KERIgoKBD v1 のケースはFusionで設計" width="240px" >}}
{{< postfig src="kerigokbd_v1_case_drafts.jpg" title="ケースの試作品たち" width="360px" >}}

ちなみに、フィラメントは [PLA White Marble](https://jp.store.bambulab.com/products/pla-marble) を使用しました。

このフィラメントは大理石調の模様がおしゃれで、さらに模様のおかげで積層痕が目立ちづらく、めっちゃ気に入っています。

{{< postfig src="bambu_lab_coffee_model.jpg" title="大理石調のフィラメント" width="360px" >}}

### KiCadで基板設計

内部の基板は [KiCad](https://www.kicad.org/) で設計して [JLCPCB](https://jlcpcb.com/jp/) に発注しました。

今回ちょっと頑張ったところとして、左右のキーボードの基板を両面リバーシブルに設計しました。

左右両方の基板を1種類で兼用できることで、基板設計のコストを抑えることができます！

{{< postfig src="kerigokbd_v1_pcb.jpg" title="KERIgoKBD v1 の基板" width="480px" >}}

### マグネットUSBケーブル

キーボード側のUSBコネクタはType-Cですが、ちょっと変わったケーブルとして[マグネットアダプタ付のUSBケーブル](https://www.aliexpress.com/item/1005006136597761.html)を使用しています。

{{< postfig src="kerigokbd_v1_usb.jpg" title="KERIgoKBD v1" width="480px" >}}

これがかなり便利で、いくつかのPCの間を繋ぎ変える時などにケーブルを抜き差ししなくても引っ張るだけですぐに繋ぎ変えることができます。

また、左右分離キーボードの場合、ファームウェアの書き換えの際に片方ずつ両側にUSB接続をして書き込まないといけないので、引っ張るだけで着脱ができるるとめっちゃスムーズです。

コネクタが消耗しないのもいいですね。

この手のマグネットコネクタに大電流を流すのは気が引けますが、キーボードなら多くても数100mAまので、特に問題ないかなと思っています。

### 滑り止めシートGRIPLUS

裏側には [GRIPLUS](https://amzn.asia/d/7vSgiKB) という滑り止めシートがついています。

このシートは薄いのにとても安定していて、ゴム足よりもおすすめです。

{{< postfig src="kerigokbd_v1_back.jpg" title="裏側はGRIPLUSで滑り止め" width="480px" >}}

### 重量

重量は左右合わせて237.5gでした。

{{< postfig src="kerigokbd_v1_weight.jpg" title="KERIgoKBD v1" width="480px" >}}

HHKB Hybrid Type-S は 540g、Moonlander は 744g だったので、かなり軽量であることがわかります。

これなら持ち運びも楽ちんです。

まあ、会社用にはもう1台作ってあるわけですが。

### USBのデバイスIDについて

今回は [pid.codes](https://pid.codes/howto/) でUSBのPIDを取得しました。

- [KERIgoKBD v1 - pid.codes](https://pid.codes/1209/E501/)

自作キーボード界隈ではUSBのPIDを取得せずに使用している人も多いですが、これで堂々とUSBデバイスとして使用できます！

### スペック

最後に KERIgoKBD v1 のスペックをまとめると以下の通りです。

| 項目             | 内容                                                                                                                                                |
| :--------------- | :-------------------------------------------------------------------------------------------------------------------------------------------------- |
| キー数           | 合計48個 (左右それぞれ24個)                                                                                                                         |
| キーピッチ       | 19.05mm                                                                                                                                             |
| サイズ           | 横140mm x 縦95mm x 厚17mm (片側)                                                                                                                    |
| 重量             | 237.5g (左右合計・USBケーブルを除く)                                                                                                                |
| バックライト     | 全キーRGB LED対応 ([SK6812 MINI-E](https://ja.aliexpress.com/item/1005005193716172.html))                                                           |
| マイコン         | [RP2040](https://www.raspberrypi.com/products/rp2040/specifications/) (Cortex-M0+ 133MHz x2, 264kB SRAM)                                            |
| フラッシュメモリ | [W25Q16JVUXIQ](https://www.digikey.jp/short/3t1bm3d5) (2MB)                                                                                         |
| キースイッチ     | [Kailh Deep Sea Silent Mini Low Profile Key Switch (Linear)](https://www.aliexpress.com/item/1005007364820059.html) (Choc V1/V2 ホットスワップ対応) |
| キーキャップ     | [NuPhy nSA Keycaps (Shine-through White)](https://www.aliexpress.com/item/1005006384968360.html)                                                    |
| 左右接続ケーブル | [10cm 3.5mm AUX Cable (White 3 Pole)](https://www.aliexpress.com/item/1005002484746676.html)                                                        |
| 滑り止めシート   | [GRIPLUS ホワイト フリーカット](http://www.amazon.co.jp/dp/B08XHMGPWW/)                                                                             |
| USBケーブル      | [USLION Magnetic USB Type-C ケーブル](https://www.aliexpress.com/item/1005006136597761.html)                                                        |

### 設計データ

KERIgoKBD v1 の設計データとソースコードはGitHubで公開しています。興味ある方はご覧ください。

- [kerikun11/kerigokbd - GitHub](https://github.com/kerikun11/kerigokbd)

## おわりに

はじめての自作キーボード KERIgoKBD v1 について紹介しました。

いつかはこうなるかなとは思っていたのですが、ついに自作キーボードの沼にハマってしまいました。

自作キーボードは作っていておもしろいだけでなく、ちゃんと実務にも役立つので素晴らしいですね。

ところで、久々にマイクロマウス以外の基板設計を行いましたが、やっぱり基板設計は楽しいですね。

今までマイクロマウスのカオスな基板設計をやってきていたので、キーボードの基板設計が比較的簡単に感じてしまうというバグが発生しています。

これからも興味の赴くまま、ものづくりを続けていきたいです。

<!-- ### 将来の展望

{{< postfig src="kerigokbd_v1_trackpad_top.jpg" title="KERIgoKBD v1" width="480px" >}}
{{< postfig src="kerigokbd_v1_trackpad_bottom_zoom.jpg" title="KERIgoKBD v1" width="360px" >}} -->
