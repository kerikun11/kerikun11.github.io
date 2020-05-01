---
date: "2016-01-13"
title: "PICでブートローダ"
categories:
  - "説明記事"
tags:
  - "PIC"
  - "PIC18F27J53"
  - "USB"
  - "ブートローダ"
thumbnail: "icon.jpg"
---

## 概要

### PIC18F27J53を使おう

以前 [PIC18F27J53のすすめ](/posts/2016-01-08-pic18f27j53/) という記事を書きました。それの続きで、今回はUSBブートローダの使い方について書きたいと思います。

### ブートローダとは

ブートローダとは自分自身にプログラムを書きこむプログラムです。これを使うとPICkitなどのライタを使わなくてもプログラムの書き込みをすることができるようになります。

ただし、初回に一度だけブートローダ用のプログラムをPICkitなどで書きこむ必要があります。

### ユーザープログラム

ユーザープログラムとは、ブートローダーにより書き込むプログラムです。あなたが作った、実際に動かすプログラムということです。

<!--more-->

## 回路

後述のI/Oピンによるブートロードモードへの移行をオンにする場合はRB0(21 pin)をプルアップしておいてください。そこをLOWにするとブートロードモードに入るので、SWなどをつけてもいいでしょう。

また、RC2(13 pin)がブートローダのステータスを出力するのでLEDをつけるといいでしょう。

どちらもユーザープログラムには影響はありません。

回路図  
{{< postfig src="sketch.png" title="PIC18F27J53の回路図" link="sketch.png" >}}

## ブートローダプログラム

### HEXファイル

以下のHEXファイルをPICに書き込むだけで動作します。HEXファイルをPICに書き込むには、MPLAB X IDEと一緒についてきた`MPLAB IPE.exe`を使います。

以下のHEXファイルはMicrochip公式ライブラリ(MLA)のソースをPIC18F27J53用に編集して作りました。コンパイルにはXC8のPRO版が必要なため、ソースではなくHEXファイルを配布します。(XC8には60日間無料のPRO体験版があります)

ソフトウェアまたはハードウェアでブートモードへ切り替えHEX（推奨）  
[HID\_Bootloader\_PIC18F27J53(RB0-software-enter).hex](HID_Bootloader_PIC18F27J53(RB0-software-enter).hex)  
ソフトウェアでブートロードモードへ切り替えHEX(I/Oピンを減らしたくない人向け)  
[HID\_Bootloader\_PIC18F27J53(software-enter).hex](HID_Bootloader_PIC18F27J53(software-enter).hex)  

## ユーザープログラムの書き方

### Configration Bitsは不要

Configration Bitsはハードウェアにかなり寄り添ったプログラムなため、ブートローダで書き換えることができません。上のHEXファイルでは、以下のConfigration Bitsがあらかじめ書き込まれています。

なお、このConfigration Bitsを変更したい場合は、ブートローダプログラムを再コンパイルする必要があるので、XC8コンパイラのPROライセンスが必要です。

~~~c
// CONFIG1L
#pragma config WDTEN = OFF, PLLDIV = 2, CFGPLLEN = ON, STVREN = OFF, XINST = OFF
// CONFIG1H
#pragma config CPUDIV = OSC1, CP0 = OFF
// CONFIG2L
#pragma config OSC = INTOSCPLL, SOSCSEL = LOW, CLKOEC = OFF, FCMEN = OFF, IESO = OFF
// CONFIG2H
#pragma config WDTPS = 1024
// CONFIG3L
#pragma config DSWDTOSC = T1OSCREF, RTCOSC = T1OSCREF, DSBOREN = OFF, DSWDTEN = OFF, DSWDTPS = G2
// CONFIG3H
#pragma config IOL1WAY = OFF, ADCSEL = BIT12, MSSP7B_EN = MSK7
// CONFIG4L
#pragma config WPFP = PAGE_127, WPCFG = OFF
// CONFIG4H
#pragma config WPDIS = OFF, WPEND = PAGE_WPFP, LS48MHZ = SYS48X8
~~~

### ROMの範囲とオフセットを指定

  1. プロジェクトを右クリックして、`Properties`を開きます。
  1. 左側の`XC8 linker`をクリックする。
  1. `Option categories:`で`Memory model`を開く。
  1. `ROM ranges`を`default,-0-FFF,-1006-1007,-1016-1017`に指定する。（下図参照）
  1. `Option categories:`で`Additional options`を開く。
  1. `Codeoffset`を`0x1000`に指定する。(下図参照)
  1. 以上。

{{< postfig src="Required_Application_Project_ROM_Ranges_Linker_Settings_for_XC8.png" title="ROM rages" >}}
{{< postfig src="Required_Application_Project_Codeoffset_Linker_Settings_for_XC8.png" title="Codeoffset" >}}

## ブートロードモードへ移行するには

### ソフトウェアでブートロードモードへ移行

ユーザープログラムからソフトウェアでブートモードへ移るには、以下のコードを書きます。

    asm("goto   0x001C");

※ブートロードモードから、ユーザープログラムに移るにはMCLRなどのリセットが必要です。

### I/Oピンでブートロードモードへ移行

PICに電源を投入またはPICをリセットしたときに、RB0端子がHIGHならばユーザープログラム、LOWならばブートローダプログラムが起動します。


## ユーザープログラムを書き込み

  1. [ここ](http://www.microchip.com/pagehandler/en-us/devtools/mla/home.html)からMicrochip Libraris for Applicationsをダウンロードし、インストールする。
  1. インストール場所/mla\_v2014\_07\_22/ apps/usb/device/bootloaders/ utilities/bin/win/ HIDBootloader.exeを起動する。
  1. ブートロードモードのPICをUSBで接続する。
  1. 上手く接続できると、右下に`connected`と表示されるので、ユーザープログラムのHEXファイルをロードして書き込めばOK。

上手くいかないときは、ドライバをインストールすればうまくいくかもしれません。ドライバも先ほどインストールしたMLAの中のutilities/usb\_drivers/に入っています。

{{< postfig src="util1.png" title="HIDbootloader.exe" >}}

## まとめ

USBブートローダを使えば、PICkitなどの周辺機器はほとんど必要なくなります。PICだけでPICの開発ができるようになるのです！

PIC最高ーーー！！！

