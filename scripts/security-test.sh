#!/bin/bash
# 安全测试脚本

echo "🛡️ 安全测试开始..."
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

# 检查本地服务器
print_colored "$BLUE" "🔍 启动本地测试服务器..."
python3 -m http.server 8000 &
SERVER_PID=$!

# 等待服务器启动
sleep 2

print_colored "$GREEN" "✅ 本地服务器已启动: http://localhost:8000"
echo ""

# 安全测试项目
print_colored "$CYAN" "🧪 安全测试项目:"
echo ""
print_colored "$WHITE" "1. 内容安全策略 (CSP) 测试"
print_colored "$WHITE" "   - 检查CSP头部是否正确设置"
print_colored "$WHITE" "   - 验证脚本来源限制"
print_colored "$WHITE" "   - 测试内联脚本阻止"
echo ""

print_colored "$WHITE" "2. XSS防护测试"
print_colored "$WHITE" "   - 测试脚本注入防护"
print_colored "$WHITE" "   - 验证HTML转义"
print_colored "$WHITE" "   - 检查事件处理器过滤"
echo ""

print_colored "$WHITE" "3. 点击劫持防护测试"
print_colored "$WHITE" "   - 验证X-Frame-Options头部"
print_colored "$WHITE" "   - 测试iframe嵌入阻止"
echo ""

print_colored "$WHITE" "4. 速率限制测试"
print_colored "$WHITE" "   - 模拟高频请求"
print_colored "$WHITE" "   - 验证限制机制"
echo ""

print_colored "$WHITE" "5. 输入验证测试"
print_colored "$WHITE" "   - 测试恶意输入过滤"
print_colored "$WHITE" "   - 验证数据清理"
echo ""

# 提供测试URL
print_colored "$CYAN" "🔗 测试地址:"
print_colored "$WHITE" "   主应用: http://localhost:8000"
print_colored "$WHITE" "   安全测试: http://localhost:8000?test=security"
echo ""

# 浏览器测试指令
print_colored "$YELLOW" "📋 手动测试步骤:"
echo ""
print_colored "$WHITE" "1. 打开浏览器访问 http://localhost:8000"
print_colored "$WHITE" "2. 按F12打开开发者工具"
print_colored "$WHITE" "3. 查看Console标签页的安全日志"
print_colored "$WHITE" "4. 检查Network标签页的响应头"
print_colored "$WHITE" "5. 尝试在控制台执行恶意脚本"
echo ""

print_colored "$GREEN" "✅ 安全测试环境已准备就绪"
print_colored "$YELLOW" "💡 提示: 测试完成后按Ctrl+C停止服务器"

# 等待用户中断
trap "kill $SERVER_PID 2>/dev/null; echo ''; print_colored '$GREEN' '✅ 测试服务器已停止'; exit 0" INT

# 保持服务器运行
while true; do
    sleep 1
done
