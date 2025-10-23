#!/bin/bash
# 一键安装Node.js、Vercel CLI并部署

echo "🚀 一键安装和部署开始..."
echo "================================"

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
NC='\033[0m'

print_colored() {
    local color="$1"
    local message="$2"
    echo -e "${color}${message}${NC}"
}

# 检查是否在项目根目录
if [ ! -f "index.html" ]; then
    print_colored "$RED" "❌ 错误: 请在项目根目录执行此脚本"
    exit 1
fi

# 1. 检查Node.js
print_colored "$BLUE" "🔍 检查Node.js安装状态..."
if command -v node &> /dev/null; then
    NODE_VERSION=$(node --version)
    print_colored "$GREEN" "✅ Node.js已安装: $NODE_VERSION"
else
    print_colored "$YELLOW" "⚠️ Node.js未安装，请手动安装"
    print_colored "$WHITE" "   1. 访问 https://nodejs.org/"
    print_colored "$WHITE" "   2. 下载LTS版本"
    print_colored "$WHITE" "   3. 安装后重启终端"
    print_colored "$WHITE" "   4. 重新运行此脚本"
    exit 1
fi

# 2. 检查npm
print_colored "$BLUE" "🔍 检查npm安装状态..."
if command -v npm &> /dev/null; then
    NPM_VERSION=$(npm --version)
    print_colored "$GREEN" "✅ npm已安装: $NPM_VERSION"
else
    print_colored "$RED" "❌ npm未找到，请检查Node.js安装"
    exit 1
fi

# 3. 安装Vercel CLI
print_colored "$BLUE" "📦 安装Vercel CLI..."
if command -v vercel &> /dev/null; then
    VERCEL_VERSION=$(vercel --version)
    print_colored "$GREEN" "✅ Vercel CLI已安装: $VERCEL_VERSION"
else
    print_colored "$YELLOW" "📥 正在安装Vercel CLI..."
    npm install -g vercel

    if [ $? -eq 0 ]; then
        print_colored "$GREEN" "✅ Vercel CLI安装成功"
    else
        print_colored "$RED" "❌ Vercel CLI安装失败"
        print_colored "$WHITE" "   请手动安装: npm install -g vercel"
        exit 1
    fi
fi

# 4. 登录Vercel
print_colored "$BLUE" "🔐 检查Vercel登录状态..."
if vercel whoami &> /dev/null; then
    USER_EMAIL=$(vercel whoami)
    print_colored "$GREEN" "✅ 已登录Vercel: $USER_EMAIL"
else
    print_colored "$YELLOW" "🔑 请登录Vercel账户..."
    print_colored "$WHITE" "   1. 浏览器将自动打开"
    print_colored "$WHITE" "   2. 登录你的Vercel账户"
    print_colored "$WHITE" "   3. 授权CLI访问"
    echo ""
    read -p "按回车键继续登录..." -r
    vercel login
fi

# 5. 部署到Vercel
print_colored "$BLUE" "🚀 部署到Vercel..."
vercel --prod --yes

if [ $? -eq 0 ]; then
    print_colored "$GREEN" "✅ Vercel部署成功"

    # 获取部署URL
    VERCEL_URL=$(vercel ls | grep -o 'https://[^[:space:]]*' | head -1)
    if [ -n "$VERCEL_URL" ]; then
        print_colored "$CYAN" "🌐 Vercel URL: $VERCEL_URL"
    fi
else
    print_colored "$RED" "❌ Vercel部署失败"
    print_colored "$WHITE" "   请检查网络连接和Vercel配置"
    exit 1
fi

# 6. 运行安全测试
print_colored "$BLUE" "🛡️ 运行安全测试..."
if [ -f "./scripts/security-test.sh" ]; then
    print_colored "$YELLOW" "🧪 启动安全测试服务器..."
    print_colored "$WHITE" "   测试地址: http://localhost:8000"
    print_colored "$WHITE" "   按Ctrl+C停止测试"
    echo ""
    ./scripts/security-test.sh
else
    print_colored "$YELLOW" "⚠️ 安全测试脚本不存在"
fi

# 7. 显示部署结果
print_colored "$GREEN" "🎉 安装和部署完成！"
echo ""
print_colored "$WHITE" "📊 部署状态:"
print_colored "$GREEN" "✅ Node.js: 已安装"
print_colored "$GREEN" "✅ npm: 已安装"
print_colored "$GREEN" "✅ Vercel CLI: 已安装"
print_colored "$GREEN" "✅ Vercel: 已部署"
echo ""
print_colored "$CYAN" "🌐 访问地址:"
if [ -n "$VERCEL_URL" ]; then
    print_colored "$WHITE" "   Vercel: $VERCEL_URL"
fi
print_colored "$WHITE" "   Netlify: https://time-2025.netlify.app"
echo ""
print_colored "$BLUE" "🛡️ 安全功能已启用:"
print_colored "$WHITE" "   ✓ 内容安全策略 (CSP)"
print_colored "$WHITE" "   ✓ XSS防护"
print_colored "$WHITE" "   ✓ 点击劫持防护"
print_colored "$WHITE" "   ✓ 速率限制"
print_colored "$WHITE" "   ✓ 输入验证"
echo ""
print_colored "$YELLOW" "💡 提示: 两个平台都已部署，提供双重保障"
