---
date: "2016-08-28"
title: "ブログを更新するスクリプト"
categories:
  - "備忘録"
tags:
  - "Raspberry Pi"
  - "シェルスクリプト"
  - "ブログ"
thumbnail: "icon.png"
---

## github上にあるブログを同期するシェルスクリプト

自分用のメモ

<!--more-->

## 前提

### ~/.ssh/config

~~~kconfig
Host github
	HostName github.com
	User git
	Port 22
	IdentityFile ~/.ssh/id_ecdsa
~~~

## Apache2の設定

### /etc/apache2/sites-available/myconf.conf

~~~kconfig
<VirtualHost *:80>
	# The ServerName directive sets the request scheme, hostname and port that
	# the server uses to identify itself. This is used when creating
	# redirection URLs. In the context of virtual hosts, the ServerName
	# specifies what hostname must appear in the request's Host: header to
	# match this virtual host. For the default virtual host (this file) this
	# value is not decisive as it is used as a last resort host regardless.
	# However, you must set it for any further virtual host explicitly.
	ServerName "kerikeri.top"
	ServerAdmin "kerikun11@gmail.com"
	DocumentRoot "/var/keriweb"
	
	<Directory />
		Options FollowSymLinks
		AllowOverride None
	</Directory>
	
	<Directory /var/keriweb/>
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

	ErrorLog ${APACHE_LOG_DIR}/error.log
	CustomLog ${APACHE_LOG_DIR}/access.log combined

	# For most configuration files from conf-available/, which are
	# enabled or disabled at a global level, it is possible to
	# include a line for only one particular virtual host. For example the
	# following line enables the CGI configuration for this host only
	# after it has been globally disabled with "a2disconf".
	#Include conf-available/serve-cgi-bin.conf
	ErrorDocument 404 /error/404/
</VirtualHost>

# vim: syntax=apache ts=4 sw=4 sts=4 sr noet
~~~

	$ sudo a2ensite myconf
	$ sudo a2dissite default-000
	$ sudo service apache2 restart

	$ sudo mkdir /var/keriweb
	$ sudo chown kerikun11 /var/keriweb
	$ sudo chgrp kerikun11 /var/keriweb

## スクリプト

### update-keriweb.sh

~~~sh
#!/bin/sh
tmpdir=/home/kerikun11/keriweb
repo=github:kerikun11/keriweb.git
rsyncfrom=./jekyll-keriweb/_site/
rsyncto=/var/keriweb
rsync='rsync -vrtl --delete'
dirname=`dirname "$tmpdir"`
basename=`basename "$tmpdir"`

if [ -d "$tmpdir" ];then
	echo "found keriweb directory"
	cd "$tmpdir"
	if git pull; then
		echo "start rsync"
		$rsync "$rsyncfrom" "$rsyncto"
		echo "end"
		exit 0
	fi
fi

echo "not found $basename"

mkdir -p "$dirname"
cd "$dirname"
rm -rf "$basename"

if git clone "$repo" "$basename"; then
	echo "clone keriweb"
	cd "$basename"
	echo "start rsync"
	$rsync "$rsyncfrom" "$rsyncto"
fi
~~~

