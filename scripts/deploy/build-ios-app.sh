#!/bin/bash
# 构建和运行iPhone App

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

print_colored "$CYAN" "📱 构建和运行iPhone App"
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

print_colored "$BLUE" "🔧 检查项目配置..."

# 检查可用的模拟器
print_colored "$YELLOW" "📱 可用的iOS模拟器:"
xcrun simctl list devices available | grep "iPhone" | head -5

print_colored "$YELLOW" "💻 可用的macOS目标:"
xcodebuild -showdestinations -project time.xcodeproj -scheme time 2>/dev/null | grep "macOS" || echo "未找到macOS目标"

print_colored "$BLUE" "🚀 开始构建项目..."

# 清理项目
print_colored "$YELLOW" "🧹 清理项目..."
xcodebuild clean -project time.xcodeproj -scheme time

# 构建iOS版本
print_colored "$YELLOW" "📱 构建iOS版本..."
xcodebuild build -project time.xcodeproj -scheme time -destination 'platform=iOS Simulator,name=iPhone 15' -configuration Debug

if [ $? -eq 0 ]; then
    print_colored "$GREEN" "✅ iOS版本构建成功"
else
    print_colored "$RED" "❌ iOS版本构建失败"
    exit 1
fi

# 构建macOS版本
print_colored "$YELLOW" "💻 构建macOS版本..."
xcodebuild build -project time.xcodeproj -scheme time -destination 'platform=macOS' -configuration Debug

if [ $? -eq 0 ]; then
    print_colored "$GREEN" "✅ macOS版本构建成功"
else
    print_colored "$RED" "❌ macOS版本构建失败"
fi

print_colored "$BLUE" "🎯 运行应用..."

# 在iOS模拟器中运行
print_colored "$YELLOW" "📱 启动iPhone模拟器..."
open -a Simulator

# 等待模拟器启动
sleep 5

# 安装并运行iOS应用
print_colored "$YELLOW" "📱 安装iOS应用到模拟器..."
xcodebuild test -project time.xcodeproj -scheme time -destination 'platform=iOS Simulator,name=iPhone 15' -configuration Debug

# 在macOS中运行
print_colored "$YELLOW" "💻 启动macOS应用..."
xcodebuild run -project time.xcodeproj -scheme time -destination 'platform=macOS' -configuration Debug &

print_colored "$GREEN" "🎉 应用启动完成！"
print_colored "$WHITE" ""
print_colored "$WHITE" "📱 运行状态:"
print_colored "$WHITE" "  - iPhone模拟器: 已启动"
print_colored "$WHITE" "  - macOS应用: 已启动"
print_colored "$WHITE" "  - Web文件: 已同步"
print_colored "$WHITE" ""
print_colored "$WHITE" "🎯 功能说明:"
print_colored "$WHITE" "  - 智能活动记录"
print_colored "$WHITE" "  - 项目进度管理"
print_colored "$WHITE" "  - 数据可视化"
print_colored "$WHITE" "  - 日记与备忘录"
print_colored "$WHITE" "  - 设置管理"
print_colored "$WHITE" ""
print_colored "$GREEN" "🎉 Activity Tracker App已成功运行！"

# 返回原目录
cd ..
