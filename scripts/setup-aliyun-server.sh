#!/bin/bash

# 阿里云服务器自动配置脚本
# 服务器IP: 47.95.7.158

echo "🚀 开始配置阿里云服务器 (IP: 47.95.7.158)..."

# 颜色定义
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# 检查是否为root用户
if [ "$EUID" -ne 0 ]; then
  echo -e "${RED}请使用root用户运行此脚本${NC}"
  echo "使用命令: sudo bash setup-aliyun-server.sh"
  exit 1
fi

echo -e "${GREEN}✅ 正在以root用户运行${NC}"

# 更新系统包
echo -e "${YELLOW}📦 更新系统包...${NC}"
apt update && apt upgrade -y

# 安装必要的软件包
echo -e "${YELLOW}📦 安装基础软件包...${NC}"
apt install -y curl wget git unzip software-properties-common

# 安装Nginx
echo -e "${YELLOW}🌐 安装Nginx...${NC}"
apt install nginx -y

# 启动并启用Nginx
systemctl start nginx
systemctl enable nginx

echo -e "${GREEN}✅ Nginx安装完成${NC}"

# 创建网站目录
echo -e "${YELLOW}📁 创建网站目录...${NC}"
mkdir -p /var/www/blog
chown -R www-data:www-data /var/www/blog
chmod -R 755 /var/www/blog

# 备份默认Nginx配置
cp /etc/nginx/sites-available/default /etc/nginx/sites-available/default.backup

# 创建博客的Nginx配置
echo -e "${YELLOW}⚙️ 配置Nginx虚拟主机...${NC}"
cat > /etc/nginx/sites-available/blog << 'EOF'
server {
    listen 80;
    listen [::]:80;
    
    # 服务器IP地址，后续可以替换为域名
    server_name 47.95.7.158;
    
    root /var/www/blog;
    index index.html index.htm;
    
    # 访问日志
    access_log /var/log/nginx/blog_access.log;
    error_log /var/log/nginx/blog_error.log;
    
    # Gzip压缩
    gzip on;
    gzip_vary on;
    gzip_min_length 1024;
    gzip_types
        text/plain
        text/css
        text/xml
        text/javascript
        application/javascript
        application/xml+rss
        application/json;
    
    location / {
        try_files $uri $uri/ =404;
    }
    
    # 静态资源缓存
    location ~* \.(jpg|jpeg|png|gif|ico|css|js|woff|woff2|ttf|svg)$ {
        expires 1y;
        add_header Cache-Control "public, immutable";
        access_log off;
    }
    
    # 安全头
    add_header X-Frame-Options "SAMEORIGIN" always;
    add_header X-XSS-Protection "1; mode=block" always;
    add_header X-Content-Type-Options "nosniff" always;
    add_header Referrer-Policy "no-referrer-when-downgrade" always;
    
    # 隐藏Nginx版本
    server_tokens off;
}
EOF

# 启用站点配置
ln -sf /etc/nginx/sites-available/blog /etc/nginx/sites-enabled/
rm -f /etc/nginx/sites-enabled/default

# 测试Nginx配置
echo -e "${YELLOW}🔍 测试Nginx配置...${NC}"
nginx -t

if [ $? -eq 0 ]; then
    echo -e "${GREEN}✅ Nginx配置测试通过${NC}"
    # 重启Nginx
    systemctl restart nginx
    echo -e "${GREEN}✅ Nginx服务重启完成${NC}"
else
    echo -e "${RED}❌ Nginx配置测试失败${NC}"
    exit 1
fi

# 创建测试页面
echo -e "${YELLOW}📄 创建测试页面...${NC}"
cat > /var/www/blog/index.html << 'EOF'
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>前端技术博客 - 部署成功</title>
    <style>
        body {
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
            max-width: 800px;
            margin: 0 auto;
            padding: 40px 20px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        .container {
            text-align: center;
            background: rgba(255,255,255,0.1);
            padding: 40px;
            border-radius: 20px;
            backdrop-filter: blur(10px);
        }
        h1 { font-size: 2.5em; margin-bottom: 20px; }
        p { font-size: 1.2em; line-height: 1.6; margin-bottom: 15px; }
        .status { 
            background: #4CAF50; 
            padding: 10px 20px; 
            border-radius: 50px; 
            display: inline-block;
            margin: 20px 0;
        }
        .info {
            background: rgba(255,255,255,0.2);
            padding: 20px;
            border-radius: 10px;
            margin-top: 30px;
            text-align: left;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>🎉 前端技术博客</h1>
        <div class="status">✅ 服务器配置成功</div>
        <p>您的Hexo博客服务器环境已经配置完成！</p>
        <p>当GitHub Actions部署完成后，这个页面将被您的博客内容替换。</p>
        
        <div class="info">
            <h3>📋 服务器信息</h3>
            <p><strong>IP地址:</strong> 47.95.7.158</p>
            <p><strong>Web服务器:</strong> Nginx</p>
            <p><strong>网站目录:</strong> /var/www/blog</p>
            <p><strong>时间:</strong> <span id="time"></span></p>
        </div>
    </div>
    
    <script>
        document.getElementById('time').textContent = new Date().toLocaleString('zh-CN');
    </script>
</body>
</html>
EOF

# 设置防火墙（如果ufw已安装）
if command -v ufw &> /dev/null; then
    echo -e "${YELLOW}🔥 配置防火墙...${NC}"
    ufw allow 'Nginx Full'
    ufw allow ssh
    echo -e "${GREEN}✅ 防火墙配置完成${NC}"
fi

# 显示服务状态
echo -e "${YELLOW}📊 检查服务状态...${NC}"
systemctl status nginx --no-pager -l

# 完成信息
echo ""
echo -e "${GREEN}🎉 阿里云服务器配置完成！${NC}"
echo ""
echo -e "${YELLOW}📋 配置信息:${NC}"
echo "  🌐 服务器IP: 47.95.7.158"
echo "  📁 网站目录: /var/www/blog"
echo "  ⚙️  配置文件: /etc/nginx/sites-available/blog"
echo "  📝 访问日志: /var/log/nginx/blog_access.log"
echo "  🚨 错误日志: /var/log/nginx/blog_error.log"
echo ""
echo -e "${YELLOW}🔗 测试访问:${NC}"
echo "  http://47.95.7.158"
echo ""
echo -e "${YELLOW}📋 下一步操作:${NC}"
echo "  1. 在GitHub仓库设置中配置Secrets:"
echo "     • ALIYUN_USERNAME: root (或您的用户名)"
echo "     • ALIYUN_SSH_KEY: SSH私钥内容"
echo ""
echo "  2. 将SSH公钥添加到服务器:"
echo "     • 公钥内容添加到 ~/.ssh/authorized_keys"
echo ""
echo "  3. 推送代码到GitHub触发自动部署:"
echo "     • git push origin main"
echo ""
echo -e "${GREEN}✨ 享受您的自动化博客部署！${NC}"