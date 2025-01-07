#!/bin/bash

# 如果需要指定python版本，请修改此处
python_bin="/usr/local/python/bin"

# 安装supervisor
$python_bin/pip3 install supervisor

# 创建软链接
# 如果python_dir不等于/usr/bin，请修改此处
if [ "$python_bin" != "/usr/bin" ]; then
    ln -s ${python_dir}/bin/supervisord /usr/bin/supervisord
    ln -s ${python_dir}/bin/supervisorctl /usr/bin/supervisorctl
fi

# 配置文件
mkdir /etc/supervisor
mkdir /etc/supervisor/conf.d
${python_bin}/echo_supervisord_conf > /etc/supervisor/supervisord.conf
cat << EOF >> /etc/supervisor/supervisord.conf
[include]
files = /etc/supervisor/conf.d/*.conf
EOF

# 创建配置
mkdir /etc/supervisor.d

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
systemctl enable supervisord
systemctl start supervisord