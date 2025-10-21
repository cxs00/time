#!/bin/bash
# Cursor超级部署脚本 - 一键完成通用部署系统安装和配置

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

# 检测系统环境
detect_system() {
    local os=$(detect_os)
    print_colored "$BLUE" "🔍 检测系统环境..."

    case $os in
        "macos")
            print_colored "$GREEN" "✅ macOS系统检测完成"
            ;;
        "linux")
            print_colored "$GREEN" "✅ Linux系统检测完成"
            ;;
        "windows")
            print_colored "$GREEN" "✅ Windows系统检测完成"
            ;;
        *)
            print_colored "$YELLOW" "⚠️ 未知系统，尝试通用安装"
            ;;
    esac

    # 检测用户信息
    local user=$(whoami)
    local home_dir="$HOME"
    print_colored "$WHITE" "  用户: $user"
    print_colored "$WHITE" "  主目录: $home_dir"
}

# 安装系统依赖
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
            print_colored "$BLUE" "安装Git、Python、curl、jq..."
            brew install git python3 curl jq
            ;;
        "linux")
            # 检测发行版
            if [ -f /etc/os-release ]; then
                . /etc/os-release
                case $ID in
                    "ubuntu"|"debian")
                        print_colored "$BLUE" "使用apt安装依赖..."
                        sudo apt update
                        sudo apt install -y git python3 python3-pip curl jq
                        ;;
                    "centos"|"rhel"|"fedora")
                        print_colored "$BLUE" "使用包管理器安装依赖..."
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

    print_colored "$GREEN" "✅ 依赖安装完成"
}

# 获取通用部署系统
get_universal_deploy() {
    print_colored "$BLUE" "📥 获取通用部署系统..."

    local deploy_dir="$HOME/Desktop/通用部署"

    # 检查是否已存在
    if [ -d "$deploy_dir" ]; then
        print_colored "$YELLOW" "⚠️ 通用部署系统已存在"
        print_colored "$WHITE" "  位置: $deploy_dir"
        return 0
    fi

    # 从GitHub克隆
    if command -v git &> /dev/null; then
        print_colored "$BLUE" "从GitHub克隆通用部署系统..."
        git clone https://github.com/cxs00/time.git temp-time

        if [ $? -eq 0 ]; then
            # 复制到目标位置
            cp -r temp-time "$deploy_dir"
            rm -rf temp-time

            print_colored "$GREEN" "✅ 通用部署系统已获取"
            print_colored "$WHITE" "  位置: $deploy_dir"
        else
            print_colored "$RED" "❌ 克隆失败，请检查网络连接"
            return 1
        fi
    else
        print_colored "$RED" "❌ Git未安装，请先安装Git"
        return 1
    fi
}

# 配置认证信息
setup_authentication() {
    print_colored "$BLUE" "🔐 配置认证信息..."

    local deploy_dir="$HOME/Desktop/通用部署"
    cd "$deploy_dir"

    # 创建主配置文件
    cat > "$HOME/.universal-deploy-config" << 'EOF'
# 通用部署系统认证配置文件
# 请填写你的认证信息

# ===========================================
# GitHub配置 (必需)
# ===========================================
GITHUB_USERNAME=your_username
GITHUB_TOKEN=your_token
GITHUB_EMAIL=your_email@example.com

# ===========================================
# Netlify配置 (推荐)
# ===========================================
NETLIFY_TOKEN=your_netlify_token
NETLIFY_SITE_ID=your_site_id
NETLIFY_SITE_URL=your_site_url

# ===========================================
# 通用配置
# ===========================================
DEFAULT_REPO_VISIBILITY=false
DEFAULT_DOMAIN_SUFFIX=netlify.app
AUTO_DEPLOY=true
NOTIFICATIONS_ENABLED=false

# ===========================================
# 安全配置
# ===========================================
ENCRYPT_TOKENS=true
TOKEN_EXPIRY_DAYS=90
AUTO_CLEANUP=true
EOF

    # 创建设备配置文件
    if [ -f "./scripts/multi-device-config.sh" ]; then
        ./scripts/multi-device-config.sh create_device
        ./scripts/multi-device-config.sh create_account
    fi

    print_colored "$GREEN" "✅ 配置文件已创建"
    print_colored "$YELLOW" "请编辑配置文件:"
    print_colored "$WHITE" "  nano $HOME/.universal-deploy-config"
    print_colored "$WHITE" "  nano $HOME/.universal-deploy-devices"
    print_colored "$WHITE" "  nano $HOME/.universal-deploy-accounts"
}

