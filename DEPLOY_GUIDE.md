# 🚀 阿里云服务器部署指南

> **服务器IP**: `47.95.7.158`  
> **GitHub仓库**: `https://github.com/GuYan-No1/hexo-tech-blog`

## 📋 部署步骤总览

```mermaid
graph TD
    A[1. 配置阿里云服务器] --> B[2. 上传SSH公钥]
    B --> C[3. 配置GitHub Secrets]
    C --> D[4. 触发自动部署]
    D --> E[5. 验证部署结果]
```

## 🖥️ 第一步：配置阿里云服务器

### 1.1 连接到服务器
```bash
ssh root@47.95.7.158
```

### 1.2 下载并运行配置脚本
```bash
# 下载项目
git clone https://github.com/GuYan-No1/hexo-tech-blog.git
cd hexo-tech-blog

# 运行服务器配置脚本
chmod +x scripts/setup-aliyun-server.sh
sudo bash scripts/setup-aliyun-server.sh
```

## 🔑 第二步：配置SSH密钥

### 2.1 将SSH公钥添加到服务器

**SSH公钥内容**（复制以下内容）：
```
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDCgEhPTECTCtQz54rxAtwagyUmnU/Z/zki9p/R37mzVPhAKiscqYM+6815H3uIIl9SpqaVQOmFM5ss5tmqmXwSgkcyijV+b6bAx+2D8REjKq1VygAf6EgDAAQqp+OTOEIw9+viuNg225jb0/aQZajVPX9OXo4hoAUqBxwwe8FV53uF/dJN4fbd9aPVHHmN0/KYBV6QzexLo/0JALhy2W7UDMgqkBZvd0XtmpVTJu3ts8XG6kMHKLi2EtFZwz2QxS/0uMZ0Ku0o8JABfi01vCnkqx3rGtwfjPY+KqH9xeBIz6RhPCudrQfAnWpODpqx/1xqOyRabZRtDKaahL9V+pA/cRNmcPSPXrs8lcgoA2lD89Eh1TqZrQ7S7bI0txMaGOKdQzwwpkKeicwxduQGCW+SWOswICn7lcLCxeDPHlKSFOAZqe5mx5Z5vNiXe3hCLIeFmTguxvr8aXHzsEIWiMN0KkdfFD7hrnPIgU+oK26C8O+qKg3o5j0DjRDR0JySg+wSyu3HS8SV40xmtm9tctxs/pnwYxQivWXNi5OozvZC0gtds2WTT3Vpfp/X5xsfJTTqa02ez5hfUBYL63RJh6nVVuR9z/RDiKVHcDqKJI8boAT1FPev0ZxffKeez8lRu8efJgPn98SZlMQkStFWcRtriD2JSfaTrlZUEdDngM3TOQ== hexo-blog-deploy
```

### 2.2 在服务器上执行
```bash
# 在服务器上执行以下命令
mkdir -p ~/.ssh
chmod 700 ~/.ssh

# 将公钥添加到authorized_keys
echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDCgEhPTECTCtQz54rxAtwagyUmnU/Z/zki9p/R37mzVPhAKiscqYM+6815H3uIIl9SpqaVQOmFM5ss5tmqmXwSgkcyijV+b6bAx+2D8REjKq1VygAf6EgDAAQqp+OTOEIw9+viuNg225jb0/aQZajVPX9OXo4hoAUqBxwwe8FV53uF/dJN4fbd9aPVHHmN0/KYBV6QzexLo/0JALhy2W7UDMgqkBZvd0XtmpVTJu3ts8XG6kMHKLi2EtFZwz2QxS/0uMZ0Ku0o8JABfi01vCnkqx3rGtwfjPY+KqH9xeBIz6RhPCudrQfAnWpODpqx/1xqOyRabZRtDKaahL9V+pA/cRNmcPSPXrs8lcgoA2lD89Eh1TqZrQ7S7bI0txMaGOKdQzwwpkKeicwxduQGCW+SWOswICn7lcLCxeDPHlKSFOAZqe5mx5Z5vNiXe3hCLIeFmTguxvr8aXHzsEIWiMN0KkdfFD7hrnPIgU+oK26C8O+qKg3o5j0DjRDR0JySg+wSyu3HS8SV40xmtm9tctxs/pnwYxQivWXNi5OozvZC0gtds2WTT3Vpfp/X5xsfJTTqa02ez5hfUBYL63RJh6nVVuR9z/RDiKVHcDqKJI8boAT1FPev0ZxffKeez8lRu8efJgPn98SZlMQkStFWcRtriD2JSfaTrlZUEdDngM3TOQ== hexo-blog-deploy" >> ~/.ssh/authorized_keys

chmod 600 ~/.ssh/authorized_keys
```

