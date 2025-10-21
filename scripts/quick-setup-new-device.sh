#!/bin/bash
# 全新设备快速部署脚本

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

# 检测操作系统
detect_os() {
    case "$(uname -s)" in
        Darwin*)    echo "macos" ;;
        Linux*)     echo "linux" ;;
        CYGWIN*)    echo "windows" ;;
        MINGW*)     echo "windows" ;;
        MSYS*)      echo "windows" ;;
        *)          echo "unknown" ;;
    esac
}

# 安装依赖
install_dependencies() {
    local os=$(detect_os)

    print_colored "$BLUE" "📦 安装系统依赖..."

    case $os in
        "macos")
            # 检查Homebrew
            if ! command -v brew &> /dev/null; then
                print_colored "$YELLOW" "安装Homebrew..."
                /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
            fi

            # 安装依赖
            brew install git python3 curl jq
            ;;
        "linux")
            # 检测发行版
            if [ -f /etc/os-release ]; then
                . /etc/os-release
                case $ID in
                    "ubuntu"|"debian")
                        sudo apt update
                        sudo apt install -y git python3 python3-pip curl jq
                        ;;
                    "centos"|"rhel"|"fedora")
                        if command -v dnf &> /dev/null; then
                            sudo dnf install -y git python3 python3-pip curl jq
                        else
                            sudo yum install -y git python3 python3-pip curl jq
                        fi
                        ;;
                esac
            fi
            ;;
        "windows")
            print_colored "$YELLOW" "请手动安装以下依赖:"
            print_colored "$WHITE" "  - Git: https://git-scm.com/download/win"
            print_colored "$WHITE" "  - Python: https://www.python.org/downloads/"
            print_colored "$WHITE" "  - PowerShell: 系统自带"
            ;;
    esac
}

# 获取通用部署系统
get_universal_deploy() {
    print_colored "$BLUE" "📥 获取通用部署系统..."

    # 检查是否已存在
    if [ -d "~/Desktop/通用部署" ]; then
        print_colored "$YELLOW" "⚠️ 通用部署系统已存在"
        return 0
    fi

    # 从GitHub克隆
    if command -v git &> /dev/null; then
        git clone https://github.com/cxs00/time.git temp-time
        cp -r temp-time ~/Desktop/通用部署
        rm -rf temp-time
        print_colored "$GREEN" "✅ 通用部署系统已获取"
    else
        print_colored "$RED" "❌ Git未安装，请先安装Git"
        return 1
    fi
}

# 配置认证信息
setup_authentication() {
    print_colored "$BLUE" "🔐 配置认证信息..."

    cd ~/Desktop/通用部署

    # 创建配置文件
    if [ -f "./scripts/multi-device-config.sh" ]; then
        ./scripts/multi-device-config.sh create_device
        ./scripts/multi-device-config.sh create_account
    else
        print_colored "$YELLOW" "⚠️ 多设备配置脚本不存在，跳过配置创建"
    fi

    print_colored "$YELLOW" "请编辑配置文件:"
    print_colored "$WHITE" "  nano ~/.universal-deploy-config"
    print_colored "$WHITE" "  nano ~/.universal-deploy-devices"
    print_colored "$WHITE" "  nano ~/.universal-deploy-accounts"

    print_colored "$YELLOW" "或使用自动同步:"
    print_colored "$WHITE" "  ./scripts/auto-sync-config.sh download"
}

# 验证配置
verify_config() {
    print_colored "$BLUE" "✅ 验证配置..."

    cd ~/Desktop/通用部署

    # 检查配置文件
    if [ -f ~/.universal-deploy-config ]; then
        print_colored "$GREEN" "✅ 主配置文件存在"
    else
        print_colored "$RED" "❌ 主配置文件不存在"
        return 1
    fi

    # 检查脚本权限
    chmod +x scripts/*.sh
    print_colored "$GREEN" "✅ 脚本权限已设置"

    # 测试配置
    if [ -f "./scripts/multi-device-config.sh" ]; then
        ./scripts/multi-device-config.sh status
    else
        print_colored "$YELLOW" "⚠️ 多设备配置脚本不存在，跳过状态检查"
    fi
}

# 显示完成信息
show_completion_info() {
    print_colored "$GREEN" "🎉 全新设备部署完成！"
    print_colored "$GREEN" "================================"

    print_colored "$WHITE" "📁 通用部署系统位置: ~/Desktop/通用部署/"
    print_colored "$WHITE" "🔧 配置文件位置: ~/.universal-deploy-config"

    echo ""
    print_colored "$BLUE" "🚀 下一步操作:"
    print_colored "$WHITE" "  1. 配置认证信息: nano ~/.universal-deploy-config"
    print_colored "$WHITE" "  2. 测试配置: ./scripts/multi-device-config.sh status"
    print_colored "$WHITE" "  3. 开始使用: ./ui/cli-interface.sh"

    echo ""
    print_colored "$YELLOW" "💡 提示:"
    print_colored "$WHITE" "  - 使用图形界面: ./ui/cli-interface.sh"
    print_colored "$WHITE" "  - 创建新项目: ./create-new-project-enhanced-v2.sh"
    print_colored "$WHITE" "  - 一键设置: ./scripts/one-click-setup.sh my-app \"我的应用\""
}

# 主函数
main() {
    print_colored "$CYAN" "🚀 全新设备快速部署"
    print_colored "$CYAN" "================================"

    # 安装依赖
    install_dependencies

    # 获取通用部署系统
    get_universal_deploy

    # 配置认证信息
    setup_authentication

    # 验证配置
    verify_config

    # 显示完成信息
    show_completion_info
}

# 运行主函数
main "$@"
