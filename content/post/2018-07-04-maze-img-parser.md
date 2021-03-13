---
date: "2018-07-04T15:18:17+09:00"
title: "MATLABで迷路画像をパースする"
categories:
  - "備忘録"
tags:
  - "マイクロマウス"
  - "MATLAB"
  - "迷路"
thumbnail: "icon.png"
---

こんにちは．けりです．

今回は，マイクロマウス公式から配布される迷路画像を，プログラムなどで読める形式に変換するMATLABコードを紹介します．

自分向けに作ったものなので，あまり高機能ではありませんが，参考になれば幸いです．

<!--more-->

## MATLAB コードの紹介

以下のMATLABコードを実行すると，画像を選択するポップが現れます．

迷路画像を選択すると，区画数などの解析結果が表示されるので，もしミスがあれば，ノイズの除去と壁の膨張というセクションのパラメータをいじって調整します．

### mazeloader.m

ダウンロードは[こちら](mazeloader.m)

```m
%% 入力
[filename, pathname] = uigetfile({'*.jpg;*.png;*.gif'}, 'Select the Maze Image');

%% 二値化＆色反転(壁を1にするため)
original = imread([pathname, filename]);
bw = imbinarize(rgb2gray(original));
bw = imcomplement(bw);
imshow(bw);

%% 迷路の輪郭を抽出
colsum = sum(bw);
rowsum = sum(bw, 2);
[wM, we] = max(colsum(1:end/2));
[eM, ee] = max(colsum(end/2:end));
[nM, ne] = max(rowsum(1:end/2));
[sM, se] = max(rowsum(end/2:end));
trim = bw(ne:(se+size(rowsum,1)/2), we:(ee+size(colsum,2)/2));
trim = imresize(trim, [1600 1600]);

%% ノイズの除去と壁の膨張
trim = imopen(trim, ones(5));   % 白点線を除去
trim = imdilate(trim, ones(5)); % 白線を太くする
imshow(trim);

%% 迷路サイズを検出
trimsum = sum(trim);
trimsum = trimsum < sum(trimsum) / length(trimsum);
maze_size = sum(([trimsum 0]-[0 trimsum])>0);
msgbox(sprintf('迷路サイズは %d です', maze_size)); % 迷路サイズの表示

%% 壁の抽出
segsize = size(trim)/maze_size;
vwall = trim(round(segsize(1)/2:segsize(1):end), round(1:segsize(2):end-segsize(2)/3));
hwall = trim(round(1:segsize(1):end-segsize(1)/3), round(segsize(2)/2:segsize(2):end));
vwall = [vwall, ones(maze_size, 1)];
hwall = [hwall; ones(1, maze_size)];

%% 壁の合成
wall =        1 * vwall(:, 2:end);      % 東 0 bit
wall = wall + 2 * hwall(1:end-1, :);    % 北 1 bit
wall = wall + 4 * vwall(:, 1:end-1);    % 西 2 bit
wall = wall + 8 * hwall(2:end, :);      % 南 3 bit

%% ファイルに保存
output = reshape(sprintf('%x',wall), maze_size, maze_size);
output = ['"'*ones(maze_size, 1) output '",'.*ones(maze_size,1)];
new_filename = sprintf('%s.txt', filename);
dlmwrite(new_filename, output, 'precision', '%c', 'delimiter', '');
lmwrite(new_filename, wall, 'precision', '%x', 'delimiter', '');
```

## 出力形式

3:2:1:0 bit がそれぞれ 南:西:北:東 の16進数表示です．

    + 1 +
    2   0
    + 3 + 

例えば

    +---+---+
    | 6   3 |
    +   +   +
    | d | d |
    +---+---+

という迷路ならば，

    63
    dd

とテキストファイルに出力されます．

これ以外の順番にするには，MATLABコードの最後の出力の数字をいじることで変えることができます．

## まとめ

とりあえず使うことはできますが，もっと使いやすく改良したいところです．

ちなみに，このコードのアイディアは，元MiceのY.I.さんから聞いたものを参考にしました．

ありがとうございます．
