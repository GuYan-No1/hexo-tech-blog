#!/bin/bash

# 阿里云服务器部署脚本
# 该脚本用于在阿里云服务器上配置Nginx和部署环境

echo "开始配置阿里云服务器环境..."

# 更新系统包
sudo apt update && sudo apt upgrade -y

# 安装Nginx
sudo apt install nginx -y

# 启动并启用Nginx
sudo systemctl start nginx
sudo systemctl enable nginx

# 创建网站目录
sudo mkdir -p /var/www/blog
sudo chown -R $USER:$USER /var/www/blog
sudo chmod -R 755 /var/www/blog

# 创建Nginx配置文件
sudo tee /etc/nginx/sites-available/blog << 'EOF'
server {
    listen 80;
    listen [::]:80;
    
    # 替换为您的域名
    server_name your-domain.com www.your-domain.com;
    
    root /var/www/blog;
    index index.html index.htm;
    
    # Gzip压缩
    gzip on;
    gzip_vary on;
    gzip_min_length 1024;
    gzip_types text/plain text/css text/xml text/javascript application/javascript application/xml+rss application/json;
    
    location / {
        try_files $uri $uri/ =404;
    }
    
    # 静态资源缓存
    location ~* \.(jpg|jpeg|png|gif|ico|css|js)$ {
        expires 1y;
        add_header Cache-Control "public, immutable";
    }
    
    # 安全头
    add_header X-Frame-Options "SAMEORIGIN" always;
    add_header X-XSS-Protection "1; mode=block" always;
    add_header X-Content-Type-Options "nosniff" always;
    add_header Referrer-Policy "no-referrer-when-downgrade" always;
    add_header Content-Security-Policy "default-src * data: 'unsafe-eval' 'unsafe-inline'" always;
    
    # 日志文件
    access_log /var/log/nginx/blog_access.log;
    error_log /var/log/nginx/blog_error.log;
}
EOF

# 启用站点配置
sudo ln -sf /etc/nginx/sites-available/blog /etc/nginx/sites-enabled/
sudo rm -f /etc/nginx/sites-enabled/default

# 测试Nginx配置
sudo nginx -t

# 重启Nginx
sudo systemctl restart nginx

# 安装Certbot用于SSL证书
sudo apt install snapd -y
sudo snap install core; sudo snap refresh core
sudo snap install --classic certbot
sudo ln -sf /snap/bin/certbot /usr/bin/certbot

echo "服务器环境配置完成！"
echo "请执行以下步骤完成配置："
echo "1. 修改 /etc/nginx/sites-available/blog 中的域名"
echo "2. 配置域名DNS解析到服务器IP"
echo "3. 运行 'sudo certbot --nginx' 配置SSL证书"
echo "4. 在GitHub仓库中配置Secrets"