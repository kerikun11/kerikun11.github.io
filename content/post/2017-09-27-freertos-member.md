---
date: "2017-09-27"
title: "FreeRTOSのTaskにC++のメンバ関数を割り当てる"
categories:
  - "備忘録"
tags:
  - "FreeRTOS"
---

## 概要

FreeRTOSはC言語で書かれているので，C++のメンバ関数をそのまま渡すことができない．そこで，今回はその解決策のひとつを紹介する．

<!--more-->

## サンプルコード

~~~cpp
class Hoge{
public:
	/** コンストラクタ.
	*/
	Hoge() : handle(NULL) {}
	/** タスク生成関数.
	FreeRTOSのTaskを新規作成し，このクラスのメンバ関数task()を割り当てる
	*/
	createTask(const char* name, const uint16_t stackSize, const UBaseType_t taskPriority) {
		// タスクを生成
		xTaskCreate([](void* obj){
			// 引数として受け取ったthisポインタをオブジェクトにキャスト
			static_cast<Hoge*>(obj)->task(); //< メンバ関数のtask()を実行
		}, name, stackSize, this, taskPriority, &handle); //< 引数にはthisポインタを渡す
	}
	/** タスク削除関数.
	*/
	deleteTask() {
		vTaskDelete(handle);
	}

private:
	TaskHandle_t handle; //< FreeRTOSのタスクハンドル

	/** 割り当てられる関数.
	createTask()によりFreeRTOSのTaskが生成され，この関数が実行される．
	*/
	void task() {
		while(1) {
			// タスクでの処理
			vTaskDelay(1000 / portTICK_RATE_MS);
		}
	}
};

int main(int argc, char *argv[]) {
	Hoge hoge;
	hoge.createTask("TaskName", 1024, 1); //< スタックサイズ1024バイト，優先度1

	while(1){
		// メインループでの処理
		vTaskDelay(1000 / portTICK_RATE_MS);
	}

	return 0;
}

~~~

## 解説

FreeRTOSに関数を渡す際，メンバ関数は渡せないので，とりあえずラムダを使った「`void*`を引数とするstaticな関数」を渡し，引数にthisポインタを指定する．

受け取ったポインタは`void*`になっているので，`static_cast<>()`によりクラスのポインタに直し，メンバ関数を呼ぶ．

## 参考記事

  * [C++でFreeRTOSのタスクをいい感じにつくる](http://idken.net/posts/2017-02-01-freertos_task_cpp/)

