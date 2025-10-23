#!/bin/bash
# Node.js安装脚本（无需管理员权限）

echo "🔧 Node.js安装开始..."
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

# 检查是否已安装Node.js
if command -v node &> /dev/null; then
    NODE_VERSION=$(node --version)
    print_colored "$GREEN" "✅ Node.js已安装: $NODE_VERSION"

    if command -v npm &> /dev/null; then
        NPM_VERSION=$(npm --version)
        print_colored "$GREEN" "✅ npm已安装: $NPM_VERSION"

        # 检查Vercel CLI
        if command -v vercel &> /dev/null; then
            VERCEL_VERSION=$(vercel --version)
            print_colored "$GREEN" "✅ Vercel CLI已安装: $VERCEL_VERSION"
            print_colored "$CYAN" "🎉 所有工具已安装完成！"
            exit 0
        else
            print_colored "$YELLOW" "📦 安装Vercel CLI..."
            npm install -g vercel
            if [ $? -eq 0 ]; then
                print_colored "$GREEN" "✅ Vercel CLI安装成功"
            else
                print_colored "$RED" "❌ Vercel CLI安装失败"
                exit 1
            fi
        fi
    else
        print_colored "$RED" "❌ npm未找到，请检查Node.js安装"
        exit 1
    fi
else
    print_colored "$YELLOW" "⚠️ Node.js未安装"
    print_colored "$WHITE" "请按照以下步骤手动安装："
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
    print_colored "$CYAN" "方法3: 使用nvm"
    print_colored "$WHITE" "1. 安装nvm:"
    print_colored "$WHITE" "   curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash"
    print_colored "$WHITE" "2. 重新加载终端:"
    print_colored "$WHITE" "   source ~/.bashrc"
    print_colored "$WHITE" "3. 安装Node.js:"
    print_colored "$WHITE" "   nvm install --lts"
    print_colored "$WHITE" "   nvm use --lts"
    echo ""
    print_colored "$YELLOW" "💡 安装完成后，重新运行此脚本"
    exit 1
fi

# 检查Vercel登录状态
print_colored "$BLUE" "🔐 检查Vercel登录状态..."
if vercel whoami &> /dev/null; then
    USER_EMAIL=$(vercel whoami)
    print_colored "$GREEN" "✅ 已登录Vercel: $USER_EMAIL"
else
    print_colored "$YELLOW" "🔑 请登录Vercel账户..."
    print_colored "$WHITE" "1. 浏览器将自动打开"
    print_colored "$WHITE" "2. 登录你的Vercel账户"
    print_colored "$WHITE" "3. 授权CLI访问"
    echo ""
    read -p "按回车键继续登录..." -r
    vercel login
fi

# 显示完成信息
print_colored "$GREEN" "🎉 安装和配置完成！"
echo ""
print_colored "$WHITE" "📊 安装状态:"
print_colored "$GREEN" "✅ Node.js: $(node --version)"
print_colored "$GREEN" "✅ npm: $(npm --version)"
print_colored "$GREEN" "✅ Vercel CLI: $(vercel --version)"
echo ""
print_colored "$CYAN" "🚀 下一步操作:"
print_colored "$WHITE" "1. 部署到Vercel: ./scripts/install-and-deploy.sh"
print_colored "$WHITE" "2. 双平台部署: ./scripts/deploy-dual.sh"
print_colored "$WHITE" "3. 查看部署状态: vercel ls"
