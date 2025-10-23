#!/bin/bash
# 快速启动脚本 - 整合所有功能

echo "🚀 TIME应用快速启动"
echo "================================"

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

# 检查是否在项目根目录
if [ ! -f "index.html" ]; then
    print_colored "$RED" "❌ 错误: 请在项目根目录执行此脚本"
    exit 1
fi

# 显示菜单
show_menu() {
    echo ""
    print_colored "$CYAN" "📋 请选择操作:"
    echo ""
    print_colored "$WHITE" "1. 🐍 Python本地部署 (立即可用)"
    print_colored "$WHITE" "2. 🛡️ 安全功能测试"
    print_colored "$WHITE" "3. 🔧 检查Node.js安装状态"
    print_colored "$WHITE" "4. 📦 安装Node.js和Vercel CLI"
    print_colored "$WHITE" "5. 🚀 一键部署到Vercel"
    print_colored "$WHITE" "6. 🌐 部署到Netlify"
    print_colored "$WHITE" "7. 📊 查看部署状态"
    print_colored "$WHITE" "8. ❓ 显示帮助信息"
    print_colored "$WHITE" "9. 🚪 退出"
    echo ""
}

# Python本地部署
python_deploy() {
    print_colored "$BLUE" "🐍 启动Python本地部署..."
    ./scripts/deploy-python.sh
}

# 安全测试
security_test() {
    print_colored "$BLUE" "🛡️ 启动安全功能测试..."
    ./scripts/local-security-test.sh
}

# 检查Node.js状态
check_nodejs() {
    print_colored "$BLUE" "🔍 检查Node.js安装状态..."
    ./scripts/install-nodejs.sh
}

# 安装Node.js
install_nodejs() {
    print_colored "$BLUE" "📦 开始安装Node.js和Vercel CLI..."
    print_colored "$YELLOW" "请按照以下步骤手动安装Node.js:"
    echo ""
    print_colored "$CYAN" "方法1: 官网下载（推荐）"
    print_colored "$WHITE" "1. 访问 https://nodejs.org/"
    print_colored "$WHITE" "2. 下载LTS版本"
    print_colored "$WHITE" "3. 双击安装包安装"
    print_colored "$WHITE" "4. 重启终端"
    echo ""
    print_colored "$CYAN" "方法2: 使用Homebrew"
    print_colored "$WHITE" "1. 安装Homebrew:"
    print_colored "$WHITE" "   /bin/bash -c \"\$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)\""
    print_colored "$WHITE" "2. 安装Node.js:"
    print_colored "$WHITE" "   brew install node"
    echo ""
    print_colored "$YELLOW" "安装完成后，重新运行此脚本选择选项5"
}

# 一键部署到Vercel
deploy_vercel() {
    print_colored "$BLUE" "🚀 一键部署到Vercel..."
    ./scripts/install-and-deploy.sh
}

# 部署到Netlify
deploy_netlify() {
    print_colored "$BLUE" "🌐 部署到Netlify..."
    ./scripts/deploy-netlify-only.sh
}

# 查看部署状态
show_status() {
    print_colored "$BLUE" "📊 查看部署状态..."
    echo ""
    print_colored "$WHITE" "🔍 检查本地服务器..."
    if lsof -Pi :8000 -sTCP:LISTEN -t >/dev/null 2>&1; then
        print_colored "$GREEN" "✅ 本地服务器运行中: http://localhost:8000"
    else
        print_colored "$YELLOW" "⚠️ 本地服务器未运行"
    fi

    echo ""
    print_colored "$WHITE" "🔍 检查Node.js..."
    if command -v node &> /dev/null; then
        print_colored "$GREEN" "✅ Node.js已安装: $(node --version)"
    else
        print_colored "$YELLOW" "⚠️ Node.js未安装"
    fi

    echo ""
    print_colored "$WHITE" "🔍 检查Vercel CLI..."
    if command -v vercel &> /dev/null; then
        print_colored "$GREEN" "✅ Vercel CLI已安装: $(vercel --version)"
    else
        print_colored "$YELLOW" "⚠️ Vercel CLI未安装"
    fi

    echo ""
    print_colored "$WHITE" "🔍 检查Git状态..."
    if git status &> /dev/null; then
        print_colored "$GREEN" "✅ Git仓库正常"
    else
        print_colored "$YELLOW" "⚠️ Git仓库异常"
    fi
}

# 显示帮助信息
show_help() {
    print_colored "$CYAN" "❓ 帮助信息"
    echo ""
    print_colored "$WHITE" "📋 功能说明:"
    print_colored "$WHITE" "• Python部署: 无需Node.js，立即可用"
    print_colored "$WHITE" "• 安全测试: 验证所有安全功能"
    print_colored "$WHITE" "• Node.js检查: 检查安装状态"
    print_colored "$WHITE" "• Vercel部署: 需要Node.js安装"
    print_colored "$WHITE" "• Netlify部署: 网络恢复后可用"
    echo ""
    print_colored "$WHITE" "📋 使用流程:"
    print_colored "$WHITE" "1. 选择Python部署进行本地测试"
    print_colored "$WHITE" "2. 运行安全测试验证功能"
    print_colored "$WHITE" "3. 安装Node.js后部署到云端"
    echo ""
    print_colored "$WHITE" "📋 访问地址:"
    print_colored "$WHITE" "• 本地测试: http://localhost:8000+"
    print_colored "$WHITE" "• Netlify: https://time-2025.netlify.app"
    print_colored "$WHITE" "• Vercel: 部署后获得URL"
}

# 主循环
main() {
    while true; do
        show_menu
        read -p "请输入选项 (1-9): " choice

        case $choice in
            1)
                python_deploy
                ;;
            2)
                security_test
                ;;
            3)
                check_nodejs
                ;;
            4)
                install_nodejs
                ;;
            5)
                deploy_vercel
                ;;
            6)
                deploy_netlify
                ;;
            7)
                show_status
                ;;
            8)
                show_help
                ;;
            9)
                print_colored "$GREEN" "👋 再见！"
                exit 0
                ;;
            *)
                print_colored "$RED" "❌ 无效选项，请重新选择"
                ;;
        esac

        echo ""
        read -p "按回车键继续..." -r
    done
}

# 运行主程序
main
