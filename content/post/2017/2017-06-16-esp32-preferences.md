---
date: "2017-06-16"
title: "ESP32の設定管理ライブラリの紹介"
categories:
  - "説明記事"
tags:
  - "ESP32"
  - "Arduino"
thumbnail: "icon.jpg"
---

## 概要

みなさん、ESP32使ってますか？僕は使っています。その偉大さには驚くばかりです。

さて、今回紹介するのは、Arduino core for ESP32に含まれているライブラリ「[Preferences](https://github.com/espressif/arduino-esp32/tree/master/libraries/Preferences)」です。

ESP32で何か物を作るとき、電源を切っても保存しておきたいデータなどがあると思います。独自の形式やJSONなどでファイルに保存する方法もありますが、保存と復元の処理を実装するのはなかなか面倒です。

みんなどうせ同じようなことをするでしょうということで、ESP32ではライブラリが用意されていました。

不揮発性のフラッシュ領域を使ってデータを保存&復元します。

<!--more-->

## Preferencesライブラリ

ライブラリのヘッダーファイルとサンプルコードをコピペします。  
ソースは[ここ](https://github.com/espressif/arduino-esp32/tree/master/libraries/Preferences)

Arduino core for ESP32 に含まれているので、特に何もインストールすることなく使うことができます。バージョンが古い場合は最新にアップデートしましょう。

### Preferences.h

~~~cpp
// Copyright 2015-2016 Espressif Systems (Shanghai) PTE LTD
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

#ifndef _PREFERENCES_H_
#define _PREFERENCES_H_

#include "Arduino.h"

class Preferences {
    protected:
        uint32_t _handle;
        bool _started;
        bool _readOnly;
    public:
        Preferences();
        ~Preferences();

        bool begin(const char * name, bool readOnly=false);
        void end();

        bool clear();
        bool remove(const char * key);

        size_t putChar(const char* key, int8_t value);
        size_t putUChar(const char* key, uint8_t value);
        size_t putShort(const char* key, int16_t value);
        size_t putUShort(const char* key, uint16_t value);
        size_t putInt(const char* key, int32_t value);
        size_t putUInt(const char* key, uint32_t value);
        size_t putLong(const char* key, int32_t value);
        size_t putULong(const char* key, uint32_t value);
        size_t putLong64(const char* key, int64_t value);
        size_t putULong64(const char* key, uint64_t value);
        size_t putFloat(const char* key, float_t value);
        size_t putDouble(const char* key, double_t value);
        size_t putBool(const char* key, bool value);
        size_t putString(const char* key, const char* value);
        size_t putString(const char* key, String value);
        size_t putBytes(const char* key, const void* value, size_t len);

        int8_t getChar(const char* key, int8_t defaultValue = 0);
        uint8_t getUChar(const char* key, uint8_t defaultValue = 0);
        int16_t getShort(const char* key, int16_t defaultValue = 0);
        uint16_t getUShort(const char* key, uint16_t defaultValue = 0);
        int32_t getInt(const char* key, int32_t defaultValue = 0);
        uint32_t getUInt(const char* key, uint32_t defaultValue = 0);
        int32_t getLong(const char* key, int32_t defaultValue = 0);
        uint32_t getULong(const char* key, uint32_t defaultValue = 0);
        int64_t getLong64(const char* key, int64_t defaultValue = 0);
        uint64_t getULong64(const char* key, uint64_t defaultValue = 0);
        float_t getFloat(const char* key, float_t defaultValue = NAN);
        double_t getDouble(const char* key, double_t defaultValue = NAN);
        bool getBool(const char* key, bool defaultValue = false);
        size_t getString(const char* key, char* value, size_t maxLen);
        String getString(const char* key, String defaultValue = String());
        size_t getBytes(const char* key, void * buf, size_t maxLen);
};

#endif
~~~

### sample.ino

起動回数をPreferencesとして保存し、再起動を繰り返してもデータが消えないというサンプルです。

~~~cpp
/*
 ESP32 start counter example with Preferences library

 This simple example demonstrate using Preferences library to store how many times
 was ESP32 module started. Preferences library is wrapper around Non-volatile
 storage on ESP32 processor.

 created for arduino-esp32 09 Feb 2017
 by Martin Sloup (Arcao)
*/

#include <Preferences.h>

Preferences preferences;

void setup() {
  Serial.begin(115200);
  Serial.println();

  // Open Preferences with my-app namespace. Each application module, library, etc.
  // has to use namespace name to prevent key name collisions. We will open storage in
  // RW-mode (second parameter has to be false).
  // Note: Namespace name is limited to 15 chars
  preferences.begin("my-app", false);

  // Remove all preferences under opened namespace
  //preferences.clear();

  // Or remove the counter key only
  //preferences.remove("counter");

  // Get a counter value, if key is not exist return default value 0
  // Note: Key name is limited to 15 chars too
  unsigned int counter = preferences.getUInt("counter", 0);

  // Increase counter
  counter++;

  // Print counter to a Serial
  Serial.printf("Current counter value: %u\n", counter);

  // Store counter to the Preferences
  preferences.putUInt("counter", counter);

  // Close the Preferences
  preferences.end();

  // Wait 10 seconds
  Serial.println("Restarting in 2 seconds...");
  delay(2000);

  // Restart ESP
  ESP.restart();
}

void loop() {}
~~~

## 説明

ヘッダーファイルとサンプルコードを見れば雰囲気はわかると思います。

要点をまとめると

  * 項目の識別には名前(文字列)を使用する(JSONみたいな感じ)
  * `Preferences::putTypeName(key, value);`で書き込む。
  * `Preferences::getTypeName(key);`で読み取る。
  * 各型に対応した関数が用意されており、型は自分で指定する
  * 対応する型がなければ、配列とバイト数で渡せばOK
  * 読み取り専用にもできる

といったところでしょうか。

## まとめ

最近は時間があるとESP32のリファレンスやデータシートを読んでいますが、このマイコンの強さには恐れいりました。みなさんもぜひ使ってみてくださいね！

ESP32のライブラリは現在も頻繁に更新されており、便利な機能が増えています。ときどきチェックして最新機能に触れましょう！
