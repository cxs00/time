#!/bin/bash

echo "🔧 修复 Web 资源配置..."

# 1. 打开 Xcode 项目
open time.xcodeproj

echo ""
echo "╔══════════════════════════════════════════════════════════════╗"
echo "║  📝 请在 Xcode 中执行以下步骤：                              ║"
echo "╚══════════════════════════════════════════════════════════════╝"
echo ""
echo "1️⃣  在左侧项目导航器中，找到 time 文件夹"
echo ""
echo "2️⃣  右键点击 time 文件夹 → Add Files to \"time\"..."
echo ""
echo "3️⃣  选择 time/Web 文件夹"
echo ""
echo "4️⃣  ⚠️ 重要：勾选以下选项"
echo "    ✅ Copy items if needed"
echo "    ✅ Create folder references (选择蓝色文件夹，不是黄色)"
echo "    ✅ Add to targets: time"
echo ""
echo "5️⃣  点击 Add"
echo ""
echo "6️⃣  验证："
echo "    • 在项目导航器中，Web 文件夹应该显示为蓝色"
echo "    • 点击项目 → time target → Build Phases → Copy Bundle Resources"
echo "    • 确认 Web 文件夹在列表中"
echo ""
echo "7️⃣  重新编译并运行"
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "完成后，按回车键继续..."
read

echo ""
echo "🚀 重新编译..."
xcodebuild -scheme time -destination 'platform=macOS' clean build

echo ""
echo "✅ 完成！现在运行应用测试"

