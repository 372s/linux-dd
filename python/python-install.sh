#!/usr/bin/bash

mkdir /opt/python
cd /opt/python
## 官方镜像 https://www.python.org/ftp/python/3.11.8/Python-3.11.8.tgz
wget https://mirrors.huaweicloud.com/python/3.11.8/Python-3.11.8.tgz
tar -zxvf Python-3.11.8.tgz
cd Python-3.11.8
echo $(pwd)

# 创建安装目录`/usr/local/python/3.11` （ 与其他python版本区分）
mkdir -p /usr/local/python/3.11
echo $(pwd)

# 安装
./configure --prefix=/usr/local/python/3.11 --enable-optimizations
make && make install

# 创建软链
ln -s /usr/local/python/3.11/bin/python3.11 /usr/bin/python3.11
ln -s /usr/local/python/3.11/bin/pip3.11 /usr/bin/pip3.11

# 更改pip源
/usr/local/python/3.11/bin/pip3.11 config set global.index-url https://mirrors.aliyun.com/pypi/simple/