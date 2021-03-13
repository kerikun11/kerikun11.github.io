---
date: "2017-03-26"
title: "ESP32用UIライブラリ"
categories:
  - "備忘録"
tags:
  - "ESP32"
  - "Arduino"
---

## 概要

ESP32も徐々に使い慣れてきました．今回の記事では，ちょっとした工作には欠かせないユーザーインターフェースのコードを紹介します．

  * スピーカーから音階を鳴らすブザークラス
  * タクトスイッチなどのボタンを扱うボタンクラス

今回のコードは，ESP32用に書かれています．ご注意ください．

<!--more-->

## 必要なライブラリ

### TaskBase.h

C++のメンバ関数をFreeRTOSに渡すためのクラスです．タスクを作るときはこのクラスを継承して使います． 
こちらのコードは，[id研](http://idken.net/posts/2017-02-01-freertos_task_cpp/)さんから教えて頂いたものを改変しております．

~~~c
#pragma once

#include "freertos/FreeRTOS.h"
#include "freertos/task.h"

class TaskBase {
  public:
    TaskBase() = delete;

    TaskBase(const char *_name, int _priority, uint32_t _stack_size = configMINIMAL_STACK_SIZE)
      : name(_name), priority(_priority), stack_size(_stack_size) {
    }
    virtual ~TaskBase() {
      delete_task();
    }
    void create_task(const BaseType_t xCoreID = tskNO_AFFINITY) {
      if (handle != NULL) {
        return;
      }
      //      xTaskCreate(task_entry_point, name, stack_size, this, priority, &handle);
      xTaskCreatePinnedToCore(task_entry_point, name, stack_size, this, priority, &handle, xCoreID);
    }
    void delete_task() {
      if (handle == NULL) {
        return;
      }
      vTaskDelete(handle);
      handle = NULL;
    }

  protected:
    xTaskHandle handle = 0;
    const char *name;
    int priority;
    uint32_t stack_size;

    virtual void task() = 0;

    static void task_entry_point(void* task_instance) {
      static_cast<TaskBase*>(task_instance)->task();
    }
};
~~~

## ブザークラス

圧電スピーカを鳴らすライブラリです．

~~~c
void Buzzer::sound(note_t note, uint8_t octave, uint32_t time_ms);
~~~

この関数に音階，オクターブ，鳴らす時間を与えると自分で好きなメロディを作ることができます．その時は`enum Music`に新しいエントリを追加して，下のswitch文の中に書いてください．

### Buzzer.h

~~~c
#pragma once

#include <Arduino.h>
#include "TaskBase.h"

#define BUZZER_TASK_PRIORITY    1
#define BUZZER_TASK_STACK_SIZE  2048
#define BUZZER_QUEUE_SIZE       5

class Buzzer : TaskBase {
  public:
    Buzzer(int pin, uint8_t ledc_channel): TaskBase("Buzzer Task", BUZZER_TASK_PRIORITY, BUZZER_TASK_STACK_SIZE), pin(pin), ledc_channel(ledc_channel) {
      playList = xQueueCreate(BUZZER_QUEUE_SIZE, sizeof(enum Music));
      ledcSetup(ledc_channel, 880, 4);
      ledcAttachPin(pin, ledc_channel);
      create_task();
    }
    virtual ~Buzzer() {}
    enum Music {
      BOOT,
      SELECT,
      CONFIRM,
      CANCEL,
      COMPLETE,
      ERROR,
    };
    void play(const enum Music music) {
      xQueueSendToBack(playList, &music, 0);
    }
  private:
    int pin;
    uint8_t ledc_channel;
    xQueueHandle playList;
    void sound(const note_t note, uint8_t octave, uint32_t time_ms) {
      ledcWriteNote(ledc_channel, note, octave);
      vTaskDelay(time_ms / portTICK_RATE_MS);
    }
    void mute(uint32_t time_ms = 400) {
      ledcWrite(ledc_channel, 0);
      vTaskDelay(time_ms / portTICK_RATE_MS);
    }
    void task() {
      while (1) {
        Music music;
        xQueueReceive(playList, &music, portMAX_DELAY);
        switch (music) {
          case BOOT:
            sound(NOTE_B, 5, 200);
            sound(NOTE_E, 6, 400);
            sound(NOTE_Fs, 6, 200);
            sound(NOTE_B, 6, 600);
            mute();
            break;
          case SELECT:
            sound(NOTE_C, 6, 100);
            mute(100);
            break;
          case CONFIRM:
            sound(NOTE_C, 6, 100);
            sound(NOTE_E, 6, 100);
            mute(100);
            break;
          case CANCEL:
            sound(NOTE_E, 6, 100);
            sound(NOTE_C, 6, 100);
            mute(100);
            break;
          case COMPLETE:
            sound(NOTE_C, 6, 100);
            sound(NOTE_D, 6, 100);
            sound(NOTE_E, 6, 100);
            sound(NOTE_F, 6, 100);
            sound(NOTE_G, 6, 100);
            sound(NOTE_A, 6, 100);
            sound(NOTE_B, 6, 100);
            sound(NOTE_C, 7, 100);
            mute(100);
            break;
          case ERROR:
            for (int i = 0; i < 6; i++) {
              sound(NOTE_C, 7, 100);
              sound(NOTE_E, 7, 100);
            }
            mute();
            break;
          default:
            sound(NOTE_C, 4, 1000);
            mute();
            break;
        }
      }
    }
};
~~~

### 使い方

~~~c
#include "Buzzer.h"

#define PIN_BUZZER      19
#define LEDC_CH_BUZZER  1

Buzzer bz(PIN_BUZZER, LEDC_CH_BUZZER);

void setup(){
  bz.play(Buzzer::BOOT);
}

void loop(){
}
~~~

## ボタンクラス

ボタンが押されるとその押され方に従ってフラグを立てます．もちろん，チャタリングは回避されています．  

このボタンライブラリでは，ボタンのクリックと3段階の長押しを判定し，それらのフラグを立てます．ライブラリを使うときはそのフラグを監視することでボタンの押下を確認することができます．

フラグを確認したらそのフラグはクリアしましょう．

### Button.h

~~~c
#pragma once

#include <Arduino.h>
#include "TaskBase.h"
#include "config.h"


#define BUTTON_SAMPLING_MS        20

#define BUTTON_PRESS_LEVEL        1
#define BUTTON_LONG_PRESS_LEVEL_1 20
#define BUTTON_LONG_PRESS_LEVEL_2 100
#define BUTTON_LONG_PRESS_LEVEL_3 500

#define BUTTON_TASK_PRIORITY      2
#define BUTTON_STACK_SIZE         1024

class Button: TaskBase {
  public:
    Button(int pin) : TaskBase("Button Task", BUTTON_TASK_PRIORITY, BUTTON_STACK_SIZE) {
      pinMode(pin, INPUT_PULLUP);
      flags = 0x00;
      create_task();
    }
    virtual ~Button() {}

    union {
      uint8_t flags;                 /**< all flags             */
      struct {
        uint8_t pressed : 1;         /**< pressed               */
        uint8_t long_pressed_1 : 1;  /**< long-pressed level 1  */
        uint8_t long_pressed_2 : 1;  /**< long-pressed level 2  */
        uint8_t long_pressed_3 : 1;  /**< long-pressed level 3  */
        uint8_t pressing : 1;        /**< pressing              */
        uint8_t long_pressing_1 : 1; /**< long-pressing level 1 */
        uint8_t long_pressing_2 : 1; /**< long-pressing level 2 */
        uint8_t long_pressing_3 : 1; /**< long-pressing level 3 */
      };
    };
  private:
    int pin;
    int counter;

    virtual void task() {
      portTickType xLastWakeTime;
      xLastWakeTime = xTaskGetTickCount();
      while (1) {
        vTaskDelayUntil(&xLastWakeTime, BUTTON_SAMPLING_MS / portTICK_RATE_MS);
        if (digitalRead(pin) == LOW) {
          if (counter < BUTTON_LONG_PRESS_LEVEL_3 + 1)
            counter++;
          if (counter == BUTTON_LONG_PRESS_LEVEL_3)
            long_pressing_3 = 1;
          if (counter == BUTTON_LONG_PRESS_LEVEL_2)
            long_pressing_2 = 1;
          if (counter == BUTTON_LONG_PRESS_LEVEL_1)
            long_pressing_1 = 1;
          if (counter == BUTTON_PRESS_LEVEL)
            pressing = 1;
        } else {
          if (counter >= BUTTON_LONG_PRESS_LEVEL_3)
            long_pressed_3 = 1;
          else if (counter >= BUTTON_LONG_PRESS_LEVEL_2)
            long_pressed_2 = 1;
          else if (counter >= BUTTON_LONG_PRESS_LEVEL_1)
            long_pressed_1 = 1;
          else if (counter >= BUTTON_PRESS_LEVEL)
            pressed = 1;
          counter = 0;
          flags &= 0x0F;
        }
      }
    }
};
~~~

### 使い方

~~~c
#include "Buzzer.h"
#include "Button.h"

#define BUTTON_PIN      0

#define PIN_BUZZER      19
#define LEDC_CH_BUZZER  1

Buzzer bz(PIN_BUZZER, LEDC_CH_BUZZER);
Button btn(BUTTON_PIN);

void setup(){
  bz.play(Buzzer::BOOT);
}

void loop(){

  if(btn.pressed){
    btn.pressed = 0; // フラグを確認したらクリアする
    bz.play(Buzzer::SELECT);
  }

  if(btn.long_pressed_1 || btn.long_pressing_2){
    btn.flags = 0; // まとめてクリア
    bz.play(Buzzer::CANCEL);
  }

}
~~~

## まとめ

ボタンやブザーなどはいつも使うので，コピペで同じコードを使いまわせると便利ですね！ぜひ使ってみてください．