## ⚙️ 第三步：配置GitHub Secrets

前往 GitHub 仓库: `https://github.com/GuYan-No1/hexo-tech-blog`

1. 点击 **Settings** 标签页
2. 在左侧菜单中选择 **Secrets and variables** > **Actions**
3. 点击 **New repository secret** 添加以下密钥：

### 3.1 ALIYUN_USERNAME
- **Name**: `ALIYUN_USERNAME`
- **Secret**: `root`

### 3.2 ALIYUN_SSH_KEY
- **Name**: `ALIYUN_SSH_KEY`  
- **Secret**: 
```
-----BEGIN OPENSSH PRIVATE KEY-----
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
-----END OPENSSH PRIVATE KEY-----
```

## 🚀 第四步：触发自动部署

### 4.1 测试SSH连接
在本地测试SSH连接是否正常：
```bash
ssh -i ~/.ssh/blog_deploy root@47.95.7.158
```

### 4.2 触发GitHub Actions
向main分支推送任何代码都会触发自动部署：
```bash
# 在本地项目目录执行
echo "部署测试" >> README.md
git add .
git commit -m "触发自动部署测试"
git push origin main
```

### 4.3 查看部署状态
1. 访问GitHub仓库的 **Actions** 标签页
2. 查看最新的工作流执行情况
3. 如果出现错误，检查日志并修复问题

## ✅ 第五步：验证部署结果

### 5.1 访问网站
在浏览器中打开: `http://47.95.7.158`

### 5.2 检查服务器状态
```bash
# 连接到服务器
ssh root@47.95.7.158

# 检查Nginx状态
systemctl status nginx

# 检查网站文件
ls -la /var/www/blog/

# 查看访问日志
tail -f /var/log/nginx/blog_access.log
```

## 🎯 预期结果

✅ **成功部署后，您将看到**：
- 网站在 `http://47.95.7.158` 正常访问
- 显示您的Hexo博客内容
- 包含三篇技术文章：
  - JavaScript ES6新特性详解
  - React Hooks使用指南  
  - Vue.js响应式原理解析

## 🔧 故障排除

### 常见问题

1. **SSH连接失败**
   ```bash
   # 检查SSH服务状态
   ssh root@47.95.7.158 "systemctl status ssh"
   
   # 确认公钥已正确添加
   ssh root@47.95.7.158 "cat ~/.ssh/authorized_keys"
   ```

2. **GitHub Actions失败**
   - 检查Secrets配置是否正确
   - 确认SSH私钥格式正确（包含完整的BEGIN和END行）
   - 查看Actions日志获取详细错误信息

3. **网站无法访问**
   ```bash
   # 检查Nginx配置
   ssh root@47.95.7.158 "nginx -t"
   
   # 重启Nginx
   ssh root@47.95.7.158 "systemctl restart nginx"
   
   # 检查防火墙状态
   ssh root@47.95.7.158 "ufw status"
   ```

## 📞 技术支持

如果遇到问题，请：
1. 查看GitHub Actions的执行日志
2. 检查服务器上的Nginx错误日志：`/var/log/nginx/blog_error.log`
3. 确认所有配置步骤都已正确完成

---

**🎉 恭喜！您的自动化博客部署系统已经配置完成！**

每次向GitHub推送代码，都会自动触发部署到您的阿里云服务器！