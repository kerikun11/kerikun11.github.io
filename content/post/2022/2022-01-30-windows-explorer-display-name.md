---
title: "Windowsのダウンロードフォルダなどの日本語表示名を英語に変更する"
date: "2022-01-30T17:00:00+09:00"
categories:
  - "説明記事"
tags:
  - "Windows"
---

## はじめに

日本語版のWindowsでは、ユーザーフォルダの「ダウンロード」や「ドキュメント」が日本語表記になっている。

しかし、実際のパスを見ると英語表記であることがわかる。  
(例: `C:\Users\your_name\Downloads`)

この記事では表面上の日本語表記をやめて、実際のパスと同じ英語表記に変更する方法を紹介する。

<!--more-->

また、フォルダひとつひとつを設定するのは面倒なので、一括変更するための `PowerShell` コマンド紹介する。

## 表示名の変更方法

まずは個別に表示名を変更する方法を紹介する。

表示名が日本語になっているフォルダには隠しファイル `desktop.ini` が保存されている。

その `desktop.ini` ファイルの中の `LocalizedResourceName` の行をコメントアウトすることで英語表示に戻すことができる。

**例: Downloads/desktop.ini**

変更前:

```ini
[.ShellClassInfo]
LocalizedResourceName=@%SystemRoot%\system32\shell32.dll,-21798
IconResource=%SystemRoot%\system32\imageres.dll,-184
```

変更後:

```ini
[.ShellClassInfo]
;LocalizedResourceName=@%SystemRoot%\system32\shell32.dll,-21798
IconResource=%SystemRoot%\system32\imageres.dll,-184
```

コメントアウト後、エクスプローラーをすべて閉じてから開きなおしたり、PCを再起動したりすると反映される。

## 一括変更

ダウンロードやドキュメントなど、すべての `desktop.ini` をひとつひとつ書き換えるのは面倒なので、一括変更するコマンドを作成した。

PowerShell で下記コードを実行すると、ユーザーフォルダ以下の desktop.ini を検索して自動的にコメントアウトしてくれる。

```ps1
Get-ChildItem $env:userprofile -Depth 2 -filter desktop.ini -Hidden -ErrorAction silentlycontinue | ForEach-Object {
    $file = $_.FullName
    echo "  File: $file"
    $LRN = 'LocalizedResourceName'
    $(Get-Content $file) -replace "^$LRN", ";$LRN" | Set-Content $file -force
}
```

実行結果:

```log
PS C:\Users\your_name> Get-ChildItem $env:userprofile -Depth 2 -filter desktop.ini -Hidden -ErrorAction silentlycontinue | ForEach-Object {
>>     $file = $_.FullName
>>     echo "  File: $file"
>>     $LRN = 'LocalizedResourceName'
>>     $(Get-Content $file) -replace "^$LRN", ";$LRN" | Set-Content $file -force
>> }
  File: C:\Users\your_name\Contacts\desktop.ini
  File: C:\Users\your_name\Downloads\desktop.ini
  File: C:\Users\your_name\Dropbox\desktop.ini
  File: C:\Users\your_name\Favorites\desktop.ini
  File: C:\Users\your_name\Favorites\Links\desktop.ini
  File: C:\Users\your_name\Links\desktop.ini
  File: C:\Users\your_name\Music\desktop.ini
  File: C:\Users\your_name\OneDrive\desktop.ini
  File: C:\Users\your_name\OneDrive\Desktop\desktop.ini
  File: C:\Users\your_name\OneDrive\Documents\desktop.ini
  File: C:\Users\your_name\OneDrive\Pictures\desktop.ini
  File: C:\Users\your_name\Saved Games\desktop.ini
  File: C:\Users\your_name\Searches\desktop.ini
  File: C:\Users\your_name\Videos\desktop.ini
```

日本語表記に戻すには、PowerShell で下記コードを実行する。

```ps1
Get-ChildItem $env:userprofile -Depth 2 -filter desktop.ini -Hidden -ErrorAction silentlycontinue | ForEach-Object {
    $file = $_.FullName
    echo "  File: $file"
    $LRN = 'LocalizedResourceName'
    $(Get-Content $file) -replace ";$LRN", "$LRN" | Set-Content $file -force
}
```

## まとめ

Windows のユーザーフォルダの日本語表示名を本来の英語表記に変更する方法を紹介した。

これでキーボード入力でのディレクトリ選択がしやすくなった。
