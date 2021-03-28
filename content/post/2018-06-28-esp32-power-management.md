---
date: "2018-06-28T08:50:59+09:00"
title: "ESP32 の Power Management 機能"
categories:
  - "説明記事"
tags:
  - "ESP32"
---

この記事では、ESP32をバッテリー駆動するためのヒントをお届けします。

<!--more-->

## はじめに

### ESP32とは？

ESP32とは、WiFi/BLEを搭載したIoTマイコンです。

CPUが240MHzのデュアルコアで、RAMも520kBと、
マイコンにしてはスペックが高いところが魅力です。

シリアル通信などのペリフェラルも充実していて、
UART, I2C, SPIなどのピンを好きなGPIOピンに割り当てることができて超便利です！！

また、公式のSDKにFreeRTOSというRTOSが組み込まれていて、
容易にマルチタスクのアプリケーションを動作させることができます。

ESP32についての記事一覧は[こちら](/tags/esp32)

### 電流消費ハンパないって！！

そんなESP32は、省エネ仕様を謳っています。

バッテリー駆動も普通にできるのかと思いきや、
スリープなどを考えずに使用すると、
CPUだけでも常時50mA程度消費し、
WiFiと同時に起動すると100mAを超えるほどになります。

これでは、どんなに大きなバッテリーを用意しても数日しか持ちません。

そこで今回は、ESP32をバッテリー駆動させるため、Power Management 機能について紹介します。

## Power Management

### 概要

ESP32 の Power Management は、ESP32公式でサポートされている機能です。

以下の3つを制御して、省エネを図ります。

- CPUの周波数
- APB (ペリフェラルのクロック) の周波数
- Light-Sleep

実際には、Power Management 機能を有効化した状態で、

~~~cpp
  // FreeRTOS の delay 関数
  // 1000 [ms]
  vTaskDelay(1000 / portTICK_PERIOD_MS);
~~~

などを実行すると、その間はCPUのクロックを止めてくれるというものです。

### 参考

