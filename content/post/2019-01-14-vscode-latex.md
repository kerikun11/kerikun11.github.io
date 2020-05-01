---
date: "2019-01-14T10:00:00+09:00"
title: "VSCodeでTeXを書こう"
categories:
  - "説明記事"
tags:
  - "VSCode"
  - "Latex"
spotlight: "true"
---

## 概要

今回は私が使っているTeXのエディタ環境を紹介します．

注目機能は以下の通りです．

- コード補完
- コード整形
- 環境に依存しにくい[.latexmk](https://texwiki.texjp.org/?Latexmk)でコンパイル
- 散らかりがちな生成物を `build` ディレクトリにまとめる
- TeXコードのとなりにPDFを表示
- `SyncTex`によりTeXコードとPDFの相互ジャンプ
- VSCode Vim を使ってvimキーバインド (オプション)

<!--more-->

## 環境構築

### インストール

次のリンクにしたがってインストールしてください．

- [TexLive](https://texwiki.texjp.org/?TeX%20Live#w628bee6)
- [Microsoft Visual Studio Code](https://code.visualstudio.com/)

### 拡張機能の追加

以下のVSCode拡張機能をインストールしましょう．

- LaTeX Workshop
- Vim (オプション)

サイドバーの拡張機能で検索してインストールできます．

### VSCodeの設定

デフォルトの設定ではなぜかTeXのコンパイルが通らなかったので，以下の設定を行います．

コマンドパレット`Ctrl+Shift+P`に`open settings json`などと入力して，
`Preferences: Open Settings (JSON)`を選び，設定ファイルに
以下の内容を追加します．

```js
{
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
    // Viewer関係
    "latex-workshop.view.pdf.viewer": "tab",
    "latex-workshop.view.pdf.zoom": "page-width",
}
```

### キーボードショートカットの追加

コマンドパレット`Ctrl+Shift+P`で
`Preferences: Open Keyboard Shortcuts File`とタイプすると開かれる
`keybindings.json`に以下の内容を追記します．

```json
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
    }
]
```

ビルド，クリーン，シンクのショートカットを追加しました．

なお，他のショートカットと干渉しないように，
TeXファイルを編集中ときだけ適用されるようにしています．

### .latexmkrc の追加

TeXにはplatexやlualatexなど様々なコマンドがありますが，エディタのビルド設定を変更してしまうと，コマンドが違うプロジェクトごとにいちいち設定を変えなければならなくなります．

それを解決するために，[latexmk](https://texwiki.texjp.org/?Latexmk)というビルドコマンドがあります．

texファイルと同じディレクトリに`.latexmkrc`という設定ファイルを置くと，そのファイルに書かれたビルドコマンドでビルドしてくれるので，エディタ側の設定を変更する必要がなくなります．

また，コンパイル時に散らかりがちな中間生成物を `build` ディレクトリにまとめる処理も書かれています．

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

デフォルトではTeXファイルを保存すると自動でビルドされます．

画像を変更したときなど，強制的にビルドしたいときは，コマンドパレットで`Latex Build`とするか，
上記で設定したキーボードショートカット`Ctrl+Alt+B`を押します．

### PDFの表示

`Ctrl+Alt+V` でPDFが表示されます．

### SyncTex

SyncTexとは，TeXのソースファイルとPDFでカーソルの位置を同期する機能です．

VSCodeのPDFビューワはSyncTexに対応しているので，TeXファイルとPDFファイルの該当箇所を行き来することができます．

#### PDF -> TeX

PDF上の文字に対し，Ctrlを押しながらマウスでクリックします．
すると，TeXソースファイルのその部分にジャンプします．

#### TeX -> PDF

コマンドパレット`Ctrl+Shift+P`で`SyncTex`とタイプするか，
上記で設定した`Ctrl+Alt+S`を押します．
すると，PDF上の該当箇所にジャンプし，ハイライトされます．

### コード補完

単語の一部を入力すると，候補が表示されます．

ESCなどで候補を閉じてしまって，もう一度表示したいときは，`Ctrl+Space`で再表示できます．

### コード整形

コマンドパレット`Ctrl+Shift+P`で`Format`とタイプするか，
ショートカットキー`Shift+Alt+F`でインデントなどがきれいに揃います．

また，表やalignの&もそろって表示され，とても見やすくなります．

```tex
\begin{align*}
    \dot{x}      & = \cos \theta u_1          \\
    \dot{y}      & = \sin \theta u_1          \\
    \dot{\theta} & = \frac{1}{l}\tan \phi u_1 \\
    \dot{\phi}   & = u_2
\end{align*}
```

### ビルドに失敗したら？

とりあえず，中間生成物をすべて消去して，クリーンビルドを試しましょう．

## その他

VSCode の最大の魅力は
`F1`または
`Ctrl+Shift+P`
を押して実行できる
コマンドパレット
だと思います．

コマンドパレットで`latex`などと入力すると，コマンドの候補がいろいろ出てきますので，是非いろいろ試してみてください！

## まとめ

TeXの文章を書くとき，一番大事なのは書きやすさではなく，書く内容です．

しかし，書く内容に専念するためにも，心地よいTeX環境があるといいですよね！

もし時間があったら，VSCodeに移行してみてはいかがでしょうか．
