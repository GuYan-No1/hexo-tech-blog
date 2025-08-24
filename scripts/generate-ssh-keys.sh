#!/bin/bash

# SSH密钥生成脚本
# 用于生成部署所需的SSH密钥对

echo "🔑 开始生成SSH密钥对..."

# 设置密钥文件名
KEY_NAME="blog_deploy"
KEY_PATH="$HOME/.ssh/$KEY_NAME"

# 检查是否已存在密钥
if [ -f "$KEY_PATH" ]; then
    echo "⚠️  密钥文件已存在: $KEY_PATH"
    read -p "是否覆盖现有密钥? (y/N): " confirm
    if [[ $confirm != [yY] ]]; then
        echo "❌ 取消操作"
        exit 1
    fi
fi

# 创建.ssh目录（如果不存在）
mkdir -p ~/.ssh
chmod 700 ~/.ssh

# 生成SSH密钥对
echo "📝 请输入您的邮箱地址（用于密钥标识）:"
read -p "邮箱: " email

if [ -z "$email" ]; then
    echo "❌ 邮箱地址不能为空"
    exit 1
fi

# 生成密钥
ssh-keygen -t rsa -b 4096 -C "$email" -f "$KEY_PATH" -N ""

if [ $? -eq 0 ]; then
    echo "✅ SSH密钥对生成成功！"
    echo ""
    echo "📁 密钥文件位置:"
    echo "   私钥: $KEY_PATH"
    echo "   公钥: $KEY_PATH.pub"
    echo ""
    
    # 显示公钥内容
    echo "🔑 公钥内容（复制到服务器 ~/.ssh/authorized_keys）:"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    cat "$KEY_PATH.pub"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""
    
    echo "🔐 私钥内容（复制到GitHub Secrets中的 ALIYUN_SSH_KEY）:"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    cat "$KEY_PATH"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""
    
    echo "📋 下一步操作:"
    echo "1. 将公钥复制到阿里云服务器:"
    echo "   ssh-copy-id -i $KEY_PATH.pub user@your-server-ip"
    echo ""
    echo "2. 或者手动添加到服务器:"
    echo "   cat $KEY_PATH.pub | ssh user@your-server-ip \"mkdir -p ~/.ssh && cat >> ~/.ssh/authorized_keys\""
    echo ""
    echo "3. 在GitHub仓库的Settings > Secrets中添加以下Secrets:"
    echo "   - ALIYUN_HOST: 您的服务器IP地址"
    echo "   - ALIYUN_USERNAME: 服务器用户名"
    echo "   - ALIYUN_SSH_KEY: 上面显示的私钥内容"
    echo "   - ALIYUN_PORT: SSH端口（通常是22）"
    echo ""
    echo "4. 测试SSH连接:"
    echo "   ssh -i $KEY_PATH user@your-server-ip"
    
else
    echo "❌ 密钥生成失败"
    exit 1
fi