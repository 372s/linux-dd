#!/bin/bash
# 下载mongodb
#wget https://fastdl.mongodb.org/linux/mongodb-linux-x86_64-rhel8-7.0.16.tgz
#tar -zxf mongodb-linux-x86_64-rhel8-7.0.16.tgz
#mv mongodb-linux-x86_64-rhel8-7.0.16 /usr/local/mongodb

#cd /usr/local/mongodb
#echo $(pwd)

# 创建用户
groupadd mongod
useradd -r -g mongod -s /bin/false mongod
#数据目录
mkdir -p /var/lib/mongo
#日志目录
mkdir -p /var/log/mongodb
#更改用户
chown -R mongod:mongod /var/lib/mongo
chown -R mongod:mongod /var/log/mongodb
# 配置文件
touch /etc/mongodb.conf
#写入配置文件
cat << EOF > /etc/mongodb.conf
# mongodb.conf
# for documentation of all options, see:
# http://docs.mongodb.org/manual/reference/configuration-options/
# where to write logging data.
systemLog:
  destination: file
  logAppend: true
  path: /var/log/mongodb/mongod.log
# Where and how to store data.
storage:
  dbPath: /var/lib/mongo
# how the process runs
processManagement:
  timeZoneInfo: /usr/share/zoneinfo
# network interfaces
net:
  port: 27017
  bindIp: 127.0.0.1
# bindIp: 180.184.53.195,127.0.0.1,192.168.12.250
# Enter 0.0.0.0,:: to bind to all IPv4 and IPv6 addresses or, alternatively, use the net.bindIpAll setting.
#security:
#  authorization:enable
EOF

# systemd
touch /etc/systemd/system/mongod.service
cat > /etc/systemd/system/mongod.service << EOF
[Unit]
Description=MongoDB Database Server
Documentation=https://docs.mongodb.org/manual
After=network-online.target
Wants=network-online.target

[Service]
Type=simple
WorkingDirectory=/var/lib/mongo
ExecStart=/usr/local/mongodb/bin/mongod -f /etc/mongodb.conf
User=mongod
Group=mongod
Restart=on-failure
#Restart=no

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload