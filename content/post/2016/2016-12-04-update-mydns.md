---
date: "2016-12-04"
title: "CrontabでMyDNS.jpのIP通知"
categories:
  - "備忘録"
tags:
 - "サーバー"
 - "Crontab"
 - "DDNS"
---

## 概要

家のIPアドレスは固定ではないのでDDNSで追いかける。

<!--more-->

## 通知スクリプト

### mydns.sh

たったこれだけ。

~~~sh
#!/bin/sh
echo "MyDNS IP UPDATE"
wget -O- 'http://mydns012345:XXXXXXXXXXX@www.mydns.jp/login.html'
echo "end"
~~~

実行権限をつけるのをお忘れなく。

## Crontabの設定

~~~sh
$ crontab -e
~~~

5分ごとに通知する。

~~~
# Edit this file to introduce tasks to be run by cron.
#
# Each task to run has to be defined through a single line
# indicating with different fields when the task will be run
# and what command to run for the task
#
# To define the time you can provide concrete values for
# minute (m), hour (h), day of month (dom), month (mon),
# and day of week (dow) or use '*' in these fields (for 'any').#
# Notice that tasks will be started based on the cron's system
# daemon's notion of time and timezones.
#
# Output of the crontab jobs (including errors) is sent through
# email to the user the crontab file belongs to (unless redirected).
#
# For example, you can run a backup of all your user accounts
# at 5 a.m every week with:
# 0 5 * * 1 tar -zcf /var/backups/home.tgz /home/
#
# For more information see the manual pages of crontab(5) and cron(8)
#
# m h  dom mon dow   command

*/5     *       *       *       *       ~/scripts/mydns.sh
~~~
