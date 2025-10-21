#!/bin/bash
# 一键设置脚本 - 创建GitHub仓库和Netlify站点

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
NC='\033[0m'

# 打印带颜色的消息
print_colored() {
    local color="$1"
    local message="$2"
    echo -e "${color}${message}${NC}"
}

# 加载配置
load_config() {
    if [ -f ~/.universal-deploy-config ]; then
        source ~/.universal-deploy-config
    else
        print_colored "$RED" "❌ 配置文件不存在: ~/.universal-deploy-config"
        return 1
    fi
}

# 一键设置
one_click_setup() {
    local project_name="$1"
    local project_description="$2"
    local is_private="${3:-false}"

    print_colored "$CYAN" "🚀 一键设置开始"
    print_colored "$CYAN" "================================"

    # 检查参数
    if [ -z "$project_name" ]; then
        print_colored "$RED" "❌ 项目名称不能为空"
        return 1
    fi

    if [ -z "$project_description" ]; then
        project_description="基于通用部署系统创建的项目"
    fi

    print_colored "$BLUE" "📦 项目信息:"
    print_colored "$WHITE" "  名称: $project_name"
    print_colored "$WHITE" "  描述: $project_description"
    print_colored "$WHITE" "  私有: $is_private"

    # 步骤1: 创建GitHub仓库
    print_colored "$BLUE" "📦 步骤1: 创建GitHub仓库..."
    local repo_url=$(./scripts/github-repo-creator.sh "$project_name" -d "$project_description" -p)

    if [ $? -eq 0 ] && [ -n "$repo_url" ]; then
        print_colored "$GREEN" "✅ GitHub仓库创建成功"
        print_colored "$WHITE" "  仓库URL: $repo_url"
    else
        print_colored "$RED" "❌ GitHub仓库创建失败"
        return 1
    fi

    # 步骤2: 创建Netlify站点
    print_colored "$BLUE" "🌐 步骤2: 创建Netlify站点..."
    local site_url=$(./scripts/netlify-deployer.sh create "$project_name" "$repo_url")

    if [ $? -eq 0 ] && [ -n "$site_url" ]; then
        print_colored "$GREEN" "✅ Netlify站点创建成功"
        print_colored "$WHITE" "  站点URL: $site_url"
    else
        print_colored "$RED" "❌ Netlify站点创建失败"
        return 1
    fi

    # 步骤3: 显示完成信息
    print_colored "$GREEN" "🎉 一键设置完成！"
    print_colored "$GREEN" "================================"

    print_colored "$WHITE" "📦 GitHub仓库:"
    print_colored "$WHITE" "  URL: $repo_url"
    print_colored "$WHITE" "  克隆: git clone $repo_url"

    print_colored "$WHITE" "🌐 Netlify站点:"
    print_colored "$WHITE" "  URL: $site_url"
    print_colored "$WHITE" "  状态: 自动部署已启用"

    print_colored "$YELLOW" "💡 下一步操作:"
    print_colored "$WHITE" "  1. 克隆仓库: git clone $repo_url"
    print_colored "$WHITE" "  2. 添加代码到仓库"
    print_colored "$WHITE" "  3. 推送到GitHub: git push origin main"
    print_colored "$WHITE" "  4. Netlify将自动部署"

    # 保存配置信息
    save_config_info "$project_name" "$repo_url" "$site_url"
}

# 保存配置信息
save_config_info() {
    local project_name="$1"
    local repo_url="$2"
    local site_url="$3"

    local config_file="~/.universal-deploy-projects"

    cat >> "$config_file" << EOF

# 项目: $project_name
PROJECT_$project_name="
PROJECT_NAME=$project_name
REPO_URL=$repo_url
SITE_URL=$site_url
CREATED_DATE=$(date)
"
EOF

    print_colored "$GREEN" "✅ 配置信息已保存到: $config_file"
}

# 显示帮助信息
show_help() {
    print_colored "$BLUE" "📖 一键设置脚本"
    print_colored "$WHITE" "用法: $0 <项目名称> [描述] [--private]"
    echo ""
    print_colored "$YELLOW" "参数:"
    print_colored "$WHITE" "  项目名称    - 项目名称（必需）"
    print_colored "$WHITE" "  描述        - 项目描述（可选）"
    print_colored "$WHITE" "  --private   - 创建私有仓库（可选）"
    echo ""
    print_colored "$YELLOW" "示例:"
    print_colored "$WHITE" "  $0 my-app"
    print_colored "$WHITE" "  $0 my-app \"我的应用\""
    print_colored "$WHITE" "  $0 my-app \"我的应用\" --private"
}

# 主函数
main() {
    # 加载配置
    load_config || return 1

    local project_name="$1"
    local project_description="$2"
    local is_private="false"

    # 检查帮助参数
    if [ "$1" = "help" ] || [ "$1" = "--help" ] || [ "$1" = "-h" ]; then
        show_help
        return 0
    fi

    # 检查私有参数
    if [ "$3" = "--private" ]; then
        is_private="true"
    fi

    # 执行一键设置
    one_click_setup "$project_name" "$project_description" "$is_private"
}

# 运行主函数
main "$@"
