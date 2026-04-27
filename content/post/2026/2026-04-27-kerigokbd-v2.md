---
date: "2026-04-27T00:00:00+09:00"
title: "自作キーボード KERIgoKBD v2 の紹介"
categories:
  - "作品紹介"
tags:
  - "キーボード"
  - "KERIgoKBD"
thumbnail: "icon.jpg"
spotlight: "true"
---

## はじめに

こんにちは、ChatGPT と Claude を行ったり来たりしているけりです。

今回の記事では私が新たに設計した自作キーボード **KERIgoKBD v2** を紹介します。

KERIgoKBD v2 は、以前紹介した [KERIgoKBD v1](/posts/2025-03-20-kerigokbd-v1/) をベースに、右手側へ **トラックパッド** を追加した左右分離キーボードです。

<!--more-->

{{< postfig src="kerigokbd_v2.jpg" title="KERIgoKBD v2" width="640px">}}

ちなみに、KERIgoKBD とは KERI's Ergonomic Keyboard の略で、けりの人間工学キーボードという意味です。

## KERIgoKBD v2 の登場

KERIgoKBD v1 は、手に合わせたキー配置で、ホームポジションからほとんど手を動かさずに数字や記号まで入力できる左右分離キーボードでした。

しばらく使ってみてキーボードとしてはかなり満足していたのですが、せっかく人間工学キーボードで指の移動を減らせているのに、**カーソルを動かすたびにマウスへ手を移動するのはスマートではない**と感じるようになりました。

そこで、KERIgoKBD v1 の設計を引き継ぎつつ、右手側に **トラックパッド** が搭載された KERIgoKBD v2 が登場しました。

{{< postfig src="kerigokbd_v2_top.jpg" title="KERIgoKBD v2 の外観" width="640px">}}

## KERIgoKBD v2 の特徴

KERIgoKBD v2 は KERIgoKBD v1 をベースにしているため、左右分離、カラムスタッガード、ロープロファイルスイッチ、全キーRGBバックライトなどの基本的な特徴は v1 と共通です。

そのあたりの詳しい説明は [KERIgoKBD v1 の紹介記事](/posts/2025-03-20-kerigokbd-v1/) をご覧ください。

一方、v2 で変わった点は以下の通りです。

- 右手側の親指キーを減らして代わりにトラックパッドを追加
- トラックパッドでタップ、ドラッグ、スクロール、ズーム操作が可能
- QMK Firmware の Auto Mouse Layer 機能を使い、ポインタ操作中はマウス用レイヤへ自動的に切り替え

以下では注目ポイントを説明します。

### トラックパッドを右手側に統合

KERIgoKBD v2 のいちばん大きな特徴は、右手側の親指付近に **トラックパッド** を搭載したことです。

