---
title: "C++のライブラリをPythonから呼び出す"
date: "2020-06-08T22:11:57+09:00"
categories:
  - "説明記事"
tags:
  - "C++"
  - "Python"
draft: "true"
---

## はじめに

こんにちは．けりです．

今回の記事ではC++で実装したライブラリをPythonから呼び出す方法を紹介します．

<!--more-->

## 概要

## 使用したライブラリ

今回使用したライブラリは `pybind11` です．

{{< postfig src="https://github.com/pybind/pybind11/raw/master/docs/pybind11-logo.png" title="pybind11" width="240px" link="https://github.com/pybind/pybind11" >}}

`Boost` にも似たようなライブラリがありますが，余計なものが少なく使いやすそうだったこちらを選びました．

## 実装

### 依存ライブラリのインストール

```sh
# Arch Linux
pacman -S gcc cmake ninja boost python
# MSYS2
pacman -S --needed \
    git \
    mingw-w64-x86_64-toolchain \
    mingw-w64-x86_64-cmake \
    mingw-w64-x86_64-ninja \
    mingw-w64-x86_64-boost \
    mingw-w64-x86_64-python \
    mingw-w64-x86_64-python-matplotlib \
```

### 依存ライブラリのリンク

ビルドのために必要なBoostとPythonのライブラリをリンクするために，`CMakeLists.txt`に以下の内容を記述します．

#### pybind11/CMakeLists.txt

```cmake
# author: Ryotaro Onuki <kerikun11+github@gmail.com>
# date: 2020.06.11

# find packages
find_package(pybind11)
if(NOT pybind11_FOUND)
  message(WARNING "pybind11 not found in your environment! skipping...")
  RETURN()
endif()

# make a python module
set(MODULE_NAME "ctrl")
file(GLOB SRC_FILES *.cpp)
pybind11_add_module(${MODULE_NAME} ${SRC_FILES})
target_include_directories(${MODULE_NAME}
  PRIVATE ${CMAKE_HOME_DIRECTORY}/include
  PRIVATE ${PYBIND11_INCLUDE_DIR}
)
# to suppress warning in clang
target_compile_options(${MODULE_NAME} PRIVATE -Wno-self-assign)

# give a name
set(CUSTOM_TARGET_NAME "pybind11")
# find python interpreter
find_package(Python3)
if(NOT Python3_FOUND)
  message(WARNING "Python3 not found in your environment! skipping...")
  RETURN()
endif()
# make a custom target to plot
add_custom_target(${CUSTOM_TARGET_NAME}_plot
  COMMAND ${CMAKE_COMMAND} -E env PYTHONPATH=${CMAKE_CURRENT_BINARY_DIR}
  ${Python3_EXECUTABLE} ${CMAKE_CURRENT_SOURCE_DIR}/plot.py
  WORKING_DIRECTORY ${CMAKE_BINARY_DIR}
  DEPENDS ${MODULE_NAME}
  USES_TERMINAL
)
```
