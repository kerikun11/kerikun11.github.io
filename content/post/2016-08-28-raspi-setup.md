---
date: "2016-08-28"
title: "ラズパイセットアップのコマンド群"
categories:
  - "備忘録"
tags:
  - "Raspberry Pi"
  - "サーバー"
thumbnail: "icon.png"
---

## はじめに

これらの作業はすべてSSHで行う．fingなどを使ってIPアドレスを調べる．

	$ ssh pi@192.168.11.13

<!--more-->

## 更新

	$ sudo apt-get update
	$ sudo apt-get upgrade

	$ sudo rpi-update

	$ sudo raspi-config

  * Expand Filesystem
  * Internationalisation Options
    * Change Locale
    * Change Timezone
    * Change Keyboard Layout
    * Change WiFi Country
  * Advanced Options
    * Change Hostname

## 必要なパッケージのインストール

	$ sudo apt-get install -y vim tmux zsh git

## ルートパスワードの変更

	$ sudo passwd root

## IPアドレスの固定化

### 静的IPの設定

あらかじめルーターの管理画面で，192.168.11.2をDHCPの割り当て範囲から外しておく．

	$ sudo vim /etc/network/interfaces

~~~kconfig
# interfaces(5) file used by ifup(8) and ifdown(8)

# Please note that this file is written to be used with dhcpcd
# For static IP, consult /etc/dhcpcd.conf and 'man dhcpcd.conf'

# Include files from /etc/network/interfaces.d:
source-directory /etc/network/interfaces.d

auto lo
iface lo inet loopback

#iface eth0 inet manual
auto eth0
allow-hotplug eth0
iface eth0 inet static
address 192.168.11.2
netmask 255.255.255.0
gateway 192.168.11.1
dns-nameservers 8.8.8.8 192.168.11.1

allow-hotplug wlan0
iface wlan0 inet manual
    wpa-conf /etc/wpa_supplicant/wpa_supplicant.conf

allow-hotplug wlan1
iface wlan1 inet manual
	wpa-conf /etc/wpa_supplicant/wpa_supplicant.conf
~~~

### 再起動

	$ sudo reboot

## 使用ユーザーの作成

### ユーザーを新規作成

	$ sudo adduser hoge
	$ sudo gpasswd -a hoge sudo

### ホームディレクトリがなければ作る

	$ sudo ls -l /home
	$ sudo mkdir /home/hoge
	$ sudo chown hoge /home/hoge
	$ sudo chgrp hoge /home/hoge

### デフォルトシェルの変更

	$ sudo vim /etc/passwd

~~~diff
- hoge:x:1001:1001:,,,:/home/hoge:/bin/bash
+ hoge:x:1001:1001:,,,:/home/hoge:/bin/zsh
~~~

### ログイン

	$ su hoge

## ユーザーpiの削除

	$ sudo userdel -r pi

## 公開鍵認証

### クライアント上

#### 必要があれば鍵の作成

	$ cd .ssh
	$ ssh-keygen -t ecdsa -C "foo"

#### 公開鍵の送信

	$ scp ~/.ssh/id_ecdsa.pub hoge@192.168.11.2:

### ホスト上

#### 受け取った公開鍵の登録

	$ mkdir ~/.ssh
	$ cat ~/id_ecdsa.pub >> ~/.ssh/authorized_keys

### 接続方法

	$ ssh hoge@192.168.11.2 -p 22 -i ~/.ssh/id_ecdsa

## SSHポートの変更，パスワード認証の禁止

	$ sudo vim /etc/ssh/sshd_config

~~~diff
- Port 22
+ Port 22222

- #PasswordAuthentication yes
+ PasswordAuthentication no
~~~

