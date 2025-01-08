#!/usr/bin/bash

# 如果需要指定python版本，请修改此处
bin_dir="/usr/local/python/3.11/bin"
pip_exec="$bin_dir/pip3"

# 安装supervisor
$pip_exec install supervisor

# 如果python_dir不等于/usr/bin，请修改此处
# if [ "$python_bin" != "/usr/bin" ]; then
#     ln -s $python_bin/supervisord /usr/bin/supervisord
#     ln -s $python_bin/supervisorctl /usr/bin/supervisorctl
# fi
# 创建软链接
if [ ! -f "/usr/bin/supervisord" ]; then
    echo "$bin_dir/supervisord"
    ln -s "$bin_dir/supervisord" /usr/bin/supervisord
fi
if [ ! -f "/usr/bin/supervisorctl" ]; then
    echo "$bin_dir/supervisorctl"
    ln -s "$bin_dir/supervisorctl" /usr/bin/supervisorctl
fi

# log
if [ ! -d "/var/log/supervisor" ]; then
    mkdir /var/log/supervisor
fi

# config dir
config_dir=/etc/supervisor
# 创建配置文件目录
if [ ! -d "$config_dir/conf.d" ]; then
    mkdir -p "$config_dir/conf.d"
fi

if [ ! -f "$config_dir/supervisord.conf" ]; then
	# 创建配置文件
	$bin_dir/echo_supervisord_conf > $config_dir/supervisord.conf
	
	# 备份配置文件
	mv $config_dir/supervisord.conf $config_dir/supervisord.example.conf
	
	# 保留非注释配置，删除空行
	cat $config_dir/supervisord.example.conf | grep -v '^;' | tr -s "\n" > $config_dir/supervisord.conf
	
    # 如果需要前台运行再修改此处
    # sed -i 's/nodaemon=false/nodaemon=true/g' $config_dir/supervisord.conf
    sed -i 's|pidfile=/tmp/supervisord.pid|pidfile=/var/run/supervisord.pid|g' $config_dir/supervisord.conf
    sed -i 's|logfile=/tmp/supervisord.log|logfile=/var/log/supervisord.log|g' $config_dir/supervisord.conf

	cat << EOF >> $config_dir/supervisord.conf
[include]
files = /etc/supervisor/conf.d/*.ini
EOF
    # 删除空行
    sed -i '/^$/d' $config_dir/supervisord.conf

fi


# 查看https://github.com/372s/supervisor-initscripts
# 生成配置文件
cat << EOF > /etc/systemd/system/supervisord.service
[Unit]
Description=Supervisor daemon
Documentation=http://supervisord.org
After=network.target

[Service]
Type=forking
ExecStart=/usr/bin/supervisord -c /etc/supervisor/supervisord.conf
ExecStop=/usr/bin/supervisorctl shutdown
ExecReload=/usr/bin/supervisorctl -c /etc/supervisor/supervisord.conf reload
# 只杀掉主程序，不杀掉子进程
KillMode=process
Restart=on-failure
RestartSec=50s

[Install]
WantedBy=multi-user.target
EOF

# 启动服务
systemctl daemon-reload
# systemctl enable supervisord
# systemctl start supervisord