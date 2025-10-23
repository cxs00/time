#!/bin/bash
# 部署监控脚本

echo "📊 部署监控系统"
echo "================================="

# 检查GitHub状态
echo "🔍 GitHub状态:"
echo "- 仓库: https://github.com/cxs00/time"
echo "- 最新提交: $(git log --oneline -1)"
echo ""

# 检查各平台状态
echo "🌐 部署平台状态:"

# Netlify状态
if [ -f "netlify.toml" ]; then
    echo "Netlify: https://time-2025.netlify.app"
    if curl -s -o /dev/null -w "%{http_code}" https://time-2025.netlify.app | grep -q "200"; then
        echo "✅ Netlify站点正常"
    else
        echo "⚠️ Netlify站点异常"
    fi
fi

# Vercel状态
if [ -f "vercel.json" ]; then
    echo "Vercel: 请检查Vercel Dashboard"
fi

# Firebase状态
if [ -f "firebase.json" ]; then
    echo "Firebase: 请检查Firebase Console"
fi

# GitHub Pages状态
if [ -f ".github/workflows/deploy.yml" ]; then
    echo "GitHub Pages: 请检查GitHub Pages设置"
fi

echo ""

# 显示部署历史
echo "📝 最近部署:"
git log --oneline -10
echo ""

# 显示版本信息
echo "🏷️ 当前版本:"
git describe --tags --abbrev=0 2>/dev/null || echo "无版本标签"
echo ""

# 显示部署建议
echo "💡 部署建议:"
echo "1. 只在重要更新时部署"
echo "2. 批量更新后统一部署"
echo "3. 监控各平台额度使用"
echo "4. 使用本地测试减少部署次数"
