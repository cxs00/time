#!/bin/bash
# GitHub专用上传脚本

echo "📤 GitHub专用上传系统"
echo "================================="

# 检查当前状态
echo "📊 当前状态:"
echo "- 分支: $(git branch --show-current)"
echo "- 版本: $(git describe --tags --abbrev=0 2>/dev/null || echo '无版本')"
echo "- 未提交更改: $(git diff --name-only | wc -l) 个文件"
echo ""

# 显示最近的更改
if ! git diff --quiet; then
    echo "📝 未提交的更改:"
    git diff --name-only
    echo ""
    read -p "是否提交这些更改？(y/N): " commit_confirm
    
    if [[ $commit_confirm == [yY] ]]; then
        git add .
        git commit -m "GitHub上传: $(date '+%Y-%m-%d %H:%M:%S')"
        echo "✅ 更改已提交"
    else
        echo "❌ 取消上传"
        exit 1
    fi
fi

# 显示上传信息
echo "📋 GitHub上传信息:"
echo "- 目标仓库: https://github.com/cxs00/time"
echo "- 上传类型: 代码同步"
echo "- 不触发任何部署平台"
echo ""

# 询问用户确认
echo "❓ 确认上传到GitHub？"
echo "  这将同步代码到GitHub仓库"
echo "  不会触发任何部署平台"
echo ""
read -p "确认上传？(y/N): " github_confirm

if [[ $github_confirm == [yY] ]]; then
    echo "🚀 开始上传到GitHub..."
    git push origin main
    echo "✅ GitHub上传完成"
    echo "📁 仓库地址: https://github.com/cxs00/time"
    echo "💡 如需部署到其他平台，请运行: ./scripts/deploy-universal.sh"
else
    echo "❌ 取消上传"
fi
