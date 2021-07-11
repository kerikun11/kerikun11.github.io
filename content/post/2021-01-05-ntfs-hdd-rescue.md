---
title: "アクセスできなくなったHDDのデータを救出した記録"
date: "2021-01-05T18:49:57+09:00"
categories:
  - "備忘録"
tags:
  - "HDD"
  - "Linux"
  - "Windows"
---

## はじめに

こんにちは。けりです。

年末にひとつ騒動がありました。

親がポータブルHDDにデータをコピーしていたところ、急に転送速度が0になってそれっきりHDDにアクセスできなくなってしまったというのです。

<!--more-->

### Windows PC からはアクセスできない

症状は結構深刻で、Windows の PC に接続するとエクスプローラがフリーズしてしまうという始末です。

デバイスマネージャーには一応表示されていましたが、コンピュータの管理画面でみてもディスクは表示されていませんでした。

### データを救出したい

そのHDDにしか保存されていないデータがあるらしく、どうにかデータだけでも救出できないかということでいろいろ試してみました。

その結果、(おそらく)全てのデータを復元できたので、備忘録としてメモを残しておきます。

## 故障したHDD

今回問題となったHDDは `Western Digital` 製の4TBポータブルHDDです。

型番は `WD Elements Portable WDBU6Y0040BBK-WESN` です。

価格.com でも上位の HDD なので壊れるとは思ってもいませんでした。

HDDは購入時のままで使用していたので、フォーマット形式は NTFS です。  
(フォーマット形式も認識できなかったので、この情報はとても重要でした)

## 必要なもの

データの復旧にあたって、以下のものを使用しました。

- 故障した 4TB の HDD
- 故障した 4TB より大きい別の HDD 2つ
  - 1つでもできるかもしれないが、2つあると安全
  - 1つは故障HDDのバックアップイメージの保存、もう1つは作業用ディスクとして修復に使用
- Linux PC
  - 今回は Arch Linux を使用、おそらく Ubuntu でも可。
- Windows PC
  - Windows 10 を使用

各 Linux コマンドのインストール方法は Linux のディストリビューションによって異なるので解説しません。

## 復旧作業のログ

今回は以下のような手順で解析およびデータの救出を行いました。

