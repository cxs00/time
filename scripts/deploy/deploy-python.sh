#!/bin/bash
# 使用Python的部署方案（无需Node.js）

echo "🐍 Python部署方案开始..."
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
    git commit -m "🐍 Python部署: 添加Python部署方案 - $(date '+%Y-%m-%d %H:%M:%S')"
fi

# 2. 运行版本升级
print_colored "$BLUE" "📈 运行智能版本升级..."
if [ -f "./scripts/smart-auto-version.sh" ]; then
    ./scripts/smart-auto-version.sh
else
    print_colored "$YELLOW" "⚠️ 版本升级脚本不存在，跳过"
fi

# 3. 尝试推送到GitHub
print_colored "$BLUE" "📤 尝试推送到GitHub..."
if git push origin main; then
    print_colored "$GREEN" "✅ GitHub推送成功"
    print_colored "$CYAN" "🌐 Netlify自动部署中: https://time-2025.netlify.app"
else
    print_colored "$YELLOW" "⚠️ GitHub推送失败，使用本地部署"
fi

# 4. 启动本地服务器
print_colored "$BLUE" "🔍 启动本地服务器..."
PORT=8000

# 检查端口是否被占用
while lsof -Pi :$PORT -sTCP:LISTEN -t >/dev/null 2>&1; do
    PORT=$((PORT + 1))
done

print_colored "$GREEN" "✅ 启动本地服务器 (端口 $PORT)..."
python3 -m http.server $PORT &
SERVER_PID=$!

# 等待服务器启动
sleep 2

# 5. 显示部署结果
print_colored "$GREEN" "🎉 Python部署完成！"
echo ""
print_colored "$WHITE" "📊 部署状态:"
if git push origin main &>/dev/null; then
    print_colored "$GREEN" "✅ GitHub: 已推送"
    print_colored "$GREEN" "✅ Netlify: 自动部署中"
else
    print_colored "$YELLOW" "⚠️ GitHub: 推送失败（网络问题）"
    print_colored "$YELLOW" "⚠️ Netlify: 需要网络恢复后推送"
fi
print_colored "$GREEN" "✅ 本地服务器: 已启动"
echo ""
print_colored "$CYAN" "🌐 访问地址:"
print_colored "$WHITE" "   本地测试: http://localhost:$PORT"
if git push origin main &>/dev/null; then
    print_colored "$WHITE" "   Netlify: https://time-2025.netlify.app"
fi
echo ""
print_colored "$BLUE" "🛡️ 安全功能已启用:"
print_colored "$WHITE" "   ✓ 内容安全策略 (CSP)"
print_colored "$WHITE" "   ✓ XSS防护"
print_colored "$WHITE" "   ✓ 点击劫持防护"
print_colored "$WHITE" "   ✓ 速率限制"
print_colored "$WHITE" "   ✓ 输入验证"
echo ""
print_colored "$YELLOW" "💡 提示:"
print_colored "$WHITE" "   1. 本地测试: 访问 http://localhost:$PORT"
print_colored "$WHITE" "   2. 停止服务器: 按Ctrl+C"
print_colored "$WHITE" "   3. 网络恢复后: 运行 git push origin main"
echo ""
print_colored "$CYAN" "🧪 安全测试:"
print_colored "$WHITE" "   1. 打开浏览器访问 http://localhost:$PORT"
print_colored "$WHITE" "   2. 按F12打开开发者工具"
print_colored "$WHITE" "   3. 查看Console标签页的安全日志"
print_colored "$WHITE" "   4. 检查Network标签页的响应头"

# 等待用户中断
trap "kill $SERVER_PID 2>/dev/null; echo ''; print_colored '$GREEN' '✅ 服务器已停止'; exit 0" INT

# 保持服务器运行
while true; do
    sleep 1
done