- ESP-IDF Programming Guide - [Power Management](http://esp-idf.readthedocs.io/en/latest/api-reference/system/power_management.html)

### 動作環境は ESP-IDF

PowerManagementのLight-Sleepを使用するためには、
`make menuconfig` を編集する必要があるので、
ESP-IDF環境で実行する必要があります。

ESP-IDFの導入は[こちら](http://esp-idf.readthedocs.io/en/latest/get-started/index.html)

## Power Management 機能の使い方

### `make menuconfig`の設定

Power Management における Light-Sleep を有効化するためには、
`make menuconfig` の 

- `Component config/FreeRTOS/Tickless idle support`

にチェックを入れます。

これで、FreeRTOSのdelay中にクロックを止めることができます。(FreeRTOSにそういう機能がちゃんとある)

Light-Sleepを使用しない場合、Arduino環境でも一応動作するようですが、240MHzが40MHzに落ちるだけなので、あまり効果がないかもしれません。

### インクルードファイル

~~~cpp
#include "esp_pm.h"
~~~

### 初期化

以下のコードを実行すると、PowerManagement機能がスタートします。

~~~cpp
#include "esp_pm.h"

void pm_init() {
	esp_pm_config_esp32_t esp_pm_config_esp32;
	esp_pm_config_esp32.max_cpu_freq = RTC_CPU_FREQ_240M; //< make menuconfigで設定したCPU周波数
	esp_pm_config_esp32.min_cpu_freq = RTC_CPU_FREQ_XTAL;
	esp_pm_config_esp32.light_sleep_enable = true;
	esp_pm_configure(&esp_pm_config_esp32);
}
~~~

### 省エネ動作

例えば、以下のような関数を呼べば、その間スリープとなります。

~~~cpp
#include "freertos/FreeRTOS.h"
#include "freertos/task.h"

void sleep_ms(uint32_t ms) {
  vTaskDelay(ms / portTICK_PERIOD_MS);
}
~~~

### スリープの禁止

シリアル通信をするときや、何かを駆動するときなど、
delayはするけどCPUのクロックを変えたくない場合があります。

そんなときは、[Power Management Locks](http://esp-idf.readthedocs.io/en/latest/api-reference/system/power_management.html#power-management-locks)を使います。

PowerManagementの各機能

- CPUの周波数
- APB (ペリフェラルのクロック) の周波数
- Light-Sleep

に対して、ロックハンドルを生成し、
ロックの獲得、解放を行います。

実行例は以下の通りです。

~~~cpp
#include "esp_pm.h"

// CPU の周波数固定ハンドル
esp_pm_lock_handle_t lock_handle_cpu;
// APB の周波数固定ハンドル
esp_pm_lock_handle_t lock_handle_apb;
// Light-Sleepの禁止ハンドル
esp_pm_lock_handle_t lock_handle_light;

// ハンドルの初期化
void pm_lock_init() {
  // CPU の周波数固定ハンドル
	esp_pm_lock_create(ESP_PM_CPU_FREQ_MAX, 0, "cpu", &lock_handle_cpu);
  // APB の周波数固定ハンドル
	esp_pm_lock_create(ESP_PM_APB_FREQ_MAX, 0, "apb", &lock_handle_apb);
  // Light-Sleepの禁止ハンドル
	esp_pm_lock_create(ESP_PM_NO_LIGHT_SLEEP, 0, "light", &lock_handle_light);
}

// ロックの獲得
void acquire(esp_pm_lock_handle_t lock_handle) {
  esp_pm_lock_acquire(lock_handle);
}

// ロックの解放
void release(esp_pm_lock_handle_t lock_handle) {
	esp_pm_lock_release(out_handle);
}

// 実行例
void pm_lock_example(){
  pm_lock_init(); //< ロックハンドルを初期化

  acquire(lock_handle_apb); //< APB周波数を固定
  // シリアル通信などを行う
  release(lock_handle_apb); //< 解放
}
~~~

## C++ ラッパ

C言語はわかりづらいので、C++のラッパを作ってみました。

- [ESP32_PowerManagement](https://github.com/kerikun11/ESP32_PowerManagement)

GitHub上のコードが最新です。以下の説明は古い可能性があります。

### PowerManagement クラス
直観的に使えるようになっています。
~~~cpp
class PowerManagement {
public:
  static void init();
  static void printLockStatus();

  class Lock {
  public:
    Lock(esp_pm_lock_type_t lock_type, const char *name);
    void acquire();
    void release();

  private:
    esp_pm_lock_handle_t lock_handle;
  };
};
~~~

### 実行例

~~~cpp
#include "esp_log.h"
#include "freertos/FreeRTOS.h"
#include "freertos/task.h"

#include "PowerManagement.h"

extern "C" void app_main() {
  // PowerManagement機能の有効化
  PowerManagement::init();
  // ロックハンドルの生成
  PowerManagement::Lock cpu_clock_lock(ESP_PM_CPU_FREQ_MAX, "my cpu lock");
  PowerManagement::Lock apb_clock_lock(ESP_PM_APB_FREQ_MAX, "my apb lock");
  PowerManagement::Lock light_sleep_lock(ESP_PM_NO_LIGHT_SLEEP, "my light-sleep lock");

  cpu_clock_lock.acquire(); //< ロック
  // write tasks under normal CPU clock frequency
  cpu_clock_lock.release(); //< 解放

  vTaskDelay(3000 / portTICK_PERIOD_MS); //< Sleep

  apb_clock_lock.acquire(); //< ロック
  // write tasks under normal ABP clock frequency
  apb_clock_lock.release(); //< 解放

  vTaskDelay(3000 / portTICK_PERIOD_MS); //< Sleep

  light_sleep_lock.acquire(); //< ロック
  // write tasks under no light-sleep
  light_sleep_lock.release(); //< 解放

  vTaskDelay(portMAX_DELAY);  //< eternal sleep
}
~~~

## サンプルプロジェクト

- [PowerManagement.zip](PowerManagement.zip)

上記のサンプルコードにログ出力のコードを追加したものです。

一応、そのまま動くはずです。

実行例

~~~shell
  unzip PowerManagement.zip
  cd PowerManagement
  make menuconfig # シリアルポートの設定
  make flash monitor
~~~

## 注意

### Light-Sleepの注意

Light-Sleepの間は、普通のGPIOはオープン状態になります。

例えば、LEDを繋いでいた場合は、消えてしまいます。

代わりに、RTC_GPIOを使うことで、Light-Sleep中もキープさせることができます。

例えば、Light-Sleep中でもLEDを光らせたければ、以下のようにします。

~~~cpp
#include "driver/rtc_io.h"

void rtc_gpio_test() {
  // rtc_gpio init
  gpio_num_t pin_led = GPIO_NUM_27; //< LEDをつけたピン
  rtc_gpio_init(pin_led); //< 初期化
  rtc_gpio_set_direction(pin_led, RTC_GPIO_MODE_OUTPUT_ONLY); //< 出力に設定
  
  // Light-Sleep中でも持続するLED
  rtc_gpio_set_level(pin_led, 1); //< LED点灯
  rtc_gpio_hold_en(pin_led); //< 持続を有効化
  vTaskDelay(1000 / portTICK_PERIOD_MS); //< Light-Sleep
  rtc_gpio_hold_dis(pin_led); //< 持続を無効化
}
~~~

詳しくは、[公式リファレンス - GPIO](http://esp-idf.readthedocs.io/en/latest/api-reference/peripherals/gpio.html#api-reference-rtc-gpio)
をご覧ください。

## まとめ

今回の内容でESP32のバッテリー駆動への足掛かりになりました。

さらに、Modem-Sleepという、Wi-Fiの省エネを図るスリープもあるので、後日紹介したいと思います。

では、みなさんも良きESP32ライフを！

## 参考

- [Power Management](http://esp-idf.readthedocs.io/en/latest/api-reference/system/power_management.html)
- [Sleep Modes](http://esp-idf.readthedocs.io/en/latest/api-reference/system/sleep_modes.html)
- [Wi-Fi Power-saving Mode](http://esp-idf.readthedocs.io/en/latest/api-guides/wifi.html#esp32-wi-fi-power-saving-mode)
