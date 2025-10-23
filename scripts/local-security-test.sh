#!/bin/bash
# 本地安全测试脚本

echo "🛡️ 本地安全测试开始..."
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

# 检查端口是否被占用
check_port() {
    local port=$1
    if lsof -Pi :$port -sTCP:LISTEN -t >/dev/null ; then
        print_colored "$YELLOW" "⚠️ 端口 $port 已被占用，尝试使用端口 $((port+1))"
        return $((port+1))
    else
        return $port
    fi
}

# 启动本地服务器
start_server() {
    local port=8000
    check_port $port
    port=$?

    print_colored "$BLUE" "🔍 启动本地测试服务器 (端口 $port)..."

    # 启动服务器
    python3 -m http.server $port &
    SERVER_PID=$!

    # 等待服务器启动
    sleep 2

    # 检查服务器是否启动成功
    if ps -p $SERVER_PID > /dev/null; then
        print_colored "$GREEN" "✅ 本地服务器已启动: http://localhost:$port"
        return $port
    else
        print_colored "$RED" "❌ 服务器启动失败"
        exit 1
    fi
}

# 显示安全测试信息
show_security_info() {
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
}

# 显示测试步骤
show_test_steps() {
    print_colored "$YELLOW" "📋 手动测试步骤:"
    echo ""
    print_colored "$WHITE" "1. 打开浏览器访问 http://localhost:$1"
    print_colored "$WHITE" "2. 按F12打开开发者工具"
    print_colored "$WHITE" "3. 查看Console标签页的安全日志"
    print_colored "$WHITE" "4. 检查Network标签页的响应头"
    print_colored "$WHITE" "5. 尝试在控制台执行恶意脚本"
    echo ""
    print_colored "$GREEN" "✅ 安全测试环境已准备就绪"
    print_colored "$YELLOW" "💡 提示: 测试完成后按Ctrl+C停止服务器"
}

# 主函数
main() {
    # 启动服务器
    start_server
    local port=$?

    # 显示安全信息
    show_security_info

    # 显示测试地址
    print_colored "$CYAN" "🔗 测试地址:"
    print_colored "$WHITE" "   主应用: http://localhost:$port"
    print_colored "$WHITE" "   安全测试: http://localhost:$port?test=security"
    echo ""

    # 显示测试步骤
    show_test_steps $port

    # 等待用户中断
    trap "kill $SERVER_PID 2>/dev/null; echo ''; print_colored '$GREEN' '✅ 测试服务器已停止'; exit 0" INT

    # 保持服务器运行
    while true; do
        sleep 1
    done
}

# 运行主函数
main
