#!/bin/bash
# 运行Activity Tracker App

# 颜色定义
GREEN='\033[0;32m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

print_colored() {
    local color="$1"
    local message="$2"
    echo -e "${color}${message}${NC}"
}

print_colored "$CYAN" "🚀 运行Activity Tracker App"
print_colored "$CYAN" "================================="

# 检查Xcode是否安装
if ! command -v xcodebuild &> /dev/null; then
    print_colored "$RED" "❌ 未找到Xcode，请先安装Xcode"
    exit 1
fi

# 检查项目文件
if [ ! -f "time/time.xcodeproj/project.pbxproj" ]; then
    print_colored "$RED" "❌ 未找到Xcode项目文件"
    exit 1
fi

print_colored "$GREEN" "✅ Xcode项目文件存在"

# 进入项目目录
cd time

print_colored "$BLUE" "🔧 检查项目状态..."

# 检查Web文件
if [ -f "time/Web/activity-tracker.html" ]; then
    print_colored "$GREEN" "✅ Web文件已同步"
else
    print_colored "$YELLOW" "⚠️  Web文件未同步，正在同步..."
    cd ..
    ./scripts/dev/sync-xcode-web.sh
    cd time
fi

print_colored "$BLUE" "📱 启动iPhone模拟器..."

# 启动iOS模拟器
open -a Simulator

# 等待模拟器启动
sleep 3

print_colored "$BLUE" "💻 启动macOS应用..."

# 在macOS中运行应用
xcodebuild run -project time.xcodeproj -scheme time -destination 'platform=macOS' -configuration Debug &

# 等待应用启动
sleep 5

print_colored "$GREEN" "🎉 Activity Tracker App已启动！"
print_colored "$WHITE" ""
print_colored "$WHITE" "📱 运行状态:"
print_colored "$WHITE" "  - iPhone模拟器: 已启动"
print_colored "$WHITE" "  - macOS应用: 已启动"
print_colored "$WHITE" "  - Web文件: 已同步"
print_colored "$WHITE" ""
print_colored "$WHITE" "🎯 应用功能:"
print_colored "$WHITE" "  - 智能活动记录"
print_colored "$WHITE" "  - 项目进度管理"
print_colored "$WHITE" "  - 数据可视化"
print_colored "$WHITE" "  - 日记与备忘录"
print_colored "$WHITE" "  - 设置管理"
print_colored "$WHITE" ""
print_colored "$WHITE" "💡 使用说明:"
print_colored "$WHITE" "  - iPhone模拟器: 查看移动端体验"
print_colored "$WHITE" "  - macOS应用: 查看桌面端体验"
print_colored "$WHITE" "  - 两个版本都使用相同的Web内容"
print_colored "$WHITE" ""
print_colored "$GREEN" "🎉 现在可以体验Activity Tracker的完整功能了！"

# 返回原目录
cd ..
