---
date: "2017-06-24"
title: "ESP32 でデュアルコアを使おう！"
categories:
  - "説明記事"
tags:
  - "ESP32"
  - "FreeRTOS"
  - "Arduino"
thumbnail: "icon.jpg"
---

## 概要

### ESP32 とは

{{< postfig src="esp32.jpg" title="ESP32" width="240px" >}}

[ESP32 Overview \| Espressif Systems](https://www.espressif.com/en/products/hardware/esp32/overview)

ESP32 は上海の企業である Espressif Systems から発売されている WiFi&Bluetooth コントローラです。
同時に gcc で開発できるマイコンでもあります。

<!--more-->

ESP-WROOM-32 という 700 円ほどの無線モジュールの中に入っているマイコンが ESP32 です。

### デュアルコア

実はこのマイコン、かなりスペックが高く、CPU がデュアルコアなんです！  
今回はその使い方を簡単に紹介します。

## RTOS (リアルタイムオペレーティングシステム)

### RTOS とは

[RTOS-Wikipedia](https://ja.wikipedia.org/wiki/%E3%83%AA%E3%82%A2%E3%83%AB%E3%82%BF%E3%82%A4%E3%83%A0%E3%82%AA%E3%83%9A%E3%83%AC%E3%83%BC%E3%83%86%E3%82%A3%E3%83%B3%E3%82%B0%E3%82%B7%E3%82%B9%E3%83%86%E3%83%A0)

さまざまな機能を持つアプリケーションを動かそうとするとき、OS を欠かすことはできません。その中でもリアルタイム OS はその名の通りリアルタイム性に優れており、ハードウェアのイベントに従って高速に処理をすることができます。

マルチタスクのやりかたを簡単に言うと、関数を 1 つのタスクと考え、OS に関数ポインタを渡しておくと、疑似的に同時並行で関数を実行してくれます。

### FreeRTOS

{{< postfig src="freertos.jpg" title="FreeRTOS" width="240px" link="http://www.freertos.org/" >}}

ESP32 の中では FreeRTOS というリアルタイム OS が動いています。  
FreeRTOS は、オープンソースの RTOS の 1 つで、さまざまなアーキテクチャに対応しています。オープンソースの RTOS の中では最も有名なものと言えるでしょう。

### ESP32 に使われている FreeRTOS

デュアルコアのためかわかりませんが、ESP32 に使われている FreeRTOS は、ESP32 用にカスタマイズされているみたいです。
ただ、使い方はほとんど同じです。

## デュアルコアの使い方

使い方はとても簡単です。

普段 FreeRTOS でタスクを作成するときは

~~~cpp
BaseType_t xTaskCreate (
  TaskFunction_t pxTaskCode,         //< タスクの関数ポインタ
  const char* const pcName,          //< タスク名
  const uint16_t usStackDepth,       //< タスクのスタックサイズ
  void* const pvParameters,          //< タスク関数に渡す引数
  UBaseType_t uxPriority,            //< タスクの優先度
  TaskHandle_t* const pxCreatedTask, //< タスクのハンドル
);
~~~

という関数を使いますが、代わりに

~~~cpp
BaseType_t xTaskCreatePinnedToCore (
  TaskFunction_t pxTaskCode,         //< タスクの関数ポインタ
  const char* const pcName,          //< タスク名
  const uint16_t usStackDepth,       //< タスクのスタックサイズ
  void* const pvParameters,          //< タスク関数に渡す引数
  UBaseType_t uxPriority,            //< タスクの優先度
  TaskHandle_t* const pxCreatedTask, //< タスクのハンドル
  const BaseType_t xCoreID           //< コア番号
);
~~~

という関数を使い、引数の最後に使用する CPU のコア番号を指定します。

つまり、どの CPU で実行するかというのはユーザーが選択する訳です。

ESP32 の場合、コアは 2 つなので、コア番号は 0 か 1 になります。

## サンプルコード

Arduino core for ESP32 環境でのサンプルコードです。

※Arduino IDE の Board 設定で Core Debug Level を info にしないとログは見えません。

~~~cpp
#include "esp32-hal-log.h"
#include "freertos/task.h"

void task0 (void* arg) {
  while (1) {
    log_i("This is Core 0");
    delay(1000);
  }
}

void task1 (void* arg) {
  while (1) {
    log_i("This is Core 1");
    delay(1500);
  }
}

void setup () {
  log_i("Hello, this is ESP32:)");
  xTaskCreatePinnedToCore(task0, "Task0", 4096, NULL, 1, NULL, 0);
  xTaskCreatePinnedToCore(task1, "Task1", 4096, NULL, 1, NULL, 1);
}

void loop () {
  delay(1500);
}
~~~

## ちなみに

ちなみに、Arduino core for ESP32 の main.cpp では、

~~~cpp
#if CONFIG_FREERTOS_UNICORE
#define ARDUINO_RUNNING_CORE 0
#else
#define ARDUINO_RUNNING_CORE 1
#endif

void loopTask (void *pvParameters)
{
  setup();
  for (;;){
    micros(); //update overflow
    loop();
  }
}

extern "C" void app_main ()
{
  initArduino();
  xTaskCreatePinnedToCore(loopTask, "loopTask", 4096, NULL, 1, NULL, ARDUINO_RUNNING_CORE);
}
~~~

こう書かれているので、いつも使っている setup () と loop () は優先度が 1 のタスクであることがわかります。

さらに、CONFIG_FREERTOS_UNICORE は false なので、このタスクを実行するコアは CPU1 であることがわかります。

おそらく OS などのシステムタスクは CPU0 で行っていて、ユーザーアプリケーションタスクを CPU1 で行うという位置づけなのでしょう。実際に各 CPU には名前がついていて、Process CPU と Application CPU となっています。

## まとめ

ついに電子工作の世界にデュアルコアがやって参りましたね！  
デュアルコアを使うためには RTOS は必須だと思うのでしっかり勉強していきたいです。  

一度デュアルコア用のコードを書けるようになっておけば、将来クアッドコアやオタクコアのマイコンが登場してもすぐに適応することができます。

実は、ESP32 には Ultra Low Power Coprocessor という 8MHz で動く CPU がもう一つ入っています。そちらもこれから使い方を勉強していきたいと思うので、収穫があったら紹介したいと思います。  

こんなにすごいマイコンですが、ESP-WROOM-32 はたった 700 円です。   
ESP32 の性能を最大限に使っていきましょう！

## 参考リンク

  * [www.espressif.com Resources](https://www.espressif.com/en/products/socs/esp32/resources)
  * [Espressif IoT Development Framework](https://github.com/espressif/esp-idf)
  * [Arduino core for ESP32 WiFi chip](https://github.com/espressif/arduino-esp32)

