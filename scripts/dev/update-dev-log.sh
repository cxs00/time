#!/bin/bash
# 开发日志更新脚本
# 用于实时更新技术开发文档

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

# 显示帮助信息
show_help() {
    print_colored "$CYAN" "📝 开发日志更新工具"
    print_colored "$CYAN" "================================="
    echo ""
    print_colored "$WHITE" "使用方法:"
    echo "  ./scripts/update-dev-log.sh [选项]"
    echo ""
    print_colored "$WHITE" "选项:"
    echo "  -a, --add <内容>     添加新的开发记录"
    echo "  -b, --bug <描述>     记录Bug修复"
    echo "  -f, --feature <描述> 记录新功能"
    echo "  -p, --performance <描述> 记录性能优化"
    echo "  -u, --update <描述>  更新项目状态"
    echo "  -s, --status        显示当前状态"
    echo "  -h, --help          显示帮助信息"
    echo ""
    print_colored "$WHITE" "示例:"
    echo "  ./scripts/update-dev-log.sh -a \"完成用户认证功能\""
    echo "  ./scripts/update-dev-log.sh -b \"修复图表显示问题\""
    echo "  ./scripts/update-dev-log.sh -f \"添加数据导出功能\""
}

# 添加开发记录
add_dev_record() {
    local content="$1"
    local timestamp=$(date '+%Y-%m-%d %H:%M')

    print_colored "$BLUE" "📝 添加开发记录..."

    # 在实时更新区域添加记录
    sed -i '' "/### 最新开发记录/a\\
#### $timestamp\\
- ✅ $content\\
" TECHNICAL_DEVELOPMENT_LOG.md

    print_colored "$GREEN" "✅ 开发记录已添加: $content"
}

# 记录Bug修复
add_bug_record() {
    local description="$1"
    local timestamp=$(date '+%Y-%m-%d')
    local bug_id=$(date '+%Y%m%d%H%M')

    print_colored "$BLUE" "🐛 记录Bug修复..."

    # 在Bug修复记录中添加
    sed -i '' "/### 已修复问题/a\\
\\
#### Bug #$bug_id: $description\\
- **问题**: $description\\
- **原因**: 待分析\\
- **解决**: 待实施\\
- **修复时间**: $timestamp\\
- **状态**: 🔄 修复中\\
" TECHNICAL_DEVELOPMENT_LOG.md

    print_colored "$GREEN" "✅ Bug记录已添加: $description"
}

# 记录新功能
add_feature_record() {
    local description="$1"
    local timestamp=$(date '+%Y-%m-%d')

    print_colored "$BLUE" "✨ 记录新功能..."

    # 在待开发功能中添加
    sed -i '' "/### 待开发功能/a\\
- [ ] $description\\
" TECHNICAL_DEVELOPMENT_LOG.md

    print_colored "$GREEN" "✅ 新功能记录已添加: $description"
}

# 记录性能优化
add_performance_record() {
    local description="$1"
    local timestamp=$(date '+%Y-%m-%d %H:%M')

    print_colored "$BLUE" "⚡ 记录性能优化..."

    # 在性能优化记录中添加
    sed -i '' "/### 优化策略/a\\
\\
// $timestamp: $description\\
// 优化效果: 待测试\\
// 实施状态: 进行中\\
" TECHNICAL_DEVELOPMENT_LOG.md

    print_colored "$GREEN" "✅ 性能优化记录已添加: $description"
}

# 更新项目状态
update_project_status() {
    local description="$1"
    local timestamp=$(date '+%Y-%m-%d %H:%M')

    print_colored "$BLUE" "🔄 更新项目状态..."

    # 更新最后更新时间
    sed -i '' "s/最后更新：.*/最后更新：$timestamp/" TECHNICAL_DEVELOPMENT_LOG.md

    # 在实时更新区域添加状态更新
    sed -i '' "/### 最新开发记录/a\\
#### $timestamp\\
- 🔄 $description\\
" TECHNICAL_DEVELOPMENT_LOG.md

    print_colored "$GREEN" "✅ 项目状态已更新: $description"
}

# 显示当前状态
show_status() {
    print_colored "$CYAN" "📊 当前项目状态"
    print_colored "$CYAN" "================================="

    # 显示文件信息
    if [ -f "TECHNICAL_DEVELOPMENT_LOG.md" ]; then
        local file_size=$(wc -l < TECHNICAL_DEVELOPMENT_LOG.md)
        local last_modified=$(stat -f "%Sm" -t "%Y-%m-%d %H:%M" TECHNICAL_DEVELOPMENT_LOG.md)

        print_colored "$GREEN" "✅ 开发日志文件存在"
        print_colored "$WHITE" "   文件大小: $file_size 行"
        print_colored "$WHITE" "   最后修改: $last_modified"
    else
        print_colored "$RED" "❌ 开发日志文件不存在"
    fi

    # 显示项目文件状态
    print_colored "$WHITE" ""
    print_colored "$WHITE" "📁 项目文件状态:"

    local files=(
        "activity-tracker.html"
        "js/activity-tracker.js"
        "js/project-manager.js"
        "js/ai-classifier.js"
        "css/activity-tracker.css"
    )

    for file in "${files[@]}"; do
        if [ -f "$file" ]; then
            print_colored "$GREEN" "  ✅ $file"
        else
            print_colored "$RED" "  ❌ $file"
        fi
    done

    # 显示Git状态
    print_colored "$WHITE" ""
    print_colored "$WHITE" "📊 Git状态:"
    if git status --porcelain | grep -q .; then
        print_colored "$YELLOW" "  🔄 有未提交的更改"
        git status --short
    else
        print_colored "$GREEN" "  ✅ 工作区干净"
    fi
}

# 主函数
main() {
    case "$1" in
        -a|--add)
            if [ -z "$2" ]; then
                print_colored "$RED" "❌ 请提供开发记录内容"
                exit 1
            fi
            add_dev_record "$2"
            ;;
        -b|--bug)
            if [ -z "$2" ]; then
                print_colored "$RED" "❌ 请提供Bug描述"
                exit 1
            fi
            add_bug_record "$2"
            ;;
        -f|--feature)
            if [ -z "$2" ]; then
                print_colored "$RED" "❌ 请提供功能描述"
                exit 1
            fi
            add_feature_record "$2"
            ;;
        -p|--performance)
            if [ -z "$2" ]; then
                print_colored "$RED" "❌ 请提供性能优化描述"
                exit 1
            fi
            add_performance_record "$2"
            ;;
        -u|--update)
            if [ -z "$2" ]; then
                print_colored "$RED" "❌ 请提供状态更新描述"
                exit 1
            fi
            update_project_status "$2"
            ;;
        -s|--status)
            show_status
            ;;
        -h|--help)
            show_help
            ;;
        *)
            print_colored "$RED" "❌ 未知选项: $1"
            show_help
            exit 1
            ;;
    esac
}

# 运行主函数
main "$@"