手順はかなり長いので、読み飛ばしたい方は[手順のまとめ](#手順のまとめ)へどうぞ。

### Linux PC に HDD を接続する

Windows PC ではアクセスすらできなかったので、手持ちの `Arch Linux` の PC で解析を行いました。

Linux PC に HDD を接続したところ、デバイス `/dev/sda` として認識されました。

確認コマンドは以下のとおりです。

```log
$ lsblk

NAME        MAJ:MIN RM   SIZE RO TYPE MOUNTPOINT
sda           8:0    0   3.6T  0 disk 
nvme0n1     259:0    0 931.5G  0 disk 
├─nvme0n1p1 259:1    0   300M  0 part /boot/efi
├─nvme0n1p2 259:2    0 914.4G  0 part /
└─nvme0n1p3 259:3    0  16.8G  0 part [SWAP]
```

`nvme0n1` が PC のメインの SSD で、 `sda` が故障した HDD です。

### Linux の gdisk コマンドで GPT パーティションを解析

まずは Linux の `gdisk` コマンドでディスクのパーティションの状態をチェックします。

```log
$ sudo gdisk /dev/sda

GPT fdisk (gdisk) version 1.0.5

Warning! Read error 0! Misbehavior now likely!
Caution! After loading partitions, the CRC doesn't check out!
Warning! Main partition table CRC mismatch! Loaded backup partition table
instead of main partition table!

Warning! One or more CRCs don't match. You should repair the disk!
Main header: OK
Backup header: OK
Main partition table: ERROR
Backup partition table: OK

Partition table scan:
  MBR: protective
  BSD: not present
  APM: not present
  GPT: damaged

****************************************************************************
Caution: Found protective or hybrid MBR and corrupt GPT. Using GPT, but disk
verification and recovery are STRONGLY recommended.
****************************************************************************
```

大事な部分を抜き出すと下記のとおりです。

```
Partition table scan:
  MBR: protective
  BSD: not present
  APM: not present
  GPT: damaged
```

```
Main header: OK
Backup header: OK
Main partition table: ERROR
Backup partition table: OK
```

GPT パーティションテーブルのうち、 `Main partition table` が破損していることがわかります。

幸いなことに、GPTパーティションテーブルはディスクの先頭と末尾の2箇所に保存されていて、 `Backup partition table` は無事なようです。

`gdisk` コマンドで修復をするのですが、破損したディスクを直接いじるのは危険なので、クローンHDDを作成してそちらで作業を行うことにしました。

### ディスクイメージのバックアップ

Linux の `ddrescue` コマンドで HDD をまるごとバックアップします。

`ddrescue` コマンドは、故障したHDDからいろいろな読み出し方を試みて最大限の情報を読み取ろうと努力する優秀なコマンドです。

`ddrescue` コマンドの引数として、故障したデバイス `/dev/sda` 、ディスクイメージの保存先 `*.img` 、 マップファイルの保存先 `*.map` を与えます。

マップファイルはコピーを中断したり再開するときに必要となるので、重要です。

ディスクイメージの保存先は、外付けの別の HDD になります。

今回は 4TB の HDD のバックアップだったので、8TB の HDD を使用しました。

コマンドを実行すると以下のように途中経過が表示されます。

```log
$ sudo ddrescue /dev/sda /mnt/another_8tb_hdd/wd_elements.img ddrescue_hdd.map

GNU ddrescue 1.25
Press Ctrl-C to interrupt
     ipos:  931266 kB, non-trimmed:    49152 B,  current rate:  68091 kB/s
     opos:  931266 kB, non-scraped:        0 B,  average rate:  19373 kB/s
non-tried:    3999 GB,  bad-sector:        0 B,    error rate:       0 B/s
  rescued:  891174 kB,   bad areas:        0,        run time:         45s
pct rescued:    0.02%, read errors:        1,  remaining time:     12h 28m
                              time since last successful read:           0
Copying non-tried blocks... Pass 1 (forwards)
```

今回、 HDD はやはり故障していたようなので、最終的に 99.98% でそれ以上コピーが進まなくなってしまいました。

`time since last successful read` がどんどん大きくなってこれ以上進まないなと思ったら `Ctrl-C` で中断します。

4TB のバックアップに、2日以上かかりました。

### バックアップ中に起きたトラブル

実は、 `ddrescue` でディスクイメージをバックアップしている際に別のトラブルが発生しました。

PC の別の USB ポートにスマホを接続したところ、USB の電源供給量を超過したらしく、HDD の電源が切れてしまいました...

さすがに別の USB ポートなら大丈夫だと思っていたのですが、ノートPCの電源は思ったより非力だったようです。

つまり、コピー中のHDDをブッち抜いたわけです...

その結果、 `ddrescue` コマンドでバックアップを再開しようとしても以下のように `Input/output Error` となって再開できなくなってしまいました。

```log
$ sudo ddrescue /dev/sda wd_elements.img ddrescue_hdd.map

GNU ddrescue 1.25

Press Ctrl-C to interrupt
Initial status (read from mapfile)
rescued: 3176 GB, tried: 3776 kB, bad-sector: 0 B, bad areas: 0

Current status
     ipos:    3178 GB, non-trimmed:    3776 kB,  current rate:       0 B/s
     opos:    3178 GB, non-scraped:        0 B,  average rate:       0 B/s
non-tried:  824395 MB,  bad-sector:        0 B,    error rate:       0 B/s
  rescued:    3176 GB,   bad areas:        0,        run time:          0s
pct rescued:   79.39%, read errors:        0,  remaining time:         n/a
                              time since last successful read:         n/a
Copying non-tried blocks... Pass 1 (forwards)
ddrescue: Write error: Input/output error
```

正直、もう詰んだと思いましたが、友人の助けを借りながら Linux カーネルのログを見ながら原因を調査したところ、
バックアップ用の 8TB の HDD の書き込みエラーが原因らしいということがわかりました。

データの書き込み中に引っこ抜いたため、NTFS論理が壊れてしまったようです。

そこで 8TB の HDD を一旦 Window PC に接続して修復を行いました。

ファイルシステム NTFS の修復アルゴリズムは Microsoft が非公開にしているので原則として Windows PC でしか実行することができません。

Windows PC に 8TB の HDD を接続して、ディスクのプロパティからエラーチェック、自動修復を行いました。

幸い、正常に修復が完了して `ddrescue` を再開することができました。

### クローンディスクの作成

`ddrescue` コマンドでディスクイメージ `*.img` にバックアップすることができたので、これをまた別の 4TB 以上の HDD に焼いて、故障したHDDのクローンディスクを作成します。

手持ちの別の 4TB の HDD が、 故障した 4TB の HDD よりも若干サイズが大きかったので、それを使用することができました。

クローンHDD は `/dev/sdc` として認識されているものとします。

下記のコマンドで故障したHDDのディスクイメージを別のHDDに焼きます。

```log
$ sudo dd if=wd_elements.img of=/dev/sdc status=progress
```

4TBの書き込みなので、1日くらいかかりました。

### パーティションテーブルの修復

ここからは上記で作成したクローンディスクに対して修復作業を行います。

まず `gdisk` コマンドでパーティションテーブルを修復します。

```log
$ sudo gdisk /dev/sdc

GPT fdisk (gdisk) version 1.0.5

Warning! Read error 0! Misbehavior now likely!
Caution! After loading partitions, the CRC doesn't check out!
Warning! Main partition table CRC mismatch! Loaded backup partition table
instead of main partition table!

Warning! One or more CRCs don't match. You should repair the disk!
Main header: OK
Backup header: OK
Main partition table: ERROR
Backup partition table: OK

Partition table scan:
  MBR: protective
  BSD: not present
  APM: not present
  GPT: damaged

****************************************************************************
Caution: Found protective or hybrid MBR and corrupt GPT. Using GPT, but disk
verification and recovery are STRONGLY recommended.
****************************************************************************

Command (? for help): ?
b	back up GPT data to a file
c	change a partition's name
d	delete a partition
i	show detailed information on a partition
l	list known partition types
n	add a new partition
o	create a new empty GUID partition table (GPT)
p	print the partition table
q	quit without saving changes
r	recovery and transformation options (experts only)
s	sort partitions
t	change a partition's type code
v	verify disk
w	write table to disk and exit
x	extra functionality (experts only)
?	print this menu

Command (? for help): r

Recovery/transformation command (? for help): ?
b        use backup GPT header (rebuilding main)
c        load backup partition table from disk (rebuilding main)
d        use main GPT header (rebuilding backup)
e        load main partition table from disk (rebuilding backup)
f        load MBR and build fresh GPT from it
g        convert GPT into MBR and exit
h        make hybrid MBR
i        show detailed information on a partition
l        load partition data from a backup file
m        return to main menu
o        print protective MBR data
p        print the partition table
q        quit without saving changes
t        transform BSD disklabel partition
v        verify disk
w        write table to disk and exit
x        extra functionality (experts only)
?        print this menu

Recovery/transformation command (? for help): c
Warning! This will probably do weird things if you've converted an MBR to
GPT form and haven't yet saved the GPT! Proceed? (Y/N): Y

Recovery/transformation command (? for help): w

Final checks complete. About to write GPT data. THIS WILL OVERWRITE EXISTING
PARTITIONS!!

Do you want to proceed? (Y/N): Y
OK; writing new GUID partition table (GPT) to /dev/sdc.
The operation has completed successfully.
```

基本的には案内に従って、バックアップパーティションテーブルからメインパーティションテーブルの復元を選択します。
最後に変更をディスクに書き込めば完了です。

ディスクを接続しなおせば、パーティション `/dev/sdc1` が認識されているはずです。

```log
$ lsblk

NAME        MAJ:MIN RM   SIZE RO TYPE MOUNTPOINT
sda           8:0    0   3.6T  0 disk 
sdb           8:0    0   7.3T  0 disk 
├─sdb1        8:1    0    16M  0 part 
└─sdb2        8:2    0   7.3T  0 part /mnt/another_8tb_hdd
sdc           8:0    0   3.6T  0 disk 
├─sdc1        8:1    0   3.6T  0 part 
nvme0n1     259:0    0 931.5G  0 disk 
├─nvme0n1p1 259:1    0   300M  0 part /boot/efi
├─nvme0n1p2 259:2    0 914.4G  0 part /
└─nvme0n1p3 259:3    0  16.8G  0 part [SWAP]
```

### NTFS としてマウントしてみる→失敗

パーティションテーブルが修復できて、パーティションが認識できたので、
運が良ければこのまま NTFS としてマウントできるのですが、
今回の場合はパーティション内も損傷していたらしく、
まだデータの読み出しはできませんでした。

```log
$ sudo mkdir /mnt/data
$ sudo mount -t ntfs /dev/sdc1 /mnt/data

ntfs_mst_post_read_fixup_warn: magic: 0x00000000  size: 1024   usa_ofs: 0  usa_count: 0: 無効な引数です
Record 0 has no FILE magic (0x0)
Failed to load $MFT: 入力/出力エラーです
Failed to mount '/dev/sdc1': 入力/出力エラーです
NTFS is either inconsistent, or there is a hardware fault, or it's a
SoftRAID/FakeRAID hardware. In the first case run chkdsk /f on Windows
then reboot into Windows twice. The usage of the /f parameter is very
important! If the device is a SoftRAID/FakeRAID then first activate
it and mount a different device under the /dev/mapper/ directory, (e.g.
/dev/mapper/nvidia_eahaabcc1). Please see the 'dmraid' documentation
for more details.
```

上記のメッセージにあるように、 Windows の PC で `chkdsk` コマンドを実行してみましたが、下記のようにエラーになりました。

```log
PS C:\WINDOWS\system32> chkdsk d: /f
ファイル システムの種類は NTFS です。
ボリュームとバージョンの判断できません。CHKDSK を中止します。
PS C:\WINDOWS\system32>
```

どうやら NTFS のブートセクタが破損してしまっていて、この方法では修復できないようです。

ちなみに Linux の `ntfsfix` コマンドも試しましたが、だめでした。

```log
$ sudo ntfsfix /dev/sdc1

Mounting volume... NTFS signature is missing.
FAILED
Attempting to correct errors... NTFS signature is missing.
FAILED
Failed to startup volume: Invalid argument
NTFS signature is missing.
Trying the alternate boot sector
Unrecoverable error
Volume is corrupt. You should run chkdsk.
```

### testdisk で NTFS のブートセクタを再構築する

NTFS の ブートセクタを再構築するには Linux の `testdisk` コマンドを使用します。

```sh
$ sudo testdisk /dev/sdc1
```

基本的にはガイドに従って操作します。

```
TestDisk 7.1, Data Recovery Utility, July 2019
Christophe GRENIER <grenier@cgsecurity.org>
https://www.cgsecurity.org

  TestDisk is free software, and comes with ABSOLUTELY NO WARRANTY.

Select a media (use Arrow keys, then press Enter):
>Disk /dev/sdc1 - 4000 GB / 3725 GiB

>[Proceed ]  [  Quit  ]

Note: Disk capacity must be correctly detected for a successful recovery.
If a disk listed above has an incorrect size, check HD jumper settings and BIOS
detection, and install the latest OS patches and disk drivers.
```

↑選択しているパーティションを確認し、 `Proceed` で次に進みます。

```
Disk /dev/sdc1 - 4000 GB / 3725 GiB

Please select the partition table type, press Enter when done.
 [Intel  ] Intel/PC partition
 [EFI GPT] EFI GPT partition map (Mac i386, some x86_64...)
 [Humax  ] Humax partition table
 [Mac    ] Apple partition map (legacy)
>[None   ] Non partitioned media
 [Sun    ] Sun Solaris partition
 [XBox   ] XBox partition
 [Return ] Return to disk selection

Hint: None partition table type has been detected.
```

↑ 形式は `None` を選びます。

```
Disk /dev/sdc1 - 4000 GB / 3725 GiB - 7813965824 sectors

     Partition                  Start        End    Size in sectors
>   P NTFS                           0 7813965823 7813965824 [Elements-4TB]

>[  Type  ]  [  Boot  ]  [  List  ]  [Undelete]  [Image Creation]  [  Quit  ]
              Change type, this setting will not be saved on disk
```

↑ もし Partition が NTFS になっていなければ、 `Type` を選択して、 `NTFS` を指定します。

```
Disk /dev/sdc1 - 4000 GB / 3725 GiB - 7813965824 sectors

     Partition                  Start        End    Size in sectors
>   P NTFS                           0 7813965823 7813965824 [Elements-4TB]

 [  Type  ] >[  Boot  ]  [  List  ]  [Undelete]  [Image Creation]  [  Quit  ]
                              Boot sector recovery
```

↑ Partition が `NTFS` であることを確認して `Boot` を選択します。

```
Disk /dev/sdc1 - 4000 GB / 3725 GiB - 7813965824 sectors

     Partition                  Start        End    Size in sectors
>   P NTFS                           0 7813965823 7813965824 [Elements-4TB]

Boot sector
Status: Bad

Backup boot sector
Status: Bad

Sectors are not identical.

A valid NTFS Boot sector must be present in order to access
any data; even if the partition is not bootable.

 [  Quit  ] >[Rebuild BS]  [  Dump  ]
                              Rebuild boot sector
```

↑ やはり NTFS ブートセクタが不正なようです。 `Rebuild BS` を選択して、NTFS のブートセクタの再構築を選択します。

```
Disk /dev/sdc1 - 4000 GB / 3725 GiB - 7813965824 sectors
     Partition                  Start        End    Size in sectors
   P NTFS                           0 7813965823 7813965824 [Elements-4TB]

filesystem size           7813965824 7813965824
sectors_per_cluster       8 8
mft_lcn                   786432 786432
mftmirr_lcn               2 2
clusters_per_mft_record   -10 -10
clusters_per_index_record 1 1
Extrapolated boot sector and current boot sector are different.

 [  Dump  ]  [  List  ] >[ Write  ]  [  Quit  ]
                                   Write boot
```

↑ `Write` を選択すると、再構築を開始します。

最終確認画面が出るので、`Y` を選択します。

```
Disk /dev/sdc1 - 4000 GB / 3725 GiB - 7813965824 sectors
     Partition                  Start        End    Size in sectors
   P NTFS                           0 7813965823 7813965824 [Elements-4TB]

Boot sector
Status: OK

Backup boot sector
Status: OK

Sectors are identical.

A valid NTFS Boot sector must be present in order to access
any data; even if the partition is not bootable.

>[  Quit  ]  [  List  ]  [Rebuild BS]  [Repair MFT]  [  Dump  ]
                            Return to Advanced menu
```

↑ 再構築が完了しました。 `Quit` を何回か押して `testdisk` を終了します。

### フォーマット形式がわからない場合

フォーマット形式が `NTFS` である確証がない場合、 `testdisk` を使用してディスクのデータからフォーマット形式を推定することができます。

`testdisk` の案内のうち、 `Analyse` を選択してパーティション形式を推定します。

```
Disk /dev/sdc1 - 4000 GB / 3725 GiB
     CHS 48000 4 16 - sector size=512

>[ Analyse  ] Analyse current partition structure and search for lost partition
 [ Advanced ] Filesystem Utils
 [ Geometry ] Change disk geometry
 [ Options  ] Modify options
 [ MBR Code ] Write TestDisk MBR code to first sector
 [ Delete   ] Delete all data in the partition table
 [ Quit     ] Return to disk selection

Note: Correct disk geometry is required for a successful recovery. 'Analyse'
process may give some warnings if it thinks the logical geometry is mismatched.
```

しかし、今回のHDDの故障の場合は NTFS と認識されなかったので、手動で `NTFS` を設定しました。


### Windows PC で NTFS ファイルシステムの修復を行う

Linux の `testdisk` コマンドで NTFS のブートセクタを再構築できたので、今度は Windows の PC で NTFS論理 の修復を行います。

管理者権限で PowerShell を起動して `chkdsk` コマンドを実行します。

以下は、接続したクローンHDDを `Dドライブ` として認識した場合の例です。

```
PS C:\WINDOWS\system32> chkdsk /f D:

ファイル システムの種類は NTFS です。
ボリューム ラベルは Elements-4TB です。

ステージ 1: 基本のファイル システム構造を検査しています ...
  400384 個のファイル レコードが処理されました。
ファイルの検査を完了しました。
 フェーズの継続時間 (ファイル レコードの検査): 3.77 秒。
孤立ファイル レコード セグメント 1B250 を削除します。
  3 個の大きなファイル レコードが処理されました。
 フェーズの継続時間 (孤立ファイル レコードの回復): 0.00 ミリ秒。
  0 個の問題のあるファイル レコードが処理されました。
 フェーズの継続時間 (不良ファイル レコードの検査): 0.34 ミリ秒。

ステージ 2: ファイル名リンケージを検査しています ...
ファイル レコード　セグメント 5 の正しくない情報を修復しています。
ファイル レコード　セグメント B の正しくない情報を修復しています。
ファイル E1F のインデックス $I30 のエラーを修復します。
CHKDSK は、ファイル E1F のインデックス $I30 のビットマップに割り当て済みとしてマークされている空き領域を検出しました。
ファイル E1F のインデックス $I30 を並べ替えます。
...
  405108 個のインデックス エントリが処理されました。
インデックスの検査を完了しました。
 フェーズの継続時間 (インデックスの検査): 31.02 秒。
CHKDSK は新しいルート ディレクトリを作成します。
CHKDSK は、元のディレクトリに再接続させるために、インデックスのないファイルをスキャンしています。
孤立したファイル $MFT (0) をディレクトリ ファイル 5 に回復します。
孤立したファイル $MFTMirr (1) をディレクトリ ファイル 5 に回復します。
孤立したファイル $LogFile (2) をディレクトリ ファイル 5 に回復します。
孤立したファイル $Volume (3) をディレクトリ ファイル 5 に回復します。
孤立したファイル $AttrDef (4) をディレクトリ ファイル 5 に回復します。
ファイル レコード　セグメント 5 の正しくない情報を修復しています。
孤立したファイル . (5) をディレクトリ ファイル 5 に回復します。
孤立したファイル $Bitmap (6) をディレクトリ ファイル 5 に回復します。
孤立したファイル $Boot (7) をディレクトリ ファイル 5 に回復します。
孤立したファイル $BadClus (8) をディレクトリ ファイル 5 に回復します。
孤立したファイル $Secure (9) をディレクトリ ファイル 5 に回復します。
孤立回復に関する他のメッセージをスキップします。
  70342 個のインデックスなしファイルがスキャンされました。
  154 個のインデックスのないファイルが元のディレクトリに回復されました。
 フェーズの継続時間 (孤立した再接続): 0.00 ミリ秒。
CHKDSK は、インデックスのない残りのファイルを回復しています。
  70188 個のインデックスのないファイルが lost and found に回復されました。
    lost and found は \found.000 にあります
 フェーズの継続時間 (孤立を lost and found に回復): 0.00 ミリ秒。
ファイル B のインデックス $I30 を作成しています。
オブジェクト ID ファイルを作成しています。
ファイル B のインデックス $I30 へインデックス エントリを挿入しています。
ファイル 26 のインデックス $O を作成しています。
ファイル 26 のインデックス $O へインデックス エントリを挿入しています。
...
  2228 個の再解析レコードが処理されました。
ファイル 26 のインデックス $O へインデックス エントリを挿入しています。
再解析ポイント ファイルを作成しています。
ファイル B のインデックス $I30 へインデックス エントリを挿入しています。
ファイル 27 のインデックス $R を作成しています。
 フェーズの継続時間 (再解析ポイントとオブジェクト ID の検査): 20.96 秒。
クォータ ファイルを作成しています。
ファイル B のインデックス $I30 へインデックス エントリを挿入しています。
ファイル 28 のインデックス $O を作成しています。
ファイル 28 のインデックス $Q を作成しています。
ファイル 28 のインデックス $Q に既定のクォータ レコードを挿入しています。

ステージ 3: セキュリティ記述子を検査しています ...
ファイル 9 のインデックス $SII を作成しています。
ファイル 9 のインデックス $SDH を作成しています。
ファイル 3 の無効なセキュリティ ID を既定のセキュリティ ID に置き換えています。
ファイル 1BFAB の無効なセキュリティ ID を既定のセキュリティ ID に置き換えています。
ファイル 1BFAA の無効なセキュリティ ID を既定のセキュリティ ID に置き換えています。
ファイル 1CD22 の無効なセキュリティ ID を既定のセキュリティ ID に置き換えています。
未定義のセキュリティ ID 100 に対する既定のセキュリティ記述子を作成しています。
...
セキュリティ記述子の検査を完了しました。
 フェーズの継続時間 (セキュリティ記述子の検査): 4.81 ミリ秒。
データ属性をファイル 4 に挿入します。
...
  2371 個のデータ ファイルが処理されました。
 フェーズの継続時間 (データ属性の検査): 182.11 ミリ秒。
マスター ファイル テーブル (MFT) のミラーでエラーを修復します。
属性定義テーブル エラーを修復します。
ブート ファイル エラーを修復します。
アッパーケース ファイル エラーを修復します。
不良クラスター ファイル エラーを修復します。
マスター ファイル テーブル (MFT) の BITMAP 属性エラーを修復します。
ボリューム ビットマップ エラーを修復します。

Windows でファイル システムが修正されました。
これ以上の操作は必要ありません。

   3815412 MB           : 全ディスク領域
 261553976 KB : 151114 個のファイル
     63548 KB : 2389 個のインデックス
         0 KB : 不良セクター
    585587 KB : システムで使用中
     65536 KB : ログ ファイルが使用
   3559355 MB           : 使用可能領域

      4096 バイト : アロケーション ユニット サイズ
 976745727 個     : 全アロケーション ユニット
 911194950 個     : 利用可能アロケーション ユニット
合計継続時間: 13.28 分 (797364 ミリ秒)。

PS C:\WINDOWS\system32>
```

### Linux PC に接続してデータを読み取る

Windows PC で NTFS の修復に成功しましたが、そのままではなぜか権限のエラーで読み取りができませんでした。

仕方ないので、クローン HDD を Linux PC に接続しました。

その結果、故障したHDD内にあったデータを無事救出することができました。

もしかすると一部のファイルに欠損があるかもしれませんが、今のところは大丈夫そうです。

## 手順のまとめ

今までの作業の内容をまとめると次のとおりです。

1. Linux の `ddrescue` コマンドでディスクイメージ `*.img` をバックアップする
1. Linux の `dd` コマンドでクローンHDDを作成する
1. Linux の `gdisk` コマンドで GPT パーティションテーブルを復元する
1. Linux の `testdisk` コマンドで NTFS ブートセクタを再構築する
1. Windows の `chkdsk` コマンドで NTFS 論理を修復する
1. Linux 上で HDD をマウントしてデータを読み出す

## 得られた教訓

最後に今回のデータ救出で得られた教訓をいくつか紹介します。

### 1つのパーティションが大きいと解析に時間がかかって辛い

今回、4TBのHDDがパーティション1つで使用されていたため、バックアップや解析など毎回 4TB のデータを扱わなければなりませんでした。

クローンディスクも 4TB 必要で、何かと時間がかかって大変でした。

パーティションをたくさん切る必要はありませんが、現実的な時間でコピーできるサイズのパーティションにしておくと解析がしやすいです。

### クローンディスクを作ってあきらめずにいろいろ試そう

HDDは物理的なディスクなので、たとえ一部のデータが壊れていても大部分のデータは残っています。

あきらめずにいろいろな方法を試してデータの救出を目指しましょう。

ディレクトリ構造が復元できなくても、バイナリからファイル単位で探し出すソフトもあります。

復旧作業を行うときは、まず `ddrescue` でバックアップを行いましょう。

その上でさらにクローンディスクを作成して、クローンディスクに対して復旧作業を行いましょう。

故障したディスクに対して直接いろいろ試すのは危険です。どんどん壊れていく可能性があります。

### データは2つ以上のデバイスにバックアップしよう

HDDもSDDも突然壊れます。

大切なデータは常に2箇所以上にバックアップして置きましょう。

小さなデータであれば、手元とクラウドの2箇所に保存するのがおすすめです。

## おわりに

GPTパーティションだけでなくNTFSのブートセクタまで破損していたのでもう無理かと思いましたが、あきらめずにいろいろ試してなんとか救出することができました。

今回紹介した方法が今後誰かの役に立てれば幸いです。

### 参考文献

- [GNU ddrescue Manual](https://www.gnu.org/software/ddrescue/manual/ddrescue_manual.html#Invoking-ddrescue)
- [dd したWindowsのディスクイメージ（NTFS）をマウントする方法](https://takuya-1st.hatenablog.jp/entry/20101004/1286200142)
- [破損または削除されたNTFSパーティションの回復](https://qastack.jp/ubuntu/775579/recovering-broken-or-deleted-ntfs-partitions)
