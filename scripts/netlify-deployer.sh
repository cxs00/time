#!/bin/bash
# Netlify部署脚本

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

# 创建Netlify站点
create_netlify_site() {
    local site_name="$1"
    local repo_url="$2"

    print_colored "$BLUE" "🌐 创建Netlify站点: $site_name"

    # 检查参数
    if [ -z "$site_name" ]; then
        print_colored "$RED" "❌ 站点名称不能为空"
        return 1
    fi

    # 检查认证信息
    if [ -z "$NETLIFY_TOKEN" ] || [ "$NETLIFY_TOKEN" = "your_netlify_token" ]; then
        print_colored "$RED" "❌ 请先配置Netlify Token"
        return 1
    fi

    # 创建站点
    local response=$(curl -s -X POST \
        -H "Authorization: Bearer $NETLIFY_TOKEN" \
        -H "Content-Type: application/json" \
        -d "{
            \"name\": \"$site_name\",
            \"repo\": {
                \"provider\": \"github\",
                \"repo\": \"$repo_url\"
            }
        }" \
        "https://api.netlify.com/api/v1/sites")

    # 检查响应
    if echo "$response" | grep -q "id"; then
        local site_url=$(echo "$response" | jq -r '.url')
        local site_id=$(echo "$response" | jq -r '.id')

        print_colored "$GREEN" "✅ Netlify站点创建成功"
        print_colored "$WHITE" "  站点URL: $site_url"
        print_colored "$WHITE" "  站点ID: $site_id"

        # 返回站点信息
        echo "$site_url"
    else
        print_colored "$RED" "❌ 创建站点失败"
        echo "$response"
        return 1
    fi
}

# 触发Netlify部署
trigger_deploy() {
    local site_id="$1"

    print_colored "$BLUE" "🚀 触发Netlify部署..."

    if [ -z "$site_id" ]; then
        print_colored "$RED" "❌ 站点ID不能为空"
        return 1
    fi

    if [ -z "$NETLIFY_TOKEN" ] || [ "$NETLIFY_TOKEN" = "your_netlify_token" ]; then
        print_colored "$RED" "❌ 请先配置Netlify Token"
        return 1
    fi

    # 触发部署
    local response=$(curl -s -X POST \
        -H "Authorization: Bearer $NETLIFY_TOKEN" \
        "https://api.netlify.com/api/v1/sites/$site_id/deploys")

    if echo "$response" | grep -q "id"; then
        print_colored "$GREEN" "✅ 部署已触发"
    else
        print_colored "$RED" "❌ 触发部署失败"
        echo "$response"
        return 1
    fi
}

# 检查站点状态
check_site_status() {
    local site_id="$1"

    if [ -z "$site_id" ]; then
        print_colored "$RED" "❌ 站点ID不能为空"
        return 1
    fi

    if [ -z "$NETLIFY_TOKEN" ] || [ "$NETLIFY_TOKEN" = "your_netlify_token" ]; then
        print_colored "$RED" "❌ 请先配置Netlify Token"
        return 1
    fi

    local response=$(curl -s -H "Authorization: Bearer $NETLIFY_TOKEN" \
        "https://api.netlify.com/api/v1/sites/$site_id")

    if echo "$response" | grep -q "id"; then
        local site_url=$(echo "$response" | jq -r '.url')
        local status=$(echo "$response" | jq -r '.state')

        print_colored "$GREEN" "✅ 站点状态: $status"
        print_colored "$WHITE" "  站点URL: $site_url"
    else
        print_colored "$RED" "❌ 获取站点状态失败"
        echo "$response"
        return 1
    fi
}

# 显示帮助信息
show_help() {
    print_colored "$BLUE" "📖 Netlify部署脚本"
    print_colored "$WHITE" "用法: $0 [选项] <命令>"
    echo ""
    print_colored "$YELLOW" "命令:"
    print_colored "$WHITE" "  create <站点名> <仓库URL>  - 创建Netlify站点"
    print_colored "$WHITE" "  deploy <站点ID>            - 触发部署"
    print_colored "$WHITE" "  status <站点ID>             - 检查站点状态"
    print_colored "$WHITE" "  help                       - 显示帮助信息"
    echo ""
    print_colored "$YELLOW" "示例:"
    print_colored "$WHITE" "  $0 create my-app https://github.com/user/repo"
    print_colored "$WHITE" "  $0 deploy abc123"
    print_colored "$WHITE" "  $0 status abc123"
}

# 主函数
main() {
    # 加载配置
    load_config || return 1

    case "$1" in
        "create")
            create_netlify_site "$2" "$3"
            ;;
        "deploy")
            trigger_deploy "$2"
            ;;
        "status")
            check_site_status "$2"
            ;;
        "help"|"--help"|"-h")
            show_help
            ;;
        "")
            show_help
            ;;
        *)
            print_colored "$RED" "❌ 未知命令: $1"
            show_help
            return 1
            ;;
    esac
}

# 运行主函数
main "$@"
