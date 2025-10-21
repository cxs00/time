#!/bin/bash
# GitHub仓库创建脚本

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
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

# 创建GitHub仓库
create_github_repo() {
    local repo_name="$1"
    local description="$2"
    local is_private="${3:-false}"

    print_colored "$BLUE" "📦 创建GitHub仓库: $repo_name"

    # 检查参数
    if [ -z "$repo_name" ]; then
        print_colored "$RED" "❌ 仓库名称不能为空"
        return 1
    fi

    # 检查认证信息
    if [ -z "$GITHUB_TOKEN" ] || [ "$GITHUB_TOKEN" = "your_token" ]; then
        print_colored "$RED" "❌ 请先配置GitHub Token"
        return 1
    fi

    # 创建仓库
    local response=$(curl -s -X POST \
        -H "Authorization: token $GITHUB_TOKEN" \
        -H "Accept: application/vnd.github.v3+json" \
        -d "{
            \"name\": \"$repo_name\",
            \"description\": \"$description\",
            \"private\": $is_private,
            \"auto_init\": true,
            \"gitignore_template\": \"Node\"
        }" \
        "https://api.github.com/user/repos")

    # 检查响应
    if echo "$response" | grep -q "id"; then
        local repo_url=$(echo "$response" | jq -r '.html_url')
        local clone_url=$(echo "$response" | jq -r '.clone_url')

        print_colored "$GREEN" "✅ GitHub仓库创建成功"
        print_colored "$WHITE" "  仓库URL: $repo_url"
        print_colored "$WHITE" "  克隆URL: $clone_url"

        # 返回仓库信息
        echo "$repo_url"
    else
        print_colored "$RED" "❌ 创建仓库失败"
        echo "$response"
        return 1
    fi
}

# 检查仓库是否存在
check_repo_exists() {
    local repo_name="$1"

    if [ -z "$GITHUB_TOKEN" ] || [ "$GITHUB_TOKEN" = "your_token" ]; then
        print_colored "$RED" "❌ 请先配置GitHub Token"
        return 1
    fi

    local response=$(curl -s -H "Authorization: token $GITHUB_TOKEN" \
        "https://api.github.com/repos/$GITHUB_USERNAME/$repo_name")

    if echo "$response" | grep -q "id"; then
        return 0
    else
        return 1
    fi
}

# 显示帮助信息
show_help() {
    print_colored "$BLUE" "📖 GitHub仓库创建脚本"
    print_colored "$WHITE" "用法: $0 [选项] <仓库名称>"
    echo ""
    print_colored "$YELLOW" "选项:"
    print_colored "$WHITE" "  -d, --description <描述>  - 仓库描述"
    print_colored "$WHITE" "  -p, --private            - 创建私有仓库"
    print_colored "$WHITE" "  -c, --check <仓库名>     - 检查仓库是否存在"
    print_colored "$WHITE" "  -h, --help               - 显示帮助信息"
    echo ""
    print_colored "$YELLOW" "示例:"
    print_colored "$WHITE" "  $0 my-app"
    print_colored "$WHITE" "  $0 my-app -d \"我的应用\""
    print_colored "$WHITE" "  $0 my-app -p"
    print_colored "$WHITE" "  $0 -c my-app"
}

# 主函数
main() {
    # 加载配置
    load_config || return 1

    local repo_name=""
    local description=""
    local is_private="false"
    local check_mode=false

    # 解析参数
    while [[ $# -gt 0 ]]; do
        case $1 in
            -d|--description)
                description="$2"
                shift 2
                ;;
            -p|--private)
                is_private="true"
                shift
                ;;
            -c|--check)
                check_mode=true
                repo_name="$2"
                shift 2
                ;;
            -h|--help)
                show_help
                return 0
                ;;
            -*)
                print_colored "$RED" "❌ 未知选项: $1"
                show_help
                return 1
                ;;
            *)
                if [ -z "$repo_name" ]; then
                    repo_name="$1"
                fi
                shift
                ;;
        esac
    done

    # 检查模式
    if [ "$check_mode" = true ]; then
        if check_repo_exists "$repo_name"; then
            print_colored "$GREEN" "✅ 仓库存在: $repo_name"
        else
            print_colored "$RED" "❌ 仓库不存在: $repo_name"
        fi
        return 0
    fi

    # 创建仓库
    if [ -n "$repo_name" ]; then
        create_github_repo "$repo_name" "$description" "$is_private"
    else
        print_colored "$RED" "❌ 请提供仓库名称"
        show_help
        return 1
    fi
}

# 运行主函数
main "$@"
