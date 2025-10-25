#!/bin/bash
# 自动同步Xcode项目中的Web文件
# 监控源文件变化并自动同步

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
NC='\033[0m'

print_colored() {
    local color="$1"
    local message="$2"
    echo -e "${color}${message}${NC}"
}

print_colored "$CYAN" "🔄 自动同步Xcode项目Web文件"
print_colored "$CYAN" "================================="

# 检查fswatch是否安装
if ! command -v fswatch &> /dev/null; then
    print_colored "$YELLOW" "⚠️  fswatch未安装，正在安装..."
    if command -v brew &> /dev/null; then
        brew install fswatch
    else
        print_colored "$RED" "❌ 请先安装Homebrew或手动安装fswatch"
        exit 1
    fi
fi

print_colored "$BLUE" "📁 监控源文件变化..."
print_colored "$WHITE" "监控目录: src/"
print_colored "$WHITE" "同步到: time/time/Web/"
print_colored "$WHITE" ""
print_colored "$WHITE" "按 Ctrl+C 停止监控"

# 监控源文件变化
fswatch -o src/ | while read f; do
    print_colored "$YELLOW" "🔄 检测到文件变化，开始同步..."

    # 同步HTML文件
    if [ -f "src/html/activity-tracker.html" ]; then
        cp "src/html/activity-tracker.html" "time/time/Web/activity-tracker.html"
        print_colored "$GREEN" "✅ 已同步 activity-tracker.html"
    fi

    if [ -f "src/html/demo-activity-tracker.html" ]; then
        cp "src/html/demo-activity-tracker.html" "time/time/Web/demo-activity-tracker.html"
        print_colored "$GREEN" "✅ 已同步 demo-activity-tracker.html"
    fi

    if [ -f "src/html/interface-showcase.html" ]; then
        cp "src/html/interface-showcase.html" "time/time/Web/interface-showcase.html"
        print_colored "$GREEN" "✅ 已同步 interface-showcase.html"
    fi

    # 同步CSS文件
    if [ -f "src/css/activity-tracker.css" ]; then
        cp "src/css/activity-tracker.css" "time/time/Web/css/activity-tracker.css"
        print_colored "$GREEN" "✅ 已同步 activity-tracker.css"
    fi

    # 同步JavaScript文件
    js_files=(
        "activity-tracker.js"
        "project-manager.js"
        "diary-memo.js"
        "ai-classifier.js"
        "app-main.js"
    )

    for js_file in "${js_files[@]}"; do
        if [ -f "src/js/$js_file" ]; then
            cp "src/js/$js_file" "time/time/Web/js/$js_file"
            print_colored "$GREEN" "✅ 已同步 $js_file"
        fi
    done

    print_colored "$GREEN" "🎉 同步完成！"
    print_colored "$WHITE" "💡 现在Xcode项目中的Web文件已更新"
done
