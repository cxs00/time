#!/bin/bash
# 多设备配置管理脚本

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

# 创建设备配置
create_device() {
    print_colored "$BLUE" "🔧 创建设备配置..."

    # 获取设备信息
    local device_name=$(hostname)
    local device_os=$(uname -s)
    local device_user=$(whoami)

    # 创建设备配置文件
    cat > ~/.universal-deploy-devices << EOF
# 多设备配置管理
# 支持不同设备使用不同认证信息

# 设备: $device_name
DEVICE_$device_name="
GITHUB_USERNAME=your_username
GITHUB_TOKEN=your_token
GITHUB_EMAIL=your_email@example.com
NETLIFY_TOKEN=your_netlify_token
NETLIFY_SITE_ID=your_site_id
NETLIFY_SITE_URL=your_site_url
"

# 设备信息
DEVICE_INFO_$device_name="
DEVICE_NAME=$device_name
DEVICE_OS=$device_os
DEVICE_USER=$device_user
CREATED_DATE=$(date)
"
EOF

    print_colored "$GREEN" "✅ 设备配置文件已创建: ~/.universal-deploy-devices"
}

# 创建账号配置
create_account() {
    print_colored "$BLUE" "👤 创建账号配置..."

    # 创建账号配置文件
    cat > ~/.universal-deploy-accounts << EOF
# 多账号配置管理
# 支持不同账号使用不同认证信息

# 个人账号
ACCOUNT_PERSONAL="
GITHUB_USERNAME=personal_username
GITHUB_TOKEN=personal_token
GITHUB_EMAIL=personal@example.com
NETLIFY_TOKEN=personal_netlify_token
NETLIFY_SITE_ID=personal_site_id
NETLIFY_SITE_URL=personal_site_url
"

# 工作账号
ACCOUNT_WORK="
GITHUB_USERNAME=work_username
GITHUB_TOKEN=work_token
GITHUB_EMAIL=work@example.com
NETLIFY_TOKEN=work_netlify_token
NETLIFY_SITE_ID=work_site_id
NETLIFY_SITE_URL=work_site_url
"
EOF

    print_colored "$GREEN" "✅ 账号配置文件已创建: ~/.universal-deploy-accounts"
}

# 检查配置状态
status() {
    print_colored "$BLUE" "📊 检查配置状态..."

    # 检查主配置文件
    if [ -f ~/.universal-deploy-config ]; then
        print_colored "$GREEN" "✅ 主配置文件存在"
        print_colored "$WHITE" "  位置: ~/.universal-deploy-config"
    else
        print_colored "$RED" "❌ 主配置文件不存在"
    fi

    # 检查设备配置文件
    if [ -f ~/.universal-deploy-devices ]; then
        print_colored "$GREEN" "✅ 设备配置文件存在"
        print_colored "$WHITE" "  位置: ~/.universal-deploy-devices"
    else
        print_colored "$RED" "❌ 设备配置文件不存在"
    fi

    # 检查账号配置文件
    if [ -f ~/.universal-deploy-accounts ]; then
        print_colored "$GREEN" "✅ 账号配置文件存在"
        print_colored "$WHITE" "  位置: ~/.universal-deploy-accounts"
    else
        print_colored "$RED" "❌ 账号配置文件不存在"
    fi

    # 检查GitHub配置
    if [ -f ~/.universal-deploy-config ]; then
        if grep -q "GITHUB_USERNAME=" ~/.universal-deploy-config; then
            print_colored "$GREEN" "✅ GitHub配置已设置"
        else
            print_colored "$YELLOW" "⚠️ GitHub配置未设置"
        fi
    fi

    # 检查Netlify配置
    if [ -f ~/.universal-deploy-config ]; then
        if grep -q "NETLIFY_TOKEN=" ~/.universal-deploy-config; then
            print_colored "$GREEN" "✅ Netlify配置已设置"
        else
            print_colored "$YELLOW" "⚠️ Netlify配置未设置"
        fi
    fi
}

# 显示帮助信息
show_help() {
    print_colored "$BLUE" "📖 多设备配置管理脚本"
    print_colored "$WHITE" "用法: $0 [命令]"
    echo ""
    print_colored "$YELLOW" "可用命令:"
    print_colored "$WHITE" "  create_device    - 创建设备配置"
    print_colored "$WHITE" "  create_account   - 创建账号配置"
    print_colored "$WHITE" "  status           - 检查配置状态"
    print_colored "$WHITE" "  help             - 显示帮助信息"
    echo ""
    print_colored "$YELLOW" "示例:"
    print_colored "$WHITE" "  $0 create_device"
    print_colored "$WHITE" "  $0 status"
}

# 主函数
main() {
    case "$1" in
        "create_device")
            create_device
            ;;
        "create_account")
            create_account
            ;;
        "status")
            status
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
            ;;
    esac
}

# 运行主函数
main "$@"
