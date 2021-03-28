---
date: "2019-01-14T10:00:00+09:00"
title: "VSCode で TeX を書こう"
categories:
  - "説明記事"
tags:
  - "VSCode"
  - "Latex"
spotlight: "true"
---

## 概要

今回は私が使っている TeX のエディタ環境を紹介します。

注目機能は以下の通りです。

- コード補完
- コード整形
- 環境に依存しにくい [.latexmk](https://texwiki.texjp.org/?Latexmk) でコンパイル
- 散らかりがちな生成物を `build` ディレクトリにまとめる
- TeX コードのとなりに PDF をリアルタイム表示
- `SyncTex` による TeX コードと PDF の相互ジャンプ
- VSCode Vim を使って vim キーバインドで編集 (オプション)

<!--more-->

## 環境構築

### インストール

次のリンクにしたがってインストールしてください。

- [TexLive](https://texwiki.texjp.org/?TeX%20Live#w628bee6)
- [Microsoft Visual Studio Code](https://code.visualstudio.com/)

### 拡張機能の追加

以下の VSCode 拡張機能をインストールしましょう。

- LaTeX Workshop
- Vim (オプション)

サイドバーの拡張機能で検索してインストールできます。

### VSCode の設定

デフォルトの設定ではなぜか TeX のコンパイルが通らなかったので、以下の設定を行います。

コマンドパレット `Ctrl+Shift+P` に `open settings json` などと入力して、
`Preferences: Open Settings (JSON)` を選び、設定ファイルに以下の内容を追加します。

```js
// settings.json
{
    // 以下を追記
    // ビルドコマンド
    "latex-workshop.latex.tools": [
        {
            "name": "latexmk",
            "command": "latexmk",
            "args": [
                "-synctex=1",
                "-interaction=nonstopmode",
                "-file-line-error",
                "-outdir=%OUTDIR%",
                "%DOC%"
            ],
            "env": {}
        }
    ],
    // .latexmkrc に書かれたディレクトリに設定すること
    "latex-workshop.latex.outDir": "%DIR%/build",
    // Viewer 関係の設定
    "latex-workshop.view.pdf.viewer": "tab",
    "latex-workshop.view.pdf.zoom": "page-width",
}
```

### キーボードショートカットの追加

コマンドパレット `Ctrl+Shift+P` で
`Preferences: Open Keyboard Shortcuts File` とタイプすると開かれる
`keybindings.json` に以下の内容を追記します。

```js
// keybindings.json
[
    {
        "key": "ctrl+alt+b",
        "command": "latex-workshop.build",
        "when": "resourceLangId == latex"
    },
    {
        "key": "ctrl+alt+c",
        "command": "latex-workshop.clean",
        "when": "resourceLangId == latex"
    },
    {
        "key": "ctrl+alt+s",
        "command": "latex-workshop.synctex",
        "when": "resourceLangId == latex"
    },
]
```

ビルド、クリーン、シンクのショートカットを追加しました。

なお、他のショートカットと干渉しないように、
TeX ファイルを編集中ときだけ適用されるようにしています。

### .latexmkrc の追加

TeX には platex や lualatex など様々なコマンドがありますが、エディタのビルド設定を変更してしまうと、コマンドが違うプロジェクトごとにいちいち設定を変えなければならなくなります。

それを解決するために、[latexmk](https://texwiki.texjp.org/?Latexmk) というビルドコマンドがあります。

tex ファイルと同じディレクトリに `.latexmkrc` という設定ファイルを置くと、そのファイルに書かれたビルドコマンドでビルドしてくれるので、エディタ側の設定を変更する必要がなくなります。

また、コンパイル時に散らかりがちな中間生成物を `build` ディレクトリにまとめる処理も書かれています。

ダウンロード: [.latexmkrc](.latexmkrc)

```perl
#!/usr/bin/env perl
# file          .latexmkrc
# author        Ryotaro Onuki
# created_at    2019.01.25
# modified_at   2019.02.05

## latex commands
$latex            = 'platex -synctex=1 -halt-on-error';
$latex_silent     = 'platex -synctex=1 -halt-on-error -interaction=batchmode';
$bibtex           = 'pbibtex -kanji=utf8';
$dvipdf           = 'dvipdfmx %O -o %D %S';
$makeindex        = 'mendex %O -o %D %S';
$max_repeat       = 5;

## pdf mode
$pdf_mode         = 3; # 0: none, 1: pdflatex, 2: ps2pdf, 3: dvipdfmx

## output directory
$aux_dir          = "build/";
$out_dir          = "build/";
```

## 使い方

### ビルド

デフォルトでは TeX ファイルを保存すると自動でビルドされます。

画像を変更したときなど、強制的にビルドしたいときは、コマンドパレットで `Latex Build` とするか、
上記で設定したキーボードショートカット `Ctrl+Alt+B` を押します。

### PDF の表示

`Ctrl+Alt+V` で PDF が表示されます。

### SyncTex

SyncTex とは、TeX のソースファイルと PDF でカーソルの位置を同期する機能です。

VSCode の PDF ビューワは SyncTex に対応しているので、TeX ファイルと PDF ファイルの該当箇所を行き来することができます。

#### PDF -> TeX

PDF 上の文字に対し、Ctrl を押しながらマウスでクリックします。
すると、TeX ソースファイルのその部分にジャンプします。

#### TeX -> PDF

コマンドパレット `Ctrl+Shift+P` で `SyncTex` とタイプするか、
上記で設定した `Ctrl+Alt+S` を押します。
すると、PDF 上の該当箇所にジャンプし、ハイライトされます。

### コード補完

単語の一部を入力すると、候補が表示されます。

ESC などで候補を閉じてしまって、もう一度表示したいときは、`Ctrl+Space` で再表示できます。

### コード整形

コマンドパレット `Ctrl+Shift+P` で `Format` とタイプするか、
ショートカットキー `Shift+Alt+F` でインデントなどがきれいに揃います。

また、表や align の&もそろって表示され、とても見やすくなります。

```tex
\begin{align*}
    \dot{x}      & = \cos \theta u_1          \\
    \dot{y}      & = \sin \theta u_1          \\
    \dot{\theta} & = \frac{1}{l}\tan \phi u_1 \\
    \dot{\phi}   & = u_2
\end{align*}
```

### ビルドに失敗したら？

とりあえず、中間生成物をすべて消去して、クリーンビルドを試しましょう。

## その他

VSCode の最大の魅力は `F1` または `Ctrl+Shift+P`
を押して実行できる **コマンドパレット** だと思います。

コマンドパレットで `latex` などと入力すると、
便利なコマンドの候補がいろいろ出てきますので、是非いろいろ試してみてください！

## まとめ

TeX の文章を書くとき、一番大事なのは書きやすさではなく **書く内容** です。

しかしながら、書く内容に専念するためにも心地よい TeX 環境があるといいですよね！

もし時間があったら、VSCode に移行してみてはいかがでしょうか。
