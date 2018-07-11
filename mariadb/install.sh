#!/bin/bash
source ../include/install-helper.sh

install_path="/usr/local/bin/mariadb"

if [ ! -d "mariadb" ]; then
  print_progress "download mariadb"
  wget http://mirrors.neusoft.edu.cn/mariadb//mariadb-10.3.8/source/mariadb-10.3.8.tar.gz
  tar -zxvf mariadb-10.3.8.tar.gz
  mv mariadb-10.3.8 mariadb
fi

print_progress "create user for mysql"
mkdir -p $install_path
mkdir -p $install_path/data/mysql
mkdir -p $install_path/log

groupadd -r mysql
useradd -r -g mysql -s /sbin/nologin -d $install_path -M mysql
chown -R mysql:mysql $install_path

print_progress "install requirements"
yum install -y cmake
yum install -y ncurses-devel

cd mariadb
a3pk_swap_on
print_progress "prepar mariadb"
cmake . \
 -DCMAKE_INSTALL_PREFIX="$install_path" \
 -DMYSQL_DATADIR="$install_path/data/mysql" \
 -DMYSQL_UNIX_ADDR=/var/lib/mysql/mysql.sock \
 -DWITHOUT_TOKUDB=1 \
 -DWITH_INNOBASE_STORAGE_ENGINE=1 \
 -DWITH_ARCHIVE_STPRAGE_ENGINE=1 \
 -DWITH_BLACKHOLE_STORAGE_ENGINE=1 \
 -DWIYH_READLINE=1 \
 -DWIYH_SSL=system \
 -DVITH_ZLIB=system \
 -DWITH_LOBWRAP=0 \
 -DDEFAULT_CHARSET=utf8 \
 -DDEFAULT_COLLATION=utf8_general_ci
assert_command_result "mariadb cmake failed"

make
assert_command_result "mariadb make failed"

make install
assert_command_result "mariadb make install failed"
cd ..

a3pk_swap_off

print_progress "setup mariadb"
cp my.cnf /etc/my.cnf
"$install_path/scripts/mysql_install_db" \
  --user=mysql \
  --datadir="$install_path/data/" \
  --basedir=$install_path

print_progress "install service"
$install_path/bin/mysqld_safe &
assert_command_result "start service failed"
sleep 3

print_progress "init mariadb"
$install_path/bin/mysql_secure_installation \
  --socket=$install_path/mysql.sock

echo ""
echo ""
echo "=========================================================="
echo "= "
echo "= Install Path : $install_path"
echo "= Start Service : $install_path/bin/mysqld_safe &"
echo "= Configuration Path : /etc/my.cnf"
echo "= "
echo "=========================================================="
