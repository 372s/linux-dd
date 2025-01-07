#!/bin/bash

# Install Node.js
wget https://mirrors.aliyun.com/nodejs-release/v20.11.1/node-v20.11.1-linux-x64.tar.gz

tar -zxf node-v20.11.1-linux-x64.tar.gz
mv node-v20.11.1-linux-x64 /usr/local/node

# Set environment variables
echo "export PATH=$PATH:/usr/local/node/bin" >> /etc/profile
source /etc/profile

# Test Node.js
node -v


# 修改配置
npm config set registry https://registry.npmmirror.com/

# 安装yarn
# npm install -g yarn
# 安装pnpm
#npm install -g pnpm

# 使用 corepack 安装 pnpm
corepack enable
#你可以使用corepack use要求 Corepack 更新你的本地package.json以使用你选择的包管理器：
#如 corepack use pnpm@7.x # sets the latest 7.x version in the package.
corepack use pnpm@latest
# 验证是否安装成功
pnpm -v
# config
pnpm config set registry "https://registry.npmmirror.com/"

# 安装pm2
#npm install -g pm2