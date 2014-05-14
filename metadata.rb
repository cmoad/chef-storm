name             "storm"
maintainer       "Yuval Oren"
maintainer_email "yuval@n3twork.com"
license          "Apache v2"
description      "Installs/Configures storm"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "0.1.0"

depends          "ark"
depends          "java"
depends          "maven"
depends          "runit", "> 1.0.0"
depends          "zeromq"