# 验证系统功能
verify_system() {
    print_colored "$BLUE" "✅ 验证系统功能..."

    local deploy_dir="$HOME/Desktop/通用部署"
    cd "$deploy_dir"

    # 设置脚本权限
    chmod +x scripts/*.sh
    print_colored "$GREEN" "✅ 脚本权限已设置"

    # 检查配置文件
    if [ -f "$HOME/.universal-deploy-config" ]; then
        print_colored "$GREEN" "✅ 主配置文件存在"
    else
        print_colored "$RED" "❌ 主配置文件不存在"
    fi

    # 测试多设备配置
    if [ -f "./scripts/multi-device-config.sh" ]; then
        print_colored "$BLUE" "测试多设备配置..."
        ./scripts/multi-device-config.sh status
    fi

    # 测试GitHub仓库创建
    if [ -f "./scripts/github-repo-creator.sh" ]; then
        print_colored "$BLUE" "测试GitHub仓库创建脚本..."
        ./scripts/github-repo-creator.sh --help > /dev/null 2>&1
        if [ $? -eq 0 ]; then
            print_colored "$GREEN" "✅ GitHub仓库创建脚本正常"
        else
            print_colored "$YELLOW" "⚠️ GitHub仓库创建脚本测试失败"
        fi
    fi

    # 测试Netlify部署
    if [ -f "./scripts/netlify-deployer.sh" ]; then
        print_colored "$BLUE" "测试Netlify部署脚本..."
        ./scripts/netlify-deployer.sh help > /dev/null 2>&1
        if [ $? -eq 0 ]; then
            print_colored "$GREEN" "✅ Netlify部署脚本正常"
        else
            print_colored "$YELLOW" "⚠️ Netlify部署脚本测试失败"
        fi
    fi

    # 测试一键设置
    if [ -f "./scripts/one-click-setup.sh" ]; then
        print_colored "$BLUE" "测试一键设置脚本..."
        ./scripts/one-click-setup.sh --help > /dev/null 2>&1
        if [ $? -eq 0 ]; then
            print_colored "$GREEN" "✅ 一键设置脚本正常"
        else
            print_colored "$YELLOW" "⚠️ 一键设置脚本测试失败"
        fi
    fi
}

# 显示完成信息
show_completion() {
    print_colored "$GREEN" "🎉 Cursor超级部署完成！"
    print_colored "$GREEN" "================================"

    print_colored "$WHITE" "📁 通用部署系统位置: $HOME/Desktop/通用部署/"
    print_colored "$WHITE" "🔧 配置文件位置: $HOME/.universal-deploy-config"

    echo ""
    print_colored "$BLUE" "🚀 下一步操作:"
    print_colored "$WHITE" "  1. 配置认证信息: nano $HOME/.universal-deploy-config"
    print_colored "$WHITE" "  2. 测试配置: cd $HOME/Desktop/通用部署 && ./scripts/multi-device-config.sh status"
    print_colored "$WHITE" "  3. 图形界面: cd $HOME/Desktop/通用部署 && ./ui/cli-interface.sh"
    print_colored "$WHITE" "  4. 创建项目: cd $HOME/Desktop/通用部署 && ./scripts/one-click-setup.sh my-app \"我的应用\""

    echo ""
    print_colored "$YELLOW" "💡 快速命令:"
    print_colored "$WHITE" "  # 配置认证"
    print_colored "$WHITE" "  nano $HOME/.universal-deploy-config"
    print_colored "$WHITE" "  "
    print_colored "$WHITE" "  # 开始使用"
    print_colored "$WHITE" "  cd $HOME/Desktop/通用部署"
    print_colored "$WHITE" "  ./ui/cli-interface.sh"
    print_colored "$WHITE" "  "
    print_colored "$WHITE" "  # 创建项目"
    print_colored "$WHITE" "  ./scripts/one-click-setup.sh my-app \"我的应用\""

    echo ""
    print_colored "$CYAN" "🎯 功能特点:"
    print_colored "$WHITE" "  ✅ 跨平台支持 (macOS/Linux/Windows)"
    print_colored "$WHITE" "  ✅ 自动依赖安装"
    print_colored "$WHITE" "  ✅ GitHub集成"
    print_colored "$WHITE" "  ✅ Netlify部署"
    print_colored "$WHITE" "  ✅ 多设备配置"
    print_colored "$WHITE" "  ✅ 一键项目创建"
}

# 主函数
main() {
    print_colored "$CYAN" "🚀 Cursor超级部署系统"
    print_colored "$CYAN" "================================"
    print_colored "$WHITE" "版本: 1.7.0"
    print_colored "$WHITE" "功能: 一键部署通用部署系统"
    echo ""

    # 1. 检测系统环境
    detect_system

    # 2. 安装系统依赖
    install_dependencies

    # 3. 获取通用部署系统
    get_universal_deploy

    # 4. 配置认证信息
    setup_authentication

    # 5. 验证系统功能
    verify_system

    # 6. 显示完成信息
    show_completion
}

# 运行主函数
main "$@"
