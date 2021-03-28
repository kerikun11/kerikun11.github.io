---
date: "2018-02-11T14:58:18+09:00"
title: "自宅サーバーにNextcloudを導入した"
categories:
- "イベント"
tags:
- "サーバー"
- "Raspberry Pi"
- "Nextcloud"
thumbnail: "icon.png"
---

こんにちは。
今回は久しぶりにサーバーの話題です。

自宅のサーバーにNextcloudを導入したので、それを紹介します。

<!--more-->

## Nextcloudとは

{{< postfig src="nextcloud.png" title="Nextcloud" width="180px" link="https://nextcloud.com/">}}

[Nextcloud](https://nextcloud.com/)とは、自前のサーバーにDropboxやGoogeDriveのようなクラウドストレージを構築するためのオープンソースソフトウェアです。

Windows, IOS, Androidなどのクライアントアプリも用意されており、DropboxやGoogeDriveのような使い方ができます。

## NASをクラウドストレージに

僕の家には[ReadyNAS 104](https://www.netgear.jp/products/details/RN10400.html)という、HDDを4つまで搭載できるNAS(Network Attached Storage)があります。

RAID6のダブルパリティに設定してあり、合計8TBの容量を持ちます。

このNASは基本的にLAN内からしかアクセスできないので、NextcloudによってこのNASをクラウドストレージとしました。

{{< postfig src="rn10400.png" title="ReadyNAS 104" width="240px" link="https://www.netgear.jp/products/details/RN10400.html">}}

このようなNASがなくても、ラズパイに直接HDDを繋ぐことでストレージを確保できます。

## サーバーはラズパイ3

現在、僕の自宅サーバーは、 **Raspberry 3 Model B** によって運用されています。このサーバーにNextcloudをインストールしました。

{{< postfig src="raspi3.jpg" title="Raspberry 3 Model B" width="240px" >}}

## 気を付けること

サーバーを外部に公開するときは、セキュリティ対策を万全にしましょう。

ファイアウォールの設定や、HTTPS対応をお忘れなく。

## 使用感

とりあえず、所望のクラウドストレージを構築することができました。

Nextcloudの設定はすべてブラウザでできるのでとても簡単です。

しかし、ラズパイでは読み込み時間がいちいち長く、少しストレスがあります。

もっと強いPCを使いたいものですが、そのときはVPSを契約すべきだと思い、当面はこのまま運用する予定です。

## まとめ

今まではLAN内からしかアクセスできなかったNASが、Nextcloudの導入により、どこからでもアクセスできるようになりました。

既にサーバーをお持ちの方ならすぐに導入できると思います。ぜひ試してみてください！

