#!/bin/bash
# 启动Activity Tracker App

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

print_colored "$CYAN" "🚀 启动Activity Tracker App"
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

# 确保Web文件同步
print_colored "$BLUE" "🔄 同步Web文件..."
./scripts/dev/sync-xcode-web.sh

print_colored "$BLUE" "📱 启动iPhone模拟器..."

# 启动iOS模拟器
open -a Simulator

# 等待模拟器启动
sleep 3

print_colored "$BLUE" "💻 打开Xcode项目..."

# 在Xcode中打开项目
open time/time.xcodeproj

print_colored "$GREEN" "🎉 Activity Tracker App准备就绪！"
print_colored "$WHITE" ""
print_colored "$WHITE" "📱 运行状态:"
print_colored "$WHITE" "  - iPhone模拟器: 已启动"
print_colored "$WHITE" "  - Xcode项目: 已打开"
print_colored "$WHITE" "  - Web文件: 已同步"
print_colored "$WHITE" ""
print_colored "$WHITE" "🎯 下一步操作:"
print_colored "$WHITE" "  1. 在Xcode中选择iPhone模拟器"
print_colored "$WHITE" "  2. 点击运行按钮 (▶️)"
print_colored "$WHITE" "  3. 等待应用在模拟器中启动"
print_colored "$WHITE" "  4. 体验Activity Tracker功能"
print_colored "$WHITE" ""
print_colored "$WHITE" "💡 应用功能:"
print_colored "$WHITE" "  - 智能活动记录"
print_colored "$WHITE" "  - 项目进度管理"
print_colored "$WHITE" "  - 数据可视化"
print_colored "$WHITE" "  - 日记与备忘录"
print_colored "$WHITE" "  - 设置管理"
print_colored "$WHITE" ""
print_colored "$GREEN" "🎉 现在可以在Xcode中运行Activity Tracker了！"
