---
date: "2016-12-04"
title: "Apache2でIR-Stationデモ"
categories:
  - "備忘録"
tags:
 - "サーバー"
 - "Raspberry Pi"
 - "Apache2"
 - "IR-Station"
 - "Sinatra"
---


## 概要

ラズパイ+Apache2+SinatraでIR-Stationのデモサイトを作る．

この記事は，デモサイトを作るときのメモ．  
デモサイト紹介記事は[こちら](/posts/2016-10-20-ir-station-demo/)

<!--more-->

## 環境作り

~~~sh
$ sudo apt-get install rubygems
$ sudo apt-get install libapache2-mod-passenger
$ sudo gem install sinatra
$ sudo gem install sinatra-contrib
$ sudo gem install passenger
$ sudo apt-get install -y libcurl4-openssl-dev apache2-threaded-dev ruby-dev libapr1-dev libaprutil1-dev
$ sudo passenger-install-apache2-module
いろいろ聞いてくるのでEnterを押しまくる．エラーがなければOK
~~~

## アプリケーションの用意

~~~sh
$ git clone https://github.com/kerikun11/IR-station.git
$ sudo mkdir /var/ir-station
$ sudo chown kerikun11 /var/ir-station
$ sudo chgrp kerikun11 /var/ir-station
$ ln -ds ~/IR-station/server_demo/main /var/ir-station/
~~~


## Apache2の設定

~~~sh
$ sudo vim /etc/apache2/sites-available/myconf.conf
~~~

以下を追記

~~~kconfig
<VirtualHost *:80>
        # The ServerName directive sets the request scheme, hostname and port that
        # the server uses to identify itself. This is used when creating
        # redirection URLs. In the context of virtual hosts, the ServerName
        # specifies what hostname must appear in the request's Host: header to
        # match this virtual host. For the default virtual host (this file) this
        # value is not decisive as it is used as a last resort host regardless.
        # However, you must set it for any further virtual host explicitly.
        ServerName "ir-station.kerikun11.mydns.jp"
        ServerAdmin "kerikun11@gmail.com"
        DocumentRoot "/var/ir-station/main/public"

        <Directory />
                Options FollowSymLinks
                AllowOverride None
        </Directory>

        <Directory /var/ir-station/>
                Options FollowSymLinks Indexes MultiViews
                AllowOverride All
                Order allow,deny
                Allow from all
                Require all granted
        </Directory>

        # Available loglevels: trace8, ..., trace1, debug, info, notice, warn,
        # error, crit, alert, emerg.
        # It is also possible to configure the loglevel for particular
        # modules, e.g.
        #LogLevel info ssl:warn

        RailsBaseURI /main
        PassengerResolveSymlinksInDocumentRoot on

        ErrorLog ${APACHE_LOG_DIR}/error.log
        CustomLog ${APACHE_LOG_DIR}/access.log combined

        # For most configuration files from conf-available/, which are
        # enabled or disabled at a global level, it is possible to
        # include a line for only one particular virtual host. For example the
        # following line enables the CGI configuration for this host only
        # after it has been globally disabled with "a2disconf".
        #Include conf-available/serve-cgi-bin.conf
</VirtualHost>

# vim: syntax=apache ts=4 sw=4 sts=4 sr noet
~~~

### 設定を反映

~~~sh
$ sudo service apache2 restart
~~~

