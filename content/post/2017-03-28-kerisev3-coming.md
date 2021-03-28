---
date: "2017-03-28"
title: "KERISE v3 ができました！"
categories:
  - "作品紹介"
tags:
  - "マイクロマウス"
  - "ロボット"
  - "KERISE"
thumbnail: "icon.jpg"
pickup: true
---

## KERISEv3

{{< postfig src="kerisev3-front-side.jpg" title="KERISE v3" width="240px" >}}

### 3台目のマウス

マイクロマウスを始めて8か月目になりました。けりです。  
作っては壊しを繰り返してはや3台目になります。なぜこんなに壊れるのでしょうか...

<!--more-->

### ハーフサイズ

さて、今回のマウスは完全にハーフマウスです。とても小さいです。かわいいです。

ハーフサイズのいいところは部品1つ1つが小さくて安いことです。壊してしまっても金銭的にはあまり痛くありません。精神的には痛いですが...

### 初の吸引機構

マイクロマウスでは吸引をすると圧倒的速度を出すことができるようなので、初めて吸引に挑戦しました！自重は支えられませんが、ある程度の吸引力があります。

### 初の変則4輪

吸引の力をタイヤでしっかり支えるために変則4輪にも挑戦しました。制御が難しそうです...

### 新しいことだらけ

今回のマウスは、今までの設計をすべて一から見直して完全に新しく作りました。さらに、マイコンもより小型の新しいものにしました。初めて触るマイコンです。新しいことだらけで大変ですが、頑張ります！

## Fusion360で設計

Fusion360が流行っています。習得するにはまず使わないといけないので、今回のマウスはFusion360で設計してみました。

{{< postfig src="kerisev3-fusion.png" title="KERISE v3 Fusion 360" width="240px" >}}

### Fusionの埋め込み表示

Fusion360はクラウド上にデータを保存できるので、HTMLに埋め込んで表示できブログに貼り付けられます。  
※ロードに時間がかかるのでご注意ください。右下にフルスクリーンボタンがあるのでそれを押すと使いやすいです。

<div class="fusion">
<iframe width="100%" height="360" src="https://myhub.autodesk360.com/ue2805ff3/shares/public/SH7f1edQT22b515c761e3ce317261c9e9ee5?mode=embed" allowfullscreen="true" webkitallowfullscreen="true" mozallowfullscreen="true"  frameborder="0"></iframe>
</div>

### Fusion360のレンダリング

Fusion360にはレンダリングという機能があり、設計した立体の光の反射などを計算して実物みたいな画像を生成してくれます。

{{< postfig src="kerisev3-rendering.png" title="KERISE v3 Fusion 360" width="480px" >}}

## 写真集

{{< postfig src="kerisev3-front-side.jpg" title="KERISEv3" width="240px" >}}
{{< postfig src="kerisev3-no-battery.jpg" title="KERISEv3" width="240px" >}}
{{< postfig src="kerisev3-front.jpg" title="KERISEv3" width="240px" >}}
{{< postfig src="kerisev3-back.jpg" title="KERISEv3" width="240px" >}}
{{< postfig src="kerisev3-up.jpg" title="KERISEv3" width="240px" >}}
{{< postfig src="kerisev3-left.jpg" title="KERISEv3" width="240px" >}}
{{< postfig src="kerisev3-right.jpg" title="KERISEv3" width="240px" >}}
{{< postfig src="kerisev3-coin.jpg" title="KERISEv3" width="240px" >}}

## 重量

16.48gでした。ハーフの中では重い方でしょうか...  
もう少し容量が小さくて軽いバッテリーを探しているので、見つかれば少し軽くなるかもです。

{{< postfig src="kerisev3-weight.jpg" title="KERISEv3" width="240px" >}}
{{< postfig src="battery.jpg" title="KERISEv3" width="240px" >}}

## 走る様子

前の機体のパラメータを少しいじって走らせてみました。壁は見ていません。  
機体は変わっても制御方法はあまり変わらないので、以前のコードを使いまわせそうです。

<div class="video"><video src="kerisev3.mp4" width="100%" controls loop preload="metadata"></video></div>
<!--
<div class="video">
<iframe width="90%" height="360" src="https://www.youtube.com/embed/p1KPrC8PSVU?rel=0" frameborder="0" allowfullscreen></iframe>
</div>
-->

## まとめ

KERISEv2が壊れてしまって、動くマウスがない状態が続きとても悲しかったので、動くマウスができて本当によかったです。ハーフマウスについていろいろ教えてくれたTwitterの方々、ありがとうございました。  
まだまだやることは山積みですが。まずはPIDパラメータの選定からやっていこうと思います。

{{< postfig src="kerisev3-hand.jpg" title="KERISEv3" width="480px" >}}
