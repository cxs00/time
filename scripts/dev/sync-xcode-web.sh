#!/bin/bash
# 同步源文件到Xcode项目中的Web目录

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

print_colored "$CYAN" "🔄 同步Xcode项目中的Web文件"
print_colored "$CYAN" "================================="

# 检查源文件是否存在
if [ ! -d "src" ]; then
    print_colored "$RED" "❌ 源文件目录不存在"
    exit 1
fi

# 检查Xcode项目目录是否存在
if [ ! -d "time/time/Web" ]; then
    print_colored "$RED" "❌ Xcode项目Web目录不存在"
    exit 1
fi

print_colored "$BLUE" "📁 检查源文件..."

# 同步HTML文件
print_colored "$YELLOW" "🔄 同步HTML文件..."
if [ -f "src/html/activity-tracker.html" ]; then
    cp "src/html/activity-tracker.html" "time/time/Web/activity-tracker.html"
    print_colored "$GREEN" "✅ 已同步 activity-tracker.html"
else
    print_colored "$RED" "❌ 源文件 activity-tracker.html 不存在"
fi

if [ -f "src/html/demo-activity-tracker.html" ]; then
    cp "src/html/demo-activity-tracker.html" "time/time/Web/demo-activity-tracker.html"
    print_colored "$GREEN" "✅ 已同步 demo-activity-tracker.html"
else
    print_colored "$RED" "❌ 源文件 demo-activity-tracker.html 不存在"
fi

if [ -f "src/html/interface-showcase.html" ]; then
    cp "src/html/interface-showcase.html" "time/time/Web/interface-showcase.html"
    print_colored "$GREEN" "✅ 已同步 interface-showcase.html"
else
    print_colored "$RED" "❌ 源文件 interface-showcase.html 不存在"
fi

# 同步CSS文件
print_colored "$YELLOW" "🔄 同步CSS文件..."
if [ -f "src/css/activity-tracker.css" ]; then
    cp "src/css/activity-tracker.css" "time/time/Web/css/activity-tracker.css"
    print_colored "$GREEN" "✅ 已同步 activity-tracker.css"
else
    print_colored "$RED" "❌ 源文件 activity-tracker.css 不存在"
fi

# 同步JavaScript文件
print_colored "$YELLOW" "🔄 同步JavaScript文件..."
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
    else
        print_colored "$RED" "❌ 源文件 $js_file 不存在"
    fi
done

# 检查同步结果
print_colored "$BLUE" "📊 同步结果检查..."

echo ""
print_colored "$WHITE" "📁 Xcode项目Web目录文件:"
ls -la time/time/Web/

echo ""
print_colored "$WHITE" "📁 源文件目录:"
ls -la src/

# 比较文件时间戳
print_colored "$BLUE" "🕐 文件时间戳比较:"
echo "源文件时间:"
stat -f "%Sm" -t "%Y-%m-%d %H:%M:%S" src/html/activity-tracker.html 2>/dev/null || echo "源文件不存在"
echo "Web文件时间:"
stat -f "%Sm" -t "%Y-%m-%d %H:%M:%S" time/time/Web/activity-tracker.html 2>/dev/null || echo "Web文件不存在"

print_colored "$GREEN" "🎉 同步完成！"
print_colored "$WHITE" ""
print_colored "$WHITE" "💡 提示:"
print_colored "$WHITE" "  - 现在Xcode项目中的Web文件已更新"
print_colored "$WHITE" "  - 重新运行Xcode项目即可看到最新界面"
print_colored "$WHITE" "  - 或者使用 ./scripts/dev/sync-xcode-web.sh 定期同步"
