#!/bin/bash

# ==================== Activity Tracker 功能测试启动脚本 ====================

echo "🧪 Activity Tracker 功能测试启动"
echo "================================="

# 检查必要文件
echo "📁 检查测试环境..."
if [ ! -f "src/html/functionality-test.html" ]; then
    echo "❌ 测试页面不存在"
    exit 1
fi

if [ ! -f "src/js/ai-classifier.js" ]; then
    echo "❌ AI分类器文件不存在"
    exit 1
fi

if [ ! -f "src/js/activity-tracker.js" ]; then
    echo "❌ 活动记录器文件不存在"
    exit 1
fi

echo "✅ 测试环境检查完成"

# 启动本地服务器
echo "🚀 启动测试服务器..."
PORT=9002

# 检查端口是否被占用
while lsof -i :$PORT > /dev/null 2>&1; do
    echo "⚠️  端口 $PORT 被占用，尝试下一个端口..."
    PORT=$((PORT + 1))
done

echo "📡 在端口 $PORT 启动服务器..."

# 启动Python HTTP服务器
python3 -m http.server $PORT > /dev/null 2>&1 &
SERVER_PID=$!

# 等待服务器启动
sleep 2

# 检查服务器是否启动成功
if ! curl -s http://localhost:$PORT > /dev/null; then
    echo "❌ 服务器启动失败"
    kill $SERVER_PID 2>/dev/null
    exit 1
fi

echo "✅ 服务器启动成功 (PID: $SERVER_PID)"

# 打开测试页面
echo "🌐 打开功能测试页面..."
if command -v open > /dev/null; then
    open "http://localhost:$PORT/src/html/functionality-test.html"
elif command -v xdg-open > /dev/null; then
    xdg-open "http://localhost:$PORT/src/html/functionality-test.html"
else
    echo "请手动打开: http://localhost:$PORT/src/html/functionality-test.html"
fi

echo ""
echo "🎯 测试说明:"
echo "  - 页面将自动加载所有Activity Tracker功能"
echo "  - 点击各个测试按钮进行功能验证"
echo "  - 使用'运行所有测试'进行完整测试"
echo "  - 查看测试结果和统计信息"
echo ""
echo "📊 测试项目:"
echo "  🤖 AI智能分类器 (关键词、历史、时间上下文)"
echo "  📝 活动记录功能 (开始/结束、计时、存储)"
echo "  🎯 项目管理 (创建、进度、里程碑)"
echo "  📊 数据可视化 (图表、统计、导出)"
echo "  📖 日记功能 (创建、备忘录、搜索)"
echo "  ⚡ 性能测试 (响应时间、内存、并发)"
echo ""
echo "🛑 按 Ctrl+C 停止测试服务器"

# 等待用户中断
trap "echo ''; echo '🛑 停止测试服务器...'; kill $SERVER_PID 2>/dev/null; echo '✅ 测试完成'; exit 0" INT

# 保持服务器运行
while true; do
    sleep 1
done
