#!/bin/bash
# TIME项目协作者环境设置脚本

echo "👥 TIME项目协作者环境设置"
echo "================================"

# 检查是否已有配置
if [ -f .env ]; then
    echo "✅ 环境配置已存在"
    source .env
    echo "当前配置:"
    echo "  GitHub用户名: $GITHUB_USERNAME"
    echo "  仓库名称: $REPO_NAME"
    echo "  Netlify配置: ${NETLIFY_TOKEN:+已设置}"
else
    echo "🔧 首次设置，请配置环境变量..."
    echo ""
    
    # 交互式配置
    read -p "请输入你的GitHub用户名: " GITHUB_USERNAME
    read -p "请输入你的GitHub Token: " GITHUB_TOKEN
    read -p "请输入你的仓库名 (默认: time): " REPO_NAME
    REPO_NAME=${REPO_NAME:-time}
    
    read -p "请输入Netlify Token (可选，直接回车跳过): " NETLIFY_TOKEN
    read -p "请输入Netlify Site ID (可选，直接回车跳过): " NETLIFY_SITE_ID
    
    # 创建环境变量文件
    cat > .env << ENVEOF
# TIME项目环境配置
GITHUB_USERNAME=$GITHUB_USERNAME
GITHUB_TOKEN=$GITHUB_TOKEN
REPO_NAME=$REPO_NAME
NETLIFY_TOKEN=$NETLIFY_TOKEN
NETLIFY_SITE_ID=$NETLIFY_SITE_ID
LOCAL_PORT=8000
DEBUG_MODE=true
PROJECT_ROOT=$(pwd)
ENVEOF
    
    echo "✅ 环境配置已保存到 .env 文件"
fi

# 配置Git远程仓库
if [ -n "$GITHUB_USERNAME" ] && [ -n "$GITHUB_TOKEN" ]; then
    git remote set-url origin https://$GITHUB_USERNAME:$GITHUB_TOKEN@github.com/$GITHUB_USERNAME/$REPO_NAME.git
    echo "✅ Git远程仓库已配置"
else
    echo "⚠️ 请设置GitHub配置以启用Git功能"
fi

echo ""
echo "🚀 协作者环境设置完成！"
echo ""
echo "📋 下一步操作:"
echo "  1. 启动开发服务器: python -m http.server 8000"
echo "  2. 打开Cursor: cursor ."
echo "  3. 开始开发: 参考 prompts/ 目录中的提示词"
echo "  4. 版本管理: ./scripts/version-traveler.sh list"
