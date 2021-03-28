---
date: "2017-09-27"
title: "FreeRTOSのTaskにC++のメンバ関数を割り当てる"
categories:
  - "備忘録"
tags:
  - "FreeRTOS"
---

## 概要

FreeRTOSはC言語で書かれているので、C++のメンバ関数をそのまま渡すことができない。今回の記事ではその解決策のひとつを紹介する。

<!--more-->

## サンプルコード

次のようにクラスを実装すると、C++のメンバ関数をC言語のFreeRTOSに渡すことができる。

~~~cpp
#include <freertos/FreeRTOS.h>
#include <freertos/task.h>

class TaskClass {
public:
  /* コンストラクタ */
  TaskClass() : handle(NULL) {}
  /*
   * FreeRTOS のタスクを生成する関数。
   * FreeRTOS のタスクを新規作成して、このクラスのメンバ関数 task() を割り当てる
   */
  void createTask(const char *name, const uint16_t stackSize,
                  const UBaseType_t taskPriority) {
    // タスクを生成
    xTaskCreate(
        [](void *this_pointer) {
          // タスク引数として受け取った this ポインタをオブジェクトにキャストして、
          // このクラスのメンバ関数である task() を実行
          static_cast<TaskClass *>(this_pointer)->task();
        },
        name,         //< タスク名
        stackSize,    //< スタックサイズ
        this,         //< タスク引数には this ポインタを渡す
        taskPriority, //< タスク優先度
        &handle       //< タスクハンドル
    );
  }
  /* タスクの削除 */
  void deleteTask() { vTaskDelete(handle); }

private:
  TaskHandle_t handle; //< FreeRTOSのタスクハンドル

  /*
   * 割り当てられる関数.
   * createTask()によりFreeRTOSのTaskが生成され、この関数が実行される。
   */
  void task() {
    while (1) {
      // タスクでの処理を書く
      // C++メンバー関数なので、メンバー変数を使用可能
      vTaskDelay(1000 / portTICK_RATE_MS);
    }
  }
};

int main(int argc, char *argv[]) {
  TaskClass task;
  task.createTask("TaskName", 1024, 1); //< スタックサイズ1024バイト、優先度1

  while (1) {
    // メインループでの処理
    vTaskDelay(1000 / portTICK_RATE_MS);
  }

  return 0;
}
~~~

## 解説

FreeRTOSに関数を渡す際、メンバ関数は渡せないので、とりあえずラムダを使った「`void*`を引数とするstaticな関数」を渡し、引数にthisポインタを指定する。

受け取ったポインタは`void*`になっているので、`static_cast<>()`によりクラスのポインタに直し、メンバ関数を呼ぶ。

## 参考記事

  * [C++でFreeRTOSのタスクをいい感じにつくる](http://idken.net/posts/2017-02-01-freertos_task_cpp/)

