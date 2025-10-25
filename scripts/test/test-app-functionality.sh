#!/bin/bash

# ==================== Activity Tracker 应用功能测试 ====================

echo "🧪 Activity Tracker 应用功能测试"
echo "================================="

# 检查应用运行状态
echo "📱 检查应用运行状态..."
IPHONE_PID=$(ps aux | grep -i "TIME.app" | grep -v grep | awk '{print $2}' | head -1)
MACOS_PID=$(ps aux | grep -i "TIME.app" | grep -v grep | awk '{print $2}' | tail -1)

if [ ! -z "$IPHONE_PID" ]; then
    echo "✅ iPhone应用正在运行 (PID: $IPHONE_PID)"
else
    echo "❌ iPhone应用未运行"
fi

if [ ! -z "$MACOS_PID" ]; then
    echo "✅ macOS应用正在运行 (PID: $MACOS_PID)"
else
    echo "❌ macOS应用未运行"
fi

echo ""

# 检查应用包内容
echo "📁 检查应用包内容..."
echo "iPhone应用包文件:"
ls -la /Users/shanwanjun/Library/Developer/Xcode/DerivedData/time-axqogsrldmeweecqsagzbecqzsdb/Build/Products/Debug-iphonesimulator/TIME.app/ | grep -E "\.(html|js|css)$" | head -5

echo ""
echo "macOS应用包文件:"
ls -la /Users/shanwanjun/Library/Developer/Xcode/DerivedData/time-axqogsrldmeweecqsagzbecqzsdb/Build/Products/Debug/TIME.app/Contents/Resources/ | grep -E "\.(html|js|css)$" | head -5

echo ""

# 检查关键文件
echo "🔍 检查关键文件..."
echo "activity-tracker.html 存在: $(if [ -f '/Users/shanwanjun/Library/Developer/Xcode/DerivedData/time-axqogsrldmeweecqsagzbecqzsdb/Build/Products/Debug-iphonesimulator/TIME.app/activity-tracker.html' ]; then echo '✅'; else echo '❌'; fi)"
echo "activity-tracker.js 存在: $(if [ -f '/Users/shanwanjun/Library/Developer/Xcode/DerivedData/time-axqogsrldmeweecqsagzbecqzsdb/Build/Products/Debug-iphonesimulator/TIME.app/activity-tracker.js' ]; then echo '✅'; else echo '❌'; fi)"
echo "ai-classifier.js 存在: $(if [ -f '/Users/shanwanjun/Library/Developer/Xcode/DerivedData/time-axqogsrldmeweecqsagzbecqzsdb/Build/Products/Debug-iphonesimulator/TIME.app/ai-classifier.js' ]; then echo '✅'; else echo '❌'; fi)"

echo ""

# 检查HTML文件内容
echo "📄 检查HTML文件内容..."
echo "JavaScript引用检查:"
grep -n "src=" /Users/shanwanjun/Library/Developer/Xcode/DerivedData/time-axqogsrldmeweecqsagzbecqzsdb/Build/Products/Debug-iphonesimulator/TIME.app/activity-tracker.html | tail -5

echo ""

# 检查CSS文件
echo "🎨 检查CSS文件..."
echo "CSS引用检查:"
grep -n "href=" /Users/shanwanjun/Library/Developer/Xcode/DerivedData/time-axqogsrldmeweecqsagzbecqzsdb/Build/Products/Debug-iphonesimulator/TIME.app/activity-tracker.html | head -3

echo ""

# 模拟器状态检查
echo "📱 检查模拟器状态..."
SIMULATOR_STATUS=$(xcrun simctl list devices | grep "iPhone 17" | grep "Booted")
if [ ! -z "$SIMULATOR_STATUS" ]; then
    echo "✅ iPhone 17模拟器已启动"
else
    echo "❌ iPhone 17模拟器未启动"
fi

echo ""

# 应用功能测试建议
echo "🎯 应用功能测试建议:"
echo "1. 在iPhone模拟器中打开Activity Tracker应用"
echo "2. 检查是否显示完整的Activity Tracker界面（不是静态界面）"
echo "3. 测试以下功能:"
echo "   - 点击'开始记录'按钮"
echo "   - 输入活动内容（如'编写代码'）"
echo "   - 查看AI智能分类是否工作"
echo "   - 测试导航栏切换功能"
echo "   - 查看统计页面是否有图表"
echo "   - 测试项目管理功能"
echo "   - 测试日记和备忘录功能"

echo ""
echo "🔧 如果应用仍显示静态界面，请检查:"
echo "1. JavaScript文件是否正确加载"
echo "2. 浏览器控制台是否有错误"
echo "3. 网络连接是否正常（用于加载ECharts）"
echo "4. 应用是否有权限访问本地文件"

echo ""
echo "📊 测试完成！请按照上述建议测试应用功能。"
