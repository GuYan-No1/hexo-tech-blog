#!/bin/bash

# 部署环境检查脚本
# 检查阿里云服务器和GitHub配置是否就绪

echo "🔍 开始检查部署环境..."
echo ""

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# 检查结果计数
PASS_COUNT=0
FAIL_COUNT=0

# 检查函数
check_item() {
    local description="$1"
    local command="$2"
    local expected="$3"
    
    echo -n "🔍 检查 $description ... "
    
    if eval "$command" >/dev/null 2>&1; then
        echo -e "${GREEN}✅ 通过${NC}"
        ((PASS_COUNT++))
        return 0
    else
        echo -e "${RED}❌ 失败${NC}"
        if [ -n "$expected" ]; then
            echo "   💡 建议: $expected"
        fi
        ((FAIL_COUNT++))
        return 1
    fi
}

# 检查本地环境
echo -e "${BLUE}━━━ 本地环境检查 ━━━${NC}"

check_item "Node.js 环境" "node --version" "请安装 Node.js 12+"
check_item "npm 环境" "npm --version" "请安装 npm"
check_item "Git 环境" "git --version" "请安装 Git"
check_item "Hexo CLI" "npx hexo --version" "请运行: npm install -g hexo-cli"

echo ""

# 检查项目配置
echo -e "${BLUE}━━━ 项目配置检查 ━━━${NC}"

check_item "package.json 存在" "test -f package.json" "请确保在项目根目录"
check_item "_config.yml 存在" "test -f _config.yml" "请确保 Hexo 配置文件存在"
check_item "GitHub Actions 配置" "test -f .github/workflows/deploy.yml" "GitHub Actions 配置文件不存在"
check_item "部署脚本存在" "test -f scripts/deploy-server.sh" "服务器部署脚本不存在"

echo ""

# 检查Git配置
echo -e "${BLUE}━━━ Git 仓库检查 ━━━${NC}"

check_item "Git 仓库已初始化" "test -d .git" "请运行: git init"

if git remote get-url origin >/dev/null 2>&1; then
    REMOTE_URL=$(git remote get-url origin)
    echo -e "🔗 远程仓库: ${GREEN}$REMOTE_URL${NC}"
    ((PASS_COUNT++))
else
    echo -e "${RED}❌ 未配置远程仓库${NC}"
    echo "   💡 建议: git remote add origin https://github.com/username/repo.git"
    ((FAIL_COUNT++))
fi

echo ""

# 检查SSH密钥
echo -e "${BLUE}━━━ SSH 密钥检查 ━━━${NC}"

SSH_KEY_PATH="$HOME/.ssh/blog_deploy"
if [ -f "$SSH_KEY_PATH" ]; then
    echo -e "🔑 SSH私钥: ${GREEN}存在${NC} ($SSH_KEY_PATH)"
    ((PASS_COUNT++))
    
    if [ -f "$SSH_KEY_PATH.pub" ]; then
        echo -e "🔑 SSH公钥: ${GREEN}存在${NC} ($SSH_KEY_PATH.pub)"
        ((PASS_COUNT++))
    else
        echo -e "${RED}❌ SSH公钥不存在${NC}"
        ((FAIL_COUNT++))
    fi
else
    echo -e "${RED}❌ SSH密钥不存在${NC}"
    echo "   💡 建议: 运行 ./scripts/generate-ssh-keys.sh 生成密钥"
    ((FAIL_COUNT++))
fi

echo ""

# 服务器连接测试（如果配置了的话）
echo -e "${BLUE}━━━ 服务器连接测试 ━━━${NC}"

echo "📝 请手动配置以下信息："
echo "   🖥️  服务器IP地址"
echo "   👤 SSH用户名"
echo "   🔑 SSH密钥认证"
echo "   🌐 域名解析"

echo ""

# GitHub Secrets检查提醒
echo -e "${BLUE}━━━ GitHub Secrets 配置提醒 ━━━${NC}"

echo "📋 请确保在GitHub仓库的 Settings > Secrets 中配置了："
echo "   • ALIYUN_HOST (服务器IP地址)"
echo "   • ALIYUN_USERNAME (SSH用户名)"
echo "   • ALIYUN_SSH_KEY (SSH私钥内容)"
echo "   • ALIYUN_PORT (SSH端口，通常是22)"

echo ""

# 生成检查报告
echo -e "${BLUE}━━━ 检查报告 ━━━${NC}"

TOTAL=$((PASS_COUNT + FAIL_COUNT))
echo "📊 检查项目总数: $TOTAL"
echo -e "✅ 通过项目: ${GREEN}$PASS_COUNT${NC}"
echo -e "❌ 失败项目: ${RED}$FAIL_COUNT${NC}"

if [ $FAIL_COUNT -eq 0 ]; then
    echo ""
    echo -e "${GREEN}🎉 恭喜！所有检查项目都已通过！${NC}"
    echo -e "${GREEN}🚀 您可以开始部署流程了！${NC}"
    echo ""
    echo "📋 接下来的步骤："
    echo "1. 将代码推送到GitHub: git push origin master"
    echo "2. 在服务器上运行: ./scripts/deploy-server.sh"
    echo "3. 配置域名解析和SSL证书"
    echo "4. 观察GitHub Actions自动部署过程"
else
    echo ""
    echo -e "${YELLOW}⚠️  有 $FAIL_COUNT 个项目需要修复${NC}"
    echo -e "${YELLOW}📋 请根据上面的建议完成配置后重新检查${NC}"
fi

echo ""
echo "🔗 更多帮助请查看: README.md"
exit $FAIL_COUNT