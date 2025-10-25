#!/bin/bash

# ==================== Activity Tracker 演示数据展示启动脚本 ====================

echo "🎬 Activity Tracker 演示数据展示"
echo "================================="

# 检查必要文件
echo "📁 检查演示文件..."
if [ ! -f "src/html/demo-with-data.html" ]; then
    echo "❌ 演示页面不存在"
    exit 1
fi

if [ ! -f "scripts/demo/create-demo-data.js" ]; then
    echo "❌ 演示数据生成器不存在"
    exit 1
fi

echo "✅ 演示文件检查完成"

# 启动本地服务器
echo "🚀 启动演示服务器..."
PORT=9003

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

# 打开演示页面
echo "🌐 打开演示数据展示页面..."
if command -v open > /dev/null; then
    open "http://localhost:$PORT/src/html/demo-with-data.html"
elif command -v xdg-open > /dev/null; then
    xdg-open "http://localhost:$PORT/src/html/demo-with-data.html"
else
    echo "请手动打开: http://localhost:$PORT/src/html/demo-with-data.html"
fi

echo ""
echo "🎯 演示数据展示说明:"
echo "  - 页面将显示完整的Activity Tracker功能演示"
echo "  - 包含15条活动记录数据"
echo "  - 包含3个项目管理示例"
echo "  - 包含5篇心情日记"
echo "  - 包含5条待办事项"
echo "  - 显示数据可视化图表"
echo "  - 展示AI智能分类效果"
echo ""
echo "📊 演示数据特点:"
echo "  🤖 AI智能分类: 自动识别活动类型"
echo "  📈 数据可视化: 活动分布饼图"
echo "  🎯 项目管理: 进度条和里程碑"
echo "  📖 心情记录: 日记和标签系统"
echo "  📋 任务管理: 待办事项和优先级"
echo ""
echo "🛑 按 Ctrl+C 停止演示服务器"

# 等待用户中断
trap "echo ''; echo '🛑 停止演示服务器...'; kill $SERVER_PID 2>/dev/null; echo '✅ 演示完成'; exit 0" INT

# 保持服务器运行
while true; do
    sleep 1
done
