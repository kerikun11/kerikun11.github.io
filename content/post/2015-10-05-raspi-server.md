---
date: "2015-10-05"
title: "Raspberry Pi 2 Type Bでサーバー作り"
categories:
  - "説明記事"
tags:
  - "Raspberry Pi"
  - "サーバー"
thumbnail: "icon.jpg"
---

## ラズパイの用意

  1. ラズパイ用のOS「NOOBS」を[raspberrypi.org](http://raspberrypi.org/downloads/)からDLして解凍する。  
  1. microSDカードをFAT32でフォーマットする。  
  1. 解凍したファイルをSDカードにコピーする。  
  1. ラズパイにSDカード、キーボード、LANケーブル（またはWiFiドングル）をつないで電源を入れる。  

<!--more-->

## 無線LANの接続

　WiFiドングルをラズパイに差す。  

	$ifconfig

このコマンドで、インターフェースを確認する。  

	$iwconfig

このコマンドでWiFi情報を確認できる。  
　次のファイルを編集して、ハードウェアインターフェースの設定をする。  

```
$sudo vim /etc/network/interfaces

auto lo
iface lo inet loopback

auto eth0
allow-hotplug eth0
iface eth0 inet static
address 192.168.11.2	←your IP
netmask 255.255.255.0	←your subnetmask
gateway 192.168.11.1	←your router IP
dns-nameserver 8.8.8.8 10.255.0.1

auto wlan0
allow-hotplug wlan0
iface wlan0 inet static
address 192.168.11.2	←your IP
netmask 255.255.255.0	←your subnetmask
gateway 192.168.11.1	←your router IP
dns-nameserver 8.8.8.8 10.255.0.1

wpa-conf /etc/wpa_supplicant/wpa_supplicant.conf

auto wlan1
allow-hotplug wlan1
iface wlan0 inet manual
wpa-conf /etc/wpa_supplicant/wpa_supplicant.conf
```

次のコマンド
	$wpa_passphrase "your SSID" "Password"
で表示された内容をもとに次のファイルの下に追加で記述する。  

```
$sudo vim /etc/wpa_supplicant/wpa_supplicant.conf

~~~
network={
	ssid="your SSID"
#psk="Password"
		psk="......."
		key_mgmt=WPA-PSK
		proto=WPA WPA2
		pairwise=CCMP TKIP
		group=CCMP TKIP WEP104 WEP40
}
```

　これでラズパイを再起動すればつながるはず。  

## Webサーバー作り

まずは、ラズパイのローカルIPを固定にする。  

 ラズパイ上でラズパイ自身のローカルIPアドレスを確認しておく。  

	$ip addr

家のルーターの管理設定にログインして、ラズパイのIPの設定を、「自動割り当て」から「手動割り当て」に変更する。  

　次に、Webサーバーアプリの「Apache2」をインストールする。  

	$sudo apt-get install apache2

　これで、とりあえずはローカルでサーバーとして使うことができる。ローカルネットワークの端末のブラウザでラズパイのローカルIPアドレスを入力すれば、アクセスできる。  

## サーバーを外部へ公開する

　今の状態では、LANからしかサーバーにアクセスできない。これを外のネットワークからでもアクセスできるようにする。  

　まず、家のルーターから外への接続用のポートを開放する。  

  1. ルーターの管理設定に入る。  
  1. ルータ設定のポート変換を選ぶ
  1. ポート変換の新規追加で、LAN側IPアドレスをラズパイのローカルIPアドレスに、LAN側ポートを80にする。  
  1. 同じように22ポートも開放する。（80はHTTP用、22はSSH用である）
  1. ラズパイをDMZ(非武装地帯)に置くことですべてのポートを開放することができるが、ファイアウォールなどを適切に設定して、使わないポートをふさがなくてはならない。グローバルからローカルに入るとき、ルーターのファイアウォールによって守られているがDMZはその外にある。したがって、ラズパイは破壊されやすくなるが、たとえラズパイが破壊されてもローカルまで破壊されることは少なくなる。  
  1. ポートの開放状況は以下のコマンドで確認できる。  

	$nmap

　次に、[確認くん](http://www.ugtop.com/spill.shtml)により自分の家のグローバルIPアドレスを確認する。家のネットワークからアクセスしましょう。  
　これで、適当なブラウザから、このグローバルIPアドレスにアクセスすれば、どこからでもラズパイのWebサーバーにアクセスできる。（ドメインはまだ取得していないので、IPアドレスを直打ちして接続している）

## 独自ドメインを取得する

　ポートの開放により外部からサーバーにアクセスできるようになった。しかし、今のままではIPアドレスにアクセスなのでいまいち。そこで次は独自ドメインを取得して自分専用のURLをGETする。  
　ドメイン取得をできるサイトはいくつかあるが、ネット上で評価のよかった「[ムームードメイン](http://www.muumuudomain.com)」で取得した。`.top`一番安くて、なんと77円＋税/年！とても安い。  

## DNSサーバーとは

　独自ドメインを取得しましたが、取得したドメインはまだラズパイのIPアドレス（家のグローバルIPアドレス）に紐ついていません。それを紐つけるのがDNSサーバーです。DNS情報はあまりにも多いので、一つのDNSサーバーで管理しているわけではなく、ネット上に無数に散らばっています。したがってあるDNSサーバーに登録すれば、いろいろなDNSサーバーを経由して目的のIPアドレスを知ることができます。DNS情報のことをレコードと言い、以下に分類されます。  

  1. Aレコード：ドメイン名からIPアドレスを返す（正引き）
  1. PTRレコード：IPアドレスからドメイン名を返す（逆引き）
  1. CNAMEレコード：ドメイン名から別のドメイン名を返す
  1. NSレコード：「再起問い合わせ」や「反復問い合わせ」の際に、「ここへ問い合わせよ」と教えてくれる

## MyDNS.jpの登録

　普通、グローバルIPアドレスは動的に割り当てられるので、それとホスト名（ドメイン名）を動的に登録・管理するのがDDNSです。無料DDNSのひとつに[MyDNS.jp](http://www.mydns.jp)があるので、今回はそれを使います。まずは会員登録をします。そして「IP ADDR DIRECT」のところに家のグローバルIPアドレスを記載します。次に、「DOMAIN INFO」のところに自分の取得したホスト名（独自ドメイン）を記載します。欄が多いですが、それ以外は何も書かなくて大丈夫です。  

## DNSの浸透時間

　ここまでの作業をすれば、取得した独自ドメインをブラウザのURLに書くだけで自分のサーバーにつなことができます。しかし、すぐにつなぐことはできません。先にも書いたようにDNSサーバーはネット上に無数に散らばっていますので、最初にアクセスしたDNSが自分のドメインとIPの関連付けを持っているとは限りません。DNSからDNSへと広がっていき、次第に世界中からアクセスできるようになります。  

## 動的IPの自動更新

　ムームードメインで、独自ドメインを取得した。MyDNS.jpにも登録した。次にやることは、動的IPアドレスの自動更新である。定期的にグローバルIPの変更をチェックして[MyDNS.jp](http://www.mydns.jp)に通知をすればよい。それには以下のコマンドを実行する。  

	$ wget -O- 'http://mydnsXXXXXX:PASSWORD@www.mydns.jp/login.html'

これをcronなどを使って定期的に実行すればよい。  


