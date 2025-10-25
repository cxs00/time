#!/bin/bash
# 快速开发日志记录脚本
# 简化版本，快速记录开发过程

# 颜色定义
GREEN='\033[0;32m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
NC='\033[0m'

print_colored() {
    local color="$1"
    local message="$2"
    echo -e "${color}${message}${NC}"
}

# 快速记录函数
quick_log() {
    local content="$1"
    local timestamp=$(date '+%Y-%m-%d %H:%M')

    # 直接添加到文件末尾
    echo "" >> TECHNICAL_DEVELOPMENT_LOG.md
    echo "#### $timestamp" >> TECHNICAL_DEVELOPMENT_LOG.md
    echo "- ✅ $content" >> TECHNICAL_DEVELOPMENT_LOG.md

    print_colored "$GREEN" "✅ 已记录: $content"
}

# 交互式记录
interactive_log() {
    print_colored "$CYAN" "📝 快速开发日志记录"
    print_colored "$CYAN" "================================="

    echo ""
    print_colored "$WHITE" "请选择记录类型:"
    echo "1. 完成功能"
    echo "2. 修复Bug"
    echo "3. 性能优化"
    echo "4. 学习收获"
    echo "5. 问题记录"
    echo "6. 自定义"

    read -p "请选择 (1-6): " choice

    case $choice in
        1)
            read -p "完成的功能: " content
            quick_log "完成功能: $content"
            ;;
        2)
            read -p "修复的Bug: " content
            quick_log "修复Bug: $content"
            ;;
        3)
            read -p "性能优化: " content
            quick_log "性能优化: $content"
            ;;
        4)
            read -p "学习收获: " content
            quick_log "学习收获: $content"
            ;;
        5)
            read -p "遇到的问题: " content
            quick_log "问题记录: $content"
            ;;
        6)
            read -p "自定义记录: " content
            quick_log "$content"
            ;;
        *)
            print_colored "$RED" "❌ 无效选择"
            exit 1
            ;;
    esac
}

# 主函数
main() {
    if [ $# -eq 0 ]; then
        interactive_log
    else
        quick_log "$*"
    fi
}

# 运行主函数
main "$@"
