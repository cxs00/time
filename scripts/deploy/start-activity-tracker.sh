#!/bin/bash
# 启动 Activity Tracker 应用

echo "🚀 启动 Activity Tracker..."

# 检查端口占用
PORT=8000
if lsof -i :$PORT -t >/dev/null 2>&1; then
    echo "⚠️  端口 $PORT 已被占用"
    echo "正在尝试使用端口 8001..."
    PORT=8001
fi

if lsof -i :$PORT -t >/dev/null 2>&1; then
    echo "⚠️  端口 $PORT 也被占用"
    echo "正在尝试使用端口 8002..."
    PORT=8002
fi

if lsof -i :$PORT -t >/dev/null 2>&1; then
    echo "❌ 端口 8000, 8001, 8002 都被占用"
    echo "请手动停止其他服务或选择其他端口"
    exit 1
fi

echo "✅ 使用端口: $PORT"
echo "🌐 访问地址: http://localhost:$PORT/activity-tracker.html"
echo ""
echo "按 Ctrl+C 停止服务器"
echo "================================="

# 启动服务器
python3 -m http.server $PORT

