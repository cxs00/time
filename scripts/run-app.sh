#!/bin/bash

echo "========================================="
echo "🚀 番茄钟iOS App启动脚本"
echo "========================================="
echo ""

# 1. 清理环境
echo "📦 步骤1: 清理环境..."
killall -9 Simulator 2>/dev/null
rm -rf ~/Library/Developer/Xcode/DerivedData/time-* 2>/dev/null
rm -rf /var/folders/*/C/-1.time 2>/dev/null
echo "✅ 环境已清理"
echo ""

# 2. 打开Xcode项目
echo "📝 步骤2: 打开Xcode项目..."
open /Users/shanwanjun/Desktop/cxs/time/time/time.xcodeproj
sleep 3
echo "✅ Xcode已打开"
echo ""

# 3. 等待用户在Xcode中操作
echo "========================================="
echo "📱 请在Xcode中进行以下操作："
echo "========================================="
echo ""
echo "1️⃣ 选择设备："
echo "   顶部工具栏 → 选择 'iPhone 16e' 或其他iPhone模拟器"
echo ""
echo "2️⃣ 运行App："
echo "   点击运行按钮 (▶️) 或按 ⌘+R"
echo ""
echo "3️⃣ 如果看到错误："
echo "   Product → Clean Build Folder (⌘+Shift+K)"
echo "   然后重新运行 (⌘+R)"
echo ""
echo "========================================="
echo "💡 提示："
echo "========================================="
echo ""
echo "• 如果仍然黑屏，检查Xcode控制台输出"
echo "• 查找 '✅ 成功加载本地HTML文件' 消息"
echo "• 或者查找 '❌' 错误消息"
echo ""
echo "• Xcode控制台位置："
echo "  底部面板 → 右侧图标 → 显示调试区域 (⌘+Shift+Y)"
echo ""
echo "========================================="
echo "✨ 准备就绪！请在Xcode中运行App"
echo "========================================="

