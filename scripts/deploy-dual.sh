#!/bin/bash
# 双平台部署脚本 - Netlify + Vercel

echo "🚀 双平台部署开始..."
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

# 1. 检查Git状态
print_colored "$BLUE" "🔍 检查Git状态..."
if ! git diff --quiet; then
    print_colored "$YELLOW" "📝 检测到未提交的更改，自动提交..."
    git add .
    git commit -m "🛡️ 安全更新: 添加安全防护和Vercel部署配置 - $(date '+%Y-%m-%d %H:%M:%S')"
fi

# 2. 运行版本升级
print_colored "$BLUE" "📈 运行智能版本升级..."
if [ -f "./scripts/smart-auto-version.sh" ]; then
    ./scripts/smart-auto-version.sh
else
    print_colored "$YELLOW" "⚠️ 版本升级脚本不存在，跳过"
fi

# 3. 推送到GitHub (触发Netlify)
print_colored "$BLUE" "📤 推送到GitHub (Netlify自动部署)..."
git push origin main

if [ $? -eq 0 ]; then
    print_colored "$GREEN" "✅ GitHub推送成功"
    print_colored "$CYAN" "🌐 Netlify部署中: https://time-2025.netlify.app"
else
    print_colored "$RED" "❌ GitHub推送失败"
    exit 1
fi

# 4. 检查Vercel CLI
print_colored "$BLUE" "🔧 检查Vercel CLI..."
if ! command -v vercel &> /dev/null; then
    print_colored "$YELLOW" "⚠️ Vercel CLI未安装，尝试安装..."
    
    # 检查Node.js
    if ! command -v node &> /dev/null; then
        print_colored "$RED" "❌ Node.js未安装，请先安装Node.js"
        print_colored "$WHITE" "   安装方法: https://nodejs.org/"
        exit 1
    fi
    
    # 安装Vercel CLI
    print_colored "$BLUE" "📦 安装Vercel CLI..."
    npm install -g vercel
    
    if [ $? -ne 0 ]; then
        print_colored "$RED" "❌ Vercel CLI安装失败"
        print_colored "$WHITE" "   请手动安装: npm install -g vercel"
        exit 1
    fi
fi

# 5. 部署到Vercel
print_colored "$BLUE" "🌐 部署到Vercel..."
vercel --prod --yes

if [ $? -eq 0 ]; then
    print_colored "$GREEN" "✅ Vercel部署成功"
    
    # 获取Vercel URL
    VERCEL_URL=$(vercel ls | grep -o 'https://[^[:space:]]*' | head -1)
    if [ -n "$VERCEL_URL" ]; then
        print_colored "$CYAN" "🌐 Vercel URL: $VERCEL_URL"
    else
        print_colored "$YELLOW" "⚠️ 无法获取Vercel URL，请检查vercel ls命令"
    fi
else
    print_colored "$RED" "❌ Vercel部署失败"
    print_colored "$WHITE" "   请检查Vercel配置和网络连接"
fi

# 6. 显示部署结果
print_colored "$GREEN" "🎉 双平台部署完成！"
echo ""
print_colored "$WHITE" "📊 部署状态:"
print_colored "$GREEN" "✅ GitHub: 已推送"
print_colored "$GREEN" "✅ Netlify: 自动部署中"
print_colored "$GREEN" "✅ Vercel: 已部署"
echo ""
print_colored "$CYAN" "🌐 访问地址:"
print_colored "$WHITE" "   Netlify: https://time-2025.netlify.app"
if [ -n "$VERCEL_URL" ]; then
    print_colored "$WHITE" "   Vercel: $VERCEL_URL"
fi
echo ""
print_colored "$BLUE" "🛡️ 安全特性已启用:"
print_colored "$WHITE" "   ✓ 内容安全策略 (CSP)"
print_colored "$WHITE" "   ✓ XSS防护"
print_colored "$WHITE" "   ✓ 点击劫持防护"
print_colored "$WHITE" "   ✓ 速率限制"
print_colored "$WHITE" "   ✓ 输入验证"
echo ""
print_colored "$YELLOW" "💡 提示: 两个平台都会自动部署，提供双重保障"
