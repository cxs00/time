#!/bin/bash

# TIME - 自动修复Xcode项目配置
# 添加Web资源到项目

echo "🔧 TIME Xcode项目自动修复脚本"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

cd "/Users/shanwanjun/Desktop/cxs/time/time"

echo "📋 问题分析："
echo "   Web文件夹存在于文件系统"
echo "   但未被添加到Xcode项目配置"
echo ""

echo "✅ 解决方案："
echo "   需要在Xcode中手动添加Web文件夹"
echo ""

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "📱 请在Xcode中操作（2分钟）："
echo ""
echo "1️⃣ 在左侧项目导航器中："
echo "   - 右键点击 'time' 文件夹"
echo "   - 选择 'Add Files to \"time\"...'"
echo ""
echo "2️⃣ 选择Web文件夹："
echo "   - 导航到: time/time/Web"
echo "   - 选中 Web 文件夹"
echo ""
echo "3️⃣ ⚠️ 重要配置："
echo "   ✅ Copy items if needed（不勾选）"
echo "   ✅ Added folders: Create folder references（选择蓝色文件夹）"
echo "   ✅ Add to targets: time（勾选）"
echo ""
echo "4️⃣ 点击 'Add' 按钮"
echo ""
echo "5️⃣ 验证添加成功："
echo "   - Web文件夹应显示为蓝色图标"
echo "   - 不能展开查看内部文件"
echo ""
echo "6️⃣ Clean并运行："
echo "   - Cmd + Shift + K (Clean)"
echo "   - Cmd + R (Run)"
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "💡 现在打开Xcode并按照上述步骤操作..."
echo ""

# 打开Xcode
open time.xcodeproj

echo "✅ Xcode已打开"
echo ""
echo "请按照上面的步骤添加Web文件夹资源！"
echo ""