トラックパッドには [Cirque Trackpad TM035035](https://mou.sr/48nN2VQ) を使用しています。

{{< postfig src="cirque_trackpad.jpg" title="右手側に搭載した Cirque Trackpad" width="480px">}}

右手の親指でそのままポインタを操作できるため、カーソルを移動する、マウスのボタンを押す、ページをスクロールする、といった操作を **キーボードに手を置いたまま** 行えます。

### トラックパッドの操作仕様

トラックパッドでは以下の操作に対応しています。

- **1回タップ** で左クリック
- **2回タップ** でダブルクリック
- **3回タップ** でトリプルクリック
- **ダブルタップ** して2回目のタッチを保持するとドラッグ
- **スクロールモード** 中は指の移動をスクロールに変換
- **ズームモード** 中は指の縦移動をズーム操作に変換
- トラックパッドに触れている間は **Auto Mouse Layer** に遷移

ノートPCのトラックパッドに近い感覚で使えるように、**タップ、ドラッグ、スクロール、ズーム** を一通り使えるようにしました。

また、タップした瞬間にカーソルが微妙にずれないようにしているので、クリック操作も安定しています。

### スクロールモードとズームモード

KERIgoKBD v2 では、特定のキーを押している間だけトラックパッドを **スクロールモード** にできます。

スクロールモード中は、通常の上下左右の移動を水平と垂直のスクロールに変換します。

トラックパッドを触るだけで縦横にスクロールできて、かなり便利です。

また、特定のキーを押している間だけトラックパッドを **ズームモード** にすることもできます。

ズームモード中は、トラックパッドの縦移動を `Ctrl` + ホイール操作として送信します。

### Auto Mouse Layer

トラックパッドを触ったときは、QMK の **Auto Mouse Layer** を使ってマウス操作用レイヤへ自動で切り替えています。

**Auto Mouse Layer** は、ポインティングデバイスを操作している間だけ一時的に有効になるレイヤです。

このレイヤには **クリック、スクロール、ズーム** など、ポインタ操作中に使いたいキーを配置しています。

たとえば、トラックパッドに触れている間だけホームポジション周辺のキーを **マウスボタン** やスクロール・ズーム操作に切り替え、指を離すと通常の文字入力レイヤに戻る、という使い方ができます。

### レイアウト

KERIgoKBD v2 は右手22キー、左手24キーの合計46キー構成です。

この記事の執筆時点のファームウェアでは、主に QWERTY、数字・記号、ファンクション・ナビゲーション、Auto Mouse Layer の4レイヤ構成で使用しています。

{{< postfig src="layout.png" link="layout.png" title="KERIgoKBD v2 のレイアウト" width="640px" >}}

親指キーの `NUM` や `FN` を押すことで、**ホームポジションに手を置いたまま** 数字、記号、ファンクションキー、矢印キーなどにアクセスできます。

また、Auto Mouse Layer により、**ポインタ操作中だけ** クリック、スクロール、ズーム系のキーをホームポジション周辺で操作できるようになります。

上記のレイアウト図の作成には下記の Keyboard Layout Editor を使用しました。

- [KERIgoKBD v2 - Keyboard Layout Editor](https://www.keyboard-layout-editor.com/#/gists/0d82236d0943d0b74055119b50123c59)

### トラックパッドを選んだ理由

自作キーボードにポインティングデバイスを搭載する場合、**トラックボール**も人気があります。ただ、今回の用途ではトラックパッドのほうが相性がよいと感じました。

トラックボールでは、ボールを動かし続けないと **Auto Mouse Layer** を維持しづらく、クリックやスクロールに移るタイミングでレイヤが戻ってしまうことがありました。

一方、**トラックパッド** では **指を置いておくだけで Auto Mouse Layer を維持** できます。ポインタを動かし、指を置いたままクリックやスクロールへ移れるので、操作性がかなりよかったです。

### トラックパッドの使用感

ポインタ移動は、低速時は細かく、高速時は大きく動くように調整しており、小さなボタンを押す操作から画面端への移動まで扱いやすくなっています。

実際に使ってみると、**カーソルを少し動かす、ボタンを押す、軽くスクロールする**、といった操作にはかなり便利です。

ただし、**完全にマウスを置き換えられるものではありません**。

CAD操作や長時間のポインタ操作は、やはりマウスのほうが快適です。

KERIgoKBD v2 のトラックパッドは、マウスを不要にするためというより、マウスへ手を伸ばすほどでもない **ちょっとした操作** を快適にするためのポインティングデバイスだと感じています。

### v1 PCB とトラックパッド配線

KERIgoKBD v2 では、KERIgoKBD v1 と同じ **KERIgoKBD v1 PCB** を使用しています。

{{< postfig src="kerigokbd_v1.2_pcb.jpg" title="KERIgoKBD v1.2 PCB" width="640px">}}

この PCB は **左右共通の両面リバーシブル基板** として設計しており、1種類の基板を左右で兼用できます。

左右それぞれの基板を別々に作る必要がないので、基板発注のコストを抑えられるのがメリットです。

v2 では基板自体はそのままで、PCB に引き出しておいた **I2C ピン** にポリウレタン線で配線してトラックパッドを追加しています。

{{< postfig src="kerigokbd_v2_back.jpg" title="KERIgoKBD v2 の裏面" width="640px">}}

裏面を見ると、左右で同じ PCB を使いつつ、右手側だけトラックパッドが追加されていることがわかります。

### スペック

最後に KERIgoKBD v2 のスペックをまとめると以下の通りです。

| 項目             | 内容                                                                                                                |
| :--------------- | :------------------------------------------------------------------------------------------------------------------ |
| キー数           | 合計46個 (左手24個、右手22個)                                                                                       |
| レイアウト       | 40%左右分離、カラムスタッガード                                                                                     |
| バックライト     | 全キーRGB LED対応                                                                                                   |
| マイコン         | [RP2040](https://www.raspberrypi.com/products/rp2040/specifications/) (Cortex-M0+ 133MHz x2, 264kB SRAM)            |
| フラッシュメモリ | [W25Q16JVUXIQ](https://www.digikey.jp/ja/products/detail/winbond-electronics/W25Q16JVUXIQ-TR/) (2MB)                |
| キースイッチ     | [Kailh Deep Sea Silent Mini Low Profile Key Switch (Linear)](https://www.aliexpress.com/item/1005007364820059.html) |
| キーキャップ     | [NuPhy nSA Keycaps (Shine-through White)](https://www.aliexpress.com/item/1005006384968360.html)                    |
| キーソケット     | [Hot Swap Socket for Kailh 1350 Chocolate](https://www.aliexpress.com/item/1005006610157756.html)                   |
| トラックパッド   | [Cirque Trackpad TM035035](https://mou.sr/48nN2VQ)                                                                  |
| 左右接続ケーブル | [3.5mm AUX Cable (White 3 Pole 10cm)](https://www.aliexpress.com/item/1005002484746676.html)                        |
| USBケーブル      | [USLION Magnetic USB Type-C ケーブル](https://www.aliexpress.com/item/1005006136597761.html)                        |
| 滑り止めシート   | [GRIPLUS ホワイト フリーカット](http://www.amazon.co.jp/dp/B08XHMGPWW/)                                             |

### 設計データ

KERIgoKBD v2 の設計データとソースコードは GitHub で公開しています。興味ある方はご覧ください。

- [KERIgoKBD v2 Hardware - GitHub](https://github.com/kerikun11/kerigokbd/tree/main/hardware/kerigokbd/kerigokbd_v2)
- [KERIgoKBD v2 Firmware - GitHub](https://github.com/kerikun11/kerigokbd/tree/main/software/qmk/keyboards/kerigokbd/kerigokbd_v2)

## おわりに

KERIgoKBD v1 でキーボードとしては満足していたのですが、さらにトラックパッドを搭載して、入力デバイスとしての完成形に近づいたかと思います。

ちなみに、今回のトラックパッドの制御コードは Codex に実装してもらいました。

欲しい機能を言葉で説明するだけで実装してもらえるなんて、いい時代になったものですね。
