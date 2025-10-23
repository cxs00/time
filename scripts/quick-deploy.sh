#!/bin/bash
# 快速部署脚本 - 整合所有功能

echo "⚡ 快速部署系统"
echo "================================="

# 显示当前状态
echo "📊 当前状态:"
echo "- 分支: $(git branch --show-current)"
echo "- 版本: $(git describe --tags --abbrev=0 2>/dev/null || echo '无版本')"
echo "- 未提交更改: $(git diff --name-only | wc -l) 个文件"
echo ""

# 如果有未提交的更改，询问是否提交
if ! git diff --quiet; then
    echo "📝 检测到未提交的更改:"
    git diff --name-only
    echo ""
    read -p "是否提交这些更改？(y/N): " commit_confirm

    if [[ $commit_confirm == [yY] ]]; then
        git add .
        git commit -m "快速部署: $(date '+%Y-%m-%d %H:%M:%S')"
        echo "✅ 更改已提交"
    else
        echo "❌ 取消部署"
        exit 1
    fi
fi

# 显示部署选项
echo "🚀 部署选项:"
echo "1. 仅上传到GitHub (不触发部署)"
echo "2. 部署到Netlify"
echo "3. 部署到Vercel"
echo "4. 通用部署 (自动检测平台)"
echo "5. 查看部署状态"
echo "6. 取消"
echo ""

read -p "请选择部署选项 (1-6): " deploy_choice

case $deploy_choice in
    1)
        echo "📤 仅上传到GitHub..."
        git push origin main
        echo "✅ GitHub上传完成"
        echo "📁 仓库地址: https://github.com/cxs00/time"
        ;;
    2)
        echo "🌐 部署到Netlify..."
        ./scripts/deploy-netlify.sh
        ;;
    3)
        echo "🌐 部署到Vercel..."
        ./scripts/deploy-vercel.sh
        ;;
    4)
        echo "🌐 通用部署..."
        ./scripts/deploy-universal.sh
        ;;
    5)
        echo "📊 查看部署状态..."
        ./scripts/deploy-monitor.sh
        ;;
    6)
        echo "❌ 取消部署"
        exit 0
        ;;
    *)
        echo "❌ 无效选择"
        exit 1
        ;;
esac
