#!/bin/bash
# Cursor认证检测器
# 当Cursor启动时自动检测并导入认证信息

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

# 检测认证目录
detect_auth_directory() {
    if [ -d ~/.cxs-auth ]; then
        print_colored "$GREEN" "🔍 检测到认证目录: ~/.cxs-auth"
        return 0
    else
        print_colored "$YELLOW" "⚠️  认证目录不存在"
        return 1
    fi
}

# 检测认证文件
detect_auth_files() {
    local auth_files=()

    if [ -f ~/.cxs-auth/github.json ]; then
        auth_files+=("GitHub")
    fi

    if [ -f ~/.cxs-auth/netlify.json ]; then
        auth_files+=("Netlify")
    fi

    if [ -f ~/.cxs-auth/vercel.json ]; then
        auth_files+=("Vercel")
    fi

    if [ -f ~/.cxs-auth/cursor-config.json ]; then
        auth_files+=("Cursor")
    fi

    if [ ${#auth_files[@]} -gt 0 ]; then
        print_colored "$GREEN" "✅ 检测到认证文件: ${auth_files[*]}"
        return 0
    else
        print_colored "$YELLOW" "⚠️  未检测到认证文件"
        return 1
    fi
}

# 自动导入认证
auto_import_auth() {
    print_colored "$BLUE" "🚀 开始自动导入认证信息..."

    # 检查导入脚本是否存在
    if [ -f "./scripts/auto-import-auth.sh" ]; then
        ./scripts/auto-import-auth.sh
    else
        print_colored "$RED" "❌ 认证导入脚本不存在"
        return 1
    fi
}

# 验证项目环境
verify_project_environment() {
    print_colored "$CYAN" "🔍 验证项目环境..."

    # 检查项目文件
    local required_files=(
        "activity-tracker.html"
        "css/activity-tracker.css"
        "js/activity-tracker.js"
        "js/project-manager.js"
        "js/ai-classifier.js"
    )

    local missing_files=()
    for file in "${required_files[@]}"; do
        if [ ! -f "$file" ]; then
            missing_files+=("$file")
        fi
    done

    if [ ${#missing_files[@]} -eq 0 ]; then
        print_colored "$GREEN" "✅ 项目文件完整"
    else
        print_colored "$RED" "❌ 缺少文件: ${missing_files[*]}"
    fi

    # 检查Git配置
    if git config --get user.name > /dev/null 2>&1; then
        print_colored "$GREEN" "✅ Git配置完整"
    else
        print_colored "$YELLOW" "⚠️  Git配置不完整"
    fi

    # 检查环境变量
    if [ -n "$NETLIFY_TOKEN" ]; then
        print_colored "$GREEN" "✅ Netlify环境变量已设置"
    else
        print_colored "$YELLOW" "⚠️  Netlify环境变量未设置"
    fi
}

# 显示项目状态
show_project_status() {
    print_colored "$CYAN" "📊 项目状态"
    print_colored "$CYAN" "================================="

    # 项目信息
    print_colored "$WHITE" "项目名称: Activity Tracker"
    print_colored "$WHITE" "版本: v2.0.0"
    print_colored "$WHITE" "状态: 核心功能完成"

    # 文件统计
    local js_files=$(find js -name "*.js" 2>/dev/null | wc -l)
    local css_files=$(find css -name "*.css" 2>/dev/null | wc -l)
    local html_files=$(find . -name "*.html" 2>/dev/null | wc -l)

    print_colored "$WHITE" "JavaScript文件: $js_files"
    print_colored "$WHITE" "CSS文件: $css_files"
    print_colored "$WHITE" "HTML文件: $html_files"

    # 认证状态
    print_colored "$WHITE" "认证状态:"
    if [ -f ~/.cxs-auth/github.json ]; then
        print_colored "$GREEN" "  ✅ GitHub认证"
    else
        print_colored "$RED" "  ❌ GitHub认证"
    fi

    if [ -f ~/.cxs-auth/netlify.json ]; then
        print_colored "$GREEN" "  ✅ Netlify认证"
    else
        print_colored "$RED" "  ❌ Netlify认证"
    fi
}

# 显示下一步操作
show_next_steps() {
    print_colored "$CYAN" "🎯 下一步操作"
    print_colored "$CYAN" "================================="

    print_colored "$WHITE" "1. 启动应用:"
    print_colored "$WHITE" "   ./start-activity-tracker.sh"
    print_colored "$WHITE" "   或 open activity-tracker.html"

    print_colored "$WHITE" "2. 功能演示:"
    print_colored "$WHITE" "   open demo-activity-tracker.html"

    print_colored "$WHITE" "3. 部署应用:"
    print_colored "$WHITE" "   ./scripts/deploy-netlify-only.sh"

    print_colored "$WHITE" "4. 查看文档:"
    print_colored "$WHITE" "   cat PROJECT_STATUS.md"
}

# 主函数
main() {
    print_colored "$CYAN" "🤖 Cursor认证检测器启动"
    print_colored "$CYAN" "================================="

    # 检测认证目录
    if detect_auth_directory; then
        # 检测认证文件
        if detect_auth_files; then
            # 自动导入认证
            auto_import_auth
        else
            print_colored "$YELLOW" "💡 提示: 请创建认证文件"
            print_colored "$WHITE" "   参考: ~/.cxs-auth/README.md"
        fi
    else
        print_colored "$YELLOW" "💡 提示: 请创建认证目录"
        print_colored "$WHITE" "   mkdir -p ~/.cxs-auth"
    fi

    # 验证项目环境
    verify_project_environment

    # 显示项目状态
    show_project_status

    # 显示下一步操作
    show_next_steps

    print_colored "$GREEN" "🎉 检测完成！"
}

# 运行主函数
main "$@"
