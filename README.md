# 前端技术博客 - CI/CD 自动化部署

> 基于 Hexo + GitHub Actions + 阿里云服务器的自动化博客部署方案

## 🚀 项目概述

这是一个完整的前端技术博客解决方案，支持：
- 📝 Hexo 静态博客生成
- 🔄 GitHub Actions 自动化 CI/CD
- ☁️ 阿里云服务器部署
- 🌐 自定义域名和 SSL 证书
- 📱 响应式设计和 SEO 优化

## 📁 项目结构

```
hexo-tech-blog/
├── .github/workflows/     # GitHub Actions 工作流
│   └── deploy.yml        # 自动部署配置
├── scripts/              # 部署脚本
│   └── deploy-server.sh  # 服务器环境配置脚本
├── source/               # 博客源文件
│   ├── _posts/          # 文章目录
│   └── ...
├── themes/               # 主题文件
├── _config.yml          # Hexo 配置文件
├── package.json         # 项目依赖
└── README.md           # 项目说明
```

## 🛠️ 部署指南

### 第一步：阿里云服务器配置

1. **连接到您的阿里云服务器**
```bash
ssh root@your-server-ip
```

2. **运行服务器配置脚本**
```bash
# 下载项目到服务器
git clone https://github.com/your-username/hexo-tech-blog.git
cd hexo-tech-blog

# 运行配置脚本
./scripts/deploy-server.sh
```

3. **配置域名和SSL**
```bash
# 编辑Nginx配置，替换为您的域名
sudo nano /etc/nginx/sites-available/blog

# 配置SSL证书
sudo certbot --nginx
```

### 第二步：GitHub 仓库配置

1. **创建 GitHub 仓库**
   - 在 GitHub 创建新仓库 `hexo-tech-blog`
   - 推送本地代码到仓库

2. **配置 GitHub Secrets**

在 GitHub 仓库的 Settings > Secrets and variables > Actions 中添加以下 Secrets：

| Secret 名称 | 说明 | 示例值 |
|------------|------|-------|
| `ALIYUN_HOST` | 阿里云服务器IP地址 | `123.456.789.0` |
| `ALIYUN_USERNAME` | 服务器用户名 | `root` 或 `ubuntu` |
| `ALIYUN_SSH_KEY` | SSH 私钥内容 | 完整的私钥文件内容 |
| `ALIYUN_PORT` | SSH 端口 | `22` |

### 第三步：生成和配置 SSH 密钥

1. **在本地生成 SSH 密钥对**
```bash
ssh-keygen -t rsa -b 4096 -C "your-email@example.com" -f ~/.ssh/blog_deploy
```

2. **将公钥添加到服务器**
```bash
# 复制公钥到服务器
ssh-copy-id -i ~/.ssh/blog_deploy.pub user@your-server-ip

# 或者手动添加
cat ~/.ssh/blog_deploy.pub | ssh user@your-server-ip "mkdir -p ~/.ssh && cat >> ~/.ssh/authorized_keys"
```

3. **在 GitHub Secrets 中添加私钥**
```bash
# 复制私钥内容到剪贴板
cat ~/.ssh/blog_deploy
```

### 第四步：域名解析配置

1. **腾讯云DNS解析配置**
   - 登录腾讯云控制台
   - 进入域名解析页面
   - 添加A记录：
     - 主机记录：`@` 和 `www`
     - 记录值：您的阿里云服务器IP

2. **等待DNS生效**（通常需要10分钟到24小时）

### 第五步：测试自动化部署

1. **推送代码触发部署**
```bash
git add .
git commit -m "初始化博客部署"
git push origin master
```

2. **查看 GitHub Actions 执行状态**
   - 在 GitHub 仓库的 Actions 标签页查看工作流执行情况

3. **验证部署结果**
   - 访问您的域名确认博客正常运行

## 📝 日常使用流程

### 写作新文章

1. **创建新文章**
```bash
npx hexo new "文章标题"
```

2. **编辑文章**
```bash
# 文章位于 source/_posts/ 目录下
vim source/_posts/文章标题.md
```

3. **本地预览**
```bash
npx hexo server
```

4. **发布文章**
```bash
git add .
git commit -m "发布新文章：文章标题"
git push origin master
```

### 自动化流程

一旦推送到 GitHub，系统会自动：
1. 🔄 触发 GitHub Actions
2. 📦 安装依赖并构建静态文件
3. 🚀 部署到阿里云服务器
4. 🔄 重载 Nginx 配置
5. ✅ 完成部署

## 🎯 功能特性

### 博客功能
- ✨ 代码高亮
- 🏷️ 标签和分类
- 📱 响应式设计
- 🔍 SEO 优化
- 💬 评论系统（可扩展）

### 技术栈
- **前端**：Hexo, HTML5, CSS3, JavaScript
- **主题**：Landscape（可自定义）
- **部署**：GitHub Actions, Nginx
- **服务器**：阿里云 ECS
- **域名**：腾讯云域名

### 性能优化
- 🗜️ Gzip 压缩
- 📦 静态资源缓存
- 🔒 安全头配置
- 📈 CDN 可扩展

## 🔧 自定义配置

### 修改博客配置
编辑 `_config.yml` 文件：
```yaml
# 站点信息
title: 前端技术博客
subtitle: 分享前端开发技术与经验
description: 专注于前端技术分享...
author: 前端开发者
language: zh-CN
timezone: Asia/Shanghai

# URL设置
url: https://your-domain.com
```

### 自定义主题
1. 下载主题到 `themes/` 目录
2. 修改 `_config.yml` 中的 `theme` 配置
3. 根据主题文档进行自定义

### 添加插件
```bash
npm install hexo-plugin-name --save
```

## 🐛 故障排除

### 常见问题

1. **部署失败**
   - 检查 GitHub Secrets 配置
   - 确认 SSH 密钥正确
   - 查看 Actions 日志

2. **域名无法访问**
   - 检查 DNS 解析配置
   - 确认 Nginx 配置正确
   - 检查防火墙设置

3. **SSL 证书问题**
   - 重新运行 `certbot --nginx`
   - 检查域名解析是否生效

### 日志查看
```bash
# Nginx 访问日志
sudo tail -f /var/log/nginx/blog_access.log

# Nginx 错误日志
sudo tail -f /var/log/nginx/blog_error.log

# 系统日志
journalctl -u nginx -f
```

## 📞 支持

如果您在部署过程中遇到问题，请：
1. 查看 GitHub Actions 执行日志
2. 检查服务器日志
3. 确认网络和DNS配置
4. 提交 Issue 描述问题

## 📄 许可证

MIT License

---

**享受您的自动化博客之旅！** 🎉