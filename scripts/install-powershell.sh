#!/bin/bash
# PowerShell安装脚本

echo "🚀 PowerShell安装开始..."
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

# 检查系统类型
print_colored "$BLUE" "🔍 检查系统信息..."
ARCH=$(uname -m)
print_colored "$GREEN" "✅ 系统架构: $ARCH"

if [ "$ARCH" = "arm64" ]; then
    print_colored "$GREEN" "✅ Apple Silicon Mac - 推荐arm64版本"
    POWERSHELL_VERSION="powershell-7.5.4-osx-arm64.pkg"
elif [ "$ARCH" = "x86_64" ]; then
    print_colored "$GREEN" "✅ Intel Mac - 推荐x64版本"
    POWERSHELL_VERSION="powershell-7.5.4-osx-x64.pkg"
else
    print_colored "$YELLOW" "⚠️ 未知架构: $ARCH"
    exit 1
fi

# 检查是否已安装PowerShell
print_colored "$BLUE" "🔍 检查PowerShell安装状态..."
if command -v pwsh &> /dev/null; then
    POWERSHELL_VER=$(pwsh --version)
    print_colored "$GREEN" "✅ PowerShell已安装: $POWERSHELL_VER"
    print_colored "$CYAN" "🎉 安装完成！"
    exit 0
fi

# 检查Homebrew
print_colored "$BLUE" "🔍 检查Homebrew安装状态..."
if command -v brew &> /dev/null; then
    print_colored "$GREEN" "✅ Homebrew已安装"

    # 使用Homebrew安装
    print_colored "$BLUE" "📦 使用Homebrew安装PowerShell..."
    brew install --cask powershell

    if [ $? -eq 0 ]; then
        print_colored "$GREEN" "✅ PowerShell安装成功"

        # 验证安装
        if command -v pwsh &> /dev/null; then
            POWERSHELL_VER=$(pwsh --version)
            print_colored "$GREEN" "✅ 验证成功: $POWERSHELL_VER"
        else
            print_colored "$YELLOW" "⚠️ 请重启终端后重试"
        fi
    else
        print_colored "$RED" "❌ Homebrew安装失败"
        print_colored "$WHITE" "请尝试手动安装"
    fi
else
    print_colored "$YELLOW" "⚠️ Homebrew未安装"
    print_colored "$WHITE" "请按照以下步骤手动安装："
    echo ""
    print_colored "$CYAN" "方法1: 安装Homebrew（需要管理员权限）"
    print_colored "$WHITE" "1. 运行: /bin/bash -c \"\$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)\""
    print_colored "$WHITE" "2. 输入管理员密码"
    print_colored "$WHITE" "3. 重新运行此脚本"
    echo ""
    print_colored "$CYAN" "方法2: 官网下载（推荐）"
    print_colored "$WHITE" "1. 访问: https://github.com/PowerShell/PowerShell/releases"
    print_colored "$WHITE" "2. 下载: $POWERSHELL_VERSION"
    print_colored "$WHITE" "3. 双击安装包安装"
    print_colored "$WHITE" "4. 重启终端"
    echo ""
    print_colored "$YELLOW" "💡 安装完成后，运行: pwsh --version"
fi

# 显示完成信息
print_colored "$GREEN" "🎉 PowerShell安装完成！"
echo ""
print_colored "$WHITE" "📋 使用方法:"
print_colored "$WHITE" "• 启动PowerShell: pwsh"
print_colored "$WHITE" "• 检查版本: pwsh --version"
print_colored "$WHITE" "• 退出PowerShell: exit"
echo ""
print_colored "$CYAN" "🚀 下一步:"
print_colored "$WHITE" "• 继续使用bash脚本: ./scripts/quick-start.sh"
print_colored "$WHITE" "• 或使用PowerShell编写新脚本"
