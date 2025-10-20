#!/bin/bash

# TIME App 自动化测试脚本
# 自动编译并在iOS模拟器和Mac上运行

echo "🚀 TIME App 自动化测试脚本"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# 进入项目目录
cd "$(dirname "$0")/time"

# 检查Xcode项目
if [ ! -f "time.xcodeproj/project.pbxproj" ]; then
    echo "❌ 错误：未找到Xcode项目文件"
    exit 1
fi

echo "📱 TIME App 调试选项："
echo ""
echo "1. iPhone 15 Pro 模拟器"
echo "2. iPhone SE (小屏幕测试)"
echo "3. iPad Pro (平板测试)"
echo "4. My Mac (Mac应用)"
echo "5. 打开Xcode手动选择"
echo ""
read -p "请选择 (1-5): " choice

case $choice in
    1)
        echo ""
        echo "📱 正在启动 iPhone 15 Pro 模拟器..."
        xcodebuild -project time.xcodeproj \
                   -scheme time \
                   -destination 'platform=iOS Simulator,name=iPhone 15 Pro' \
                   -quiet \
                   build
        
        echo "✅ 编译完成，正在运行..."
        xcrun simctl boot "iPhone 15 Pro" 2>/dev/null || true
        open -a Simulator
        xcrun simctl install booted time.app 2>/dev/null || true
        xcrun simctl launch booted com.yourcompany.time
        ;;
    2)
        echo ""
        echo "📱 正在启动 iPhone SE 模拟器..."
        xcodebuild -project time.xcodeproj \
                   -scheme time \
                   -destination 'platform=iOS Simulator,name=iPhone SE (3rd generation)' \
                   -quiet \
                   build
        
        echo "✅ 编译完成，正在运行..."
        xcrun simctl boot "iPhone SE (3rd generation)" 2>/dev/null || true
        open -a Simulator
        ;;
    3)
        echo ""
        echo "📱 正在启动 iPad Pro 模拟器..."
        xcodebuild -project time.xcodeproj \
                   -scheme time \
                   -destination 'platform=iOS Simulator,name=iPad Pro (12.9-inch) (6th generation)' \
                   -quiet \
                   build
        
        echo "✅ 编译完成，正在运行..."
        open -a Simulator
        ;;
    4)
        echo ""
        echo "💻 正在编译Mac版本..."
        xcodebuild -project time.xcodeproj \
                   -scheme time \
                   -destination 'platform=macOS' \
                   build
        
        echo "✅ 编译完成"
        echo "💡 请在Xcode中运行Mac版本"
        ;;
    5)
        echo ""
        echo "🔧 正在打开Xcode..."
        open time.xcodeproj
        echo "✅ Xcode已打开，请手动选择设备并运行"
        ;;
    *)
        echo ""
        echo "❌ 无效选择，正在打开Xcode..."
        open time.xcodeproj
        ;;
esac

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "📊 测试要点："
echo "   ✓ 检查Logo是⏰（不是🍅）"
echo "   ✓ 检查标题是TIME（不是番茄时钟）"
echo "   ✓ 检查主色是紫色（不是红色）"
echo "   ✓ 检查导航有[统计][分析][设置]"
echo "   ✓ 点击'分析'查看5个图表"
echo ""
echo "🐛 如果显示异常："
echo "   1. 停止运行 (Cmd + .)"
echo "   2. Clean Build Folder (Cmd + Shift + K)"
echo "   3. 重新运行 (Cmd + R)"
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

