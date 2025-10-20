#!/bin/bash

echo "🚀 正在配置iOS番茄时钟App..."
echo ""

cd "$(dirname "$0")/time"

# 检查文件是否存在
echo "✅ 检查文件..."
if [ -f "time/PomodoroWebView.swift" ]; then
    echo "   ✓ PomodoroWebView.swift 已创建"
else
    echo "   ✗ PomodoroWebView.swift 未找到"
    exit 1
fi

if [ -d "time/Web" ]; then
    echo "   ✓ Web文件夹已创建"
    echo "   ✓ 包含文件:"
    ls -la time/Web/ | grep -E "(index.html|css|js)" | awk '{print "     -", $NF}'
else
    echo "   ✗ Web文件夹未找到"
    exit 1
fi

echo ""
echo "📱 准备在Xcode中打开项目..."
echo ""
echo "⚠️  请在Xcode中手动完成以下步骤："
echo ""
echo "1️⃣  添加Web文件夹:"
echo "   • 右键点击左侧的 'time' 文件夹"
echo "   • 选择 'Add Files to \"time\"...'"
echo "   • 选择 'time/Web' 文件夹"
echo "   • ⚠️ 重要: 选择 'Create folder references' (蓝色文件夹)"
echo "   • 确保勾选 'Add to targets: time'"
echo "   • 点击 'Add'"
echo ""
echo "2️⃣  添加Swift文件:"
echo "   • 右键点击 'time' 文件夹"
echo "   • 'Add Files to \"time\"...'"
echo "   • 选择 'PomodoroWebView.swift'"
echo "   • 点击 'Add'"
echo ""
echo "3️⃣  运行App:"
echo "   • 选择 iPhone 模拟器"
echo "   • 点击 ▶️ 按钮"
echo "   • 等待编译完成"
echo ""

# 打开Xcode
echo "🔧 正在打开Xcode..."
open time.xcodeproj

echo ""
echo "✨ Xcode已打开！请按照上面的步骤操作。"
echo ""

