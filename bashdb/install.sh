#!/bin/bash
mkdir -p /usr/local/bin/bashdb

wget https://sourceforge.net/projects/bashdb/files/bashdb/4.2-0.92/bashdb-4.4-0.92.tar.gz/download -O bashdb.tar.gz
tar -xf bashdb.tar.gz
mv bashdb-4.4-0.92 bashdb
cd bashdb
./configure
make
make install
