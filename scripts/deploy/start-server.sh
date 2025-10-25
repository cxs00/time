#!/bin/bash
# 启动HTTP服务器（使用高端口避免冲突）

# 颜色定义
GREEN='\033[0;32m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

print_colored() {
    local color="$1"
    local message="$2"
    echo -e "${color}${message}${NC}"
}

# 查找可用端口
find_available_port() {
    local port=9000
    while lsof -i :$port > /dev/null 2>&1; do
        port=$((port + 1))
        if [ $port -gt 9999 ]; then
            print_colored "$RED" "❌ 无法找到可用端口"
            exit 1
        fi
    done
    echo $port
}

PORT=$(find_available_port)

print_colored "$CYAN" "🌐 启动HTTP服务器"
print_colored "$CYAN" "================================="

# 检查Python是否可用
if command -v python3 &> /dev/null; then
    PYTHON_CMD="python3"
elif command -v python &> /dev/null; then
    PYTHON_CMD="python"
else
    print_colored "$RED" "❌ 未找到Python，请安装Python后重试"
    exit 1
fi

print_colored "$BLUE" "🚀 启动服务器 (端口: $PORT)..."

# 启动服务器
$PYTHON_CMD -m http.server $PORT --directory . &
SERVER_PID=$!

# 等待服务器启动
sleep 2

# 检查服务器是否启动成功
if ps -p $SERVER_PID > /dev/null; then
    print_colored "$GREEN" "✅ 服务器启动成功！"
    print_colored "$WHITE" ""
    print_colored "$WHITE" "📱 访问地址:"
    print_colored "$WHITE" "  界面展示: http://localhost:$PORT/src/html/interface-showcase.html"
    print_colored "$WHITE" "  主应用: http://localhost:$PORT/src/html/activity-tracker.html"
    print_colored "$WHITE" "  功能演示: http://localhost:$PORT/src/html/demo-activity-tracker.html"
    print_colored "$WHITE" ""
    print_colored "$WHITE" "🎯 功能说明:"
    print_colored "$WHITE" "  - 查看所有界面设计"
    print_colored "$WHITE" "  - 桌面端和移动端对比"
    print_colored "$WHITE" "  - 功能特性介绍"
    print_colored "$WHITE" "  - 交互式界面展示"
    print_colored "$WHITE" ""
    print_colored "$GREEN" "🎉 HTTP服务器已启动！"
    print_colored "$WHITE" ""
    print_colored "$WHITE" "按 Ctrl+C 停止服务器"

    # 自动打开浏览器
    if command -v open &> /dev/null; then
        open "http://localhost:$PORT/src/html/interface-showcase.html"
    elif command -v xdg-open &> /dev/null; then
        xdg-open "http://localhost:$PORT/src/html/interface-showcase.html"
    fi

    # 等待用户中断
    trap "print_colored '$GREEN' '🛑 正在停止服务器...'; kill $SERVER_PID; exit 0" INT
    wait $SERVER_PID
else
    print_colored "$RED" "❌ 服务器启动失败"
    exit 1
fi
