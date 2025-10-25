#!/bin/bash

# TIME Activity Tracker - 快速启动脚本
# 版本: v2.1.0
# 创建时间: 2025-01-27

set -e

echo "🚀 TIME Activity Tracker - 快速启动脚本"
echo "========================================"
echo ""

# 检查环境
echo "🔍 检查开发环境..."

# 检查Python
if command -v python3 &> /dev/null; then
    echo "✅ Python 3: $(python3 --version)"
else
    echo "❌ Python 3 未安装，请先安装Python 3"
    exit 1
fi

# 检查Xcode
if command -v xcodebuild &> /dev/null; then
    echo "✅ Xcode: $(xcodebuild -version | head -n1)"
else
    echo "❌ Xcode 未安装，请先安装Xcode"
    exit 1
fi

# 检查Git
if command -v git &> /dev/null; then
    echo "✅ Git: $(git --version)"
else
    echo "❌ Git 未安装，请先安装Git"
    exit 1
fi

echo ""
echo "🎯 选择启动方式:"
echo "1) Web版本 (最简单)"
echo "2) iOS模拟器"
echo "3) macOS应用"
echo "4) 全部启动"
echo ""

read -p "请选择 (1-4): " choice

case $choice in
    1)
        echo ""
        echo "🌐 启动Web版本..."
        echo "启动本地服务器在端口8000..."
        python3 -m http.server 8000 &
        SERVER_PID=$!
        echo "✅ 服务器已启动 (PID: $SERVER_PID)"
        echo "📱 打开浏览器访问: http://localhost:8000/src/html/activity-tracker.html"
        echo ""
        echo "按 Ctrl+C 停止服务器"
        wait $SERVER_PID
        ;;
    2)
        echo ""
        echo "📱 启动iOS模拟器..."
        cd time/time
        echo "🔨 构建iOS应用..."
        xcodebuild build -project time.xcodeproj -scheme time -destination 'platform=iOS Simulator,name=iPhone 17' 2>&1 | tail -10
        echo "📲 安装并启动应用..."
        xcrun simctl install booted /Users/shanwanjun/Library/Developer/Xcode/DerivedData/time-axqogsrldmeweecqsagzbecqzsdb/Build/Products/Debug-iphonesimulator/TIME.app
        xcrun simctl launch booted -1.time
        echo "✅ iOS应用已启动"
        ;;
    3)
        echo ""
        echo "💻 启动macOS应用..."
        cd time/time
        echo "🔨 构建macOS应用..."
        xcodebuild build -project time.xcodeproj -scheme time -destination 'platform=macOS' 2>&1 | tail -5
        echo "🚀 启动应用..."
        open /Users/shanwanjun/Library/Developer/Xcode/DerivedData/time-axqogsrldmeweecqsagzbecqzsdb/Build/Products/Debug/TIME.app
        echo "✅ macOS应用已启动"
        ;;
    4)
        echo ""
        echo "🚀 启动全部版本..."
        
        # 启动Web版本
        echo "🌐 启动Web版本..."
        python3 -m http.server 8000 &
        WEB_PID=$!
        echo "✅ Web服务器已启动 (PID: $WEB_PID)"
        
        # 启动iOS版本
        echo "📱 启动iOS模拟器..."
        cd time/time
        xcodebuild build -project time.xcodeproj -scheme time -destination 'platform=iOS Simulator,name=iPhone 17' 2>&1 | tail -10
        xcrun simctl install booted /Users/shanwanjun/Library/Developer/Xcode/DerivedData/time-axqogsrldmeweecqsagzbecqzsdb/Build/Products/Debug-iphonesimulator/TIME.app
        xcrun simctl launch booted -1.time
        echo "✅ iOS应用已启动"
        
        # 启动macOS版本
        echo "💻 启动macOS应用..."
        xcodebuild build -project time.xcodeproj -scheme time -destination 'platform=macOS' 2>&1 | tail -5
        open /Users/shanwanjun/Library/Developer/Xcode/DerivedData/time-axqogsrldmeweecqsagzbecqzsdb/Build/Products/Debug/TIME.app
        echo "✅ macOS应用已启动"
        
        echo ""
        echo "🎉 所有版本已启动！"
        echo "📱 Web版本: http://localhost:8000/src/html/activity-tracker.html"
        echo "📱 iOS模拟器: 已启动"
        echo "💻 macOS应用: 已启动"
        echo ""
        echo "按 Ctrl+C 停止Web服务器"
        wait $WEB_PID
        ;;
    *)
        echo "❌ 无效选择，请重新运行脚本"
        exit 1
        ;;
esac

echo ""
echo "🎉 启动完成！"
echo "📖 查看 QUICK_START.md 获取更多信息"
echo "📚 查看 PROJECT_HISTORY_VERSION.md 了解项目历史"