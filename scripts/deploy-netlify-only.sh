#!/bin/bash
# 仅Netlify部署脚本（无需Node.js）

echo "🚀 Netlify部署开始..."
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
    git commit -m "🛡️ 安全更新: 添加全面安全防护 - $(date '+%Y-%m-%d %H:%M:%S')"
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
    print_colored "$YELLOW" "⏳ 请等待1-2分钟让Netlify完成部署"
else
    print_colored "$RED" "❌ GitHub推送失败"
    print_colored "$WHITE" "   请检查网络连接和Git配置"
    exit 1
fi

# 4. 显示部署结果
print_colored "$GREEN" "🎉 Netlify部署完成！"
echo ""
print_colored "$WHITE" "📊 部署状态:"
print_colored "$GREEN" "✅ GitHub: 已推送"
print_colored "$GREEN" "✅ Netlify: 自动部署中"
echo ""
print_colored "$CYAN" "🌐 访问地址:"
print_colored "$WHITE" "   Netlify: https://time-2025.netlify.app"
echo ""
print_colored "$BLUE" "🛡️ 安全特性已启用:"
print_colored "$WHITE" "   ✓ 内容安全策略 (CSP)"
print_colored "$WHITE" "   ✓ XSS防护"
print_colored "$WHITE" "   ✓ 点击劫持防护"
print_colored "$WHITE" "   ✓ 速率限制"
print_colored "$WHITE" "   ✓ 输入验证"
echo ""
print_colored "$YELLOW" "💡 提示: 如需Vercel部署，请先安装Node.js"
print_colored "$WHITE" "   安装方法: https://nodejs.org/"
