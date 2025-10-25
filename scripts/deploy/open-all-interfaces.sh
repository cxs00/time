#!/bin/bash
# 打开所有界面展示页面

# 颜色定义
GREEN='\033[0;32m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
RED='\033[0;31m'
NC='\033[0m'

print_colored() {
    local color="$1"
    local message="$2"
    echo -e "${color}${message}${NC}"
}

print_colored "$CYAN" "🎨 Activity Tracker 所有界面展示"
print_colored "$CYAN" "================================="

# 检查界面展示文件是否存在
if [ ! -f "src/html/all-interfaces-showcase.html" ]; then
    print_colored "$RED" "❌ 所有界面展示文件不存在: src/html/all-interfaces-showcase.html"
    exit 1
fi

print_colored "$GREEN" "✅ 所有界面展示文件存在"
print_colored "$WHITE" ""

# 直接打开文件
print_colored "$BLUE" "🚀 打开所有界面展示页面..."

if command -v open &> /dev/null; then
    # macOS
    open "src/html/all-interfaces-showcase.html"
    print_colored "$GREEN" "✅ 已在浏览器中打开所有界面展示页面"
elif command -v xdg-open &> /dev/null; then
    # Linux
    xdg-open "src/html/all-interfaces-showcase.html"
    print_colored "$GREEN" "✅ 已在浏览器中打开所有界面展示页面"
else
    print_colored "$YELLOW" "⚠️  无法自动打开浏览器，请手动打开:"
    print_colored "$WHITE" "  文件路径: $(pwd)/src/html/all-interfaces-showcase.html"
fi

print_colored "$WHITE" ""
print_colored "$WHITE" "📱 界面展示内容:"
print_colored "$WHITE" "  - 🏠 主界面: 活动记录和快速操作"
print_colored "$WHITE" "  - 🎯 项目页面: 进度管理和里程碑"
print_colored "$WHITE" "  - 📈 统计页面: 数据可视化"
print_colored "$WHITE" "  - 📖 日记页面: 心情记录和备忘录"
print_colored "$WHITE" "  - ⚙️ 设置页面: 个性化配置"
print_colored "$WHITE" "  - 🧪 演示页面: 功能展示和体验"
print_colored "$WHITE" "  - 📱 移动端: 响应式设计"
print_colored "$WHITE" ""
print_colored "$WHITE" "🎨 展示特色:"
print_colored "$WHITE" "  - 阵列式布局展示"
print_colored "$WHITE" "  - 每个界面都有外框"
print_colored "$WHITE" "  - 悬停交互效果"
print_colored "$WHITE" "  - 响应式网格布局"
print_colored "$WHITE" "  - 详细功能说明"
print_colored "$WHITE" ""
print_colored "$GREEN" "🎉 所有界面展示页面已打开！"
