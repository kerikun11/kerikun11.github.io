---
date: "2018-02-16T18:51:25+09:00"
title: "ESP32にSmartConfigでWiFi情報を伝える"
categories:
- "説明記事"
tags:
- "ESP32"
---

## WiFiのSSIDとパスワードをどう伝えるか問題

ESP32はWiFiに接続することができますが、ソースコードにWiFiのSSIDとパスワードを書いてしまうと、後から変更できません。

さらに、ソースコードを公開するときは、SSIDとパスワードの部分をいちいち削除しなければならず、けっこう面倒です。

以前は[SDカードを使ってWiFi情報を伝える方法](/posts/2017-07-29-esp32-wifi-sd/)を紹介しましたが、これも割と手間でした。

SmartConfigとは、そんな悩みをスマホで解決する機能です。

<!--more-->

## SmartConfigとは

ESP32のSmartConfig機能は、ESP32がWiFiのアクセスポイントになることで、スマホからWiFi情報を伝えてやろうというものです。

既にESP8266のときからある機能で、スマホのアプリがあります。

- [Google Play ESP8266 SmartConfig](https://play.google.com/store/apps/details?id=com.cmmakerclub.iot.esptouch&hl=ja)
- [AppStore SmartConfig](https://itunes.apple.com/us/app/smartconfig/id1233975749?mt=8)

## 使い方

### ESP32側

ここでは例によって [Arduino core for the ESP32](https://github.com/espressif/arduino-esp32) 環境でのやり方を紹介します。

[ここ](https://github.com/espressif/arduino-esp32/blob/master/libraries/WiFi/examples/WiFiSmartConfig/WiFiSmartConfig.ino)に公式のサンプルコードがあります。

SmartConfigの関数はWiFiクラスに宣言されていますので、そのまますぐに使うことができます。

{{< highlight cpp >}}
#include "WiFi.h"
void setup() {
	Serial.begin(115200); //< シリアルの初期化

	// WiFI を AP + STA モードにする
	WiFi.mode(WIFI_AP_STA);
	WiFi.beginSmartConfig(); //< SmartConfigの初期化

	// スマホからのアクセスを待つ
	Serial.println("Waiting for SmartConfig.");
	while (!WiFi.smartConfigDone()) {
		delay(500);
		Serial.print(".");
	}
	// スマホからSSIDとパスワードが送られてきた
	Serial.println("SmartConfig received.");

	// WiFiに接続
	Serial.println("Waiting for WiFi");
	while (WiFi.status() != WL_CONNECTED) {
		delay(500);
		Serial.print(".");
	}
	// 接続成功
	Serial.println("WiFi Connected.");
}

void loop() {
}
{{< /highlight >}}

### スマホ側

アプリを起動して、WiFiのパスワードを入力するだけです。

- [Google Play ESP8266 SmartConfig](https://play.google.com/store/apps/details?id=com.cmmakerclub.iot.esptouch&hl=ja)
- [AppStore SmartConfig](https://itunes.apple.com/us/app/smartconfig/id1233975749?mt=8)


## まとめ

驚くほど簡単にWiFi情報の伝達ができてしまいました。

いい時代になったものです。
